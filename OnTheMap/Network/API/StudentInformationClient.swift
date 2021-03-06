//
//  StudentInformationClient.swift
//  OnTheMap
//
//  Created by Guilherme on 1/22/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class StudentInformationClient: NSObject {
    let client: NetworkClient!

    init(session: URLSessionProtocol = URLSession.shared) {
        client = NetworkClient(session: session)
    }

    fileprivate func baseParseRequest(with parameters: [String: AnyObject]) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: parseURL(with: parameters))
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Headers.ParseRESTApiID)
        request.addValue(Constants.AppKey, forHTTPHeaderField: Headers.ParseApplicationID)
        return request
    }

    func getStudents(with parameters: [String: AnyObject], success: @escaping ([StudentLocation]?) -> Void, failure: @escaping (Error?) -> Void) {
        let request = baseParseRequest(with: parameters)
        client.get(request: request as URLRequest, decoder: Students.self) { (students, error) in
            if error != nil {
                failure(error)
            } else {

                if let students = students?.results {
                    DataManager.shared.students = students
                }
                success(students?.results)
            }
        }
    }

    func saveStudent(_ student: StudentLocation, success: @escaping (StudentLocation?) -> Void, failure: @escaping (Error?) -> Void) {
        let request = baseParseRequest(with: [:])
        let body = String(describing: student)
        client.post(request: request, body: body, decoder: StudentLocation.self) { (student, error) in
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
