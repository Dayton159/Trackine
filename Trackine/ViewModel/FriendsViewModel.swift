//
//  FriendsViewModel.swift
//  Trackine
//
//  Created by Dayton on 23/04/21.
//

import UIKit

struct FriendsViewModel {
    
    private let friend:CDFriends
    
    init(friend:CDFriends) {
        self.friend = friend
    }
    
    var friendName:String {
        guard let name = friend.name else { return String() }
        
        return name
    }
    
    var friendPicture:UIImage {
        guard let image = UIImage(named: friendName) else { return UIImage() }
        
        return image
    }
    
    var borrowedItem:Int16 {
        guard let tools = friend.tools else { return Int16() }
        var borrowedItem = Int16()
        
        tools.forEach{
            guard let tool = $0 as? CDTools else { return }
            borrowedItem += tool.itemCount
        }
        return borrowedItem
    }
    
    var totalItemBorrowed:String {
        let label = "Item Borrowed: "
       
        return label + String(borrowedItem)
    }
}
