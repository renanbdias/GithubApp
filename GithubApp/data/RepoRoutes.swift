//
//  RepoRoutes.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import Foundation
import Combine

final class RepoRoutes: API {
    private var url: URL {
        baseURL.appendingPathComponent("/search/repositories")
    }
}

// MARK: - RepoNetworkInterface
extension RepoRoutes: RepoNetworkInterface {
    func fetchReposBy(date: String, sort: String, order: String, page: Int) -> AnyPublisher<APIResponse, URLError> {
        let queries = [
            "q": date,
            "sort": sort,
            "order": order,
            "page": String(page)
        ]
        return get(url: url, queries: queries)
    }
}
