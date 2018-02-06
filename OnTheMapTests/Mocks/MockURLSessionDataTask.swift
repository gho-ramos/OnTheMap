//
//  MockURLSessionDataTask.swift
//  OnTheMapTests
//
//  Created by Guilherme on 2/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
@testable import OnTheMap

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
}
