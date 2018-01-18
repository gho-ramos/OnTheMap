//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 17/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct StudentInformation: Equatable {
    let objectId: String!
    let uniqueKey: String?
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let createdAt: AnyObject?
    let updatedAt: AnyObject?
    let ACL: AnyObject?

    init(dictionary: [String: AnyObject]) {
        objectId = dictionary[Network.JSONStudentKeys.ObjectID] as? String ?? ""
        uniqueKey = dictionary[Network.JSONStudentKeys.UniqueKey] as? String ?? ""
        firstName = dictionary[Network.JSONStudentKeys.FirstName] as? String ?? ""
        lastName = dictionary[Network.JSONStudentKeys.LastName] as? String ?? ""
        mapString = dictionary[Network.JSONStudentKeys.MapString] as? String ?? ""
        mediaURL = dictionary[Network.JSONStudentKeys.MediaURL] as? String ?? ""
        latitude = dictionary[Network.JSONStudentKeys.Latitude] as? Float ?? 0
        longitude = dictionary[Network.JSONStudentKeys.Longitude] as? Float ?? 0
        createdAt = dictionary[Network.JSONStudentKeys.CreatedAt]
        updatedAt = dictionary[Network.JSONStudentKeys.UpdatedAt]
        ACL = dictionary[Network.JSONStudentKeys.ACL]
    }
}

func == (lsi: StudentInformation, rsi: StudentInformation) -> Bool {
    return lsi.objectId == rsi.objectId
}
