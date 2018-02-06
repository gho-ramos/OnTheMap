//
//  NetworkClient.swift
//  OnTheMap
//
//  Created by Guilherme on 2/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class NetworkClient: NSObject {
    typealias SuccessCompletionBlock<T> = (_ result: T?) -> Void
    typealias FailureCompletionBlock = (_ error: Error?) -> Void
    typealias CompletionBlock<T> = (_ result: T?, _ error: Error?) -> Void

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    // MARK: HTTP Methods

    func get<T: Decodable>(request: URLRequest, decoder type: T.Type, completion: @escaping CompletionBlock<T>) {
        let task = handler(request: request) { (data, error) in
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(type, from: data!)
                completion(decoded, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }

    func post<T: Codable>(request: NSMutableURLRequest, body: String, decoder type: T.Type, completion: @escaping CompletionBlock<T>) {
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)
        let task = handler(request: request as URLRequest) { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(type, from: data)
                    completion(decoded, nil)
                } catch let error {
                   completion(nil, NetworkError.decodeFailure(error))
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }

    func post<T: Codable, J: Encodable>(request: NSMutableURLRequest, body: J, decoder type: T.Type, completion: @escaping CompletionBlock<T>) {
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try encode(body)
        } catch let error {
            completion(nil, error)
            return
        }
        let task = handler(request: request as URLRequest) { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(type, from: data)
                    completion(decoded, nil)
                } catch let error {
                    completion(nil, NetworkError.decodeFailure(error))
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }

    func delete<T: Codable>(request: NSMutableURLRequest, decoder type: T.Type, completion: @escaping CompletionBlock<T>) {
        request.httpMethod = "DELETE"
        let task = handler(request: request as URLRequest) { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(type, from: data)
                    completion(decoded, nil)
                } catch let error {
                    completion(nil, NetworkError.decodeFailure(error))
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }

    // MARK: Data related methods

    private func handler(request: URLRequest, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTaskProtocol {
        let isUdacity = request.url?.absoluteString.range(of: AuthenticationClient.Constants.ApiHost) != nil
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

    private func encode<T: Encodable>(_ object: T) throws -> Data {
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(object)
            return encoded
        } catch let error {
            throw NetworkError.encodeFailure(error)
        }
    }

    private func extract(from data: Data, _ isUdacity: Bool) -> Data? {
        if isUdacity {
            let range = Range(5..<data.count)
            return data.subdata(in: range)
        }
        return data
    }

    class func buildURL(forComponents components: URLComponents, with parameters: [String: AnyObject]) -> URL? {
        var components = components
        components.queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            components.queryItems?.append(URLQueryItem(name: key, value: value as? String))
        }

        return components.url!
    }
}
