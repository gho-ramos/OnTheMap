//
//  StudentInformationClient.swift
//  OnTheMap
//
//  Created by Guilherme on 1/22/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class StudentInformationClient: NSObject {
    static let shared = StudentInformationClient()

    private override init() {}

    func getStudentsLocations(_ parameters: [String: AnyObject], _ completion: @escaping (([StudentLocation]?, Error?) -> Void)) {
        let request = NSMutableURLRequest(url: Network.buildParseURL(with: parameters, nil))
        request.addValue(Network.ParseConstants.ApiKey, forHTTPHeaderField: Network.HeaderKeys.ParseRESTApiID)
        request.addValue(Network.ParseConstants.AppKey, forHTTPHeaderField: Network.HeaderKeys.ParseApplicationID)
        Network.shared.get(request: request) { (results, error) in
            var studentsLocations = [StudentLocation]()
            if let error = error {
                completion(nil, error)
            } else {
                if let results = results?[Network.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    for value in results {
                        studentsLocations.append(StudentLocation(dictionary: value))
                    }
                    completion(studentsLocations, nil)
                } else {
                    let err = ErrorHandler.buildError(message: "Failed to parse object to StudentLocation Array",
                                                      code: 2,
                                                      err: error)
                    completion(nil, err)
                }
            }
        }
    }

    func getStudentLocation(byUniqueKey uniqueKey:String, _ completion: @escaping ((StudentLocation?, Error?) -> Void)) {
        let uniqueKeyFilter = "{ \"uniqueKey\": \"\(uniqueKey)\" }"
        let parameters = [ "where": uniqueKeyFilter ]
        let request = NSMutableURLRequest(url: Network.buildParseURL(with: parameters as [String: AnyObject], nil))
        request.addValue(Network.ParseConstants.ApiKey, forHTTPHeaderField: Network.HeaderKeys.ParseRESTApiID)
        request.addValue(Network.ParseConstants.AppKey, forHTTPHeaderField: Network.HeaderKeys.ParseApplicationID)
        Network.shared.get(request: request) { (results, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let results = results?[Network.JSONResponseKeys.Results] as? [[String: AnyObject]], results.count > 0 {
                    let student = StudentLocation(dictionary: results.first!)
                    completion(student, nil)
                } else {
                    let err = ErrorHandler.buildError(message: "Failed to parse object to StudentLocation Array",
                                                      code: 2,
                                                      err: error)
                    completion(nil, err)
                }
            }
        }
    }

    func save(studentLocation: StudentLocation, _ completion: @escaping ((StudentLocation?, Error?) -> Void)) {
        
    }
}
