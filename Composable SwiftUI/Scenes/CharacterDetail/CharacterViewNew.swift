import SwiftUI
import Kingfisher

struct CharacterViewNew: View {

    let character: Character

    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                LoadingView()
//                    .frame(width: .infinity, height: .infinity, alignment: .center)

            } else {
                MainContentView(character: character)
            }
        }
        .background {
            BackgroundPatternView()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
}

struct MainContentView: View {
    @State private var isCollapsed: Bool = false

    let character: Character

    var body: some View {
        VStack(spacing: 0) {

            if isCollapsed {
                HStack(spacing: 16) {
                    KFImage(URL(string: character.image))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .background {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.black.opacity(0.4))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color(red: 0.24, green: 0.86, blue: 0.52), lineWidth: 4)
                                )
                        }

                    VStack(alignment: .leading, spacing: 16) {
                        Text(character.name.uppercased())
                        //                        .font(.custom("Impact", size: 36))
                            .font(Theme.Fonts.title)
                            .fontWeight(.black)
                            .foregroundColor(Color(red: 0.24, green: 0.86, blue: 0.52))
                            .shadow(color: .black, radius: 0, x: 2, y: 2)

                        HStack {
                            InfoCard(title: "SPECIES", value: character.species.uppercased())
                            StatusBadgeView(status: character.status)
                        }
                    }
                }
            } else {
                CharacterDisplayView(character: character)
            }

            ScrollView {

                // Bottom content overlay
                BottomContentView(character: character)
                    .padding(.top, 60)
            }
        }
    }
}

struct CharacterDisplayView: View {
    let character: Character

    var body: some View {
        KFImage(URL(string: character.image))
            .resizable()
            .scaledToFit()
            .frame(width: 304, height: 304)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.black.opacity(0.4))
                    .frame(width: 320, height: 320)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(red: 0.24, green: 0.86, blue: 0.52), lineWidth: 4)
                )
            }
        .overlay(alignment: .topTrailing) {
            VStack(alignment: .trailing, spacing: 16) {
                StatusBadgeView(status: character.status)

                InfoCard(title: "SPECIES", value: character.species.uppercased())
            }
            .offset(x: 40, y: 16)
        }
    }
}

struct StatusBadgeView: View {
    let status: CharacterStatus

    var body: some View {
        HStack(spacing: 8) {
            statusIcon
            Text(status.rawValue.uppercased())
                .font(.custom("Impact", size: 12))
                .fontWeight(.black)
//                .letterSpacing(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(statusColor)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.black.opacity(0.2), lineWidth: 2)
        )
    }

    @ViewBuilder
    private var statusIcon: some View {
        switch status {
        case .alive:
            Image(systemName: "heart.fill")
                .foregroundColor(Color.black)
                .font(.system(size: 14))
        case .dead:
            Image(systemName: "xmark")
                .foregroundColor(Color.white)
                .font(.system(size: 14))
        case .unknown:
            Image(systemName: "questionmark")
                .foregroundColor(Color.black)
                .font(.system(size: 14))
        }
    }

    private var statusColor: Color {
        switch status {
        case .alive:
            return Color(red: 0.24, green: 0.86, blue: 0.52)
        case .dead:
            return Color.red
        case .unknown:
            return Color.yellow
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Impact", size: 10))
                .fontWeight(.black)
                .foregroundColor(Color(red: 0.24, green: 0.86, blue: 0.52).opacity(0.8))

            Text(value)
                .font(.custom("Impact", size: 14))
                .fontWeight(.black)
                .foregroundColor(.white)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.24, green: 0.86, blue: 0.52).opacity(0.5), lineWidth: 2)
                )
        )
    }
}

