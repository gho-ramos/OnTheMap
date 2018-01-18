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
                    OnTheMapErrorHandler.sendError("", code: 0) { (_, error) in
                        completionHandler(nil, error)
                    }
                }
            }
        }
    }
}
