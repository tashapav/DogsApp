//
//  DogFactItem.swift
//  DogsApp
//
//  Created by pavlovanv on 14.04.2025.
//

import Foundation
import CoreData

@objc(DogFactItem)
public class DogFactItem: NSManagedObject {
    @NSManaged public var fact: String
    @NSManaged public var imageUrl: String
    @NSManaged public var id: UUID
    @NSManaged public var favoritedBy: Set<User>?
}

extension DogFactItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogFactItem> {
        return NSFetchRequest<DogFactItem>(entityName: "DogFactItem")
    }
    
    static func createOrFind(fact: String, imageUrl: String, context: NSManagedObjectContext) -> DogFactItem {
        let request: NSFetchRequest<DogFactItem> = DogFactItem.fetchRequest()
        request.predicate = NSPredicate(format: "imageUrl == %@", imageUrl)
        
        if let existingItem = try? context.fetch(request).first {
            return existingItem
        }
        
        let newItem = DogFactItem(context: context)
        newItem.id = UUID()
        newItem.fact = fact
        newItem.imageUrl = imageUrl
        return newItem
    }
}

