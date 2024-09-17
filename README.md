# 📱 Composable SwiftUI

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=JavierLaguna_Composable-SwiftUI&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=JavierLaguna_Composable-SwiftUI)

[![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=JavierLaguna_Composable-SwiftUI)](https://sonarcloud.io/summary/new_code?id=JavierLaguna_Composable-SwiftUI)

## 📝 Description

Little iOS app for consume [The Rick and Morty](https://rickandmortyapi.com/) API. Inspired on [RickAndMortyBeerBuddy](https://github.com/danielriverolosa/RickAndMortyBeerBuddy) Android project from [Daniel Rivero Losa](https://github.com/danielriverolosa).

The target of the app is list all characters of the television show Rick and Morty.
Show the character details and the Beer Buddy of all characters.

> Project used for learn SwiftUI + TCA architecture

## 📷 Screenshots

![Character List](/.readme_resources/characters_list.png)
![Character List Error](/.readme_resources/characters_list_error.png)

![Character List Search](/.readme_resources/characters_list_search.png)
![Character List Search No Results](/.readme_resources/characters_list_search_no_results.png)

![Character Detail](/.readme_resources/character_detail_1.png)
![Character Detail](/.readme_resources/character_detail_2.png)

![Match Beer Buddy](/.readme_resources/match_beer_buddy.png)
![Match Beer Buddy Not Found](/.readme_resources/match_beer_buddy_not_found.png)

![Beer Buddy Info](/.readme_resources/beer_buddy_info.png)


## 🚩 Instructions

1. ⬇️ Get dependencies

    1. Install rswift with Homebrew

        ```bash
        brew install rswift
        ```

    1.  Open Xcode and SPM will autoinstall the dependencies.

## 🚧 Application Architecture

[Swift](https://www.apple.com/es/swift/) + [SwiftUI](https://developer.apple.com/xcode/swiftui/) app.

Based on [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) + [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture) as main architecture.

[Coordinator](https://khanlou.com/2015/01/the-coordinator/) pattern for routing.

[GitFlow](https://datasift.github.io/gitflow/IntroducingGitFlow.html) as Git methodology.

## ✅ App Features

##### Character List

- List all characters with infinite pagination
- Search character by name

##### Character detail

- Show chracater info details

##### Character Beer Buddy

- Once the user selects a character the application will search for the perfect galactic beer companion by applying the following criteria:

    - The Ricks Council has decreed perimeter confinement of planets, so actors will only be able to date actors that are in the same location.

    - In order for them to have enough anecdotes to tell while getting drunk, priority will be given to the characters who have shared more times filming set, for this purpose the number of chapters in which they have coincided will be bought.

    - In case two possible matches have shared the same number of chapters with the selected character, preference will be given to those who have known each other the longest, using the date of the first chapter in which they appeared together.

    - If they have participated in the same number of chapters, and they met on the same day, priority will be given to the candidate who has not seen the selected character for the longest time, using the date of the last chapter in which they both appeared.

    - Finally, in case there is more than one candidate that meets all the criteria, they will be ordered by ID.

## 🛠 Work in progress

- Fix TabBar accent color.

## 🔮 Next steps / features

- Split SwiftUI components for improve reuse.
- Add some library for mock entities for use in tests and SwiftUI previews.
- Show Location and Episodes info.

## 💻 Author

> Javier Laguna
