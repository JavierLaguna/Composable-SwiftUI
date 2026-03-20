import SwiftUI
import ComposableArchitecture

struct LocationsListView: View {

    let store: StoreOf<LocationsListReducer>

    var body: some View {
        Group {
            switch store.locations.state {
            case .initial,
                    .loading,
                    .populated:

                if let locations = store.locations.data {
                    LocationsList(
                        locations: locations,
                        isLoading: store.locations.isLoading
                    )

                } else {
                    FullScreenLoadingView()
                }

            case .error(let error):
                ErrorView(
                    error: error,
                    onRetry: {
                        store.send(.getLocations)
                    }
                )
                .padding(.horizontal, Theme.Space.xxl)

            default:
                EmptyView()
            }
        }
        .background {
            BackgroundPatternPrimaryView()
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle(R.string.localizable.locationsListTitle())
        .environment(store)
        .task {
            store.send(.onAppear)
        }
    }
}

private struct LocationsList: View {

    @Environment(StoreOf<LocationsListReducer>.self)
    private var store

    let locations: [Location]
    let isLoading: Bool

    var body: some View {
        List {
            Group {
                ForEach(locations) { location in
                    LocationCellView(location: location)
                        .onAppear {
                            if location == locations.last {
                                store.send(.getMoreLocations)
                            }
                        }
                }

                if isLoading {
                    HStack {
                        Spacer()
                        LoadingView()
                        Spacer()
                    }
                }

                Color.clear
                    .frame(height: Theme.Space.tabBarHeight)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(
                vertical: Theme.Space.m,
                horizontal: Theme.Space.xxl
            ))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

private struct LocationCellView: View {

    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Space.s) {
            Text(location.name)
                .specialBodyStyle()

            Text(location.type.rawValue)
                .bodyStyle(bold: true)

            if location.dimension.lowercased() == "unknown" {
                HStack(spacing: Theme.Space.xs) {
                    Text(R.string.localizable.locationsListDimension(""))
                        .bodyStyle(small: true)
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundStyle(Color.black)
                }

            } else {
                Text(R.string.localizable.locationsListDimension(location.dimension))
                    .bodyStyle(small: true)
            }

            HStack(spacing: Theme.Space.xs) {
                Text(R.string.localizable.locationsListResidents(location.residents.count))
                Image(systemName: "person.3.fill")
            }
            .bodyStyle(small: true)
            .foregroundStyle(Theme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Space.l)
        .background(Theme.Colors.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.m, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.m, style: .continuous)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        )
    }
}

#Preview {
    NavigationStack {
        LocationsListView(
            store: Store(
                initialState: .init(),
                reducer: {
                    LocationsListReducer.build()
                }
            )
        )
    }
    .allEnvironmentsInjected
}
