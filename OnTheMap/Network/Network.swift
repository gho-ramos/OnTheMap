//
//  Network.swift
//  OnTheMap
//
//  Created by Guilherme on 1/22/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

class Network: NSObject {
    private let session = URLSession.shared
    static let shared = Network()

    private override init() { }

    func get<T: Decodable>(request: URLRequest, decoderType: T.Type, completion: @escaping ((T?, Error?) -> Void)) {
        let task = handler(request: request) { (data, error) in
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(decoderType, from: data!)
                completion(decoded, nil)
            } catch let error {
                completion(nil, NetworkError.decodeFailure(error))
            }
        }
        task.resume()

    }

    func post<T: Codable, J: Encodable>(request: NSMutableURLRequest, body: J, decoderType: T.Type, completion: @escaping (T?, Error?) -> Void) {
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
                    let decoded = try decoder.decode(decoderType, from: data)
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

    func delete<T: Codable>(request: NSMutableURLRequest, decoderType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        request.httpMethod = "DELETE"
        let task = handler(request: request as URLRequest) { (data, error) in
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(decoderType, from: data!)
                completion(decoded, nil)
            } catch let error {
                completion(nil, NetworkError.decodeFailure(error))
            }
        }
        task.resume()
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

    private func handler(request: URLRequest, completion: @escaping ((Data?, Error?) -> Void)) -> URLSessionDataTask {
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
