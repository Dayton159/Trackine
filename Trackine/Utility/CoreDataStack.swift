//
//  CoreDataStack.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import UIKit
import CoreData

class CoreDataStack {
    
    private init() {}
    static let shared = CoreDataStack()
    
    lazy var persistentContainer = NSPersistentContainer(name: "Trackine").with {
        
        $0.loadPersistentStores { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        }
        $0.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        $0.viewContext.undoManager = nil
        $0.viewContext.shouldDeleteInaccessibleFaults = true
        $0.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension CoreDataStack {
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
}

