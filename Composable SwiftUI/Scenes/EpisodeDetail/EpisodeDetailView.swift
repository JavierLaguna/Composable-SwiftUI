import SwiftUI

struct EpisodeDetailView: View {

    static private let bgColor = Theme.Colors.backgroundTertiary

    let episode: Episode

    var body: some View {
        VStack {
            Image(uiImage: episode.image)
                .resizable()
                .scaledToFill()
                .frame(height: 200)

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

                Text(episode.name)
                    .specialTitleStyle()
                    .multilineTextAlignment(.center)

            ScrollView {
                HStack {
                    HStack(spacing: Theme.Space.none) {
                        Image(systemName: "calendar")

                        Text(episode.airDate.formatted(date: .long, time: .omitted))
                            .bodyStyle(small: true)
                    }
                    .padding(Theme.Space.l)
                    .background(Theme.Colors.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.m, style: .continuous))
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.m, style: .continuous)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                    )

                    HStack(spacing: Theme.Space.none) {
                        Image(systemName: "number.square.fill")

                        Text(episode.code)
                            .bodyStyle(bold: true)
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

            Spacer()
        }
        .background(Self.bgColor)
    }
}

#Preview {
    NavigationStack {
        EpisodeDetailView(episode: Episode.mock)
    }
    .allEnvironmentsInjected
}
