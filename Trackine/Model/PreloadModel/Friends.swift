//
//  Friends.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import Foundation

enum Friends:Int, CaseIterable {
    
    case brian
    case luke
    case letty
    case shaw
    case parker
    
    var names:String {
        switch self {
        case .brian:
            return "Brian"
        case .luke:
            return "Luke"
        case .letty:
            return "Letty"
        case .shaw:
            return "Shaw"
        case .parker:
            return "Parker"
        }
    }
    
}
