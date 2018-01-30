//
//  NetworkError.swift
//  OnTheMap
//
//  Created by Guilherme on 1/30/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case decodeFailure(Error)
    case networkFailure(Error)
    case noResultsFound
}
