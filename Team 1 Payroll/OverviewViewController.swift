//
//  OverviewViewController.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 10/1/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Schedule.isHidden = false
        WorkTimes.isHidden = true
        ApprovePay.isHidden = true
        Wages.isHidden = true
    }
    
    @IBOutlet weak var Schedule: UIView!
    @IBOutlet weak var WorkTimes: UIView!
    @IBOutlet weak var ApprovePay: UIView!
    @IBOutlet weak var Wages: UIView!
    @IBOutlet weak var tabBar: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: Any) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            Schedule.isHidden = false
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = true
            break
        case 1:
            Schedule.isHidden = true
            WorkTimes.isHidden = false
            ApprovePay.isHidden = true
            Wages.isHidden = true
            break
        case 2:
            Schedule.isHidden = true
            WorkTimes.isHidden = true
            ApprovePay.isHidden = false
            Wages.isHidden = true
            break
        case 3:
            Schedule.isHidden = true
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = false
            break
        default:
            Schedule.isHidden = false
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = true
            break
        }
    }
}
