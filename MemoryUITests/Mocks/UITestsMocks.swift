//
//  Mocks.swift
//  Memory
//
//  Created by Anton Semenov on 08.03.2025.
//

import XCTest
import Foundation

enum UITestsMocks {
    struct FolderMock {
        let name: String
        let icon: String
        let description: String
    }

    static func mockFolder(
        app: XCUIApplication,
        folder: FolderMock = .init(
            name: "Folder name",
            icon: "😍",
            description: "Folder description"
        )
    ) {
        let listTab = app.tabBars.buttons["List"]
        listTab.tap()

        let newFolderButton = app.buttons[FoldersListAccessibilityIdentifier.newFolderButton]
        newFolderButton.tap()

        let nameTextField = app.textFields[EditFolderAccessibilityIdentifier.nameField]
        nameTextField.tap()
        nameTextField.typeText(folder.name)

        let iconTextField = app.textFields[EditFolderAccessibilityIdentifier.iconField]
        iconTextField.tap()
        iconTextField.typeText(folder.icon)

        let descriptionTextField = app.textFields[EditFolderAccessibilityIdentifier.descriptionField]
        descriptionTextField.tap()
        descriptionTextField.typeText(folder.description)

        let isFavoriteSwitch = app.switches[EditFolderAccessibilityIdentifier.isFavoriteSwitch]
        isFavoriteSwitch.tap()

        let saveButton = app.buttons[EditFolderAccessibilityIdentifier.saveButton]
        saveButton.tap()
    }

    struct CategoryMock {
        let name: String
        let icon: String
        let description: String
    }

    static func mockCategory(
        app: XCUIApplication,
        category: CategoryMock = .init(
            name: "Category name",
            icon: "🥶",
            description: "category description"
        )
    ) {
        Self.mockFolder(app: app)
        
        app.tabBars.buttons["List"].tap()
        app.collectionViews[FoldersListAccessibilityIdentifier.folderList].cells.element(boundBy: 1).tap()
        app.buttons[FolderDetailsAccessibilityIdentifier.addCategoryButton].tap()

        let nameTextField = app.textFields[EditCategoryAccessibilityIdentifier.nameField]
        nameTextField.tap()
        nameTextField.typeText(category.name)

        let iconTextField = app.textFields[EditCategoryAccessibilityIdentifier.iconField]
        iconTextField.tap()
        iconTextField.typeText(category.icon)

        let descriptionTextField = app.textFields[EditCategoryAccessibilityIdentifier.descriptionField]
        descriptionTextField.tap()
        descriptionTextField.typeText(category.description)

        let saveButton = app.buttons[EditCategoryAccessibilityIdentifier.saveButton]
        saveButton.tap()
    }

    struct WordMock {
        let word: String
        let transcription: String
        let translation: String
        let examples: [Example]

        struct Example {
            let example: String
            let translation: String
        }
    }

    static func mockWordRememberItem(
        app: XCUIApplication,
        word: WordMock = WordMock(
            word: "Word",
            transcription: "wɜːrd",
            translation: "Слово",
            examples: [
                WordMock.Example(example: "First example", translation: "Первый пример")
            ]
        )
    ) {
        Self.mockCategory(app: app)

        app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellDescription(id: 1)].tap()

        app.buttons[CategoryDetailsAccessibilityIdentifier.newRememberItemButton].tap()
        let nameTextField = app.textFields[EditWordRememberItemAccessibilityIdentifier.wordTextField]
        nameTextField.tap()
        nameTextField.typeText(word.word)

        let iconTextField = app.textFields[EditWordRememberItemAccessibilityIdentifier.transcriptionTextField]
        iconTextField.tap()
        iconTextField.typeText(word.transcription)

        let descriptionTextField = app.textFields[EditWordRememberItemAccessibilityIdentifier.translationTextField]
        descriptionTextField.tap()
        descriptionTextField.typeText(word.translation)

        word.examples.forEach {
            app.buttons[EditWordRememberItemAccessibilityIdentifier.newExampleButton].tap()

            let exampleTextField = app.textViews
                .matching(identifier: EditWordRememberItemAccessibilityIdentifier.newExampleTextField)
                .allElementsBoundByIndex
                .last!
//                .textFields
//                .firstMatch
            exampleTextField.tap()
            exampleTextField.typeText($0.example)

            let exampleTranslationTextField = app.textViews
                .matching(identifier: EditWordRememberItemAccessibilityIdentifier.newExampleTranslationTextField)
                .allElementsBoundByIndex
                .last!
//                .textFields
//                .firstMatch

            exampleTranslationTextField.tap()
            exampleTranslationTextField.typeText($0.translation)
        }

        app.switches[EditWordRememberItemAccessibilityIdentifier.startLearnSwitcher].tap()

        let saveButton = app.buttons[EditWordRememberItemAccessibilityIdentifier.saveButton]
        saveButton.tap()
    }
}
