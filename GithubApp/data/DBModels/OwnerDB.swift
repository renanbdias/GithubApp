//
//  OwnerDB.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import RealmSwift

@objcMembers
final class OwnerDB: Object {
    dynamic var login: String = ""
    dynamic var id: Int = 0
}
