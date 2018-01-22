//
//  Authentication.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 21/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Authentication: Decodable {
    let account: Account?
    let session: Session?
}
