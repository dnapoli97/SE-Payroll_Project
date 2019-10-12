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
        test.text = empsInfo![component].homeAddress
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if managedObjectContext == nil{
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        Schedule.isHidden = false
        WorkTimes.isHidden = true
        ApprovePay.isHidden = true
        Wages.isHidden = true
        newEmployee.isHidden = true
        
        picker.dataSource = self
        picker.delegate = self
        
        
        empNames = []
        empsInfo = []
        emps = []
        empssch = []
        empspay = []
    }
    
    @IBOutlet weak var newEmployee: UIView!
    @IBOutlet weak var Schedule: UIView!
    @IBOutlet weak var WorkTimes: UIView!
    @IBOutlet weak var ApprovePay: UIView!
    @IBOutlet weak var Wages: UIView!
    @IBOutlet weak var tabBar: UISegmentedControl!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var test: UILabel!
    
    @IBAction func indexChanged(_ sender: Any) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            Schedule.isHidden = false
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = true
            newEmployee.isHidden = true
            break
        case 1:
            Schedule.isHidden = true
            WorkTimes.isHidden = false
            ApprovePay.isHidden = true
            Wages.isHidden = true
            newEmployee.isHidden = true
            break
        case 2:
            Schedule.isHidden = true
            WorkTimes.isHidden = true
            ApprovePay.isHidden = false
            Wages.isHidden = true
            newEmployee.isHidden = true
            break
        case 3:
            Schedule.isHidden = true
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = false
            newEmployee.isHidden = true
            break
        case 4:
            Schedule.isHidden = true
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = true
            newEmployee.isHidden = false
            break
        default:
            Schedule.isHidden = false
            WorkTimes.isHidden = true
            ApprovePay.isHidden = true
            Wages.isHidden = true
            break
        }
    }
    
    
    func ScheduleViewload(){
        
    }

    @IBAction func topersonal(_ sender: Any) {
        self.performSegue(withIdentifier: "personal", sender: self)
    }
    
    
    
    
}
