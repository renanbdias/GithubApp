//
//  GitHubResponse.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import Foundation

struct GitHubResponse: Codable {
    let items: [GitHubRepo]
}
