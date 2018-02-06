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

    private override init() {}

    fileprivate func baseParseRequest(with parameters: [String: AnyObject]) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: parseURL(with: parameters))
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Headers.ParseRESTApiID)
        request.addValue(Constants.AppKey, forHTTPHeaderField: Headers.ParseApplicationID)
        return request
    }

    func getStudents(with parameters: [String: AnyObject], success: @escaping ([StudentLocation]?) -> Void, failure: @escaping (Error?) -> Void) {
        let request = baseParseRequest(with: parameters)
        NetworkClient().get(request: request as URLRequest, decoder: Students.self) { (students, error) in
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

    func saveStudent(_ student: StudentLocation, success: @escaping (StudentLocation?) -> Void, failure: @escaping (Error?) -> Void) {
        let request = baseParseRequest(with: [:])
        let body = """
            {
                \"uniqueKey\": \"\(student.uniqueKey ?? "")\",
                \"firstName\": \"\(student.firstName ?? "")\",
                \"lastName\": \"\(student.lastName ?? "")\",
                \"mapString\": \"\(student.mapString ?? "")\",
                \"mediaURL\": \"\(student.mediaURL ?? "")\",
                \"latitude\": \(student.latitude ?? 0.0),
                \"longitude\": \(student.longitude ?? 0.0)
            }
            """
        NetworkClient().post(request: request, body: body, decoder: StudentLocation.self) { (student, error) in
            if error != nil {
                failure(error)
            } else {
                success(student)
            }
        }
    }

    private func parseURL(with parameters: [String: AnyObject], for pathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (pathExtension ?? "")

        return NetworkClient.buildURL(forComponents: components, with: parameters)!
    }
}
