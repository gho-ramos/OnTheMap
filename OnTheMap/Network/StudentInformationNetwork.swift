//
//  StudentInformationNetwork.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 18/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class StudentInformationNetwork: NSObject {
    static let shared = StudentInformationNetwork()

    var studentLocations: [StudentInformation]?

    private override init() { }

    func getStudentLocations(_ parameters: [String: AnyObject] = [:], _ completionHandler: @escaping (_ data: [StudentInformation]?, _ error: Error?) -> Void) {
        _ = Network.shared.get(parameters) { (results, error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                if let results = results?[Network.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    self.studentLocations = [StudentInformation]()
                    for studentInformation in results {
                        self.studentLocations?.append(StudentInformation(dictionary: studentInformation))
                    }
                    completionHandler(self.studentLocations, nil)
                } else {
                    OnTheMapErrorHandler.sendError("Cannot get students locations", code: 0) { (_, error) in
                        completionHandler(nil, error)
                    }
                }
            }
        }
    }

    func getStudentLocation(uniqueKey: String, _ completionHandler: @escaping (_ data: StudentInformation?, _ error: Error?) -> Void) {
        let parameters = [
            "where": "{'uniqueKey':\(uniqueKey)}"
        ]
        _ = Network.shared.get(parameters as [String: AnyObject]) { (results, error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                if let user = results?[Network.JSONResponseKeys.User] as? [String: AnyObject] {
                    completionHandler(StudentInformation(dictionary: user), nil)
                } else {
                    OnTheMapErrorHandler.sendError("Cannot get student location", code: 0) { (_, error) in
                        completionHandler(nil, error)
                    }
                }
            }
        }
    }
}
