//
//  LevelConfiguration.swift
//  MemoryGame
//
//  Created by arkokat on 19/04/2018.
//  Copyright © 2018 afeka. All rights reserved.
//

import Foundation

enum Level {
    case EASY
    case MEDIUM
    case HARD
}

class LevelConfiguration {
    let numRows: Int
    let numCols: Int
    
    init(level: Level) {
        numRows = 4
        
        switch (level) {
        case .EASY:
            numCols = 3
        case .MEDIUM:
            numCols = 4
        case .HARD:
            numCols = 5
        }
    }
}
