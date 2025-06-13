import SwiftUI

struct EpisodeCarouselView: View {
    let episodes: [Episode]
    let maxVisible: Int
    let onSeeAll: () -> Void

    init(
        episodes: [Episode],
        maxVisible: Int = 5,
        onSeeAll: @escaping () -> Void
    ) {
        self.episodes = episodes
        self.maxVisible = maxVisible
        self.onSeeAll = onSeeAll
    }

    private var displayedEpisodes: [Episode] {
        Array(episodes.prefix(maxVisible))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Episodes")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(displayedEpisodes, id: \.id) { episode in
                        VStack(alignment: .leading) {
                            Image(uiImage: episode.image)
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                            Text(episode.name)
                                .font(.subheadline)
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

                                    Text("Ver todos")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            }
                            .frame(width: 150)
                            .padding(.trailing, 28)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    EpisodeCarouselView(episodes: Episode.mocks) {
        print("SEE ALL")
    }
}
