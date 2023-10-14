import SwiftUI
import ScalingHeaderScrollView
import Kingfisher

struct CharacterDetailView: View {

    private let minHeight = 110.0
    private let maxHeight = 372.0

    var character: Character

    @State private var progress: CGFloat = 0

    var body: some View {
        ScalingHeaderScrollView {
            ZStack {
                ZStack {
                    Theme.Colors.background.edgesIgnoringSafeArea(.all)
                    largeHeader(progress: progress)
                }
            }
        } content: {
            VStack(alignment: .leading, spacing: 20) {
                infoView(title: R.string.localizable.characterDetailStatus(), value: character.status.localizedDescription)

                infoView(title: R.string.localizable.characterDetailSpecies(), value: character.species)

                infoView(title: R.string.localizable.characterDetailType(), value: character.type.isEmpty ? "-" : character.type)

                infoView(title: R.string.localizable.characterDetailGender(), value: character.gender.localizedDescription)

                infoView(title: R.string.localizable.characterDetailOrigin(), value: character.origin.name)

                infoView(title: R.string.localizable.characterDetailLocation(), value: character.location.name)

                infoView(title: R.string.localizable.characterDetailNumberOfEpisodes(), value: String(character.episodes.count))

                Color.clear.frame(height: 100)
            }
            .padding(.top, -110)
            .padding(.horizontal, Theme.Space.xxl)
            .frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
        }
        .height(min: minHeight, max: maxHeight)
        .collapseProgress($progress)
        .background(Theme.Colors.background)
    }

    private var smallHeader: some View {
        HStack(spacing: 12.0) {
            KFImage(URL(string: character.image))
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .clipShape(RoundedRectangle(cornerRadius: 6.0))

            Text(character.name)
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.subtitle)
        }
    }

    private func largeHeader(progress: CGFloat) -> some View {
        ZStack {
            KFImage(URL(string: character.image))
                .resizable()
                .scaledToFill()
                .frame(height: maxHeight)
                .opacity(1 - progress)

            VStack {
                Spacer()

                ZStack(alignment: .leading) {

                    VisualEffectView(effect: UIBlurEffect(style: .regular))
                        .mask(Rectangle().cornerRadius(40, corners: [.topLeft, .topRight]))
                        .offset(y: 10.0)
                        .frame(height: 80.0)

                    RoundedRectangle(cornerRadius: 40.0, style: .circular)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [Theme.Colors.background.opacity(0.0), Theme.Colors.background]
                                ),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    Text(character.name)
                        .foregroundColor(Theme.Colors.text)
                        .font(Theme.Fonts.title)
                        .padding(.leading, 24.0)
                        .padding(.top, 10.0)
                        .opacity(1 - max(0, min(1, (progress - 0.75) * 4.0)))

                    smallHeader
                        .padding(.leading, 85.0)
                        .opacity(progress)
                        .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
                }
                .frame(height: 80.0)
            }
        }
    }

    private func infoView(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.Space.m) {
            Text(title)
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.title2)
                .underline()

            Text(value)
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.subtitle)
        }
    }
}

#Preview {
    let location = CharacterLocation(id: 1, name: "Earth")
    let character = Character(
        id: 1,
        name: "Rick Sanchez",
        status: .alive,
        species: "Human",
        type: "",
        gender: .male,
        origin: location,
        location: location,
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episodes: []
    )

    return CharacterDetailView(character: character)
}
