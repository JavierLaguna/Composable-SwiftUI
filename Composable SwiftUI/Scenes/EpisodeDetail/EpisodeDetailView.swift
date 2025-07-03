import SwiftUI
import ComposableArchitecture
import Kingfisher

struct EpisodeDetailView: View {

    static private let bgColor = Theme.Colors.backgroundTertiary

    let store: StoreOf<EpisodeDetailReducer>

    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: store.episode.image)
                    .resizable()
                    .scaledToFill()
                    .stretchyVisualEffect()
                    .overlay(alignment: .bottom) {
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Self.bgColor.opacity(0.3),
                                Self.bgColor.opacity(0.5),
                                Self.bgColor.opacity(0.7),
                                Self.bgColor.opacity(0.85),
                                Self.bgColor
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 120)
                    }

                Text(store.episode.name)
                    .specialTitleStyle()
                    .multilineTextAlignment(.center)
                    .padding(.top, Theme.Space.m)
                    .padding(.horizontal, Theme.Space.l)

                Spacer()
                    .frame(height: Theme.Space.xxxl)

                Group {
                    VStack(spacing: Theme.Space.xl) {
                        HStack {
                            InfoCard(
                                icon: "calendar",
                                title: store.episode.airDate.formatted(date: .long, time: .omitted)
                            )

                            InfoCard(
                                icon: "number.square.fill",
                                title: store.episode.code
                            )
                        }
                        .padding(.horizontal, Theme.Space.xl)

                        VStack(alignment: .leading) {
                            HStack(spacing: Theme.Space.m) {
                                Image(systemName: "person.circle.fill")
                                    .bold()
                                    .foregroundStyle(Theme.Colors.primary)

                                Text(R.string.localizable.episodeDetailCharacters())
                                    .bodyStyle(bold: true)

                                Spacer()
                            }
                            .padding(.horizontal, Theme.Space.l)

                            if let characters = store.characters.data {
                                CharactersCarouselView(characters: characters)
                            }
                        }
                        .padding(.vertical, Theme.Space.l)
                        .cardStyle(padding: Theme.Space.none)

                        VStack(alignment: .leading) {
                            Text("Episode Description")
                        }
                        .cardStyle()
                    }
                }
                .padding(.horizontal, Theme.Space.xl)

                Color.clear
                    .frame(height: Theme.Space.tabBarHeight)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Self.bgColor)
        .task {
            store.send(.onAppear)
        }
    }
}

private struct InfoCard: View {

    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: Theme.Space.m) {
            Image(systemName: icon)
                .bold()
                .foregroundStyle(Theme.Colors.primary)

            Text(title)
                .bodyStyle(bold: true)
        }
        .cardStyle()
    }
}

private struct CharactersCarouselView: View {

    let characters: [Character]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: Theme.Space.l) {
                ForEach(characters, id: \.id) { character in
                    VStack(alignment: .leading) {
                        KFImage(URL(string: character.image))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .clipShape(Circle())
                    }
                }
                .frame(width: 80)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        EpisodeDetailView(
            store: Store(
                initialState: .init(
                    episode: Episode.mock
                ),
                reducer: {
                    EpisodeDetailReducer.build()
                }
            )
        )
    }
    .allEnvironmentsInjected
}
