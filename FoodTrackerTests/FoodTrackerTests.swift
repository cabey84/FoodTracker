//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Chandi Abey  on 8/1/16.
//  Copyright © 2016 Chandi Abey . All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    // MARK: FoodTracker Tests
    
    
    //Tests to confirm that the Meal initializer returns when no nmae or negative rating is provided.
    func testMealInitialization() {
        //Success case
        let potentialItem = Meal(name: "Newest meal", photo: nil, rating: 5)
        //tests that the Meal object is not nil after initialization
        XCTAssertNotNil(potentialItem)
        
        //Fail cases
        let noName = Meal(name: "", photo: nil, rating: 0)
        //asserts that an object is nil, fails initialization
        XCTAssertNil(noName, "Empty name is invalid")
        
        
        //expect the test case to fail b/c rating is negative
        let badRating = Meal(name: "Really bad rating", photo: nil, rating: -1)
        XCTAssertNil(badRating, "Negative ratings are invalid, be positive")
        
    }
    
    
    
}
