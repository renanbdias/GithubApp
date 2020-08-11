//
//  Service.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import Foundation

class Service<T> {
    let network: T
    
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(network: T) {
        self.network = network
    }
}
