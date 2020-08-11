//
//  RepoService.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import Foundation
import Combine
import RealmSwift

protocol RepoNetworkInterface {
    func fetchReposBy(date: String, sort: String, order: String, page: Int) -> AnyPublisher<APIResponse, URLError>
}

final class RepoService: Service<RepoNetworkInterface> {
    // MARK: Any additional properties
}

// MARK: - TrendingReposViewModelServiceInterface
extension RepoService: TrendingReposViewModelServiceInterface {
    func fetchReposBy(date: String, sort: String, order: String, page: Int) -> AnyPublisher<[GitHubRepo], Error> {
        network.fetchReposBy(date: date, sort: sort, order: order, page: page)
            .map(\.data)
            .decode(type: GitHubResponse.self, decoder: jsonDecoder)
            .map(\.items)
            .eraseToAnyPublisher()
    }
    
    func favorite(repo: GitHubRepo) {
        do {
            let realm = try Realm()
            
            if let _ = realm.object(ofType: GitHubRepoDB.self, forPrimaryKey: repo.id) {
                // MARK: Repo's already on the database
                // Find a better solution?
                return
            }
            
            let owner = OwnerDB()
            owner.id = repo.owner.id
            owner.login = repo.owner.login
            
            let githubDB = GitHubRepoDB()
            githubDB.id = repo.id
            githubDB.name = repo.name
            githubDB.owner = owner
            githubDB.repoDescription = repo.description
            githubDB.stargazersCount = repo.stargazersCount
            
            try realm.write {
                realm.add(githubDB)
            }
            
        } catch let error {
            // MARK: TODO handle error...
            print(error.localizedDescription)
        }
    }
}

// MARK: - FavoriteReposViewModelInterface
extension RepoService: FavoriteReposServiceInterface {
    var reposPublisher: AnyPublisher<[GitHubRepo], Never> {
        Just(try? Realm()).compactMap { $0 }
            .flatMap {
                $0.objects(GitHubRepoDB.self)
                    .collectionPublisher
                    .map { $0.map(GitHubRepo.init(gitHubRepoDB:)) }
                    .catch { _ in Just([]) }
            }
            .eraseToAnyPublisher()
    }
}
