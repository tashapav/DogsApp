//
//  User.swift
//  DogsApp
//
//  Created by pavlovanv on 14.04.2025.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @NSManaged public var username: String
    @NSManaged public var password: String
    @NSManaged public var favoriteItems: Set<DogFactItem>?
}

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    static func findUser(username: String, context: NSManagedObjectContext) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let users = try context.fetch(request)
            return users.first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
    func addToFavoriteItems(_ value: DogFactItem) {
        let items = self.mutableSetValue(forKey: "favoriteItems")
        items.add(value)
    }
        
    func removeFromFavoriteItems(_ value: DogFactItem) {
        let items = self.mutableSetValue(forKey: "favoriteItems")
        items.remove(value)
    }
}
