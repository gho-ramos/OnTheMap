//
//  ErrorHandler.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 22/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class ErrorHandler: NSObject {

    class func buildError(message: String, code: Int, err: Error?) -> Error {
        let userInfo = [NSLocalizedDescriptionKey: message]
        let error = NSError(
            domain: "Error: \(String(describing: err))\n\nLine: \(#line) of Function \(#function)",
            code: code,
            userInfo: userInfo)

        return error
    }

    class func checkStatus(_ data: Data?, _ response: URLResponse?, _ err: Error?) -> RequestStatus {
        guard err == nil else {
            let error = ErrorHandler.buildError(message: "There was an error with your request",
                                                code: 0,
                                                err: err)
            return RequestStatus(success: false, error: error)
        }

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            let error = ErrorHandler.buildError(message: "There was an error with your request",
                                                code: 0,
                                                err: err)
            return RequestStatus(success: false, error: error)
        }

        guard data != nil else {
            let error = ErrorHandler.buildError(message: "No data was returned by the request",
                                                code: 0,
                                                err: err)
            return RequestStatus(success: false, error: error)
        }
        return RequestStatus(success: true, error: nil)
    }

}
