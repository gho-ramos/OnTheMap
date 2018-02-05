//
//  UserResponse.swift
//  OnTheMap
//
//  Created by Guilherme on 2/5/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Response: Decodable {
    let user: UserResponse?
}

struct UserResponse: Decodable {
    let firstName: String
    let lastName: String
    let key: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
