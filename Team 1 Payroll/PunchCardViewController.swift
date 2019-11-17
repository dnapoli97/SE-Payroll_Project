//
//  PunchCardViewController.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 10/16/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import UIKit
import CoreData

class PunchCardViewController: UIViewController {

    var currentLogin: Employee!
    var firstLaunch: FirstLaunch!
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var clockInButton: UIButton!
    @IBOutlet weak var clockOutButton: UIButton!
    
    @IBAction func clockInPressed(_ sender: Any) {
        currentLogin.pay!.clockIn = Date.init()
        do{
            try managedObjectContext.save()
        }catch{
            print(error)
        }
    }
    
    @IBAction func clockOutPressed(_ sender: Any) {
        currentLogin.pay!.clockOut = Date.init()
        do{
            try managedObjectContext.save()
        }catch{
            print(error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
