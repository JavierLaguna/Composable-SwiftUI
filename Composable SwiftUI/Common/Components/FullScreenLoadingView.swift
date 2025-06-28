import SwiftUI

struct FullScreenLoadingView: View {

    var body: some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}

#Preview {
    FullScreenLoadingView()
}
