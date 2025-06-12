import SwiftUI
import ComposableArchitecture
import Kingfisher

struct CharacterDetailView: View {

    let store: StoreOf<CharacterNeighborsReducer>
    let character: Character

    @Namespace private var namespace

    var body: some View {
        Group {
//            if store.locationDetail.isLoading {
//                LoadingView()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .ignoresSafeArea()
//
//            } else {
                MainContentView(character: character, namespace: namespace)
//            }
        }
        .background(BackgroundPatternSecondaryView())
        .ignoresSafeArea(.container, edges: .bottom) // Permitir que el contenido se extienda al safe area inferior
    }
}

private struct GeometryEffectIds {
    static let character = "characterImage"
    static let status = "characterStatus"
    static let name = "characterName"
    static let species = "characterSpecies"
}

private struct MainContentView: View {

    let character: Character
    let namespace: Namespace.ID

    private let collapseThreshold: CGFloat = 120
    private let hysteresis: CGFloat = 20

    @State private var isCollapsed: Bool = false
    @State private var namePosition: CGFloat = 0

    private func updateCollapsedState(scrollOffset: CGFloat) {
        let shouldCollapse: Bool

        if isCollapsed {
            // Si está colapsado, necesita menos scroll para expandirse (hysteresis)
            shouldCollapse = scrollOffset > (collapseThreshold - hysteresis)
        } else {
            // Si está expandido, necesita más scroll para colapsar (hysteresis)
            shouldCollapse = scrollOffset > (collapseThreshold + hysteresis)
        }

        if shouldCollapse != isCollapsed {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCollapsed = shouldCollapse
            }
        }
    }

    @ViewBuilder
    private var headerView: some View {
        Group {
            if isCollapsed {
                CollapsedHeaderView(character: character, namespace: namespace)

            } else {
                ExpandedHeaderView(character: character, namespace: namespace)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isCollapsed)
    }

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: Theme.Space.none) {
                headerView

                ScrollViewReader { _ in
                    ScrollView {
                        VStack(spacing: 0) {
                            // Bottom content overlay
                            BottomContentView(character: character, namespace: namespace)
                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onChange(of: geometry.frame(in: .named("scrollView")).minY) { _, newValue in
                                        updateCollapsedState(scrollOffset: abs(newValue))
                                    }
                            }
                        )
                    }
                    .coordinateSpace(name: "scrollView")
                }
            }
            .clipped()
        }
    }
}

private struct ExpandedHeaderView: View {

    let character: Character
    let namespace: Namespace.ID

    var body: some View {
        CharacterImageView(
            character: character,
            size: .large,
            namespace: namespace
        )
        .overlay(alignment: .topTrailing) {
            VStack(alignment: .trailing, spacing: Theme.Space.xl) {
                StatusBadgeView(status: character.status)
                    .matchedGeometryEffect(id: GeometryEffectIds.status, in: namespace)

                InfoCard(
                    title: "SPECIES",
                    value: character.species.uppercased()
                )
                .matchedGeometryEffect(id: GeometryEffectIds.species, in: namespace)
            }
            .offset(
                x: 40,
                y: Theme.Space.xl
            )
        }
        .padding(.top, Theme.Space.xl)
    }
}

struct CollapsedHeaderView: View {

    let character: Character
    let namespace: Namespace.ID

    var body: some View {
        HStack(spacing: Theme.Space.xl) {
            CharacterImageView(character: character, size: .small, namespace: namespace)

            VStack(alignment: .leading, spacing: 8) {
                Text(character.name.uppercased())
                    .font(Theme.Fonts.title)
                    .foregroundColor(Theme.Colors.primary)
                    .shadow(color: .black, radius: 0, x: 1, y: 1)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: GeometryEffectIds.name, in: namespace)

                HStack(spacing: 8) {
                    StatusBadgeView(status: character.status)
                        .matchedGeometryEffect(id: GeometryEffectIds.status, in: namespace)

                    TagView(text: character.species)
                        .matchedGeometryEffect(id: GeometryEffectIds.species, in: namespace)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Color.black.opacity(0.95)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Theme.Colors.primary.opacity(0.3)),
                    alignment: .bottom
                )
        )
    }
}

