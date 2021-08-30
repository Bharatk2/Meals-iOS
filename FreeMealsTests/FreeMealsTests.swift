//
//  FreeMealsTests.swift
//  FreeMealsTests
//
//  Created by Bharat Kumar on 8/27/21.
//

import XCTest
@testable import FreeMeals
class FreeMealsTests: XCTestCase {
    
    let timeout: TimeInterval = 5
    
    func testFetchAllCategories() throws {
        let expectation = self.expectation(description: "fetch is succesfull")
        
        ModelController.shared.getCategories { categories, error  in
            XCTAssertNil(error)
            XCTAssertNotNil(categories)
            print("these are succefull categories : \(categories)")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testDecoding() throws {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        let expectation = self.expectation(description: "Data decodes from the backend")
        URLSession.shared.dataTask(with: url) { data, response, error in
            XCTAssertNil(error)
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                
                XCTAssertNoThrow(
                    try JSONDecoder().decode(Categories.self, from: data)
                )
                
            }
            catch { }
        }
        .resume()
        expectation.fulfill()
        waitForExpectations(timeout: timeout)
    }
    
}
