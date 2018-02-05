//
//  Session.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 21/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Session: Codable {
    let identifier: String?
    let expiration: String?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case expiration
    }
}
