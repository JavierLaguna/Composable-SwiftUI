import SwiftUI

struct BackgroundPatternPrimaryView: View {

    var body: some View {
        R.image.ic_background.image
            .resizable()
            .scaledToFill()
            .ignoresSafeArea(.all)
    }
}

#Preview {
    HStack {
        Spacer()
    }
    .background(BackgroundPatternPrimaryView())
}
