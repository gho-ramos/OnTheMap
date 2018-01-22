//
//  Authentication.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 21/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Authentication {
    let account: Account?
    let session: Session?

    enum Keys: String {
        case account, session
    }

    init(dictionary: [String: AnyObject]) {
        account = dictionary[Keys.account.rawValue] as? Account
        session = dictionary[Keys.session.rawValue] as? Session
    }
}
