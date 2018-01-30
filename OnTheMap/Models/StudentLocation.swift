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
    let latitude: Float?
    let longitude: Float?
    let createdAt: String?
    let updatedAt: String?

    func fullName() -> String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }

    func studentAnnotationPoint() -> MKPointAnnotation? {
        guard let latitude = latitude, let longitude = longitude else { return nil }

        let coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = fullName()
        annotation.subtitle = mediaURL

        return annotation
    }
}
