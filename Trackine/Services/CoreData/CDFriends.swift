//
//  CDFriends.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import CoreData

extension CDFriends {
    
    static var context: NSManagedObjectContext {
        let context = CoreDataStack.shared.context
        return context
    }
    
    
    
}
