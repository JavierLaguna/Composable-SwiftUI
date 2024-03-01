import SwiftUI

struct NeighborsListView: View {

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    private let locationDetail: LocationDetail

    init(locationDetail: LocationDetail) {
        self.locationDetail = locationDetail
    }

    @ViewBuilder
    private func headerItem(image: String, text: String) -> some View {
        HStack {
            Image(systemName: image)

            Text(text)

            Spacer()
        }
    }

    var body: some View {
        VStack {
            VStack(spacing: Theme.Space.m) {
                Text(locationDetail.name)
                    .font(Theme.Fonts.titleBold)

                Divider()
                    .tint(Theme.Colors.primary)
                    .padding(.vertical, Theme.Space.l)

                headerItem(
                    image: "globe.europe.africa",
                    text: locationDetail.type.rawValue
                )

                headerItem(
                    image: "antenna.radiowaves.left.and.right.circle.fill",
                    text: locationDetail.dimension
                )

                headerItem(
                    image: "person.3.sequence.fill",
                    text: "\(R.string.localizable.characterNeighborsResidents()) \(locationDetail.residents.count)"
                )
            }
            .font(Theme.Fonts.subtitle)
            .foregroundColor(Theme.Colors.primary)
            .padding(Theme.Space.l)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(locationDetail.residents) {
                        NeighborsCellView(character: $0)
                    }
                }
                .padding(Theme.Space.l)
            }
        }
    }
}

#Preview {
    NeighborsListView(
        locationDetail: .init(
            id: 1,
            name: "name",
            type: .citadel,
            dimension: "Dimension",
            residents: []
        )
    )
}
