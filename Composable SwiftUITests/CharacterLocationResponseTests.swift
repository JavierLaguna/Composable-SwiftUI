//
//  CharacterLocationResponseTests.swift
//  Composable SwiftUI
//
//  Created by Javier Laguna on 9/5/25.
//

import XCTest
@testable import Composable_SwiftUI

final class CharacterLocationResponseTests: XCTestCase {

    func test_toDomain_withValidURL_shouldMapCorrectly() {
        // Given
        let response = CharacterLocationResponse(name: "Earth", url: "https://api.com/location/42")

        // When
        let domain = response.toDomain()

        // Then
        XCTAssertEqual(domain.id, 42)
        XCTAssertEqual(domain.name, "Earth")
    }

    func test_toDomain_withInvalidURL_shouldDefaultIdToZero() {
        // Given
        let response = CharacterLocationResponse(name: "Unknown", url: "invalid_url")

        // When
        let domain = response.toDomain()

        // Then
        XCTAssertEqual(domain.id, 0)
        XCTAssertEqual(domain.name, "Unknown")
    }

    func test_toDomain_withEmptyURL_shouldDefaultIdToZero() {
        // Given
        let response = CharacterLocationResponse(name: "Nowhere", url: "")

        // When
        let domain = response.toDomain()

        // Then
        XCTAssertEqual(domain.id, 0)
        XCTAssertEqual(domain.name, "Nowhere")
    }
}
