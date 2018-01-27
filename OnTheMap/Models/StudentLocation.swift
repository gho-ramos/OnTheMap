//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Guilherme on 1/22/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

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
}
