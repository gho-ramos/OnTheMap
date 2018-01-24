//
//  OnTheMapTests.swift
//  OnTheMapTests
//
//  Created by Guilherme Ramos on 17/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import XCTest
@testable import OnTheMap

class OnTheMapTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStudentInformation() {
        let studentLocation = StudentLocation(dictionary: [
            "createdAt": "2015-02-24T22:35:30.639Z" as AnyObject,
            "firstName": "John" as AnyObject,
            "lastName": "Doe" as AnyObject,
            "latitude": 37.322998 as AnyObject,
            "longitude": -122.032182 as AnyObject,
            "mapString": "Cupertino, CA" as AnyObject,
            "mediaURL": "https://udacity.com" as AnyObject,
            "objectId": "8ZEuHF5uX8" as AnyObject,
            "uniqueKey": "1234" as AnyObject,
            "updatedAt": "2015-03-11T02:42:59.217Z" as AnyObject
        ])

        print(studentLocation.description())
    }

}
