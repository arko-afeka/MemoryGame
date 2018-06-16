//
//  Utils.swift
//  MemoryGame
//
//  Created by arkokat on 11/06/2018.
//  Copyright © 2018 afeka. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
