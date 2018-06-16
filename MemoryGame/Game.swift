//
//  Game.swift
//  MemoryGame
//
//  Created by arkokat on 20/04/2018.
//  Copyright © 2018 afeka. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Game: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelConf!.numRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! Card
        
        cell.id = cards![indexPath.row][indexPath.section]
        cell.flipped = false
        
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
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
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    let managedContext = appDelegate?.persistentContainer.viewContext
                    let score = HighScore(insertInto: managedContext)
                    score.name = self.name
                    score.time = self.time as NSNumber
                    score.save()
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
    
    func shuffle(numbers: [Int]) -> [Int] {
        var tmp = numbers
        var result = [Int]()
        
        for i in 0..<numbers.count {
            var rand = Int(arc4random_uniform(UInt32(tmp.count)))
            result.append(
                tmp[rand])
            tmp.remove(at: rand)
        }
        
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let totalCards = levelConf!.numRows * levelConf!.numCols / 2
        var locations = shuffle(numbers: Array(0..<totalCards*2))
        self.cards = Array(repeating: Array(repeating: 0, count: self.levelConf!.numCols), count: self.levelConf!.numRows)
        
        for card in 0..<totalCards {
            var loc = locations.removeFirst()
            self.cards![loc % levelConf!.numRows][loc % levelConf!.numCols] = card + 1
            
            loc = locations.removeFirst()
            self.cards![loc % levelConf!.numRows][loc % levelConf!.numCols] = card + 1
        }
        
        self.nameLabel.text! += name
        progress.setProgress(0, animated: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(MAX_TIME / 100), repeats: true, block: timerFired)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
