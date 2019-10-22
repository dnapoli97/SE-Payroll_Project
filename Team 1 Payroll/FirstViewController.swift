//
//  FirstViewController.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 9/18/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import UIKit
import SQLite
import CoreData

class FirstViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var currentLogin: Employee!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOverview" {
            let nextViewController = segue.destination as! OverviewViewController
            nextViewController.currentLogin = currentLogin
               }
        if segue.identifier == "toPersonal" {
            let nextViewController = segue.destination as! personalViewController
            nextViewController.currentLogin = currentLogin
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            var adminInDb = false
            for result in results{
                if "admin" == result.username{
                    adminInDb = true
                }
            }
            if !adminInDb {
                guard let entityDescription = NSEntityDescription.entity(forEntityName: "Employee", in: managedObjectContext) else {
                    return
                }
                guard let entityDescriptionInfo = NSEntityDescription.entity(forEntityName: "Employee_Info", in: managedObjectContext) else {
                                   return
                               }
                    let newValueInfo = Employee_Info(entity: entityDescriptionInfo, insertInto: managedObjectContext)
                
                    guard let entityDescriptionSchedule = NSEntityDescription.entity(forEntityName: "Schedule", in: managedObjectContext) else {
                                   return
                               }
                    let newValueSchedule = Schedule(entity: entityDescriptionSchedule, insertInto: managedObjectContext)
                
                    guard let entityDescriptionPay =   NSEntityDescription.entity(forEntityName: "Pay", in: managedObjectContext) else {
                                   return
                               }
                    let newValuePay = Pay(entity: entityDescriptionPay, insertInto: managedObjectContext)
                
                let newValue = Employee(entity: entityDescription, insertInto: managedObjectContext)
                
                newValue.setValue("admin", forKey: "username")
                newValue.setValue("admin", forKey: "password")
                newValue.setValue(0, forKey: "id")
                newValue.setValue(true, forKey: "ismanager")
                newValueInfo.setValue("admin", forKey: "firstName")
                newValueInfo.setValue("admin", forKey: "lastName")
                newValueInfo.setValue("123 admin st", forKey: "homeAddress")
                newValuePay.setValue(10.00, forKey: "wage")
                newValue.setValue(newValueInfo, forKey: "info")
                newValue.setValue(newValueSchedule, forKey: "schedule")
                newValue.setValue(newValuePay, forKey: "pay")
                
                do{
                    try managedObjectContext.save()
                }catch{
                    print("Saving Error")
                }
            }
        }catch{
            print(error)
        }
    }
    
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var tabBar: UITabBarItem!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var invalidLogin: UILabel!
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if checkLogin{
            username.text = nil
            password.text = nil
            invalidLogin.isHidden = true
            if currentLogin.ismanager{
                self.performSegue(withIdentifier: "toOverview", sender: self)
            }else{
                self.performSegue(withIdentifier: "toPersonal", sender: self)
            }
        }
    }
    
    
    
}

extension FirstViewController{
    func save(value: String, key: String){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Employee", in: context) else {
                return
            }
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            
            newValue.setValue(value, forKey: key)
            do{
                try context.save()
                print("Saved: true")
            }catch{
                print("Saving Error")
            }
        }
    }
    
    func retrieveValue(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try context.fetch(fetchRequest)
                for result in results{
                    if let testValue = result.accessibilityElements{
                        print(testValue.description)
                    }
                }
            }catch{
                print("Could not retrieve")
            }
        }
    }
    
    var checkLogin: Bool {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
            let user = username.text
            let pass = password.text
            do{
                let results = try context.fetch(fetchRequest)
                for result in results{
                    if user == result.username{
                        if pass == result.password{
                            currentLogin = result
                            return true
                        }
                    }
                }
                invalidLogin.isHidden = false
            }catch{
                print(error)
            }
        }
        return false
    }
}