private struct CharacterImageView: View {

    enum Size {
        case small
        case large

        var size: CGFloat {
            switch self {
            case .small: 64
            case .large: 320
            }
        }
    }

    let character: Character
    let size: Size
    let namespace: Namespace.ID

    var body: some View {
        KFImage(URL(string: character.image))
            .resizable()
            .scaledToFit()
            .frame(
                width: size.size * 0.95,
                height: size.size * 0.95
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.black.opacity(0.4))
                    .frame(
                        width: size.size,
                        height: size.size
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Theme.Colors.primary, lineWidth: 4)
                    )
            }
            .matchedGeometryEffect(id: GeometryEffectIds.character, in: namespace)
    }
}

private struct BottomContentView: View {
    let character: Character
    let namespace: Namespace.ID

    var body: some View {
        VStack(spacing: 0) {
            // Gradiente que se conecta con la imagen de arriba
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.8),
                    Color.black.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: Theme.Space.xl) {
                    Text(character.name.uppercased())
                        .font(Theme.Fonts.title)
                        .fontWeight(.black)
                        .foregroundColor(Theme.Colors.primary)
                        .shadow(color: .black, radius: 0, x: 2, y: 2)
                        .matchedGeometryEffect(id: GeometryEffectIds.name, in: namespace)

                    HStack(spacing: Theme.Space.xl) {
                        TagView(text: "\(character.created.formatted(.dateTime.year())) | \(character.gender.localizedDescription)")

                        TagView(text: character.type)
                    }
                }

                Text(character.description)
                    .multilineTextAlignment(.leading)
                    .font(.custom("Impact", size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))

                HStack(spacing: Theme.Space.xl) {
                    InfoCard(
                        title: "ORIGIN",
                        value: character.origin.name
                    )

                    InfoCard(
                        title: "LAST LOCATION",
                        value: character.location.name
                    )

                    InfoCard(
                        title: "Nº EPISODES",
                        value: "\(character.episodes.count)"
                    )
                }

                // Botón de navegación siempre visible
                HStack {
                    Spacer()
                    NavigationButton(icon: "chevron.right")
                    Spacer()
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 62)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black.opacity(0.95))

            // Extender el fondo negro solo para cubrir safe area inferior
            Color.black.opacity(0.95)
                .frame(height: 50)
        }
    }
}

private struct TagView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.custom("Impact", size: 12))
            .fontWeight(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Theme.Colors.primary.opacity(0.2))
                    .overlay(
                        Capsule()
                            .stroke(Theme.Colors.primary, lineWidth: 1)
                    )
            )
            .foregroundColor(Theme.Colors.primary)
    }
}

private struct InfoCard: View {

    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Space.s) {
            Text(title)
                .font(.custom("Impact", size: 12))
                .fontWeight(.black)
                .foregroundColor(Theme.Colors.primary)

            Text(value)
                .font(.custom("Impact", size: 14))
                .fontWeight(.black)
                .foregroundColor(.white)
        }
        .padding(Theme.Space.xl)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.m)
                .fill(Color.black.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.m)
                        .stroke(Theme.Colors.primary.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

private struct NavigationButton: View {
    let icon: String
    let isActive: Bool

    init(icon: String, isActive: Bool = false) {
        self.icon = icon
        self.isActive = isActive
    }

    var body: some View {
        Button(action: {}) {
            Circle()
                .fill(isActive ? Theme.Colors.primary.opacity(0.2) : Color.black.opacity(0.6))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(Theme.Colors.primary)
                        .font(.system(size: 20, weight: .medium))
                )
                .overlay(
                    Circle()
                        .stroke(
                            isActive ? Theme.Colors.primary : Theme.Colors.primary.opacity(0.3),
                            lineWidth: 2
                        )
                )
        }
        .scaleEffect(isActive ? 1.1 : 1.0)
        .animation(.spring(response: 0.3), value: isActive)
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(
            store: Store(
                initialState: .init(
                    locationDetail: .init(state: .loading)
                ),
                reducer: {
                    CharacterNeighborsReducer.build(locationId: 1)
                }
            ),
            character: Character.mock
        )
    }
}
