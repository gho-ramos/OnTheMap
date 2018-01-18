//
//  Network.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 17/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class Network: NSObject {
    static let shared = Network()

    private var session = URLSession.shared

    private override init() {}

    func get(_ parameters: [String: AnyObject], _ completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
        let request = buildParseURLRequestWithParameters(parameters)

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                OnTheMapErrorHandler.sendError("There was an error with your request: \(error!)",
                        completionHandlerForGET)
                return
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                statusCode >= 200 && statusCode <= 299 else {

                OnTheMapErrorHandler.sendError("Your request returned a status code other than 2xx!",
                               completionHandlerForGET)
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                OnTheMapErrorHandler.sendError("No data was returned by the request!",
                                               completionHandlerForGET)
                return
            }

            self.convert(data: data, completionHandler: completionHandlerForGET)
        }

        task.resume()

        return task
    }

    func post(_ parameters: [String: AnyObject], jsonBody: [String: String], _ completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
        let request = buildParseURLRequestWithParameters(parameters)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonBody.description.data(using: String.Encoding.utf8)

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                OnTheMapErrorHandler.sendError("There was an error with your request: \(error!)",
                    completionHandlerForPOST)
                return
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                statusCode >= 200 && statusCode <= 299 else {

                OnTheMapErrorHandler.sendError("Your request returned a status code other than 2xx!",
                                               completionHandlerForPOST)
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                OnTheMapErrorHandler.sendError("No data was returned by the request!",
                                               completionHandlerForPOST)
                return
            }

            self.convert(data: data, completionHandler: completionHandlerForPOST)

        }

        task.resume()

        return task
    }

    private func convert(data: Data, completionHandler: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch let error {
            OnTheMapErrorHandler.sendError("Could not parse the data as JSON: \(error)", completionHandler)
        }

        completionHandler(parsedResult, nil)
    }

    private func buildParseURLRequestWithParameters(_ parameters: [String: AnyObject]) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: Network.parseURLWithParameters(parameters))
        request.addValue(Network.Constants.ApiKey, forHTTPHeaderField: Network.HeaderKeys.ParseRESTApiID)
        request.addValue(Network.Constants.AppKey, forHTTPHeaderField: Network.HeaderKeys.ParseApplicationID)

        return request
    }

    class func parseURLWithParameters(_ parameters: [String: AnyObject]) -> URL {
        var components = URLComponents()
        components.scheme = Network.Constants.ApiScheme
        components.host = Network.Constants.ApiHost
        components.path = Network.Constants.ApiPath
        components.queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }

        return components.url!

    }
}
