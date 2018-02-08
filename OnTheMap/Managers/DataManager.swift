//
//  DataManager.swift
//  OnTheMap
//
//  Created by Guilherme on 2/5/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    var user: UserResponse?
    var students = [StudentLocation]()

    static let shared = DataManager()

    private override init() {  }

}
