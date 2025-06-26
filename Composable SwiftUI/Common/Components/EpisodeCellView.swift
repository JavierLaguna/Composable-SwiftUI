import SwiftUI

struct EpisodeCellView: View {

    let episode: Episode

    var body: some View {
        HStack(spacing: Theme.Space.none) {
            VStack(alignment: .leading, spacing: Theme.Space.none) {
                Text(episode.name)
                    .specialSubtitleStyle()

                Text("\(episode.code) | \(episode.airDate.formatted(date: .long, time: .omitted))")
                    .bodyStyle()
            }

            Spacer()

            Image(uiImage: episode.image)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.l, style: .continuous))
        }
    }
}

#Preview {
    EpisodeCellView(episode: Episode.mock)
}
