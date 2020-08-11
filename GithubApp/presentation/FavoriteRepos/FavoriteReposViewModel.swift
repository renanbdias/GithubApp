//
//  FavoriteReposViewModel.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import Combine

protocol FavoriteReposServiceInterface {
    var reposPublisher: AnyPublisher<[GitHubRepo], Never> { get }
}

final class FavoriteReposViewModel {
    private let service: FavoriteReposServiceInterface
    
    init(service: FavoriteReposServiceInterface) {
        self.service = service
    }
}

// MARK: - FavoriteReposTableViewControllerInterface
extension FavoriteReposViewModel: FavoriteReposTableViewControllerInterface {
    var reposPublisher: AnyPublisher<[GithubRepoCellViewModel], Never> {
        service.reposPublisher.map {
            $0.map(GithubRepoCellViewModel.init)
        }
        .eraseToAnyPublisher()
    }
}
