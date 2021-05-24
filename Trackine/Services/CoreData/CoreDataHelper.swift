//
//  CoreDataHelper.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    static let context = CoreDataStack.shared.context
    
    //MARK: - CDTools Create
    static func createToolsForFriend(toolName:String?,itemCount:Int16, forFriend:CDFriends) {
        
        if let toolEntity = NSEntityDescription.entity(forEntityName: "CDTools", in: context) {
            
            let newTools = NSManagedObject(entity: toolEntity, insertInto: context)
            
            newTools.setValue(toolName, forKey: "name")
            newTools.setValue(itemCount, forKey: "itemCount")
            newTools.setValue(forFriend, forKey: "ofFriend")
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
    
    //MARK: - CDTools Read
    
    static func readTools(queryType:ToolQuery, toolName:String? = nil) -> [CDTools] {
        
        var returnedTools = [CDTools]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDTools")
        
            fetchRequest.predicate = updatePredicate(queryType: queryType, toolName: toolName)
        
        do {
            let fetchedTools = try context.fetch(fetchRequest)
            fetchedTools.forEach { (fetchRequestResult) in
                guard let tool = fetchRequestResult as? CDTools else { return }
                
                returnedTools.append(tool)
            }
        } catch let error as NSError {
            print("Could not read. \(error), \(error.userInfo)")
        }
        
        return returnedTools
    }
    
    static func readTool(queryType:ToolQuery,_ toolName:String) -> CDTools? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDTools")
        
        let toolPredicate = updatePredicate(queryType: queryType, toolName: toolName)
        
        fetchRequest.predicate = toolPredicate
        
        do {
            let fetchedTool = try context.fetch(fetchRequest)
            guard let toolToBeRead = fetchedTool.first as? CDTools else { return nil }
            
            return toolToBeRead
            
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    //MARK: - CDTools Update
    
    static func updateTool(_ transaction:Loan) {
        
        let originTool = transaction.tools
        
        guard let toolName = originTool.name else { return }
        guard let friendName = transaction.byFriend.name else { return }
        // read managed object
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDTools")
        fetchRequest.predicate = updatePredicate(queryType: transaction.toolQuery, friendName: friendName, toolName: toolName)
        
        do {
            // make the changes
            let fetchedTool = try context.fetch(fetchRequest)
            
            if let affectedTool = fetchedTool.first as? CDTools {
                
                originTool.itemCount -= transaction.value
                affectedTool.itemCount += transaction.value

            } else {
                originTool.itemCount -= transaction.value
                createToolsForFriend(toolName: originTool.name, itemCount: transaction.value, forFriend: transaction.byFriend)
            }
            
            // save
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not change. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - CDTools Delete
    
    static func deleteToolFromFriend(toolQuery:ToolQuery, friendName: String, toolName:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDTools")
        
        fetchRequest.predicate = updatePredicate(queryType: toolQuery, friendName: friendName, toolName: toolName)
        
        do {
            let fetchedTool = try context.fetch(fetchRequest)
            guard let toolToBeDeleted = fetchedTool.first as? CDTools else { return }
            context.delete(toolToBeDeleted)
            
            do {
                try context.save()

            } catch let error as NSError {
                // TODO error handling
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }
    
    //MARK: - Predicate
    
    static func updatePredicate(queryType: ToolQuery, friendName:String? = nil, toolName:String? = nil) -> NSPredicate {
        
        let secondPredicate = NSPredicate(format: "name = %@", toolName ?? NSNull())
        
        switch queryType {
        case .transaction:
            let firstPredicate = NSPredicate(format: "ofFriend.name = %@", friendName ?? NSNull())
            
            return NSCompoundPredicate(andPredicateWithSubpredicates: [firstPredicate, secondPredicate])
        case .dominicTools:
            let firstPredicate = NSPredicate(format: "ofFriend = nil")
            
            return toolName == nil ? firstPredicate : NSCompoundPredicate(andPredicateWithSubpredicates: [firstPredicate, secondPredicate])
        case .toolBorrowers:
                let firstPredicate = NSPredicate(format: "ofFriend != nil")
            return NSCompoundPredicate(andPredicateWithSubpredicates: [firstPredicate, secondPredicate])
        }
    }
    
    
    //MARK: - CDFriends Read
    
    static func readFriends() -> [CDFriends] {
        
        var returnedFriends = [CDFriends]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDFriends")
      
        do {
            let fetchedFriends = try context.fetch(fetchRequest)
            fetchedFriends.forEach { (fetchRequestResult) in
                guard let friend = fetchRequestResult as? CDFriends else { return }
                
                returnedFriends.append(friend)
            }
        } catch let error as NSError {
            print("Could not read. \(error), \(error.userInfo)")
        }
        
        return returnedFriends
    }
    
    static func readFriend(name:String) -> CDFriends? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDFriends")
        
        let friendPredicate = NSPredicate(format: "name = %@", name)
        
        fetchRequest.predicate = friendPredicate
        
        do {
            let fetchedFriends = try context.fetch(fetchRequest)
            guard let friendsToBeRead = fetchedFriends.first as? CDFriends else { return nil }
            
            return friendsToBeRead
            
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    
    static func removeAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDFriends")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDTools")
        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        do {
            try CDFriends.context.execute(deleteRequest)
            try CDTools.context.execute(deleteRequest1)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        AppData.hasPreloadData = false
    }
}

extension CDFriends {
    static var context: NSManagedObjectContext {
        let context = CoreDataStack.shared.context
        return context
    }
}

extension CDTools {
    static var context: NSManagedObjectContext {
        let context = CoreDataStack.shared.context
        return context
    }
}
