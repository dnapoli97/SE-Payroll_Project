//
//  SecondViewController.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 9/18/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let nextVC = segue.destination as? OverviewViewController {
        nextVC.managedObjectContext = managedObjectContext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var secondTab: UITabBarItem!
    
    func changeSecondTabOff() {
        secondTab.isEnabled = false
    }
    
    func changeSecondTabOn() {
        secondTab.isEnabled = true
    }
}

