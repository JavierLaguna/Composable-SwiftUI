import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        VStack {
            ProgressView()
                .controlSize(.large)
                .tint(Theme.Colors.primary)
                .padding(Theme.Space.l)
        }
        .padding(Theme.Space.xxxl)
        .background(.ultraThinMaterial)
        .cornerRadius(Theme.Radius.l)
    }
}

struct LoadingView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoadingView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
