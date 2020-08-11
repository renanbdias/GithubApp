//
//  TrendingReposViewModel.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import Foundation
import Combine

protocol TrendingReposViewModelServiceInterface {
    func fetchReposBy(date: String, sort: String, order: String, page: Int) -> AnyPublisher<[GitHubRepo], Error>
    func favorite(repo: GitHubRepo)
}

final class TrendingReposViewModel {
    private let service: TrendingReposViewModelServiceInterface
    
    private var cancellables = Set<AnyCancellable>()
    private var page = 0
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        return "created:>\(dateFormatter.string(from: Date()))"
    }
    
    @Published var repos: [GitHubRepo] = []
    
    init(service: TrendingReposViewModelServiceInterface) {
        self.service = service
    }
}

// MARK: - TrendingReposTableViewControllerInterface
extension TrendingReposViewModel: TrendingReposTableViewControllerInterface {
    var reposCount: Int {
        repos.count
    }
    
    var animateChanges: Bool {
        page == 1
    }
    
    var reposPublisher: AnyPublisher<[GithubRepoCellViewModel], Never> {
        $repos.map {
            $0.map(GithubRepoCellViewModel.init)
        }
        .eraseToAnyPublisher()
    }
    
    func loadRepos() {
        page += 1
        service.fetchReposBy(date: formattedDate, sort: "stars", order: "desc", page: page)
            // May handle error here
            .catch { _ in Just([GitHubRepo]()) }
            .sink { [weak self] (repos) in
                self?.repos += repos
            }
            .store(in: &cancellables)
    }
    
    func didSelectRepoAt(indexPath: IndexPath) {
        let repo = repos[indexPath.row]
        service.favorite(repo: repo)
    }
}
