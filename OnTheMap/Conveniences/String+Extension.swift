//
//  String+Extension.swift
//  OnTheMap
//
//  Created by Guilherme on 2/5/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

extension String {
    func replace(key: String, to value: String) -> String? {
        let key = "#\(key)"
        if self.range(of: key) != nil {
            return self.replacingOccurrences(of: key, with: value)
        } else {
            return nil
        }
    }
}