struct BottomContentView: View {
    let character: Character

    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.8), Color.black.opacity(0.95)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 80)

            VStack(alignment: .leading, spacing: 24) {
                // Character name and info
                VStack(alignment: .leading, spacing: 16) {
                    Text(character.name.uppercased())
//                        .font(.custom("Impact", size: 36))
                        .font(Theme.Fonts.title)
                        .fontWeight(.black)
                        .foregroundColor(Color(red: 0.24, green: 0.86, blue: 0.52))
                        .shadow(color: .black, radius: 0, x: 2, y: 2)

                    HStack(spacing: 16) {
                        TagView(text: "CREATED YEAR | \(character.gender.localizedDescription)")
                        TagView(text: character.type)
                    }
                }

                // Description
                Text("Rick Sanchez is a genius scientist whose alcoholism and reckless, nihilistic behavior are sources of concern for his daughter's family, as well as the safety of their son, Morty. He is easily bored and does not do well with mundane requests, which he often reflects in his creation of some sort of sci-fi gadget to fulfill those requests. Rick shows a disregard for attachment, as he is willing to abandon realities and even family members.")
                    .multilineTextAlignment(.leading)
                    .lineLimit(12, reservesSpace: true) // TODO: JLi
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
//                    .lineSpacing(9)

                // Location info
                HStack(spacing: 16) {
                    LocationCard(title: "ORIGIN", location: character.origin.name)
                    LocationCard(title: "LAST LOCATION", location: character.location.name)
                    LocationCard(title: "EPISODES", location: "\(character.episodes.count)")
                }

                // Play button
                Button(action: {}) {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 20))

                        Text("VIEW EPISODES")
                            .font(.custom("Impact", size: 18))
                            .fontWeight(.black)
//                            .letterSpacing(1)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.24, green: 0.86, blue: 0.52))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.black.opacity(0.2), lineWidth: 2)
                    )
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3), value: true)

                // Navigation controls
                NavigationControlsView()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            .background(Color.black.opacity(0.95))
            .ignoresSafeArea()
        }
    }
}

struct TagView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.custom("Impact", size: 12))
            .fontWeight(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
//                    .fill(Color(red: 0.24, green: 0.86, blue: 0.52).opacity(0.2))
                    .fill(Theme.Colors.primary.opacity(0.2))
                    .overlay(
                        Capsule()
                            .stroke(Theme.Colors.primary, lineWidth: 1)
                    )
            )
            .foregroundColor(Theme.Colors.primary)
    }
}

struct LocationCard: View {
    let title: String
    let location: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Impact", size: 12))
                .fontWeight(.black)
                .foregroundColor(Color(red: 0.24, green: 0.86, blue: 0.52))

            Text(location)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.24, green: 0.86, blue: 0.52).opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct NavigationControlsView: View {
    var body: some View {
        HStack {
            NavigationButton(icon: "chevron.right")
        }
    }
}

struct NavigationButton: View {
    let icon: String
    let isActive: Bool

    init(icon: String, isActive: Bool = false) {
        self.icon = icon
        self.isActive = isActive
    }

    var body: some View {
        Button(action: {}) {
            Circle()
                .fill(isActive ? Color(red: 0.24, green: 0.86, blue: 0.52).opacity(0.2) : Color.black.opacity(0.6))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(Color(red: 0.24, green: 0.86, blue: 0.52))
                        .font(.system(size: 20, weight: .medium))
                )
                .overlay(
                    Circle()
                        .stroke(
                            isActive ? Color(red: 0.24, green: 0.86, blue: 0.52) : Color(red: 0.24, green: 0.86, blue: 0.52).opacity(0.3),
                            lineWidth: 2
                        )
                )
        }
        .scaleEffect(isActive ? 1.1 : 1.0)
        .animation(.spring(response: 0.3), value: isActive)
    }
}

struct BackgroundPatternView: View {

    var body: some View {
        ZStack {
            R.image.ic_background_2.image
                .resizable()
                .scaledToFill()

            Color.black.opacity(0.5)
        }

        .ignoresSafeArea()
    }
}

#Preview {
    let location = CharacterLocation(id: 1, name: "Earth")
    let character = Character(
        id: 1,
        name: "Rick Sanchez",
        status: .alive,
        species: "Human",
        type: "Planet",
        gender: .male,
        origin: location,
        location: location,
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episodes: []

        // TODO: JLI - Add to model?
        //        created: "2017-11-04T18:48:46.250Z",
        //        description: "Rick Sanchez is a genius scientist whose alcoholism and reckless, nihilistic behavior are sources of concern for his daughter's family, as well as the safety of their son, Morty. He is easily bored and does not do well with mundane requests, which he often reflects in his creation of some sort of sci-fi gadget to fulfill those requests. Rick shows a disregard for attachment, as he is willing to abandon realities and even family members."
    )

    NavigationStack {
        CharacterViewNew(character: character)
    }
}
