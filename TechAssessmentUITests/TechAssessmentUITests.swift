import XCTest

final class TechAssessmentUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {}
    
    func testAppCreatingProductWorks() throws {
        let app = XCUIApplication()
        app.launchArguments =  ["in-memory-storage-mode"]
        app.launch()
        
        XCTAssertEqual(app.cells.count, 0)
        XCTAssertTrue(app.staticTexts["No products found"].exists)
        
        app.buttons["Add"].tap()
        let textField = app.textFields["e.g., Shirt, Coat"]
        textField.tap()
        textField.typeText("Product 1")
        app.buttons["Save"].tap()
        app.buttons["List"].tap()
        
        XCTAssertEqual(app.cells.count, 1)
        XCTAssertEqual(app.staticTexts.element(matching: .staticText, identifier: "Product 1").label, "Product 1")
    }
}
