//
//  AppData.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import Foundation

struct AppData {
    
    // UserDefaults Property Wrapper
    
    @Defaults(key: "hasPreloadData", defaultValue: false)
    static var hasPreloadData: Bool
}



