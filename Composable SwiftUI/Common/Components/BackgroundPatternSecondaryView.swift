import SwiftUI

struct BackgroundPatternSecondaryView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    var body: some View {
        ZStack {
            R.image.ic_background_2.image
                .resizable()
                .scaledToFill()

            Theme.Colors.background.opacity(colorScheme == .dark ? 0.5 : 0.7)
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
