//
//  SceneDelegate.swift
//  GithubSearch
//
//  Created by seungwooKim on 2023/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let viewController = GithubSearchViewController()
        viewController.reactor = GithubSearchReactor()
        let navgationContoller = UINavigationController(rootViewController: viewController)
//        navgationContoller.navigationBar.prefersLargeTitles = true
        window?.rootViewController = navgationContoller
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }


}

