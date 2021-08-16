//
//  AccessiblitySampleUITests.swift
//  AccessiblitySampleUITests
//
//  Created by Delma Song on 2021/08/08.
//

import XCTest

class AccessiblitySampleUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func test_add_button_images_change() throws {
        let accessiblitysampleAccessibilitytodolistviewNavigationBar = app.navigationBars["AccessiblitySample.AccessibilityToDoListView"]
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["UI Test"]/*[[".cells.staticTexts[\"UI Test\"]",".staticTexts[\"UI Test\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let plustButton = accessiblitysampleAccessibilitytodolistviewNavigationBar.buttons["add"]
        plustButton.tap()
        XCTAssertFalse(plustButton.exists)

        let removeButton = accessiblitysampleAccessibilitytodolistviewNavigationBar.buttons["remove"]
        removeButton.tap()
        XCTAssertFalse(removeButton.exists)
        XCTAssertTrue(plustButton.exists)
    }

    func test_task_add_and_check() throws {

        app.tables/*@START_MENU_TOKEN@*/.staticTexts["UI Test"]/*[[".cells.staticTexts[\"UI Test\"]",".staticTexts[\"UI Test\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["AccessiblitySample.AccessibilityToDoListView"]
            /*@START_MENU_TOKEN@*/.buttons["AccessibilityToDoListViewController.rightBarButton"]/*[[".buttons[\"add\"]",".buttons[\"AccessibilityToDoListViewController.rightBarButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        let textField = app.textFields["AccessibilityToDoListViewController.taskInputField"]
        textField.tap()
        textField.typeText("iPhone")

        app/*@START_MENU_TOKEN@*/.staticTexts["submit"]/*[[".buttons[\"할 일 작성 완료 버튼\"].staticTexts[\"submit\"]",".buttons[\"AccessibilityToDoListViewController.submitButton\"].staticTexts[\"submit\"]",".staticTexts[\"submit\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let accessibilitytodolistviewcontrollerTasklistsTable = app/*@START_MENU_TOKEN@*/.tables["AccessibilityToDoListViewController.taskLists"]/*[[".tables[\"할 일 목록\"]",".tables[\"AccessibilityToDoListViewController.taskLists\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let iPhoneCheckButton = accessibilitytodolistviewcontrollerTasklistsTable
            .cells
            .containing(.staticText, identifier:"iPhone")
            /*@START_MENU_TOKEN@*/.buttons["AccessibilityToDoListTableViewCell.checkButton"]/*[[".buttons[\"할 일 완료 여부 표시 버튼\"]",".buttons[\"AccessibilityToDoListTableViewCell.checkButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        iPhoneCheckButton.tap()
        XCTAssertEqual(iPhoneCheckButton.isSelected, true)
    }

    func test_check_all_lists() throws {
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["UI Test"]/*[[".cells.staticTexts[\"UI Test\"]",".staticTexts[\"UI Test\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let accessibilitytodolistviewcontrollerTasklistsTable = app/*@START_MENU_TOKEN@*/.tables["AccessibilityToDoListViewController.taskLists"]/*[[".tables[\"할 일 목록\"]",".tables[\"AccessibilityToDoListViewController.taskLists\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        while !accessibilitytodolistviewcontrollerTasklistsTable
                .cells
                .element(boundBy: 0)
                .buttons["AccessibilityToDoListTableViewCell.checkButton"]
                .isSelected
        {
            let button = accessibilitytodolistviewcontrollerTasklistsTable
                .cells
                .element(boundBy: 0)
                /*@START_MENU_TOKEN@*/.buttons["AccessibilityToDoListTableViewCell.checkButton"]/*[[".buttons[\"할 일 완료 여부 표시 버튼\"]",".buttons[\"AccessibilityToDoListTableViewCell.checkButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            button.tap()
            XCTAssertTrue(button.isSelected)
        }

        
    }

    func test_sample() throws {


    }

}
