//
//  SessionManager.swift
//  OnTheMap
//
//  Created by Guilherme on 2/5/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class SessionManager: NSObject {
    var user: UserResponse?

    static let shared = SessionManager()

    private override init() {  }

}
