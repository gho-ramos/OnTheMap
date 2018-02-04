//
//  FacebookAuthentication.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 03/02/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct FacebookAuthentication: Encodable {
    let token: String?

    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
