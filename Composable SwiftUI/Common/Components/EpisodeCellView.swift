import SwiftUI

struct EpisodeCellView: View {

    let episode: Episode

    var body: some View {
        HStack(spacing: Theme.Space.none) {
            VStack(alignment: .leading, spacing: Theme.Space.l) {
                Text(episode.name)
                    .specialBodyStyle()

                VStack(alignment: .leading, spacing: Theme.Space.none) {
                    Text(episode.code)
                        .bodyStyle(bold: true)

                    Text(episode.airDate.formatted(date: .long, time: .omitted))
                        .bodyStyle(small: true)
                }
            }

            Spacer()

            Image(uiImage: episode.image)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.l, style: .continuous))
        }
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
    VStack {
        Spacer()

        EpisodeCellView(episode: Episode.mock)

        Spacer()
    }
    .background(.red)
}
