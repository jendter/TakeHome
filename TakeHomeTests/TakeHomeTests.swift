//
//  TakeHomeTests.swift
//  TakeHomeTests
//
//  Created by Joshua Endter on 2020-03-11.
//  Copyright © 2020 JRE. All rights reserved.
//

import XCTest
import UIKit
import Moya
import Mapper
import Moya_ModelMapper

@testable import TakeHome

class TakeHomeTests: XCTestCase {

    var apiSampleProvider: APIProvider!
    
    override func setUp() {
        apiSampleProvider = APIProvider(endpointClosure: { (target) -> Endpoint in
            return .init(url: URL(target: target).absoluteString,
                         sampleResponseClosure: { return .networkResponse(200, target.sampleData) },
                         method: target.method,
                         task: target.task,
                         httpHeaderFields: target.headers)
        }, stubClosure: { (_) in .immediate })
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPICategories() {
        let apiCall = expectation(description: "Categories sample API call.")
        var categories: [AdCategory]?
        apiSampleProvider.request(.categories) { (result) in
            do {
                categories = try result.get().map(to: [AdCategory].self)
                apiCall.fulfill()
            } catch let error {
                XCTFail("Could not decode JSON. Full Error: \(error)")
            }
        }
        wait(for: [apiCall], timeout: 1)
        XCTAssert(categories?.count == 5)
        XCTAssert(categories?.first?.name == "Balanced impactful budgetary management")
    }
    
    func testAPIAds() {
        let apiCall = expectation(description: "Ads sample API call.")
        var ads: [Ad]?
        apiSampleProvider.request(.ads(categoryId: 1)) { (result) in
            do {
                ads = try result.get().map(to: [Ad].self)
                apiCall.fulfill()
            } catch let error {
                XCTFail("Could not decode JSON. Full Error: \(error)")
            }
        }
        wait(for: [apiCall], timeout: 1)
        XCTAssert(ads?.count == 25)
        XCTAssert(ads?.last?.title == "iterate ubiquitous experiences")
    }

}
