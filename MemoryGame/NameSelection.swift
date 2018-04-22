//
//  ViewController.swift
//  MemoryGame
//
//  Created by arkokat on 19/04/2018.
//  Copyright © 2018 afeka. All rights reserved.
//

import UIKit

class NameSelection: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    var name: String = ""
    
    @IBAction func enter(_ sender: UIButton) {
        if (nameField.text?.count == 0) {
            let alert = UIAlertController(title: "ERROR", message: "You didn't enter your name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        
        self.name = nameField.text!
        self.performSegue(withIdentifier: "levelSelection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination as! LevelSelection
        
        view.name = self.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

