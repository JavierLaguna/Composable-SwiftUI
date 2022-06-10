import SwiftUI

struct ErrorView: View {
    var error: Error
    var onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: Theme.Space.xxl) {
            R.image.error_404.image
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(Theme.Radius.xl)
            
            Text(error.localizedDescription) 
                .font(Theme.Fonts.title2)
                .foregroundColor(Theme.Colors.text)
                .multilineTextAlignment(.center)
            
            ButtonView(title: R.string.localizable.commonsRetry()) {
                onRetry()
            }
        }
        .padding(Theme.Space.xxl)
        .background(Theme.Colors.background)
        .cornerRadius(Theme.Radius.xxl)
        .shadow(radius: Theme.Radius.m)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        let error = InteractorError.generic(message: "Algo ha fallado")
        ErrorView(error: error, onRetry: {})
    }
}
