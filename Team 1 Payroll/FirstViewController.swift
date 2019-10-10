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
                
                let newValue = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
                
                newValue.setValue("admin", forKey: "username")
                newValue.setValue("admin", forKey: "password")
                do{
                    try managedObjectContext.save()
                    print("Saved: true")
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
            self.performSegue(withIdentifier: "toOverview", sender: self)
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
                            return true
                        }else{
                            invalidLogin.isHidden = false
                            return false
                        }
                    }else{
                        invalidLogin.isHidden = false
                        return false
                    }
                }
            }catch{
                print(error)
            }
        }
        return false
    }
}

