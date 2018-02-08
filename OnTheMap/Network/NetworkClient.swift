//
//  NetworkClient.swift
//  OnTheMap
//
//  Created by Guilherme on 2/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class NetworkClient: NSObject {
    typealias NetworkingCompletionBlock<T> = (_ result: T?, _ error: NetworkError?) -> Void
    typealias NetworkingSuccessBlock = (_ result: Data) -> Void
    typealias NetworkingFailureBlock = (_ error: NetworkError?) -> Void

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    // MARK: HTTP Methods

    func get<T: Decodable>(request: URLRequest, decoder type: T.Type, completion: @escaping NetworkingCompletionBlock<T>) {
        let task = taskHandler(request: request, success: { data in
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(type, from: data)
                completion(decoded, nil)
            } catch let error {
                completion(nil, NetworkError.decodeFailure(error))
            }
        }, failure: { error in
            completion(nil, error)
        })
        task.resume()
    }

    func post<T: Codable>(request: NSMutableURLRequest, body: String, decoder type: T.Type, completion: @escaping NetworkingCompletionBlock<T>) {
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)
        let task = taskHandler(request: request as URLRequest, success: { data in
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(type, from: data)
                completion(decoded, nil)
            } catch let error {
                completion(nil, NetworkError.decodeFailure(error))
            }
        }, failure: { error in
            completion(nil, error)
        })
        task.resume()
    }

    func post<T: Codable, J: Encodable>(request: NSMutableURLRequest, body: J, decoder type: T.Type, completion: @escaping NetworkingCompletionBlock<T>) {
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try encode(body)
        } catch let error {
            completion(nil, NetworkError.encodeFailure(error))
            return
        }
        let task = taskHandler(request: request as URLRequest, success: { data in
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(type, from: data)
                completion(decoded, nil)
            } catch let error {
                completion(nil, NetworkError.decodeFailure(error))
            }
        }, failure: { error in
            completion(nil, error)
        })
        task.resume()
    }

    func delete<T: Codable>(request: NSMutableURLRequest, decoder type: T.Type, completion: @escaping NetworkingCompletionBlock<T>) {
        request.httpMethod = "DELETE"
        let task = taskHandler(request: request as URLRequest, success: { data in
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(type, from: data)
                completion(decoded, nil)
            } catch let error {
                completion(nil, NetworkError.decodeFailure(error))
            }
        }, failure: { error in
            completion(nil, error)
        })
        task.resume()
    }

    // MARK: Data related methods

    private func taskHandler(request: URLRequest, completion: @escaping ((_ data: Data?, _ error: NetworkError?) -> Void)) -> URLSessionDataTaskProtocol {
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

    private func taskHandler(request: URLRequest, success: @escaping NetworkingSuccessBlock, failure: @escaping NetworkingFailureBlock) -> URLSessionDataTaskProtocol {
        let isUdacity = request.url?.absoluteString.range(of: AuthenticationClient.Constants.ApiHost) != nil
        let task = session.dataTask(with: request) { (data, response, error) in
            let status = ErrorHandler.checkStatus(data, response, error)
            if status.success {
                guard let data = self.extract(from: data!, isUdacity) else {
                    failure(NetworkError.unauthorized)
                    return
                }
                success(data)
            } else {
                failure(status.error)
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
