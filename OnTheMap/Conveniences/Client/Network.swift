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

    func get<T: Decodable>(request: URLRequest, decoderType: T.Type, completion: @escaping ((T?, Error?) -> Void)) {
        let task = handler(request: request) { (data, error) in
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(decoderType, from: data!)
                completion(decoded, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()

    }

    func post<T: Codable>(request: NSMutableURLRequest, body: String, decoderType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)
        let task = handler(request: request as URLRequest) { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(decoderType, from: data)
                    completion(decoded, nil)
                } catch let error {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }

    func delete<T: Codable>(request: NSMutableURLRequest, decoderType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        request.httpMethod = "DELETE"
        let task = handler(request: request as URLRequest) { (data, error) in
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(decoderType, from: data!)
                completion(decoded, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }

    private func handler(request: URLRequest, completion: @escaping ((Data?, Error?) -> Void)) -> URLSessionDataTask {
        let isUdacity = request.url?.absoluteString.range(of: UdacityConstants.ApiHost) != nil
        let task = session.dataTask(with: request) { (data, response, error) in
            let status = ErrorHandler.checkStatus(data, response, error)
            if status.success {
                completion(self.extract(from: data!, isUdacity), nil)
            } else {
                completion(nil, status.error)
            }
        }
        return task
    }

    private func extract(from data: Data, _ isUdacity: Bool) -> Data? {
        if isUdacity {
            let range = Range(5..<data.count)
            return data.subdata(in: range)
        }
        return data
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
