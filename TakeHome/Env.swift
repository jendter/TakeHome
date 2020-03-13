//
//  Env.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-12.
//  Copyright © 2020 JRE. All rights reserved.
//

import Foundation

struct Env {
    static let isDebug : Bool = {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }()
    
    // With more time, a theme struct would be injected into ViewControllers. For now, fonts are just statically defined.
    static let boldFont: String = "PingFangHK-Semibold"
    static let standardFont: String = "PingFangHK-Regular"
}
