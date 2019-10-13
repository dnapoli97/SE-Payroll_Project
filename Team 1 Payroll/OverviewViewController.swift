//
//  OverviewViewController.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 10/1/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import UIKit
import CoreData

class OverviewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var currentLogin: Employee!
    var managedObjectContext: NSManagedObjectContext!
    var empNames: [String]!
    var emps:[Employee]!
    var empsInfo:[Employee_Info]!
    var empssch:[Schedule]!
    var empspay:[Pay]!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "personal" {
            let nextViewController = segue.destination as! personalViewController
            nextViewController.currentLogin = currentLogin
            nextViewController.managedObjectContext = managedObjectContext
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if let empinfo = result.info{
                        if let first = empinfo.firstName{
                            if let last = empinfo.lastName{
                                let name = last + ", " + first
                                empNames.append(name)
                                if let empsch = result.schedule{
                                    empssch.append(empsch)
                                }
                                if let emppay = result.pay{
                                    empspay.append(emppay)
                                }
                                empsInfo.append(empinfo)
                                emps.append(result)
                            }
                        }
                    }
                }
                return results.count
            }catch{
                print(Error.self)
        }
    return 0
}
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return empNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        test.text = emps![row].password
    
    
    
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if managedObjectContext == nil{
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        ScheduleView.isHidden = false
        WorkTimes.isHidden = true
        ApprovePay.isHidden = true
        Wages.isHidden = true
        newEmployee.isHidden = true
        passwordDontMatch.isHidden = true
        
        picker.dataSource = self
        picker.delegate = self
        
        
        empNames = []
        empsInfo = []
        emps = []
        empssch = []
        empspay = []
    }
    
    @IBOutlet weak var newEmployee: UIView!
    @IBOutlet weak var ScheduleView: UIView!
    @IBOutlet weak var WorkTimes: UIView!
    @IBOutlet weak var ApprovePay: UIView!
    @IBOutlet weak var Wages: UIView!
    @IBOutlet weak var tabBar: UISegmentedControl!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var test: UILabel!
    
    @IBAction func indexChanged(_ sender: Any) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            ScheduleView.isHidden = false
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = true
            newEmployee.isHidden = true
            break
        case 1:
            ScheduleView.isHidden = true
            WorkTimes.isHidden = false
            ApprovePay.isHidden = true
            Wages.isHidden = true
            newEmployee.isHidden = true
            break
        case 2:
            ScheduleView.isHidden = true
            WorkTimes.isHidden = true
            ApprovePay.isHidden = false
            Wages.isHidden = true
            newEmployee.isHidden = true
            break
        case 3:
            ScheduleView.isHidden = true
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = false
            newEmployee.isHidden = true
            break
        case 4:
            ScheduleView.isHidden = true
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = true
            newEmployee.isHidden = false
            break
        default:
            ScheduleView.isHidden = false
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = true
            newEmployee.isHidden = true
            break
        }
    }
    
    
    

    @IBAction func topersonal(_ sender: Any) {
        self.performSegue(withIdentifier: "personal", sender: self)
    }
    
    @IBAction func returnToMan(_ unwindSegue: UIStoryboardSegue) {}
    
    @IBOutlet weak var newFname: UITextField!
    @IBOutlet weak var newLname: UITextField!
    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newConfirm: UITextField!
    @IBOutlet weak var newPhone: UITextField!
    @IBOutlet weak var newAddress: UITextField!
    @IBOutlet weak var newManager: UISwitch!
    @IBOutlet weak var newWage: UITextField!
    @IBOutlet weak var passwordDontMatch: UILabel!
    
    
    @IBAction func confirmNewEmployee(_ sender: Any) {
        
        if (newFname.text == "" || newLname.text == "" || newUsername.text == "" || newPassword.text == "" || newConfirm.text == "" || newAddress.text == "" || newWage.text == "" || newPassword.text != newConfirm.text){
            
            if newPassword.text != newConfirm.text {
                newPassword.text = ""
                newConfirm.text = ""
                passwordDontMatch.isHidden = false
            }
            
        }else{
        
            guard let entityDescriptionEmp = NSEntityDescription.entity(forEntityName: "Employee", in: managedObjectContext) else {
                               return
                           }
            let newValueEmp = Employee(entity: entityDescriptionEmp, insertInto: managedObjectContext)
            
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
            
            newValueEmp.setValue(emps.count, forKey: "id")
            newValueEmp.setValue(newManager.isOn, forKey: "ismanager")
            newValueEmp.setValue(newUsername.text, forKey: "username")
            newValueEmp.setValue(newPassword.text, forKey: "password")
            newValueInfo.setValue(newFname.text, forKey: "firstName")
            newValueInfo.setValue(newLname.text, forKey: "lastName")
            newValueInfo.setValue(newAddress.text, forKey: "homeAddress")
            if newPhone.text != "" {
                newValueInfo.setValue(Int64(newPhone.text!), forKey: "phoneNumber")
            }
            
            newValuePay.setValue(Float(newWage.text!), forKey: "wage")
            newValueEmp.setValue(newValueInfo, forKey: "info")
            newValueEmp.setValue(newValueSchedule, forKey: "schedule")
            newValueEmp.setValue(newValuePay, forKey: "pay")
            do{
                try managedObjectContext.save()
                print("Saved: true")
            }catch{
                print(error)
            }
            
            newFname.text = ""
            newLname.text = ""
            newUsername.text = ""
            newPassword.text = ""
            newConfirm.text = ""
            newPhone.text = ""
            newAddress.text = ""
            newManager.setOn(false, animated: false)
            newWage.text = ""
            passwordDontMatch.isHidden = true
        }
    }
    
}
