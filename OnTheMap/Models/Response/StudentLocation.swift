//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Guilherme on 1/22/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import MapKit

struct StudentLocation: Codable {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case objectId
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
        case createdAt
        case updatedAt
    }

    func studentAnnotationPoint() -> MKPointAnnotation? {
        guard let latitude = latitude, let longitude = longitude else { return nil }

        let coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = fullName
        annotation.subtitle = mediaURL

        return annotation
    }
}

extension StudentLocation: CustomStringConvertible {
    var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }

    var description: String {
        return """
        {
            \"uniqueKey\": \"\(uniqueKey ?? "")\",
            \"firstName\": \"\(firstName ?? "")\",
            \"lastName\": \"\(lastName ?? "")\",
            \"mapString\": \"\(mapString ?? "")\",
            \"mediaURL\": \"\(mediaURL ?? "")\",
            \"latitude\": \(latitude ?? 0),
            \"longitude\": \(longitude ?? 0)
        }
        """
    }
}
