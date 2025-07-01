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
                    .padding(.horizontal, Theme.Space.m)

            ScrollView {
                VStack(spacing: Theme.Space.xl) {
                    HStack {
                        InfoCard(
                            icon: "calendar",
                            title: episode.airDate.formatted(date: .long, time: .omitted)
                        )

                        InfoCard(
                            icon: "number.square.fill",
                            title: episode.code
                        )
                    }
                    .padding(.top, Theme.Space.l)
                    .padding(.horizontal, Theme.Space.xl)

                    VStack(alignment: .leading) {
                        HStack(spacing: Theme.Space.m) {
                            Image(systemName: "person.circle.fill")
                                .bold()
                                .foregroundStyle(Theme.Colors.primary)

                            Text("Characters") // TODO: JLI
                                .bodyStyle(bold: true)

                            Spacer()
                        }

                        // TODO: JLI - Characters Horizontal Scroll
                    }
                    .cardStyle()

                    VStack(alignment: .leading) {
                        Text("Episode Description")
                    }
                    .cardStyle()
                }
            }
            .padding(.top, Theme.Space.l)
            .padding(.horizontal, Theme.Space.xl)

            Spacer()
        }
        .background(Self.bgColor)
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

#Preview {
    NavigationStack {
        EpisodeDetailView(episode: Episode.mock)
    }
    .allEnvironmentsInjected
}
