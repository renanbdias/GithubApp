//
//  API.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import Foundation
import Combine

typealias APIResponse = (data: Data, response: URLResponse)

protocol API {
    var baseURL: URL { get }
    func get(url: URL, queries: [String: String]) -> AnyPublisher<APIResponse, URLError>
}

extension API {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }
    
    func get(url: URL, queries: [String: String] = [:]) -> AnyPublisher<APIResponse, URLError> {
        var finalURL = url
        
        if !queries.isEmpty {
            queries.forEach { finalURL = finalURL.appending($0, value: $1) }
        }
        
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: finalURL))
            .handleEvents(receiveOutput: { print($1) })
            .eraseToAnyPublisher()
    }
}
