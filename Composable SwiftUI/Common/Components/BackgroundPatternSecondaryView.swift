import SwiftUI

struct BackgroundPatternSecondaryView: View {

    var body: some View {
        ZStack {
            R.image.ic_background_2.image
                .resizable()
                .scaledToFill()

            if Theme.isDarkMode {
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
