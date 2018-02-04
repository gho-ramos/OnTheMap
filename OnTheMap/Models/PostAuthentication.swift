//
//  PostAuthentication.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 03/02/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct PostAuthentication: Encodable {
    let facebook: FacebookAuthentication?
    let udacity: UdacityAuthentication?

    enum CodingKeys: String, CodingKey {
        case facebook = "facebook_mobile"
        case udacity
    }
}
