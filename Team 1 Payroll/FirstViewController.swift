//
//  FirstViewController.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 9/18/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import UIKit
import SQLite

class FirstViewController: UIViewController {
    
    var database: Connection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }catch{
            print(error)
        }
    }
    
    @IBOutlet weak var tabBar: UITabBarItem!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func segueToNext(_ sender: Any){
        self.performSegue(withIdentifier: "NextSeg", sender: self)
    }
    
    

    
    
}

