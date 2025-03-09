//
//  EditFolderUITests.swift
//  Memory
//
//  Created by Anton Semenov on 08.03.2025.
//

import XCTest
import Foundation

@testable import Memory

final class EditFolderUITests: SCTestBase {
    let folderName = "Test folder name"
    let folderIcon = "😍"
    let folderDescription = "Test folder description"

    func testEditFolder() throws {
        UITestsMocks.mockFolder(
            app: app,
            folder: .init(
                name: folderName,
                icon: folderIcon,
                description: folderDescription
            )
        )

        let notEmptyList = app.collectionViews[FoldersListAccessibilityIdentifier.folderList]
        notEmptyList.cells.element(boundBy: 1).tap()
        app.buttons[FolderDetailsAccessibilityIdentifier.options].tap()
        app.buttons[FolderDetailsAccessibilityIdentifier.editButton].tap()

        let editedFolderName = "Edited folder name"
        let editedFolderIcon = "😄"
        let editedFolderDescription = "Edited folder description"

        let nameTextField = app.textFields[EditFolderAccessibilityIdentifier.nameField]
        sleep(1)
        nameTextField.tap()
        nameTextField.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        nameTextField.typeText(editedFolderName)

        let iconTextField = app.textFields[EditFolderAccessibilityIdentifier.iconField]
        iconTextField.tap()
        iconTextField.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        iconTextField.typeText(editedFolderIcon)

        let descriptionTextField = app.textFields[EditFolderAccessibilityIdentifier.descriptionField]
        descriptionTextField.tap()
        descriptionTextField.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        descriptionTextField.typeText(editedFolderDescription)

        let isFavoriteSwitch = app.switches[EditFolderAccessibilityIdentifier.isFavoriteSwitch]
        isFavoriteSwitch.tap()

        let saveButton = app.buttons[EditFolderAccessibilityIdentifier.saveButton]
        saveButton.tap()

        app.navigationBars.buttons.element(boundBy: 0).tap()
        let editedFolder = notEmptyList.cells.element(boundBy: 1)
        let title = editedFolder.staticTexts[EditItemListAccessibilityIdentifier.itemListCellTitle(id: 1)]
        XCTAssertEqual(title.label, editedFolderName)
        let icon = editedFolder.staticTexts[EditItemListAccessibilityIdentifier.itemListCellIcon(id: 1)]
        XCTAssertEqual(icon.label, editedFolderIcon)
        let description = editedFolder.staticTexts[EditItemListAccessibilityIdentifier.itemListCellDescription(id: 1)]
        XCTAssertEqual(description.label, editedFolderDescription)
    }

    func testCreateFolder() throws {
        UITestsMocks.mockFolder(
            app: app,
            folder: .init(
                name: folderName,
                icon: folderIcon,
                description: folderDescription
            )
        )

        let notEmptyList = app.collectionViews[FoldersListAccessibilityIdentifier.folderList]
        XCTAssertEqual(notEmptyList.cells.count, 2)

        let newFolder = notEmptyList.cells.element(boundBy: 1)
        let title = newFolder.staticTexts[EditItemListAccessibilityIdentifier.itemListCellTitle(id: 1)]
        XCTAssertEqual(title.label, folderName)
        let icon = newFolder.staticTexts[EditItemListAccessibilityIdentifier.itemListCellIcon(id: 1)]
        XCTAssertEqual(icon.label, folderIcon)
        let description = newFolder.staticTexts[EditItemListAccessibilityIdentifier.itemListCellDescription(id: 1)]
        XCTAssertEqual(description.label, folderDescription)
    }
}
