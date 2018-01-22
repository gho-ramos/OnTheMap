//
//  AuthenticationClient.swift
//  OnTheMap
//
//  Created by Guilherme on 1/22/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class AuthenticationClient: NSObject {
    static let shared = AuthenticationClient()
    private override init() { }

    func logout(_ completion: @escaping ([String: AnyObject]?, Error?) -> Void) {
        let request = NSMutableURLRequest(url: Network.buildUdacityURL(with: [:], Network.UdacityMethods.Session))
        Network.shared.delete(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let result = result as? [String: AnyObject] {
                    completion(result, nil)
                } else {
                    let err = ErrorHandler.buildError(message: "Failed to logout",
                                                      code: 2,
                                                      err: error)
                    completion(nil, err)
                }
            }
        }
    }

    func authenticate(with token: String, _ completion: @escaping ((Authentication?, Error?) -> Void)) {
        let request = NSMutableURLRequest(url: Network.buildUdacityURL(with: [:], Network.UdacityMethods.Session))
        let body = "{ \"facebook_mobile\": { \"access_token\": \"\(token)\" } }"
        Network.shared.post(request: request, body: body) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let result = result as? [String: AnyObject] {
                    completion(Authentication(dictionary: result), nil)
                } else {
                    let err = ErrorHandler.buildError(message: "Failed to parse Facebook result to Authentication",
                                                      code: 2,
                                                      err: error)
                    completion(nil, err)
                }
            }
        }
    }

    func authenticate(username: String, password: String, _ completion: @escaping ((Authentication?, Error?) -> Void)) {
        let request = NSMutableURLRequest(url: Network.buildUdacityURL(with: [:], Network.UdacityMethods.Session))
        let body = "{ \"udacity\": { \"username\": \"\(username)\", \"password\": \"\(password)\"} }"
        Network.shared.post(request: request, body: body) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let result = result as? [String: AnyObject] {
                    completion(Authentication(dictionary: result), nil)
                } else {
                    let err = ErrorHandler.buildError(message: "Failed to parse result to Authentication",
                                                      code: 2,
                                                      err: error)
                    completion(nil, err)
                }
            }

        }
    }
}
