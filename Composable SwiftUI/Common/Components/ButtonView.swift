import SwiftUI

struct ButtonView: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title.uppercased())
                .font(Theme.Fonts.button)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.buttonText)
                .padding()
                .background(Theme.Colors.buttonBackground)
                .cornerRadius(20)
                .shadow(radius: 10)
        })
    }
}

#Preview {
    ButtonView(title: "Button") {
        print("button pressed")
    }
}
