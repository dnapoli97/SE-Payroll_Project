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
    var currentLogin: Employee!
    var firstLaunch: FirstLaunch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "punchIn" {
        let nextViewController = segue.destination as! PunchCardViewController
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
        
        invalidLogin.isHidden = true
        
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var invalidLogin: UILabel!
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if checkLogin{
            invalidLogin.isHidden = true
            self.performSegue(withIdentifier: "punchIn", sender: self)
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

