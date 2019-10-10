//
//  personalView.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 10/10/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import UIKit
import SQLite
import CoreData

class personalViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
    }
    
    var managedObjectContext: NSManagedObjectContext!

    @IBAction func Logout(_ sender: Any) {
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    
    @IBAction func backToManager(_ sender: Any) {
        self.performSegue(withIdentifier: "manager", sender: self)
    }
    
}
