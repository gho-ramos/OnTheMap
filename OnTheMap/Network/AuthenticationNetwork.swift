//
//  AuthenticationNetwork.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 19/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

enum AuthenticationError: Error {
    case parseError
}

class AuthenticationNetwork: NSObject {
    static let shared = AuthenticationNetwork()

    private override init() {

    }

    func postSessionForUdacity(username: String, password: String, completionHandler: @escaping (_ authentication: Authentication?, _ error: Error?) -> Void) {
        let body = "{ \"udacity\": { \"username\": \"\(username)\", \"password\": \"\(password)\" } }"
        let udacityUrl = Network.buildUdacityURL(with: [:], at: "/session")
        _ = Network.shared.post(udacityUrl, body) { (Authentication, err) in
            if let err = err {
                let error = ErrorHandler.buildError(message: "Failed to post a session", code: 1, err: err)
                completionHandler(nil, error)
            } else {
                if let authentication = results as? Authentication {
                    completionHandler(authentication, nil)
                } else {
                    let error = ErrorHandler.buildError(message: "Failed while parsing authentication object",
                                                        code: 1,
                                                        err: AuthenticationError.parseError)
                    completionHandler(nil, error)
                }
            }
        }
    }

}
