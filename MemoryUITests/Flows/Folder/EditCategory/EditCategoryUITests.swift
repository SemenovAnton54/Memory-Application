//
//  EditCategoryUITests.swift
//  Memory
//
//  Created by Anton Semenov on 08.03.2025.
//

import XCTest
import Foundation

@testable import Memory

final class EditCategoryUITests: SCTestBase {
    let categoryName = "Test Category name"
    let categoryIcon = "👿"
    let categoryDescription = "Test Category description"

    func testEditCategory() throws {
        UITestsMocks.mockCategory(
            app: app,
            category: .init(
                name: categoryName,
                icon: categoryIcon,
                description: categoryDescription
            )
        )

        XCTAssertEqual(app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellTitle(id: 1)].label, categoryName)
        XCTAssertEqual(app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellIcon(id: 1)].label, categoryIcon)
        XCTAssertEqual(app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellDescription(id: 1)].label, categoryDescription)

        app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellDescription(id: 1)].tap()
        app.buttons[CategoryDetailsAccessibilityIdentifier.options].tap()
        app.buttons[CategoryDetailsAccessibilityIdentifier.editButton].tap()

        let editedCategoryName = "Edited category name"
        let editedCategoryIcon = "😄"
        let editedCategoryDescription = "Edited category description"

        let nameTextField = app.textFields[EditCategoryAccessibilityIdentifier.nameField]
        sleep(1)
        nameTextField.tap()
        nameTextField.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        nameTextField.typeText(editedCategoryName)

        let iconTextField = app.textFields[EditCategoryAccessibilityIdentifier.iconField]
        iconTextField.tap()
        iconTextField.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        iconTextField.typeText(editedCategoryIcon)

        let descriptionTextField = app.textFields[EditCategoryAccessibilityIdentifier.descriptionField]
        descriptionTextField.tap()
        descriptionTextField.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        descriptionTextField.typeText(editedCategoryDescription)

        let saveButton = app.buttons[EditCategoryAccessibilityIdentifier.saveButton]
        saveButton.tap()

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertEqual(app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellTitle(id: 1)].label, editedCategoryName)
        XCTAssertEqual(app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellIcon(id: 1)].label, editedCategoryIcon)
        XCTAssertEqual(app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellDescription(id: 1)].label, editedCategoryDescription)
    }

    func testCreateCategory() throws {
        UITestsMocks.mockCategory(
            app: app,
            category: .init(
                name: categoryName,
                icon: categoryIcon,
                description: categoryDescription
            )
        )

        XCTAssertEqual(app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellTitle(id: 1)].label, categoryName)
        XCTAssertEqual(app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellIcon(id: 1)].label, categoryIcon)
        XCTAssertEqual(app.staticTexts[EditItemListAccessibilityIdentifier.itemListCellDescription(id: 1)].label, categoryDescription)
    }
}
