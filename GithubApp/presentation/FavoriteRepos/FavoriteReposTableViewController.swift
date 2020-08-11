//
//  FavoriteReposTableViewController.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import UIKit
import Combine

protocol FavoriteReposTableViewControllerInterface {
    var reposPublisher: AnyPublisher<[GithubRepoCellViewModel], Never> { get }
}

final class FavoriteReposTableViewController: UITableViewController {
     private let viewModel: FavoriteReposTableViewControllerInterface
     private lazy var dataSource = makeDataSource()
     private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FavoriteReposTableViewControllerInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        viewModel.reposPublisher
            .sink { [weak self] (repos) in
                guard let self = self else { return }
                var snapshot = Snapshot()
                snapshot.appendSections([.repo])
                snapshot.appendItems(repos)
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableView setup
private extension FavoriteReposTableViewController {
    func setupTableView() {
        tableView.register(
            UINib(nibName: "GitHubRepoTableViewCell", bundle: nil),
            forCellReuseIdentifier: "GitHubRepoTableViewCell")
        tableView.allowsSelection = false
    }
    
    func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { (tableView, indexPath, repoViewModel) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "GitHubRepoTableViewCell",
                for: indexPath) as? GitHubRepoTableViewCell
            cell?.populate(viewModel: repoViewModel)
            return cell
        }
    }
}
