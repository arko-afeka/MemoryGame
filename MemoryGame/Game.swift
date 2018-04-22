//
//  Game.swift
//  MemoryGame
//
//  Created by arkokat on 20/04/2018.
//  Copyright © 2018 afeka. All rights reserved.
//

import Foundation
import UIKit

class Game: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelConf!.numRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! Card
        
        let id = indexPath.section + indexPath.row * (levelConf?.numRows)!
        cell.id = cards![id % levelConf!.numRows][id % levelConf!.numCols]
        cell.imageView.image = UIImage(named: String(cards![id % levelConf!.numRows][id % levelConf!.numCols]))
        cell.imageView.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! Card
        
        if (!cell.flipped) {
            cell.flipped = true
            
            if lastFlipped == nil {
                lastFlipped = cell
                return
            }
            
            if lastFlipped!.id == cell.id {
                totalDiscoverd += 1
                
                checkEnd()
            } else {
                let curFlip = self.lastFlipped!
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    cell.flipped = false
                    curFlip.flipped = false
                })
            }
            
            lastFlipped = nil
        }
    }
    
    func checkEnd() {
        if totalDiscoverd == (levelConf.numRows * levelConf.numCols / 2) {
            let alert = UIAlertController(title: "GAME END", message: "You've won!!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                DispatchQueue.main.async(execute: {
                    () in
                    self.dismiss(animated: true, completion: nil)
                })
            }))
            self.show(alert, sender: nil)
        } else if progress.progress == 1 {
            let alert = UIAlertController(title: "GAME END", message: "Not all cards flipped, try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction) in
                DispatchQueue.main.async(execute: {
                    () in
                    self.dismiss(animated: true, completion: nil)
                })
            }))
            self.show(alert, sender: nil)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return levelConf!.numCols
    }
    
    let MAX_TIME: Float = 120
    var levelConf: LevelConfiguration!
    var name: String = ""
    var cards: [[Int]]!
    var time: Float = 0.0
    var timer: Timer!
    var totalDiscoverd: Int = 0
    var lastFlipped: Card?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progress: UIProgressView!
    
    func timerFired(timer: Timer) {
        time += 1
        progress.setProgress(time / MAX_TIME, animated: true)
        
        if time >= MAX_TIME {
            checkEnd()
            timer.invalidate()
        }
    }
    
    func shuffleArray(array: [Int]) -> [Int] {
        var shuffled: [Int] = Array()
        var items = array
        
        for _ in 0..<array.count {
            let rand = Int(arc4random_uniform(UInt32(items.count)))
            shuffled.append(items[rand])
            items.remove(at: rand)
        }

        return shuffled
    }
    
    func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32) -> [Int] {
        var uniqueNumbers = Set<Int>()
        while uniqueNumbers.count < numberOfRandoms {
            uniqueNumbers.insert(Int(arc4random_uniform(maxNum)) + minNum)
        }
        return Array(uniqueNumbers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let totalCards = levelConf!.numRows * levelConf!.numCols / 2
        let cards = uniqueRandoms(numberOfRandoms: totalCards, minNum: 1, maxNum: 10)
        var locations = shuffleArray(array: Array(0...(totalCards * 2 - 1)))
        self.cards = Array(repeating: Array(repeating: 0, count: self.levelConf!.numCols), count: self.levelConf!.numRows)
        
        for card in cards {
            var loc = locations.removeFirst()
            self.cards![loc % levelConf!.numRows][loc % levelConf!.numCols] = card
            
            loc = locations.removeFirst()
            self.cards![loc % levelConf!.numRows][loc % levelConf!.numCols] = card
        }
        
        self.nameLabel.text! += name
        progress.setProgress(0, animated: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(MAX_TIME / 100), repeats: true, block: timerFired)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
