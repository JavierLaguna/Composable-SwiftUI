import SwiftUI
import Kingfisher
import SkeletonUI

struct CharacterCellView: View {
    var character: Character?

    private var showLoading: Bool {
        character == nil
    }

    var body: some View {
        ZStack {
            HStack(spacing: -Theme.Space.xl) {
                KFImage(URL(string: character?.image ?? ""))
                    .resizable()
                    .skeleton(with: showLoading)
                    .shape(type: .rectangle)
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .cornerRadius(30)
                    .zIndex(1)

                HStack {

                    if let character {
                        VStack(alignment: .leading, spacing: Theme.Space.l) {
                            Text(character.name)
                                .specialBodyStyle()
                                .skeleton(with: showLoading)

                            TagView(
                                text: character.location.name,
                                icon: Image(systemName: "globe.europe.africa.fill")
                            )

                            Spacer()
                        }
                        .padding(.top)
                        .padding(.leading)

                        Spacer()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 90)
                .background(Theme.Colors.backgroundSecondary)
                .cornerRadius(10)
            }
        }

    }
}

#Preview {
    CharacterCellView(character: Character.mock)
        .padding()
        .background(.black)
}
