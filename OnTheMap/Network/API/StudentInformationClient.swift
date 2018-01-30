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
    var all: [StudentLocation]?

    private override init() {}

    func getStudents(with parameters: [String: AnyObject], success: @escaping ([StudentLocation]?) -> Void, failure: @escaping (Error?) -> Void) {
        let request = NSMutableURLRequest(url: parseURL(with: parameters))
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Headers.ParseRESTApiID)
        request.addValue(Constants.AppKey, forHTTPHeaderField: Headers.ParseApplicationID)
        Network.shared.get(request: request as URLRequest, decoderType: Students.self) { (students, error) in
            if error != nil {
                failure(error)
            } else {
                self.all = students?.results
                success(self.all)
            }
        }
    }

    private func parseURL(with parameters: [String: AnyObject], for pathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (pathExtension ?? "")

        return Network.buildURL(forComponents: components, with: parameters)!
    }
}
