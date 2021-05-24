//
//  ToolsViewModel.swift
//  Trackine
//
//  Created by Dayton on 22/04/21.
//

import UIKit

struct ToolsViewModel {
    
    private let tool:CDTools
    private let theOtherTools:[CDTools]?
   
    
    init(tool:CDTools, theOtherTools:[CDTools]? = nil) {
        self.tool = tool
        self.theOtherTools = theOtherTools
    }
    
    var toolName:String {
        guard let name = tool.name else { return String() }
        
        return name
    }
    
    var toolsIcon:UIImage {
        guard let toolIcon = UIImage(named: toolName) else { return UIImage() }
        
        return toolIcon
    }
    
    var totalItem:String {
        let label = "Total: "
         
        return label + String(tool.itemCount)
    }
    
    var totalBorrowed:String {
        guard let tools = theOtherTools else { return String()}
        
        let label = "Borrowed: "
        var borrowedItem = Int16()
        
        tools.forEach{ borrowedItem += $0.itemCount }
        
        return label + String(borrowedItem)
    }
}
