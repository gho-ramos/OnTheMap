//
//  Constants.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 17/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

extension Network {

    struct ParseConstants {
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"

        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"

        static let AuthenticationUrl = "https://www.udacity.com/api/session"
    }

    struct UdacityConstants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }

    struct UdacityMethods {
        static let Session = "/session"
        static let UsersUserID = "/users/#userid"
    }

    struct HeaderKeys {
        static let ParseApplicationID = "X-Parse-Application-Id"
        static let ParseRESTApiID = "X-Parse-REST-API-Key"
        static let XsrfToken = "X-XSRF-TOKEN"
    }

    struct JSONResponseKeys {
        static let Results = "results"
        static let User = "user"
    }
    struct JSONStudentKeys {
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let ACL = "ACL"
    }
}
