//
//  String+Extension.swift
//  OnTheMap
//
//  Created by Guilherme on 2/5/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

extension String {

    /// Replace the specified key to a certain value
    ///
    /// - Parameters:
    ///   - key: Key to be replaced by a value
    ///   - value: New value of the string
    /// - Returns: String with the replaced value
    func replace(key: String, to value: String) -> String? {
        let key = "#\(key)"
        if self.range(of: key) != nil {
            return self.replacingOccurrences(of: key, with: value)
        } else {
            return nil
        }
    }
}
