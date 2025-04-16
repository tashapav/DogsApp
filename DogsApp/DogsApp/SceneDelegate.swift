//
//  SceneDelegate.swift
//  DogsApp
//
//  Created by pavlovanv on 14.04.2025.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("scene start")
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = AuthViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
