//
//  Account.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 21/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Account {
    let registered: Bool?
    let key: String?

    enum Keys: String {
        case registered, key
    }

    init(dictionary: [String: AnyObject]) {
        registered = dictionary[Keys.registered.rawValue] as? Bool
        key = dictionary[Keys.key.rawValue] as? String
    }
}
