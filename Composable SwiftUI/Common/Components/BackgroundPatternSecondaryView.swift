import SwiftUI

struct BackgroundPatternSecondaryView: View {

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            R.image.ic_background_2.image
                .resizable()
                .scaledToFill()

            if colorScheme == .dark {
                Color.black.opacity(0.5)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HStack {
        Spacer()
    }
    .background(BackgroundPatternSecondaryView())
}
