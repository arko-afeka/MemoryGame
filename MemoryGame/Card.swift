//
//  Card.swift
//  MemoryGame
//
//  Created by arkokat on 20/04/2018.
//  Copyright © 2018 afeka. All rights reserved.
//

import Foundation
import UIKit

class Card: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var id: Int = 0
    var flipped: Bool = false {
        didSet {
            imageView.isHidden = !flipped
            
        }
    }
}
