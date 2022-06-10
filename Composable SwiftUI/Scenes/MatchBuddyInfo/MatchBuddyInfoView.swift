import SwiftUI

struct MatchBuddyInfoView: View {
    var body: some View {
        VStack(spacing: Theme.Space.xl) {
            
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(Theme.Colors.primary)
                .padding(.bottom, Theme.Space.xxl)
            
            Text(R.string.localizable.matchBuddyInfoParagraph1())
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.body)
            
            Text(R.string.localizable.matchBuddyInfoParagraph2())
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.body)
            
            Text(R.string.localizable.matchBuddyInfoParagraph3())
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.body)
            
            Text(R.string.localizable.matchBuddyInfoParagraph4())
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.body)
            
            Text(R.string.localizable.matchBuddyInfoParagraph5())
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.body)
        }
        .padding(Theme.Space.xxl)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(Theme.Colors.background)
    }
}

struct MatchBuddyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MatchBuddyInfoView()
    }
}
