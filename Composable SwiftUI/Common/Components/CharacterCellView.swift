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
                    VStack(alignment: .leading) {
                        Text(character?.name)
                            .foregroundColor(Theme.Colors.text)
                            .font(Theme.Fonts.body)
                            .skeleton(with: showLoading)
                        
                        Text(character?.species)
                            .foregroundColor(Theme.Colors.text)
                            .font(Theme.Fonts.body2)
                            .skeleton(with: showLoading)
                        
                        Text(character?.type)
                            .foregroundColor(Theme.Colors.text)
                            .font(Theme.Fonts.body2)
                            .skeleton(with: showLoading)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 90)
                .background(Theme.Colors.background)
                .cornerRadius(10)
            }
        }
        
    }
}

struct CharacterCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
        
        CharacterCellView(character: character)
    }
}
