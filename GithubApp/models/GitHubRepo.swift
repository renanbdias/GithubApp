//
//  GithubRepository.swift
//  GitHubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import Foundation

struct GitHubRepo: Codable, Hashable {
    let id: Int
    let name: String
    let owner: Owner
    let description: String?
    let stargazersCount: Int
}

// MARK: - Realm initializer
extension GitHubRepo {
    init(gitHubRepoDB: GitHubRepoDB) {
        self.id = gitHubRepoDB.id
        self.name = gitHubRepoDB.name
        self.owner = Owner(ownerDB: gitHubRepoDB.owner ?? OwnerDB())
        self.description = gitHubRepoDB.repoDescription
        self.stargazersCount = gitHubRepoDB.stargazersCount
    }
}
