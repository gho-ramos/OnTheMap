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
        let request = NSMutableURLRequest(url: udacityURL(with: [:], for: Methods.Session))
        let httpCookieStorage = HTTPCookieStorage.shared
        var xsrfCookie: HTTPCookie? = nil
        for cookie in httpCookieStorage.cookies! {
            if Headers.XsrfToken.range(of: cookie.name) != nil {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: Headers.XsrfToken)
        }
        Network.shared.delete(request: request, decoderType: Authentication.self) { (session, error) in
            if let error = error {
                failure(error)
            } else {
                success(session)
            }
        }
    }

    func login(with token: String, success: @escaping ((Authentication?) -> Void), failure: @escaping ((Error?) -> Void)) {
        let request = NSMutableURLRequest(url: udacityURL(with: [:], for: Methods.Session))
        let body = "{ \"facebook_mobile\": { \"access_token\": \"\(token)\" } }"
        Network.shared.post(request: request, body: body, decoderType: Authentication.self) { (authentication, error) in
            if let error = error {
                failure(error)
            } else {
                success(authentication)
            }
        }
    }

    func login(username: String, password: String, success: @escaping ((Authentication?) -> Void), failure: @escaping ((Error?) -> Void)) {
        let request = NSMutableURLRequest(url: udacityURL(with: [:], for: Methods.Session))
        let body = "{ \"udacity\": { \"username\": \"\(username)\", \"password\": \"\(password)\"} }"
        Network.shared.post(request: request, body: body, decoderType: Authentication.self) { (authentication, error) in
            if let error = error {
                failure(error)
            } else {
                success(authentication)
            }
        }
    }

    private func udacityURL(with parameters: [String: AnyObject], for pathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (pathExtension ?? "")

        return Network.buildURL(forComponents: components, with: parameters)!
    }
}
