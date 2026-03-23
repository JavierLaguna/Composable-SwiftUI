import SwiftUI

struct BackgroundImageModifier: ViewModifier {
    let image: Image

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.bottom + geometry.safeAreaInsets.top)
                    .offset(y: -geometry.safeAreaInsets.top)

                content
            }
        }
    }
}

extension View {
    func backgroundImage(_ image: Image) -> some View {
        modifier(BackgroundImageModifier(image: image))
    }
}
