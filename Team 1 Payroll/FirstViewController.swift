//
//  FirstViewController.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 9/18/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//  Code reviewed by Evan Scruggs 11/17/19

import UIKit
import SQLite
import CoreData

class FirstViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var currentLogin: Employee!
    var defaultDate: Date!
    var firstLaunch: FirstLaunch!
    
    // assigns values to the next view controller so the same instance of the variables are accessed
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOverview" {
            let nextViewController = segue.destination as! OverviewViewController
            nextViewController.currentLogin = currentLogin
            nextViewController.firstLaunch = firstLaunch
            nextViewController.defaultDate = defaultDate
        }
        if segue.identifier == "toPersonal" {
            let nextViewController = segue.destination as! personalViewController
            nextViewController.currentLogin = currentLogin
            nextViewController.firstLaunch = firstLaunch
            nextViewController.defaultDate = defaultDate
        }
    }
    
    // closes the keyboard that opens when typing in a text box by touching anywhere on the screen outside of the keyboard
    
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
        
        let cal = Calendar.current
        
        let defaultcomps = DateComponents.init(calendar: cal, year: 2000, month: 1, day: 1, hour: 0, minute: 1)
        defaultDate = cal.date(from: defaultcomps)
        // first launch is a final class that is connected to user default so that it only runs on first launch and the varaibles are not manipulated again
        
        firstLaunch = FirstLaunch(userDefaults: .standard, key: "com.any-suggestion.FirstLaunch.WasLaunchedBefore")
        
        // if it is the first launch then Admin is created in the DB and a default date is set based off the default date assigned to admin
        
        if firstLaunch.isFirstLaunch {
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
            
            let calendar = Calendar.current
            let defaultcomps = DateComponents(calendar: calendar, year: 2000, month: 1, day: 1, hour: 0, minute: 1)
            defaultDate = calendar.date(from: defaultcomps)
            
            let userdefault = firstLaunch.getUserDefault
            
            userdefault.setValue(defaultDate, forKey: "defaultDate")
            
        }
        
    }
    
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var invalidLogin: UILabel!
    
    // func accessed by pressing the login button that calls checkLogin to check the DB for the username and matching password
    
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

// utility save func *currrently not used

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
            }catch{
                print("Saving Error")
            }
        }
    }
    
    // utility retrieve value func used for testing * currently not used
    
    func retrieveValue(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try context.fetch(fetchRequest)
                for result in results{
                    if result.info?.firstName == "admin"{
                        currentLogin = result
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

