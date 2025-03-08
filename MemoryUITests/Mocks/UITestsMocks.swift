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
}
