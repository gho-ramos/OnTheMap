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

    func logout(success: @escaping (Authentication?) -> Void, failure: @escaping (Error?) -> Void) {
        let request = NSMutableURLRequest(url: Network.buildUdacityURL(with: [:], Network.UdacityMethods.Session))
        let httpCookieStorage = HTTPCookieStorage.shared
        var xsrfCookie: HTTPCookie? = nil
        for cookie in httpCookieStorage.cookies! {
            if Network.HeaderKeys.XsrfToken.range(of: cookie.name) != nil {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: Network.HeaderKeys.XsrfToken)
        }
        Network.shared.delete(request: request, decoderType: Authentication.self) { (session, error) in
            if let error = error {
                failure(error)
            } else {
                success(session)
            }
        }
    }

    func authenticate(with token: String, success: @escaping ((Authentication?) -> Void), failure: @escaping ((Error?) -> Void)) {
        let request = NSMutableURLRequest(url: Network.buildUdacityURL(with: [:], Network.UdacityMethods.Session))
        let body = "{ \"facebook_mobile\": { \"access_token\": \"\(token)\" } }"
        Network.shared.post(request: request, body: body, decoderType: Authentication.self) { (authentication, error) in
            if let error = error {
                failure(error)
            } else {
                success(authentication)
            }
        }
    }

    func authenticate(username: String, password: String, success: @escaping ((Authentication?) -> Void), failure: @escaping ((Error?) -> Void)) {
        let request = NSMutableURLRequest(url: Network.buildUdacityURL(with: [:], Network.UdacityMethods.Session))
        let body = "{ \"udacity\": { \"username\": \"\(username)\", \"password\": \"\(password)\"} }"
        Network.shared.post(request: request, body: body, decoderType: Authentication.self) { (authentication, error) in
            if let error = error {
                failure(error)
            } else {
                success(authentication)
            }
        }
    }
}
