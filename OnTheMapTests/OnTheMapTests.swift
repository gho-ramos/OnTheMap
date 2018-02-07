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
    var client: NetworkClient!
    let session = MockURLSession()
    override func setUp() {
        super.setUp()
        client = NetworkClient(session: session)
    }

    func testGet() {
        let url = URL(string: "http://www.google.com.br")
        let request = NSMutableURLRequest(url: url!)
        let expected = Account(registered: true, key: "12345")

        var actualData: Account?
        session.nextResponse = MockURLSession.response200()
        session.nextData = encode(expected)

        client.get(request: request as URLRequest, decoder: Account.self) { (result, _) in
            if result != nil {
                actualData = result
            } else {
                XCTFail("Failed to get")
            }
        }

        XCTAssertEqual(actualData?.key, expected.key)
    }

    func testPost() {
        let url = URL(string: "http://www.google.com.br")
        let request = NSMutableURLRequest(url: url!)
        let body = PostAuthentication(facebook: nil,
                                      udacity: UdacityAuthentication(username: "user", password: "password"))
        let expected = AuthenticationResponse(account: Account(registered: true, key: "12930127570"),
                                              session: Session(identifier: "12301801239019", expiration: "2"))

        var actualData: AuthenticationResponse?
        session.nextResponse = MockURLSession.response200()
        session.nextData = encode(expected)

        client.post(request: request, body: body, decoder: AuthenticationResponse.self) { (result, _) in
            if result != nil {
                actualData = result
            } else {
                XCTFail("Failed to post")
            }
        }

        XCTAssertEqual(actualData?.account?.key, expected.account?.key)
    }

    func testStringPost() {
        let url = URL(string: "http://www.google.com.br")
        let request = NSMutableURLRequest(url: url!)
        let body = """
            {\"uniqueKey\": \"1234\",
            \"firstName\": \"John\",
            \"lastName\": \"Doe\",
            \"mapString\": \"Mountain View, CA\",
            \"mediaURL\": \"https://udacity.com\",
            \"latitude\": 37.386052,
            \"longitude\": -122.083851}
        """
        let expected = StudentLocation(objectId: nil, uniqueKey: nil, firstName: nil, lastName: nil,
                                       mapString: nil, mediaURL: nil, latitude: nil, longitude: nil,
                                       createdAt: nil, updatedAt: nil)
        var actualData: StudentLocation?
        session.nextResponse = MockURLSession.response200()
        session.nextData = encode(expected)

        client.post(request: request, body: body, decoder: StudentLocation.self) { (result, _) in
            if result != nil {
                actualData = result
            } else {
                XCTFail("Failed to post")
            }
        }

        XCTAssertEqual(actualData?.uniqueKey, expected.uniqueKey)
    }

    func testDelete() {
        let url = URL(string: "http://www.google.com.br")
        let request = NSMutableURLRequest(url: url!)
        let expected = Account(registered: true, key: "12345")
        var actualData: Account?
        session.nextResponse = MockURLSession.response200()
        session.nextData = encode(expected)

        client.delete(request: request, decoder: Account.self) { (result, _) in
            if result != nil {
                actualData = result
            } else {
                XCTFail("Failed to delete")
            }
        }
        XCTAssertEqual(actualData?.key, expected.key)
    }

    func encode<T: Encodable>(_ data: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(data)
        } catch {
            return nil
        }
    }
}
