import SwiftUI

struct EpisodeCarouselView: View {

    let episodes: [Episode]
    let maxVisible: Int
    let onEpisodeTap: (Episode) -> Void
    let onSeeAll: () -> Void

    init(
        episodes: [Episode],
        maxVisible: Int = 5,
        onEpisodeTap: @escaping (Episode) -> Void,
        onSeeAll: @escaping () -> Void
    ) {
        self.episodes = episodes
        self.maxVisible = maxVisible
        self.onEpisodeTap = onEpisodeTap
        self.onSeeAll = onSeeAll
    }

    private var displayedEpisodes: [Episode] {
        Array(episodes.prefix(maxVisible))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(R.string.localizable.commonsEpisodes())
                .specialSubtitleStyle()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(displayedEpisodes, id: \.id) { episode in
                        VStack(alignment: .leading) {
                            Button {
                                onEpisodeTap(episode)
                            } label: {
                                Image(uiImage: episode.image)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                            .buttonStyle(PressableButtonStyle())

                            Text(episode.name)
                                .bodyStyle()
                                .lineLimit(1)
                        }
                        .frame(width: 150)
                    }

                    if episodes.count > maxVisible {
                        Button(action: onSeeAll) {
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 150, height: 150)

                                    Text(R.string.localizable.commonsSeeAll())
                                        .font(Theme.Fonts.button)
                                        .foregroundColor(Theme.Colors.primary)
                                }
                            }
                            .frame(width: 150)
                            .padding(.trailing, 28)
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    EpisodeCarouselView(
        episodes: Episode.mocks,
        onEpisodeTap: { print("Tapped episode: \($0.name)") },
        onSeeAll: { print("SEE ALL") }
    )
}
