//
//  PrefillData.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import Foundation
import CoreData

class PrefillData {
    
    static let context = CoreDataStack.shared.context
    
    static func createStarterFriends(name:String) {
        
        if let friendEntity = NSEntityDescription.entity(forEntityName: "CDFriends", in: context) {
            
            let newFriend = NSManagedObject(entity: friendEntity, insertInto: context)
            
            newFriend.setValue(name, forKey: "name")
            
            do {
                try context.save()
            } catch let error as NSError {
                // TODO error handling
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func createStarterTools(name:String, itemCount:Int16) {
        
        if let toolEntity = NSEntityDescription.entity(forEntityName: "CDTools", in: context) {
            
            let newTools = NSManagedObject(entity: toolEntity, insertInto: context)
            
            newTools.setValue(name, forKey: "name")
            newTools.setValue(itemCount, forKey: "itemCount")
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                // TODO error handling
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}
