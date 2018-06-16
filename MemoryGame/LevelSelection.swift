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
    
    @IBAction func highScores(_ sender: Any) {
        self.performSegue(withIdentifier: "highScores", sender: self)
    }
    
    @IBAction func replace(_ sender: Any) {
        self.performSegue(withIdentifier: "imageReplace", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "game") {
            let gameView = segue.destination as! Game
            
            gameView.levelConf = LevelConfiguration(level: self.level!)
            gameView.name = name
        }
    }
    
    func getDefaultData(id: Int) -> Data {
        return UIImagePNGRepresentation(UIImage(named: String(id))!)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults = [String: Any]()
        
        for i in 0..<10 {
            defaults[String(format: "card%d", i + 1)] = getDefaultData(id: i + 1)
        }
        
        UserDefaults.standard.register(defaults: defaults)
        
        nameData.text! += name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
