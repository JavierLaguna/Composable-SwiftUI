import SwiftUI
import ComposableArchitecture
import Kingfisher

struct CharacterDetailView: View {

    let store: StoreOf<CharacterDetailReducer>

    @Namespace private var namespace

    var body: some View {
        Group {
            if store.currentCharacter.isLoading {
                FullScreenLoadingView()

            } else {
                MainContentView(namespace: namespace)
            }
        }
        .background(BackgroundPatternSecondaryView())
        .ignoresSafeArea(.container, edges: .bottom)
        .environment(store)
        .task {
            store.send(.onAppear)
        }
    }
}

private struct GeometryId {
    static let character = "characterImage"
    static let status = "characterStatus"
    static let name = "characterName"
    static let species = "characterSpecies"
    static let scroll = "scrollView"
}

private struct MainContentView: View {

    @Environment(StoreOf<CharacterDetailReducer>.self)
    private var store

    let namespace: Namespace.ID

    private let collapseThreshold: CGFloat = 120
    private let hysteresis: CGFloat = 20

    @State private var isCollapsed: Bool = false
    @State private var namePosition: CGFloat = 0

    var character: Character {
        store.currentCharacter.data! // TODO: JLI - Fix
    }

    private func updateCollapsedState(scrollOffset: CGFloat) {
        let shouldCollapse: Bool

        if isCollapsed {
            shouldCollapse = scrollOffset > (collapseThreshold - hysteresis)
        } else {
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
                CollapsedHeaderView(
                    character: character,
                    namespace: namespace
                )

            } else {
                ExpandedHeaderView(character: character, namespace: namespace)
                    .offset(y: Theme.Space.xxl)
                    .zIndex(1)
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
                        VStack(spacing: Theme.Space.none) {
                            DetailContentView(namespace: namespace)
                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onChange(of: geometry.frame(in: .named(GeometryId.scroll)).minY) { _, newValue in
                                        updateCollapsedState(scrollOffset: abs(newValue))
                                    }
                            }
                        )
                    }
                    .coordinateSpace(name: GeometryId.scroll)
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
                    .matchedGeometryEffect(id: GeometryId.status, in: namespace)

                InfoCard(
                    title: R.string.localizable.characterDetailSpecies(),
                    value: character.species
                )
                .fixedSize(horizontal: true, vertical: true)
                .matchedGeometryEffect(id: GeometryId.species, in: namespace)
            }
            .offset(
                x: Theme.Space.xxxl,
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

            VStack(alignment: .leading, spacing: Theme.Space.m) {
                Text(character.name)
                    .specialBodyStyle()
                    .lineLimit(1)
                    .matchedGeometryEffect(
                        id: GeometryId.name,
                        in: namespace
                    )

                HStack(spacing: Theme.Space.m) {
                    StatusBadgeView(status: character.status)
                        .matchedGeometryEffect(id: GeometryId.status, in: namespace)

                    TagView(text: character.species)
                        .matchedGeometryEffect(id: GeometryId.species, in: namespace)
                }
            }

            Spacer()
        }
        .padding(.horizontal, Theme.Space.xl)
        .padding(.vertical, Theme.Space.l)
        .background(
            Theme.Colors.background
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
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.xl))
            .background {

                let cornerRadius = Theme.Radius.xl + 4

                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.black.opacity(0.4))
                    .frame(
                        width: size.size,
                        height: size.size
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Theme.Colors.primary, lineWidth: 4)
                    )
            }
            .matchedGeometryEffect(id: GeometryId.character, in: namespace)
    }
}

private struct DetailContentView: View {

    static private let bgColor = Theme.Colors.background

    @Environment(StoreOf<CharacterDetailReducer>.self)
    private var store

    @Environment(CharactersCoordinator.self)
    private var charactersCoordinator

    let namespace: Namespace.ID

    var character: Character {
        store.currentCharacter.data! // TODO: JLI - Fix
    }

