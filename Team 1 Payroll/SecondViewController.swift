//
//  SecondViewController.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 9/18/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

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

