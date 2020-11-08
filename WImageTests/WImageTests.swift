//
//  WImageTests.swift
//  WImageTests
//
//  Created by Ilya Sorokin on 08.11.2020.
//

import XCTest
@testable import WImage

class WImageTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoading() throws {
        let url = URL(string: "http://lorempixel.com/100/100/")!
        var count = 2
        let i1 = WImage.shared.load(url: url, completion: { image in
            count -= 1
            XCTAssert(image != nil)
        })
        let i2 = WImage.shared.load(url: url, completion: { image in
            count -= 1
            XCTAssert(image != nil)
        })
        XCTAssert(WImage.shared.loadingItems.count == (count > 0 ? 1 : 0))
        if (count > 0) {
            WImage.shared.cancel(item: i1)
            count -= 1
            XCTAssert(WImage.shared.loadingItems.count == count)
            WImage.shared.cancel(item: i2)
            XCTAssert(WImage.shared.loadingItems.count == 0)
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testW1() throws {
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
