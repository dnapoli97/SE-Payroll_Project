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
    var firstLaunch: FirstLaunch!
    var defaultDate: Date!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manager" {
            let nextViewController = segue.destination as! OverviewViewController
            nextViewController.currentLogin = currentLogin
            nextViewController.managedObjectContext = managedObjectContext
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
        
        personal_Info.isHidden = true
        payStub.isHidden = true
        temp.isHidden = true
        nextMonday.isUserInteractionEnabled = false
        nextTuesday.isUserInteractionEnabled = false
        nextWednesday.isUserInteractionEnabled = false
        nextThursday.isUserInteractionEnabled = false
        nextFriday.isUserInteractionEnabled = false
        nextSaturday.isUserInteractionEnabled = false
        nextSunday.isUserInteractionEnabled = false
        currentMonday.isUserInteractionEnabled = false
        currentTuesday.isUserInteractionEnabled = false
        currentWednesday.isUserInteractionEnabled = false
        currentThursday.isUserInteractionEnabled = false
        currentFriday.isUserInteractionEnabled = false
        currentSaturday.isUserInteractionEnabled = false
        currentSunday.isUserInteractionEnabled = false
        rHours.isUserInteractionEnabled = false
        rRate.isUserInteractionEnabled = false
        rPay.isUserInteractionEnabled = false
        oHours.isUserInteractionEnabled = false
        oRate.isUserInteractionEnabled = false
        oPay.isUserInteractionEnabled = false
        tHours.isUserInteractionEnabled = false
        tPay.isUserInteractionEnabled = false
        fedTax.isUserInteractionEnabled = false
        stateTax.isUserInteractionEnabled = false
        medicareTax.isUserInteractionEnabled = false
        socialSecurityTax.isUserInteractionEnabled = false
        gPay.isUserInteractionEnabled = false
        
        nextWeek.isHidden = true
        
        if managedObjectContext == nil{
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        if !currentLogin.ismanager {
            managerViewButton.isHidden = true
        }
        
        displaySchedule()
        displayPayStub()
        displayPersonalInfo()
        
    }
    
    @IBOutlet weak var schedule: UIView!
    @IBOutlet weak var personal_Info: UIView!
    @IBOutlet weak var payStub: UIView!
    @IBOutlet weak var temp: UIView!
    @IBOutlet weak var tabBar: UISegmentedControl!
    @IBOutlet weak var managerViewButton: UIButton!
    
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - Toggle Views
    
    @IBAction func indexChange(_ sender: Any) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            schedule.isHidden = false
            personal_Info.isHidden = true
            payStub.isHidden = true
            temp.isHidden = true
            nextMonday.isUserInteractionEnabled = false
            nextTuesday.isUserInteractionEnabled = false
            nextWednesday.isUserInteractionEnabled = false
            nextThursday.isUserInteractionEnabled = false
            nextFriday.isUserInteractionEnabled = false
            nextSaturday.isUserInteractionEnabled = false
            nextSunday.isUserInteractionEnabled = false
            currentMonday.isUserInteractionEnabled = false
            currentTuesday.isUserInteractionEnabled = false
            currentWednesday.isUserInteractionEnabled = false
            currentThursday.isUserInteractionEnabled = false
            currentFriday.isUserInteractionEnabled = false
            currentSaturday.isUserInteractionEnabled = false
            currentSunday.isUserInteractionEnabled = false
            displaySchedule()
            break
        case 1:
            schedule.isHidden = true
            personal_Info.isHidden = false
            payStub.isHidden = true
            temp.isHidden = true
            fname.isUserInteractionEnabled = false
            lname.isUserInteractionEnabled = false
            address.isUserInteractionEnabled = false
            phone.isUserInteractionEnabled = false
            married.isUserInteractionEnabled = false
            personalSave.isHidden = true
            break
        case 2:
            schedule.isHidden = true
            personal_Info.isHidden = true
            payStub.isHidden = false
            temp.isHidden = true
            displayPayStub()
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
    
    // MARK: - Pay Stub
    
    @IBOutlet weak var rHours: UITextField!
    @IBOutlet weak var rRate: UITextField!
    @IBOutlet weak var rPay: UITextField!
    @IBOutlet weak var oHours: UITextField!
    @IBOutlet weak var oRate: UITextField!
    @IBOutlet weak var oPay: UITextField!
    @IBOutlet weak var tHours: UITextField!
    @IBOutlet weak var tPay: UITextField!
    @IBOutlet weak var fedTax: UITextField!
    @IBOutlet weak var stateTax: UITextField!
    @IBOutlet weak var medicareTax: UITextField!
    @IBOutlet weak var socialSecurityTax: UITextField!
    @IBOutlet weak var gPay: UITextField!
    
    func calcFedIncomeTax(grossPay: Float) -> Float{
        var tax: Float
        if currentLogin.info!.married  {
            if grossPay < 588 {
                tax = grossPay - 222
                tax = tax * 0.1
            }else if grossPay < 1788 {
                tax = grossPay - 283
                tax = tax * 0.12
            }else if grossPay < 3395 {
                tax = grossPay - 932.09
                tax = tax * 0.22
            }else if grossPay < 6280 {
                tax = grossPay - 1137.33
                tax = tax * 0.24
            }else if grossPay < 7914 {
                tax = grossPay - 2423
                tax = tax * 0.32
            }else if grossPay < 11761 {
                tax = grossPay - 2893.66
                tax = tax * 0.35
            }else {
                tax = grossPay - 3372.97
                tax = tax * 0.37
            }
        }else {
            if grossPay < 254 {
                tax = grossPay - 71
                tax = tax * 0.1
            }else if grossPay < 815 {
                tax = grossPay - 101.5
                tax = tax * 0.12
            }else if grossPay < 1658 {
                tax = grossPay - 425.82
                tax = tax * 0.22
            }else if grossPay < 3100 {
                tax = grossPay - 528.50
                tax = tax * 0.24
            }else if grossPay < 3917 {
                tax = grossPay - 1171.38
                tax = tax * 0.32
            }else if grossPay < 9687{
                tax = grossPay - 1406.71
                tax = tax * 0.35
            }else {
                tax = grossPay - 1854.30
                tax = tax * 0.37
            }
        
        }
        if tax > 0{
            return tax
        }
        return 0
    }
    
    func calcSocialTax(grossPay: Float) -> Float{
        return grossPay * 0.062
    }
    
    func calcMedicareTax(grossPay: Float) -> Float{
        return grossPay * 0.0145
    }
    
    func calcStateIncomeTax(grossPay: Float) -> Float{
        var tax: Float
        if grossPay*52 < 2970 {
            tax = 0
        }else if grossPay*52 < 5940 {
            tax = grossPay * 0.03
        }else if grossPay*52 < 8910 {
            tax = grossPay * 0.04
        }else if grossPay*52 < 11880 {
            tax = grossPay * 0.05
        }else if grossPay*52 < 14860 {
            tax = grossPay * 0.06
        }else {
            tax = grossPay * 0.07
        }
        return tax
    }
    
    func displayPayStub(){
        let pay = currentLogin.pay!
        var time: Double!
        if (pay.clockOut!) != (defaultDate!) {
            time = ((pay.time + Double (pay.clockOut!.timeIntervalSince(pay.clockIn!))) / 3600)
        } else if pay.clockIn! != defaultDate!{
            let tempdate = Date.init()
            time = ((pay.time + Double (tempdate.timeIntervalSince(pay.clockIn!))) / 3600)
        }else{
            time = ((pay.time + Double (pay.clockOut!.timeIntervalSince(pay.clockIn!))) / 3600)
        }
        let grossPay: Float
        tHours.text = String(format: "%.2f", time)
        if time <= 40 {
            rHours.text = String(format: "%.2f", time)
            rPay.text = String(format: "%.2f", pay.wage * Float(time))
            grossPay = pay.wage * Float(time)
            tPay.text = String(format: "%.2f" , grossPay)
            oPay.text = ""
            oHours.text = ""
            oRate.text = ""
        }else {
            rHours.text = "40.00"
            oHours.text = String(format: "%.2f", time - 40)
            oRate.text = String(format: "%.2f", pay.wage * 1.5)
            rPay.text = String(format: "%.2f", pay.wage * 40)
            oPay.text = String(format: "%.2f", (pay.wage * 1.5) * Float(time - 40))
            grossPay = pay.wage * 40 + ((pay.wage * 1.5) * Float(time - 40))
            tPay.text = String(format: "%.2f" , grossPay)
        }
        rRate.text = String(format: "%.2f", pay.wage)
        let fTax = calcFedIncomeTax(grossPay: grossPay)
        let sTax = calcStateIncomeTax(grossPay: grossPay)
        let mTax = calcMedicareTax(grossPay: grossPay)
        let ssTax = calcSocialTax(grossPay: grossPay)
        fedTax.text = String(format: "%.2f", fTax)
        stateTax.text = String(format: "%.2f", sTax)
        medicareTax.text = String(format: "%.2f", mTax)
        socialSecurityTax.text = String(format: "%.2f", ssTax)
        gPay.text = String(format: "%.2f", (grossPay - fTax - sTax - mTax - ssTax))
        
    }
    
    // MARK: - Schedule
    
    @IBOutlet weak var weekSelect: UISegmentedControl!
    @IBOutlet weak var currentWeek: UIView!
    @IBOutlet weak var nextWeek: UIView!
    @IBOutlet weak var currentMonday: UITextField!
    @IBOutlet weak var currentTuesday: UITextField!
    @IBOutlet weak var currentWednesday: UITextField!
    @IBOutlet weak var currentThursday: UITextField!
    @IBOutlet weak var currentFriday: UITextField!
    @IBOutlet weak var currentSaturday: UITextField!
    @IBOutlet weak var currentSunday: UITextField!
    @IBOutlet weak var nextMonday: UITextField!
    @IBOutlet weak var nextTuesday: UITextField!
    @IBOutlet weak var nextWednesday: UITextField!
    @IBOutlet weak var nextThursday: UITextField!
    @IBOutlet weak var nextFriday: UITextField!
    @IBOutlet weak var nextSaturday: UITextField!
    @IBOutlet weak var nextSunday: UITextField!
    
    func displaySchedule(){
        currentMonday.text = currentLogin.schedule!.day0
        currentTuesday.text = currentLogin.schedule!.day1
        currentWednesday.text = currentLogin.schedule!.day2
        currentThursday.text = currentLogin.schedule!.day3
        currentFriday.text = currentLogin.schedule!.day4
        currentSaturday.text = currentLogin.schedule!.day5
        currentSunday.text = currentLogin.schedule!.day6
        nextMonday.text = currentLogin.schedule!.day7
        nextTuesday.text = currentLogin.schedule!.day8
        nextWednesday.text = currentLogin.schedule!.day9
        nextThursday.text = currentLogin.schedule!.day10
        nextFriday.text = currentLogin.schedule!.day11
        nextSaturday.text = currentLogin.schedule!.day12
        nextSunday.text = currentLogin.schedule!.day13
    }
    
    @IBAction func weekChange(_ sender: Any) {
        switch weekSelect.selectedSegmentIndex {
        case 0:
            currentWeek.isHidden = false
            nextWeek.isHidden = true
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
            nextMonday.isUserInteractionEnabled = false
            nextTuesday.isUserInteractionEnabled = false
            nextWednesday.isUserInteractionEnabled = false
            nextThursday.isUserInteractionEnabled = false
            nextFriday.isUserInteractionEnabled = false
            nextSaturday.isUserInteractionEnabled = false
            nextSunday.isUserInteractionEnabled = false
            break
        default:
            currentWeek.isHidden = false
            nextWeek.isHidden = true
            nextMonday.isUserInteractionEnabled = false
            nextTuesday.isUserInteractionEnabled = false
            nextWednesday.isUserInteractionEnabled = false
            nextThursday.isUserInteractionEnabled = false
            nextFriday.isUserInteractionEnabled = false
            nextSaturday.isUserInteractionEnabled = false
            nextSunday.isUserInteractionEnabled = false
            currentMonday.isUserInteractionEnabled = false
            currentTuesday.isUserInteractionEnabled = false
            currentWednesday.isUserInteractionEnabled = false
            currentThursday.isUserInteractionEnabled = false
            currentFriday.isUserInteractionEnabled = false
            currentSaturday.isUserInteractionEnabled = false
            currentSunday.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Personal Info
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var married: UISwitch!
    @IBOutlet weak var personalEdit: UIButton!
    @IBOutlet weak var personalSave: UIButton!
    
    func displayPersonalInfo(){
        fname.text = currentLogin.info!.firstName!
        lname.text = currentLogin.info!.lastName!
        address.text = currentLogin.info!.homeAddress!
        phone.text = String(currentLogin.info!.phoneNumber)
        married.setOn(currentLogin.info!.married, animated: false)
    }
    
    @IBAction func personalEditPress(_ sender: Any) {
        fname.isUserInteractionEnabled = true
        lname.isUserInteractionEnabled = true
        address.isUserInteractionEnabled = true
        phone.isUserInteractionEnabled = true
        married.isUserInteractionEnabled = true
        personalEdit.isHidden = true
        personalSave.isHidden = false
    }
    
    @IBAction func personalSavePress(_ sender: Any) {
        do{
            currentLogin.info!.setValue(fname.text!, forKey: "firstName")
            currentLogin.info!.setValue(lname.text!, forKey: "lastName")
            currentLogin.info!.setValue(address.text!, forKey: "homeAddress")
            if phone.text! != ""{
                currentLogin.info!.setValue(Int64(phone.text!), forKey: "phoneNumber")
            }
            currentLogin.info!.setValue(married.isOn, forKey: "married")
            try managedObjectContext.save()
        }catch{
            print(error)
        }
        
        personalSave.isHidden = true
        personalEdit.isHidden = false
        displayPersonalInfo()
    }
    
    
}
