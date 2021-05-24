//
//  Tools.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import Foundation

enum Tools:Int, CaseIterable {
    
    case wrench
    case cutter
    case pliers
    case screwDriver
    case weldingMachine
    case weldingGlasses
    case hammer
    case measuringTape
    case alanKeySet
    case airCompressor
    
    
    var names:String {
        switch self {
        case .wrench:
            return "Wrench"
        case .cutter:
            return "Cutter"
        case .pliers:
            return "Pliers"
        case .screwDriver:
            return "Screw Driver"
        case .weldingMachine:
            return "Welding Machine"
        case .weldingGlasses:
            return "Welding Glasses"
        case .hammer:
            return "Hammer"
        case .measuringTape:
            return "Measuring Tape"
        case .alanKeySet:
            return "Alan Key Set"
        case .airCompressor:
            return "Air Compressor"
        }
    }
    
    var itemCount:Int16 {
        switch self {
        case .wrench:
            return 6
        case .cutter:
            return 15
        case .pliers:
            return 12
        case .screwDriver:
            return 13
        case .weldingMachine:
            return 3
        case .weldingGlasses:
            return 7
        case .hammer:
            return 4
        case .measuringTape:
            return 9
        case .alanKeySet:
            return 4
        case .airCompressor:
            return 2
        }
    }
    
     
    
    
}
