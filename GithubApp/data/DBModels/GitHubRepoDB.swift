//
//  GitHubRepoDB.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import RealmSwift

@objcMembers
final class GitHubRepoDB: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var owner: OwnerDB?
    dynamic var repoDescription: String?
    dynamic var stargazersCount: Int = 0
    
    override static func primaryKey() -> String? {
        "id"
    }
}


