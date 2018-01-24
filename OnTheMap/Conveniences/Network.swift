//
//  Network.swift
//  OnTheMap
//
//  Created by Guilherme on 1/22/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

class Network: NSObject {
    static let shared = Network()

    private let session = URLSession.shared

    private override init() { }

    typealias CompletionHandler = ((AnyObject?, Error?) -> Void)

    func get(request: NSMutableURLRequest, completion: @escaping CompletionHandler) {
        let task = taskHandler(request: request as URLRequest) { (result, error) in
            completion(result, error)
        }

        task.resume()
    }

    func delete(request: NSMutableURLRequest, completion: @escaping CompletionHandler) {
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = taskHandler(request: request as URLRequest) { (result, error) in
            completion(result, error)
        }

        task.resume()

    }

    func post(request: NSMutableURLRequest, body: String, completion: @escaping CompletionHandler) {
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)

        let task = taskHandler(request: request as URLRequest) { (result, error) in
            completion(result, error)
        }

        task.resume()
    }

    func taskHandler(request: URLRequest, completionHandler completion: @escaping CompletionHandler) -> URLSessionDataTask {
        let shouldExtractRange = request.url?.absoluteString.range(of: UdacityConstants.ApiHost) != nil
        let task = session.dataTask(with: request) { (data, response, error) in
            let status = ErrorHandler.checkStatus(data, response, error)
            if status.success {
                var data = data
                if shouldExtractRange {
                    let range = Range(5..<data!.count)
                    data = data?.subdata(in: range)
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    completion(result as AnyObject, nil)
                } catch let error {
                    let e = ErrorHandler.buildError(message: "Cannot convert data to JSON", code: 1, err: error)
                    completion(nil, e)
                }
            } else {
                completion(nil, status.error)
            }
        }
        return task
    }

    private class func buildURL(forComponents components: URLComponents, with parameters: [String: AnyObject]) -> URL? {
        var components = components
        components.queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            components.queryItems?.append(URLQueryItem(name: key, value: value as? String))
        }

        return components.url!
    }

    class func buildParseURL(with parameters: [String: AnyObject], _ pathExtension: String?) -> URL {
        var components = URLComponents()
        components.scheme = ParseConstants.ApiScheme
        components.host = ParseConstants.ApiHost
        components.path = ParseConstants.ApiPath + (pathExtension ?? "")

        return buildURL(forComponents: components, with: parameters)!
    }

    class func buildUdacityURL(with parameters: [String: AnyObject], _ pathExtension: String?) -> URL {
        var components = URLComponents()
        components.scheme = UdacityConstants.ApiScheme
        components.host = UdacityConstants.ApiHost
        components.path = UdacityConstants.ApiPath + (pathExtension ?? "")

        return buildURL(forComponents: components, with: parameters)!
    }
}
