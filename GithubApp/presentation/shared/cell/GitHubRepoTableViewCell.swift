//
//  GitHubRepoTableViewCell.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import UIKit
import Combine

protocol GitHubRepoCellInterface {
    var name: String { get }
    var description: String? { get }
    var avatarImage: AnyPublisher<UIImage?, Never> { get }
    var userLogin: String { get }
    var starsCount: String { get }
}

final class GitHubRepoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var starCountLabel: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = Set<AnyCancellable>()
        userAvatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
    }
    
    private func applyLayout() {
        nameLabel.font = .boldSystemFont(ofSize: 17)
        descriptionLabel.font = .systemFont(ofSize: 14)
        userAvatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        userAvatarImageView.tintColor = .black
        userLoginLabel.font = .systemFont(ofSize: 14)
        starCountLabel.font = .boldSystemFont(ofSize: 17)
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .black
    }
    
    func populate(viewModel: GitHubRepoCellInterface) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        userLoginLabel.text = viewModel.userLogin
        starCountLabel.text = viewModel.starsCount
        viewModel.avatarImage
            .assign(to: \.image, on: userAvatarImageView)
            .store(in: &cancellables)
    }
}
