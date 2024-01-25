//
//  SceneDelegate.swift
//  CoreDataDemo
//
//  Created by Nikolai Maksimov on 24.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let rootVC = UINavigationController(rootViewController: PersonViewController())
        rootVC.navigationBar.prefersLargeTitles = true
        window?.rootViewController = rootVC
        setupNavigationBar()
        window?.makeKeyAndVisible()
    }
    
    private func setupNavigationBar() {
        UIView.appearance().tintColor = .darkGray
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255)
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
