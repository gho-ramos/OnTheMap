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
    var all = [StudentLocation]()

    lazy var baseParseURL: URLComponents = self.makeBaseParseURL()
    private func makeBaseParseURL() -> URLComponents {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath

        return components
    }

    private override init() {}

    fileprivate func baseParseRequest(with parameters: [String: AnyObject]) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: parseURL(with: parameters))
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Headers.ParseRESTApiID)
        request.addValue(Constants.AppKey, forHTTPHeaderField: Headers.ParseApplicationID)
        return request
    }

    func getStudents(with parameters: [String: AnyObject], success: @escaping ([StudentLocation]?) -> Void, failure: @escaping (Error?) -> Void) {
        let request = baseParseRequest(with: parameters)
        Network.shared.get(request: request as URLRequest, decoderType: Students.self) { (students, error) in
            if error != nil {
                failure(error)
            } else {
                if let all = students?.results {
                    self.all = all
                }
                success(self.all)
            }
        }
    }

    func saveStudent(_ student: StudentLocation, success: @escaping (StudentLocation) -> Void, failure: @escaping (Error?) -> Void) {
        let request = baseParseRequest(with: [:])

    }

    private func parseURL(with parameters: [String: AnyObject], for pathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (pathExtension ?? "")

        return Network.buildURL(forComponents: components, with: parameters)!
    }
}
