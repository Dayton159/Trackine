//
//  UIBuilder.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import Foundation


protocol Builder {}
extension Builder {
    public func with(configure: (inout Self) -> Void) -> Self {
        var this = self
        configure(&this)
        return this
    }
}
extension NSObject: Builder {}
