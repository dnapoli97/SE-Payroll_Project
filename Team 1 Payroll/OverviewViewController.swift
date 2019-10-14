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
    var empsUsername: [String]!
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
        usernameTaken.isHidden = true
        followingSave.isHidden = true
        nextSave.isHidden = true
        nextWeek.isHidden = true
        followingWeek.isHidden = true
        
        pickerSchedule.dataSource = self
        pickerSchedule.delegate = self
        
        
        empNames = []
        empsInfo = []
        emps = []
        empssch = []
        empspay = []
        empsUsername = []
    }
    
    @IBOutlet weak var newEmployee: UIView!
    @IBOutlet weak var ScheduleView: UIView!
    @IBOutlet weak var WorkTimes: UIView!
    @IBOutlet weak var ApprovePay: UIView!
    @IBOutlet weak var Wages: UIView!
    @IBOutlet weak var tabBar: UISegmentedControl!
    
    // MARK: - Toggle Views
    
    @IBAction func indexChanged(_ sender: Any) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            ScheduleView.isHidden = false
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = true
            newEmployee.isHidden = true
            pickerSchedule.reloadAllComponents()
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
    
    // MARK: - Adding new Employee
    
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
    @IBOutlet weak var usernameTaken: UILabel!
    
    
    @IBAction func confirmNewEmployee(_ sender: Any) {
        
        if (newFname.text == "" || newLname.text == "" || newUsername.text == "" || newPassword.text == "" || newConfirm.text == "" || newAddress.text == "" || newWage.text == "" || newPassword.text != newConfirm.text){
            
            if newPassword.text != newConfirm.text {
                newPassword.text = ""
                newConfirm.text = ""
                passwordDontMatch.isHidden = false
            }
            
        }else{
            if !empsUsername.contains(newUsername.text!){
                
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
            
                guard let entityDescriptionPay =   NSEntityDescription.entity(forEntityName: "Pay", in: managedObjectContext) else {
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
                usernameTaken.isHidden = true
            }else{
                usernameTaken.isHidden = false
            }
        }
    }
    
    // MARK: - Edit Schedule
    
    @IBOutlet weak var weekSelect: UISegmentedControl!
    @IBOutlet weak var pickerSchedule: UIPickerView!
    @IBOutlet weak var currentWeek: UIView!
    @IBOutlet weak var nextWeek: UIView!
    @IBOutlet weak var followingWeek: UIView!
    @IBOutlet weak var currentMonday: UITextField!
    @IBOutlet weak var currentTuesday: UITextField!
    @IBOutlet weak var currentWednesday: UITextField!
    @IBOutlet weak var currentThursday: UITextField!
    @IBOutlet weak var currentFriday: UITextField!
    @IBOutlet weak var currentSaturday: UITextField!
    @IBOutlet weak var currentSunday: UITextField!
    @IBOutlet weak var currentEdit: UIButton!
    @IBOutlet weak var currentSave: UIButton!
    @IBOutlet weak var nextMonday: UITextField!
    @IBOutlet weak var nextTuesday: UITextField!
    @IBOutlet weak var nextWednesday: UITextField!
    @IBOutlet weak var nextThursday: UITextField!
    @IBOutlet weak var nextFriday: UITextField!
    @IBOutlet weak var nextSaturday: UITextField!
    @IBOutlet weak var nextSunday: UITextField!
    @IBOutlet weak var nextEdit: UIButton!
    @IBOutlet weak var nextSave: UIButton!
    @IBOutlet weak var followingMonday: UITextField!
    @IBOutlet weak var followingTuesday: UITextField!
    @IBOutlet weak var followingWednesday: UITextField!
    @IBOutlet weak var followingThursday: UITextField!
    @IBOutlet weak var followingFriday: UITextField!
    @IBOutlet weak var followingSaturday: UITextField!
    @IBOutlet weak var followingSunday: UITextField!
    @IBOutlet weak var followingEdit: UIButton!
    @IBOutlet weak var followingSave: UIButton!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
             let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                do{
                    let results = try managedObjectContext.fetch(fetchRequest)
                    for result in results{
                        empsUsername.append(result.username!)
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
            currentMonday.text = empssch[row].day0
            currentTuesday.text = empssch[row].day1
            currentWednesday.text = empssch[row].day2
            currentThursday.text = empssch[row].day3
            currentFriday.text = empssch[row].day4
            currentSaturday.text = empssch[row].day5
            currentSunday.text = empssch[row].day6
            nextMonday.text = empssch[row].day7
            nextTuesday.text = empssch[row].day8
            nextWednesday.text = empssch[row].day9
            nextThursday.text = empssch[row].day10
            nextFriday.text = empssch[row].day11
            nextSaturday.text = empssch[row].day12
            nextSunday.text = empssch[row].day13
            followingMonday.text = empssch[row].day14
            followingTuesday.text = empssch[row].day15
            followingWednesday.text = empssch[row].day16
            followingThursday.text = empssch[row].day17
            followingFriday.text = empssch[row].day18
            followingSaturday.text = empssch[row].day19
            followingSunday.text = empssch[row].day20
            weekChange(pickerView.self)
        }
    
    @IBAction func weekChange(_ sender: Any) {
        switch weekSelect.selectedSegmentIndex {
        case 0:
            currentWeek.isHidden = false
            nextWeek.isHidden = true
            followingWeek.isHidden = true
            currentSave.isHidden = true
            currentMonday.isUserInteractionEnabled = false
            currentTuesday.isUserInteractionEnabled = false
            currentWednesday.isUserInteractionEnabled = false
            currentThursday.isUserInteractionEnabled = false
            currentFriday.isUserInteractionEnabled = false
            currentSaturday.isUserInteractionEnabled = false
            currentSunday.isUserInteractionEnabled = false
            break
        case 1:
            currentWeek.isHidden = true
            nextWeek.isHidden = false
            followingWeek.isHidden = true
            nextSave.isHidden = true
            nextMonday.isUserInteractionEnabled = false
            nextTuesday.isUserInteractionEnabled = false
            nextWednesday.isUserInteractionEnabled = false
            nextThursday.isUserInteractionEnabled = false
            nextFriday.isUserInteractionEnabled = false
            nextSaturday.isUserInteractionEnabled = false
            nextSunday.isUserInteractionEnabled = false
            break
        case 2:
            currentWeek.isHidden = true
            nextWeek.isHidden = true
            followingWeek.isHidden = false
            followingSave.isHidden = true
            followingMonday.isUserInteractionEnabled = false
            followingTuesday.isUserInteractionEnabled = false
            followingWednesday.isUserInteractionEnabled = false
            followingThursday.isUserInteractionEnabled = false
            followingFriday.isUserInteractionEnabled = false
            followingSaturday.isUserInteractionEnabled = false
            followingSunday.isUserInteractionEnabled = false
            break
        default:
            currentWeek.isHidden = false
            nextWeek.isHidden = true
            followingWeek.isHidden = true
        }
        
    }
    @IBAction func editFollowingPress(_ sender: Any) {
        followingMonday.isUserInteractionEnabled = true
        followingTuesday.isUserInteractionEnabled = true
        followingWednesday.isUserInteractionEnabled = true
        followingThursday.isUserInteractionEnabled = true
        followingFriday.isUserInteractionEnabled = true
        followingSaturday.isUserInteractionEnabled = true
        followingSunday.isUserInteractionEnabled = true
        followingSave.isHidden = false
    }
    
    @IBAction func saveFollowingPress(_ sender: Any) {
        let selectedemp = empssch[pickerSchedule.selectedRow(inComponent: 0)]
        if followingMonday.text == "" {
            followingMonday.text = "-"
        }
        if followingTuesday.text == "" {
            followingTuesday.text = "-"
        }
        if followingWednesday.text == "" {
            followingWednesday.text = "-"
        }
        if followingThursday.text == "" {
            followingThursday.text = "-"
        }
        if followingFriday.text == "" {
            followingFriday.text = "-"
        }
        if followingSaturday.text == "" {
            followingSaturday.text = "-"
        }
        if followingSunday.text == "" {
            followingSunday.text = "-"
        }
        
        selectedemp.setValue(followingMonday.text, forKey: "day14")
        selectedemp.setValue(followingTuesday.text, forKey: "day15")
        selectedemp.setValue(followingWednesday.text, forKey: "day16")
        selectedemp.setValue(followingThursday.text, forKey: "day17")
        selectedemp.setValue(followingFriday.text, forKey: "day18")
        selectedemp.setValue(followingSaturday.text, forKey: "day19")
        selectedemp.setValue(followingSunday.text, forKey: "day20")
        
        do{
            try managedObjectContext.save()
            followingMonday.isUserInteractionEnabled = false
            followingTuesday.isUserInteractionEnabled = false
            followingWednesday.isUserInteractionEnabled = false
            followingThursday.isUserInteractionEnabled = false
            followingFriday.isUserInteractionEnabled = false
            followingSaturday.isUserInteractionEnabled = false
            followingSunday.isUserInteractionEnabled = false
            followingSave.isHidden = true
        }catch{
            print(error)
        }
    }
    
    @IBAction func editNextPress(_ sender: Any) {
        nextMonday.isUserInteractionEnabled = true
        nextTuesday.isUserInteractionEnabled = true
        nextWednesday.isUserInteractionEnabled = true
        nextThursday.isUserInteractionEnabled = true
        nextFriday.isUserInteractionEnabled = true
        nextSaturday.isUserInteractionEnabled = true
        nextSunday.isUserInteractionEnabled = true
        nextSave.isHidden = false
    }
    
    @IBAction func saveNextPress(_ sender: Any) {
        let selectedemp = empssch[pickerSchedule.selectedRow(inComponent: 0)]
        if nextMonday.text == "" {
            nextMonday.text = "-"
        }
        if nextTuesday.text == "" {
            nextTuesday.text = "-"
        }
        if nextWednesday.text == "" {
            nextWednesday.text = "-"
        }
        if nextThursday.text == "" {
            nextThursday.text = "-"
        }
        if nextFriday.text == "" {
            nextFriday.text = "-"
        }
        if nextSaturday.text == "" {
            nextSaturday.text = "-"
        }
        if nextSunday.text == "" {
            nextSunday.text = "-"
        }
        
        selectedemp.setValue(nextMonday.text, forKey: "day7")
        selectedemp.setValue(nextTuesday.text, forKey: "day8")
        selectedemp.setValue(nextWednesday.text, forKey: "day9")
        selectedemp.setValue(nextThursday.text, forKey: "day10")
        selectedemp.setValue(nextFriday.text, forKey: "day11")
        selectedemp.setValue(nextSaturday.text, forKey: "day12")
        selectedemp.setValue(nextSunday.text, forKey: "day13")
        
        do{
            try managedObjectContext.save()
            nextMonday.isUserInteractionEnabled = false
            nextTuesday.isUserInteractionEnabled = false
            nextWednesday.isUserInteractionEnabled = false
            nextThursday.isUserInteractionEnabled = false
            nextFriday.isUserInteractionEnabled = false
            nextSaturday.isUserInteractionEnabled = false
            nextSunday.isUserInteractionEnabled = false
            nextSave.isHidden = true
        }catch{
            print(error)
        }
    }
    
    @IBAction func editCurrentPress(_ sender: Any) {
        currentMonday.isUserInteractionEnabled = true
        currentTuesday.isUserInteractionEnabled = true
        currentWednesday.isUserInteractionEnabled = true
        currentThursday.isUserInteractionEnabled = true
        currentFriday.isUserInteractionEnabled = true
        currentSaturday.isUserInteractionEnabled = true
        currentSunday.isUserInteractionEnabled = true
        currentSave.isHidden = false
    }
    
    @IBAction func saveCurrentPress(_ sender: Any) {
        let selectedemp = empssch[pickerSchedule.selectedRow(inComponent: 0)]
        if currentMonday.text == "" {
            currentMonday.text = "-"
        }
        if currentTuesday.text == "" {
            currentTuesday.text = "-"
        }
        if currentWednesday.text == "" {
            currentWednesday.text = "-"
        }
        if currentThursday.text == "" {
            currentThursday.text = "-"
        }
        if currentFriday.text == "" {
            currentFriday.text = "-"
        }
        if currentSaturday.text == "" {
            currentSaturday.text = "-"
        }
        if currentSunday.text == "" {
            currentSunday.text = "-"
        }
        
        selectedemp.setValue(currentMonday.text, forKey: "day0")
        selectedemp.setValue(currentTuesday.text, forKey: "day1")
        selectedemp.setValue(currentWednesday.text, forKey: "day2")
        selectedemp.setValue(currentThursday.text, forKey: "day3")
        selectedemp.setValue(currentFriday.text, forKey: "day4")
        selectedemp.setValue(currentSaturday.text, forKey: "day5")
        selectedemp.setValue(currentSunday.text, forKey: "day6")
        
        do{
            try managedObjectContext.save()
            currentMonday.isUserInteractionEnabled = false
            currentTuesday.isUserInteractionEnabled = false
            currentWednesday.isUserInteractionEnabled = false
            currentThursday.isUserInteractionEnabled = false
            currentFriday.isUserInteractionEnabled = false
            currentSaturday.isUserInteractionEnabled = false
            currentSunday.isUserInteractionEnabled = false
            currentSave.isHidden = true
        }catch{
            print(error)
        }
    }
    
    
    
    
}
