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
    var students: [StudentLocation]?

    private override init() {}

    func getStudents(with parameters: [String: AnyObject], success: @escaping ([StudentLocation]?) -> Void, failure: @escaping (Error?) -> Void) {
        let request = NSMutableURLRequest(url: Network.buildParseURL(with: parameters, nil))
        request.addValue(Network.ParseConstants.ApiKey, forHTTPHeaderField: Network.HeaderKeys.ParseRESTApiID)
        request.addValue(Network.ParseConstants.AppKey, forHTTPHeaderField: Network.HeaderKeys.ParseApplicationID)
        Network.shared.get(request: request as URLRequest, decoderType: Students.self) { (students, error) in
            if error != nil {
                failure(error)
            } else {
                self.students = students?.results
                success(self.students)
            }
        }
    }
}
