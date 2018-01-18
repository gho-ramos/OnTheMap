//
//  OnTheMapErrorHandler.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 18/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class OnTheMapErrorHandler: NSObject {
    class func sendError(functionName: String = #function, line: Int = #line,
                         _ message: String, code: Int = 1,
                         _ completionHandler: (_ result: AnyObject?, _ error: Error?) -> Void) {
        let userInfo = [NSLocalizedDescriptionKey: message]
        let error = NSError(domain: "Line: \(line) of Function: \(functionName)", code: code, userInfo: userInfo)

        completionHandler(nil, error)
    }
}
