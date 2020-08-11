//
//  GitHubRepo+DiffableDataSource.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 11/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import UIKit

enum ListSection: Hashable {
    case repo
}

typealias DataSource = UITableViewDiffableDataSource<ListSection, GithubRepoCellViewModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, GithubRepoCellViewModel>
