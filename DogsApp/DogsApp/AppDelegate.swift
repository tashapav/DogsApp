//
//  AppDelegate.swift
//  DogsApp
//
//  Created by pavlovanv on 14.04.2025.
//

//

import UIKit
import CoreData

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        if let count = try? context.count(for: request), count == 0 {
            let newUser = User(context: context)
            newUser.username = "test"
            newUser.password = "123"
            CoreDataStack.shared.saveContext()
        }
        print("end application")
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("in application2")
        let conf = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        conf.delegateClass = SceneDelegate.self
        return conf
    }
    
}

