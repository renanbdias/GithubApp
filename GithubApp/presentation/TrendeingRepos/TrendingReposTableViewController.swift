//
//  TrendingReposTableViewController.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import UIKit
import Combine

protocol TrendingReposTableViewControllerInterface {
    var reposCount: Int { get }
    var animateChanges: Bool { get }
    var reposPublisher: AnyPublisher<[GithubRepoCellViewModel], Never> { get }
    func loadRepos()
    func didSelectRepoAt(indexPath: IndexPath)
}

final class TrendingReposTableViewController: UITableViewController {
    private let viewModel: TrendingReposTableViewControllerInterface
    private lazy var dataSource = makeDataSource()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: TrendingReposTableViewControllerInterface) {
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
                self.applySnapshot(repos: repos)
            }
            .store(in: &cancellables)
        
        viewModel.loadRepos()
    }
}

// MARK: - UITableView setup
private extension TrendingReposTableViewController {
    func setupTableView() {
        tableView.register(
            UINib(nibName: "GitHubRepoTableViewCell", bundle: nil),
            forCellReuseIdentifier: "GitHubRepoTableViewCell")
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
    
    func applySnapshot(repos: [GithubRepoCellViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.repo])
        snapshot.appendItems(repos)
        dataSource.apply(snapshot, animatingDifferences: viewModel.animateChanges)
    }
}

// MARK: - UITableViewDelegate
extension TrendingReposTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "Favorite Repo?",
            message: "Add this repo to your favories?",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.viewModel.didSelectRepoAt(indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let actions = [okAction, cancelAction]
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.reposCount - 10 {
            viewModel.loadRepos()
        }
    }
}
