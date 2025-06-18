import SwiftUI

// MARK: TextModifiers
extension View {

    func specialTitleStyle() -> some View {
        modifier(SpecialTitleModifier())
    }

    func specialSubtitleStyle() -> some View {
        modifier(SpecialSubtitleModifier())
    }

    func specialBodyStyle() -> some View {
        modifier(SpecialBodyModifier())
    }

    func titleStyle(small: Bool = false, bold: Bool = false) -> some View {
        modifier(TitleModifier(small: small, bold: bold))
    }

    func subtitleStyle() -> some View {
        modifier(SubtitleModifier())
    }

    func sectionTitleStyle() -> some View {
        modifier(SectionTitleModifier())
    }

    func bodyStyle(small: Bool = false, bold: Bool = false) -> some View {
        modifier(BodyModifier(small: small, bold: bold))
    }

    func chipStyle() -> some View {
        modifier(ChipModifier())
    }
}

struct SpecialTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.Fonts.Special.title)
            .foregroundStyle(Theme.Colors.primary)
            .textCase(.uppercase)
    }
}

struct SpecialSubtitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.Fonts.Special.subtitle)
            .foregroundStyle(Theme.Colors.primary)
            .textCase(.uppercase)
    }
}

struct SpecialBodyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.Fonts.Special.body)
            .foregroundStyle(Theme.Colors.primary)
            .textCase(.uppercase)
    }
}

struct TitleModifier: ViewModifier {
    let small: Bool
    let bold: Bool

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(Theme.Colors.primary)
            .textCase(.uppercase)
    }

    private var font: Font {
        switch (small, bold) {
        case (true, true): Theme.Fonts.title2Bold
        case (true, false): Theme.Fonts.title2
        case (false, true): Theme.Fonts.titleBold
        case (false, false): Theme.Fonts.title
        }
    }
}

struct SubtitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.Fonts.subtitle)
            .foregroundStyle(Theme.Colors.primary)
            .textCase(.uppercase)
    }
}

struct SectionTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.Fonts.sectionTitle)
            .foregroundStyle(Theme.Colors.primary)
            .textCase(.uppercase)
    }
}

struct BodyModifier: ViewModifier {
    let small: Bool
    let bold: Bool

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(Theme.Colors.text)
    }

    private var font: Font {
        switch (small, bold) {
        case (true, true): Theme.Fonts.body2Bold
        case (true, false): Theme.Fonts.body2
        case (false, true): Theme.Fonts.bodyBold
        case (false, false): Theme.Fonts.body
        }
    }
}

struct ChipModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.Fonts.chip)
            .foregroundStyle(Theme.Colors.primary)
            .textCase(.uppercase)
    }
}
