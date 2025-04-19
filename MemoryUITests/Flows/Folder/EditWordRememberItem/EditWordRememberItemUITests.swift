//
//  EditWordRememberItem.swift
//  Memory
//
//  Created by Anton Semenov on 12.03.2025.
//

import XCTest
import Foundation

@testable import Memory

final class EditWordRememberItemUITests: SCTestBase {
    let word = "Word"
    let transcription = "wɜːrd"
    let translation = "Слово"

    func testEditFolder() throws {
        UITestsMocks.mockWordRememberItem(
            app: app,
            word: UITestsMocks.WordMock(
                word: word,
                transcription: transcription,
                translation: translation,
                examples: [
                    UITestsMocks.WordMock.Example(
                        example: "First example",
                        translation: "Первый пример"
                    )
                ]
            )
        )

        let notEmptyList = app.collectionViews[CategoryDetailsAccessibilityIdentifier.collectionView]
        notEmptyList.cells.element(boundBy: 5).tap()

        app.buttons[CategoryDetailsAccessibilityIdentifier.editButton].tap()

        let editedRememberWord = "Edited Word"
        let editedRememberTranscription = "edited wɜːrd"
        let editedRememberTranslation = "Измененное слово"

        let nameTextField = app.textFields[EditWordRememberItemAccessibilityIdentifier.wordTextField]
        sleep(1)
        nameTextField.tap()
        nameTextField.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        nameTextField.typeText(editedRememberWord)

        let iconTextField = app.textFields[EditWordRememberItemAccessibilityIdentifier.transcriptionTextField]
        iconTextField.tap()
        iconTextField.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        iconTextField.typeText(editedRememberTranscription)

        let descriptionTextField = app.textFields[EditWordRememberItemAccessibilityIdentifier.translationTextField]
        descriptionTextField.tap()
        descriptionTextField.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        descriptionTextField.typeText(editedRememberTranslation)

        let saveButton = app.buttons[EditWordRememberItemAccessibilityIdentifier.saveButton]
        saveButton.tap()

        let editedWordItem = notEmptyList.cells.element(boundBy: 5)
        let title = editedWordItem.staticTexts[CategoryDetailsAccessibilityIdentifier.wordValueCellTitle(id: 1)]
        XCTAssertEqual(title.label, editedRememberWord)
        let icon = editedWordItem.staticTexts[CategoryDetailsAccessibilityIdentifier.wordTranslationCellTitle(id: 1)]
        XCTAssertEqual(icon.label, editedRememberTranslation)
    }

    func testCreateWordRememberItem() throws {
        UITestsMocks.mockWordRememberItem(
            app: app,
            word: UITestsMocks.WordMock(
                word: word,
                transcription: transcription,
                translation: translation,
                examples: [
                    UITestsMocks.WordMock.Example(
                        example: "First example",
                        translation: "Первый пример"
                    )
                ]
            )
        )

        let notEmptyList = app.collectionViews[CategoryDetailsAccessibilityIdentifier.collectionView]

        XCTAssertEqual(notEmptyList.staticTexts[CategoryDetailsAccessibilityIdentifier.wordValueCellTitle(id: 1)].label, word)
        XCTAssertEqual(notEmptyList.staticTexts[CategoryDetailsAccessibilityIdentifier.wordTranslationCellTitle(id: 1)].label, translation)
    }
}
