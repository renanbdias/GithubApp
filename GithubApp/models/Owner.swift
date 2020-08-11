//
//  Owner.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import Foundation

struct Owner: Codable, Hashable {
    let login: String
    let id: Int
}

// MARK: - Realm
extension Owner {
    init(ownerDB: OwnerDB) {
        self.login = ownerDB.login
        self.id = ownerDB.id
    }
}
