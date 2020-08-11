//
//  SceneDelegate.swift
//  GithubApp
//
//  Created by Renan Benatti Dias on 10/08/20.
//  Copyright © 2020 Renan Benatti Dias. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let repoRoutes = RepoRoutes()
        let repoService = RepoService(network: repoRoutes)
        let trendingReposViewModel = TrendingReposViewModel(service: repoService)
        let trendingReposTableViewController = TrendingReposTableViewController(viewModel: trendingReposViewModel)
        let trendingTabBatItem = UITabBarItem(title: "Trending", image: UIImage(systemName: "list.bullet"), tag: 0)
        trendingReposTableViewController.tabBarItem = trendingTabBatItem
        let trendingNavigationController = UINavigationController(rootViewController: trendingReposTableViewController)
        
        let favoriteReposViewModel = FavoriteReposViewModel(service: repoService)
        let favoriteReposTableViewController = FavoriteReposTableViewController(viewModel: favoriteReposViewModel)
        let favoriteTabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "star.fill"),
            tag: 1)
        favoriteReposTableViewController.tabBarItem = favoriteTabBarItem
        
        let tabbarViewController = UITabBarController()
        tabbarViewController.setViewControllers([trendingNavigationController, favoriteReposTableViewController], animated: true)
        
        window.rootViewController = tabbarViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}
