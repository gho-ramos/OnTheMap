//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Guilherme on 1/30/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

extension StudentInformationClient {

    struct Constants {
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"

        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"

        static let AuthenticationUrl = "https://www.udacity.com/api/session"
    }

    struct Headers {
        static let ParseApplicationID = "X-Parse-Application-Id"
        static let ParseRESTApiID = "X-Parse-REST-API-Key"
    }

}
