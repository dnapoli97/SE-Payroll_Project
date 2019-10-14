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
    
    var currentLogin: Employee!
    var empInfo: Employee_Info!
    var empSchedule: Schedule!
    var empPay: Pay!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manager" {
            let nextViewController = segue.destination as! OverviewViewController
            nextViewController.currentLogin = currentLogin
            nextViewController.managedObjectContext = managedObjectContext
               }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personal_Info.isHidden = true
        payStub.isHidden = true
        temp.isHidden = true
        
        if managedObjectContext == nil{
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        if !currentLogin.ismanager {
            managerViewButton.isHidden = true
        }
        
    }
    
    @IBOutlet weak var schedule: UIView!
    @IBOutlet weak var personal_Info: UIView!
    @IBOutlet weak var payStub: UIView!
    @IBOutlet weak var temp: UIView!
    @IBOutlet weak var tabBar: UISegmentedControl!
    @IBOutlet weak var managerViewButton: UIButton!
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBAction func indexChange(_ sender: Any) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            schedule.isHidden = false
            personal_Info.isHidden = true
            payStub.isHidden = true
            temp.isHidden = true
            break
        case 1:
            schedule.isHidden = true
            personal_Info.isHidden = false
            payStub.isHidden = true
            temp.isHidden = true
            break
        case 2:
            schedule.isHidden = true
            personal_Info.isHidden = true
            payStub.isHidden = false
            temp.isHidden = true
            break
        case 3:
            schedule.isHidden = true
            personal_Info.isHidden = true
            payStub.isHidden = true
            temp.isHidden = false
            break
        default:
            schedule.isHidden = false
            personal_Info.isHidden = true
            payStub.isHidden = true
            temp.isHidden = true
            break
        }
    }
}

extension personalViewController{
    func changeInfo(){
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            for result in results{
                if "admin" == result.username{
                    guard let entityDescriptionInfo = NSEntityDescription.entity(forEntityName: "Employee_Info", in: managedObjectContext) else {
                        return
                    }
                     let newValueInfo = Employee_Info(entity: entityDescriptionInfo, insertInto: managedObjectContext)
                    guard let entityDescriptionSchedule = NSEntityDescription.entity(forEntityName: "Schedule", in: managedObjectContext) else {
                        return
                    }
                     let newValueSchedule = Schedule(entity: entityDescriptionSchedule, insertInto: managedObjectContext)
                    guard let entityDescriptionPay = NSEntityDescription.entity(forEntityName: "Pay", in: managedObjectContext) else {
                        return
                    }
                     let newValuePay = Pay(entity: entityDescriptionPay, insertInto: managedObjectContext)
                    result.setValue(0, forKey: "id")
                    result.setValue(true, forKey: "ismanager")
                    newValueInfo.setValue("admin", forKey: "firstName")
                    newValueInfo.setValue("admin", forKey: "lastName")
                    newValueInfo.setValue("123 Peach Rd", forKey: "homeAddress")
                    newValueInfo.setValue(5555555555, forKey: "phoneNumber")
                    newValuePay.setValue(15.50, forKey: "wage")
                    newValueSchedule.setValue("4:00-9:00", forKey: "day0")
                    newValueSchedule.setValue("3:30-9:00", forKey: "day1")
                    newValueSchedule.setValue("11:00-4:00", forKey: "day2")
                    newValueSchedule.setValue("4:00-9:00", forKey: "day3")
                    newValueSchedule.setValue("3:30-9:00", forKey: "day4")
                    newValueSchedule.setValue("11:00-4:00", forKey: "day5")
                    newValueSchedule.setValue("4:00-9:00", forKey: "day7")
                    newValueSchedule.setValue("3:30-9:00", forKey: "day8")
                    newValueSchedule.setValue("11:00-4:00", forKey: "day9")
                    newValueSchedule.setValue("4:00-9:00", forKey: "day10")
                    newValueSchedule.setValue("3:30-9:00", forKey: "day11")
                    newValueSchedule.setValue("11:00-4:00", forKey: "day12")
                    result.setValue(newValueInfo, forKey: "info")
                    result.setValue(newValueSchedule, forKey: "schedule")
                    result.setValue(newValuePay, forKey: "pay")
                    do{
                        try managedObjectContext.save()
                        print("Saved: true")
                    }catch{
                        print("Saving Error")
                    }
                }
            }
        }catch{
            print(error.self)
        }
    }
    
}
