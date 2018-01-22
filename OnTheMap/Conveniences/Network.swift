//
//  Network.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 17/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

enum UdacityError: Error {
    case parseFailure
}

class Network: NSObject {
    static let shared = Network()

    private var session = URLSession.shared

    private override init() {}

    func get<T: Decodable>(_ url: URL, _ completionHandlerForGET: @escaping (_ results: T?, _ error: Error?) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, err) in
            let status = ErrorHandler.checkStatus(data, response, err)
            if status.success {
                self.convert(data: data!, for: T.self, completionHandler: completionHandlerForGET)
            } else {
                completionHandlerForGET(nil, status.error)
            }
        }

        task.resume()

        return task
    }

    func post<T: Decodable>(_ url: URL, _ body: String?, _ completionHandlerForPOST: @escaping (_ results: T?, _ error: Error?) -> Void) -> URLSessionDataTask {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body?.data(using: .utf8)

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            let status = ErrorHandler.checkStatus(data, response, error)
            if status.success {
                let fromUdacity = (url.absoluteString.range(of: "udacity") != nil)
                self.convert(data: data!, for: T.self, fromUdacity, completionHandler: completionHandlerForPOST)
            } else {
                completionHandlerForPOST(nil, status.error)
            }
        }

        task.resume()

        return task
    }

    private func convert<T: Decodable>(data: Data, for decodingType: T.Type, _ fromUdacity: Bool = false, completionHandler: @escaping (_ result: T?, _ error: Error?) -> Void) {
        do {
            var data = data
            if fromUdacity {
                data = try udacityDataHandler(data: data)
            }

            let json = try JSONDecoder().decode(decodingType, from: data)

            completionHandler(json, nil)
        } catch let error {
            let err = ErrorHandler.buildError(message: "Could not parse the data as JSON: \(error)", code: 0, err: error)
            completionHandler(nil, err)
        }
    }

    class func buildParseURLRequest(with parameters: [String: AnyObject], at path: String?) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: Network.buildParseURL(with: parameters, at: path))
        request.addValue(Network.ParseConstants.ApiKey, forHTTPHeaderField: Network.HeaderKeys.ParseRESTApiID)
        request.addValue(Network.ParseConstants.AppKey, forHTTPHeaderField: Network.HeaderKeys.ParseApplicationID)

        return request
    }

    class func buildURL(with scheme: String, for host:String, at pathExtension: String, parameters: [String: AnyObject]) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = pathExtension
        components.queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }

        return components.url!
    }

    class func buildUdacityURL(with parameters: [String: AnyObject], at path: String?) -> URL {
        return buildURL(with: Network.UdacityConstants.ApiScheme,
                        for: Network.UdacityConstants.ApiHost,
                        at: Network.UdacityConstants.ApiPath + (path ?? ""),
                        parameters: parameters)
    }

    class func buildParseURL(with parameters: [String: AnyObject], at path: String?) -> URL {
        return buildURL(with: Network.ParseConstants.ApiScheme,
                        for: Network.ParseConstants.ApiHost,
                        at: Network.ParseConstants.ApiPath + (path ?? ""),
                        parameters: parameters)

    }

    private func udacityDataHandler(data: Data?) throws -> Data {

        guard let data = data else {
            throw UdacityError.parseFailure
        }

        let range = Range(5..<data.count)
        return data.subdata(in: range)

    }
}
