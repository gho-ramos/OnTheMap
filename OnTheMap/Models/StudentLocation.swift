//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Guilherme on 1/22/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct StudentLocation: CustomStringConvertible {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Float?
    let longitude: Float?
    let createdAt: String?
    let updatedAt: String?

    var description: String {
        get {

        }
    }

    init(dictionary: [String: AnyObject]) {
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        latitude = dictionary["latitude"] as? Float
        longitude = dictionary["longitude"] as? Float
        createdAt = dictionary["createdAt"] as? String
        updatedAt = dictionary["updatedAt"] as? String
    }

}