    var body: some View {
        VStack(spacing: Theme.Space.none) {
            LinearGradient(
                colors: [
                    Color.clear,
                    Self.bgColor.opacity(0.3),
                    Self.bgColor.opacity(0.55),
                    Self.bgColor.opacity(0.8),
                    Self.bgColor
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)

            VStack(alignment: .leading, spacing: Theme.Space.xxl) {
                Group {
                    VStack(alignment: .leading, spacing: Theme.Space.xl) {
                        Text(character.name)
                            .specialTitleStyle()
                            .matchedGeometryEffect(
                                id: GeometryId.name,
                                in: namespace
                            )

                        HStack(spacing: Theme.Space.xl) {
                            TagView(text: "\(character.created.formatted(.dateTime.year())) | \(character.gender.localizedDescription)")

                            if !character.type.isEmpty {
                                TagView(text: character.type)
                            }
                        }
                    }

                    Text(character.description)
                        .bodyStyle()
                        .multilineTextAlignment(.leading)

                    HStack(alignment: .top, spacing: Theme.Space.xl) {
                        InfoCard(
                            title: R.string.localizable.characterDetailOrigin(),
                            value: character.origin.name
                        )

                        InfoCard(
                            title: R.string.localizable.characterDetailLocation(),
                            value: character.location.name
                        )

                        InfoCard(
                            title: R.string.localizable.characterDetailNumberOfEpisodes(),
                            value: "\(character.episodes.count)"
                        )
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, Theme.Space.xxl)

                if store.viewMode == .allInfo {
                    if let episodes = store.episodes.data {
                        EpisodeCarouselView(
                            episodes: episodes,
                            onEpisodeTap: {
                                charactersCoordinator.navigateToEpisodeDetail(episode: $0)
                            },
                            onSeeAll: {
                                charactersCoordinator.navigateToEpisodesList(episodes: episodes)
                            }
                        )
                        .padding(.top, Theme.Space.m)
                    }

                    Group {
                        HStack {
                            Spacer()

                            ButtonView(
                                title: R.string.localizable.characterDetailBeerBuddy(),
                                icon: "mug.fill"
                            ) {
                                charactersCoordinator.navigateToBeerBuddy(character: character)
                            }

                            Spacer()
                        }
                        .padding(.top, Theme.Space.l)

                        HStack {
                            Spacer()

                            ButtonView(
                                title: R.string.localizable.characterDetailNeighbors(),
                                icon: "house.lodge.fill"
                            ) {
                                charactersCoordinator.navigateToNeighbors(character: character)
                            }

                            Spacer()
                        }

                        HStack {
                            CircleIconButton(
                                icon: "chevron.left",
                                isDisabled: !store.canSeePreviousCharacter
                            ) {
                                store.send(.seePreviousCharacter)
                            }

                            Spacer()

                            CircleIconButton(
                                icon: "chevron.right",
                                isDisabled: !store.canSeeNextCharacter
                            ) {
                                store.send(.seeNextCharacter)
                            }
                        }
                        .padding(.top, Theme.Space.xl)
                    }
                    .padding(.horizontal, Theme.Space.xxl)
                }
            }
            .padding(.bottom, 62)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Self.bgColor)

            Self.bgColor
                .frame(height: 50)
        }
    }
}

private struct InfoCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Space.s) {
            Text(title)
                .sectionTitleStyle()

            Spacer()

            Text(value)
                .bodyStyle(small: true, bold: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(Theme.Space.xl)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.m)
                .fill(Theme.Colors.background)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.m)
                        .stroke(Theme.Colors.primary.opacity(0.8), lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(
            store: Store(
                initialState: .init(
                    character: Character.mock,
                    viewMode: .allInfo
                ),
                reducer: {
                    CharacterDetailReducer.build()
                }
            )
        )
    }
    .allEnvironmentsInjected
}
