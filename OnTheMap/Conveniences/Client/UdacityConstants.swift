//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Guilherme on 1/30/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

extension AuthenticationClient {

    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }

    struct Keys {
        static let UserID = "userid"
    }

    struct Headers {
        static let XsrfToken = "X-XSRF-TOKEN"
    }

    struct Methods {
        static let Session = "/session"
        static let UsersUserID = "/users/#userid"
    }
}
