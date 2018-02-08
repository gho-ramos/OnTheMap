//
//  ErrorHandler.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 22/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class ErrorHandler: NSObject {

    /// Build and error object with a message, code and a custom or default error
    ///
    /// - Parameters:
    ///   - message: Message that wil be displayed within the "userInfo" property
    ///   - code: code of the error
    ///   - err: Custom or default application error
    /// - Returns: A new error object with custom properties, indicating the function and line
    class func buildError(message: String, code: Int, err: Error?) -> Error {
        let userInfo = [NSLocalizedDescriptionKey: message]
        let error = NSError(
            domain: "Error: \(String(describing: err))\n\nLine: \(#line) of Function \(#function)",
            code: code,
            userInfo: userInfo)

        return error
    }

    /// Check the status of the request that the server returned and create a {success, error}
    /// set that will indicate wether the request has succeeded or failed.
    ///
    /// - Parameters:
    ///   - data: The data returned by the server.
    ///   - response: An object that provides response metadata, such as HTTP headers and status code. If you are making an HTTP or HTTPS request, the returned object is actually an HTTPURLResponse object.
    ///   - err: An error object that indicates why the request failed, or nil if the request was successful.
    /// - Returns: Request status set { Success, Error }
    class func checkStatus(_ data: Data?, _ response: URLResponse?, _ err: Error?) -> RequestStatus {
        guard err == nil else {
            let error = ErrorHandler.buildError(message: "There was an error with your request",
                                                code: 0,
                                                err: err)
            return RequestStatus(success: false, error: NetworkError.error(error))
        }

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 403 else {
            return RequestStatus(success: false, error: NetworkError.unauthorized)
        }

        guard statusCode >= 200 && statusCode <= 299 else {
            let error = ErrorHandler.buildError(message: "There was an error with your request",
                                                code: 0,
                                                err: err)
            return RequestStatus(success: false, error: NetworkError.networkFailure(error))
        }

        guard data != nil else {
            let error = ErrorHandler.buildError(message: "No data was returned by the request",
                                                code: 0,
                                                err: err)
            return RequestStatus(success: false, error: NetworkError.noResultsFound(error))
        }
        return RequestStatus(success: true, error: nil)
    }

}
