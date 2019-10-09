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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let nextVC = segue.destination as? OverviewViewController {
        nextVC.managedObjectContext = managedObjectContext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
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
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Employee_Info", in: context) else {
                return
            }
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            
            newValue.setValue(value, forKey: key)
            do{
                try context.save()
                print("Saved: \(value)")
            }catch{
                print("Saving Error")
            }
        }
    }
    
    func retrieveValue(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Employee_Info>(entityName: "Employee_Info")
        
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
            let fetchRequest = NSFetchRequest<Employee_Info>(entityName: "Employee_Info")
            let user = username.text
            let pass = password.text
            do{
                let results = try context.fetch(fetchRequest)
                for result in results{
                    print(result)
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

