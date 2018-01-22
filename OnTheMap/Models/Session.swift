//
//  Session.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 21/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Session {
    let id: String?
    let expiration: String?

    enum Keys: String {
        case id, expiration
    }

    init(dictionary: [String: AnyObject]) {
        id = dictionary[Keys.id.rawValue] as? String
        expiration = dictionary[Keys.expiration.rawValue] as? String
    }
}
