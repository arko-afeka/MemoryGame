//
//  LevelSelection.swift
//  
//
//  Created by arkokat on 19/04/2018.
//

import Foundation
import UIKit

class LevelSelection: UIViewController {
    @IBOutlet weak var nameData: UILabel!
    var name: String = ""
    var level: Level?
    
    func nextScreen() {
        self.performSegue(withIdentifier: "game", sender: self)
    }
    
    @IBAction func easy(_ sender: Any) {
        self.level = .EASY
        self.nextScreen()
    }
    
    @IBAction func medium(_ sender: Any) {
        self.level = .MEDIUM
        self.nextScreen()
    }
    
    @IBAction func hard(_ sender: Any) {
        self.level = .HARD
        self.nextScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameView = segue.destination as! Game
        
        gameView.levelConf = LevelConfiguration(level: self.level!)
        gameView.name = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameData.text! += name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
