//
//  GithubRepoCellViewModel.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import UIKit
import Combine

final class GithubRepoCellViewModel {
    let repo: GitHubRepo
    
    init(repo: GitHubRepo) {
        self.repo = repo
    }
}

// MARK: - Hashable
extension GithubRepoCellViewModel: Hashable {
    static func == (lhs: GithubRepoCellViewModel, rhs: GithubRepoCellViewModel) -> Bool {
        lhs.repo == rhs.repo
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(repo)
    }
}

// MARK: - GitHubRepoCellInterface
extension GithubRepoCellViewModel: GitHubRepoCellInterface {
    var name: String {
        repo.name
    }
    
    var description: String? {
        repo.description
    }
    
    var avatarImage: AnyPublisher<UIImage?, Never> {
        // MARK: Refactor to an ImageService or something like that (include cache and stuff).
        // MARK: For some reason, Codable does not map avatar_url. This is a hack I developed. Investigate later...
        Just(URL(string: "https://avatars1.githubusercontent.com/u/\(repo.owner.id)?v=4"))
            .compactMap { $0 }
            .flatMap {
                URLSession.shared.dataTaskPublisher(for: $0)
                    .map { UIImage(data: $0.data) }
                    .catch { _ in Just(nil) }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    var userLogin: String {
        repo.owner.login
    }
    
    var starsCount: String {
        // MARK: - TODO
        String(repo.stargazersCount)
    }
}
