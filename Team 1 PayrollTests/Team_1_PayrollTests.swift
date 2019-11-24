//
//  Team_1_PayrollTests.swift
//  Team 1 PayrollTests
//
//  Created by Dylan Napoli on 9/18/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//  Started on 11/

import CoreData
import XCTest
@testable import Team_1_Payroll


//This set of tests is going to go through all files ion the Team 1 Payroll folder that either takes parameters or returns value testable
class Team_1_PayrollTests: XCTestCase {

    var managedObjectContext: NSManagedObjectContext!
    var currentLogin: Employee!
    var currentInfo: Employee_Info!
    var currentPay: Pay!
    var currentSch: Schedule!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //this test is designed to fetch employees from the database to ensure that there exists an admin account
    func testAdminInDatabase() {
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                //This XCTest makes sure whatever the parameter is is equal to true, if not then it prints the String
                XCTAssertTrue(currentLogin.username == "admin", "System's database does not contain admin user")
                
            }catch{
                print("Could not retrieve")
            }
        
    }
    
    //This function is used for test the Fed Income Tax calculations. We compare math by hand to the function call with expected output
    func test_personalViewController_calcFedIncomeTax() {
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        var pay, tax: Float
        let p = Team_1_Payroll.personalViewController()
        
        //set the value of the current login as a married status
        p.currentLogin = currentLogin
        p.currentLogin.info?.married = true
        
        //testing condition where the value made is lower than normal bound to test outside if statement
        pay = 0
        tax = -71
        if tax > 0{
            
        }
        else{
            tax = 0
        }
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket ranging up to 588 (anything too low gets caught by outside if
        pay = 500
        tax = pay - 222
        tax = tax * 0.1
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 588 <= $ < 1788
        pay = 1700
        tax = pay - 283
        tax = tax * 0.12
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 1788 <= $ < 3395
        pay = 3300
        tax = pay - 932.09
        tax *= 0.22
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 3395 <= $ < 6280
        pay = 6200
        tax = pay - 1137.33
        tax *= 0.24
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 6280 <= $ < 7914
        pay = 7900
        tax = pay - 2423
        tax *= 0.32
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 7914 <= $ < 11761
        pay = 11700
        tax = pay - 2893.66
        tax *= 0.35
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 11761 <= $ < infinity
        pay = 20000
        tax = pay - 3372.97
        tax *= 0.37
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //now repeat with a married value set to false(single employees)
        
        p.currentLogin.info?.married = false
        
        //tests the bracket for pay up to 254 but outside iff has been tested and catches too low of value
        pay = 250
        tax = pay - 71
        tax = tax * 0.1
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 254 <= $ < 815
        pay = 800
        tax = pay - 101.5
        tax = tax * 0.12
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 815 <= $ < 1658
        pay = 1600
        tax = pay - 425.82
        tax *= 0.22
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 1658 <= $ < 3100
        pay = 3000
        tax = pay - 528.50
        tax *= 0.24
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 3100 <= $ < 3917
        pay = 3900
        tax = pay - 1171.38
        tax *= 0.32
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 3917 <= $ < 9687
        pay = 9600
        tax = pay - 1406.71
        tax *= 0.35
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 9687 <= $ < infinity
        pay = 10000
        tax = pay - 1854.30
        tax *= 0.37
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
    }
    
    
    //this tests the returns succesful when the function matches expected math
    func testPersonalViewController_calcSocialTax(){
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        var pay, ssTax: Float
        let p = Team_1_Payroll.personalViewController()
        
        //expected math operations
        pay = 1000
        ssTax = pay * 0.062
        
        //tests against the function call
        XCTAssertTrue(ssTax == p.calcSocialTax(grossPay: pay))
    }
    //This test is designed to test the true value of the calcMedicareTax function against the true value
    func testPersonalViewController_calcMedicareTax(){
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        var pay, medTax: Float
        let p = Team_1_Payroll.personalViewController()
        
        //calculates what should be the Medicare tax
        pay = 1000
        medTax = pay * 0.0145
        
        
        //tests the function to the calculated value
        XCTAssertTrue(medTax == p.calcMedicareTax(grossPay: pay))
    }
    //This Test is ensuring the calcStateIncomeTax works according to the math setup for all bracket values
    
    func testPersonalViewController_calcStateIncomeTax(){
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        var pay, tax: Float
        let p = Team_1_Payroll.personalViewController()
        
        //taxes are zero when $ < 2970
        pay = 0
        tax = 0
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay), "Success")
        
        //tax value when 2970 <= $ < 5940
        pay *= 52
        tax = pay * 0.03
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
        
        //tax value when 5940 <= $ < 8910
        pay = 150
        pay *= 52
        tax = pay * 0.04
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
        
        //tax value when 8910 <= $ < 11880
        pay = 200
        pay *= 52
        tax = pay * 0.05
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
        
        //tax value when 11880 <= $ < 14860
        pay = 250
        pay *= 52
        tax = pay * 0.06
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
        
        //tax value when 14860 <= $ < infinity
        pay = 1000
        pay *= 52
        tax = pay * 0.07
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
    }
    //This tests if the clockin value populates the employee that is currently logged in
    func testPunchCardViewController_clockInPressed(){
       
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        let p = Team_1_Payroll.PunchCardViewController()
        p.currentLogin = currentLogin
        p.managedObjectContext = managedObjectContext
        let timeNow: Date
        //stores current time in timeNow Date variable
        timeNow = Date.init()
        //stores current time in current login's punch in value
        p.clockInPressed("yes")
        
        //true as long as the function works correctly since the date varibale is created right after it is always larger, unless the function fails to store date data, then it will not be a greater value
        XCTAssertTrue(p.currentLogin.pay!.clockIn! > timeNow)
        
    }
    
    func testPunchCardViewController_clockOutPressed(){
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        let p = Team_1_Payroll.PunchCardViewController()
        p.currentLogin = currentLogin
        p.managedObjectContext = managedObjectContext
        let timeNow: Date
        //stores current time in timeNow Date variable
        timeNow = Date.init()
        //stores current time in current login's punch in value
        p.clockOutPressed("yes")
        
        //true as long as the function works correctly since the date varibale is created right after it is always larger, unless the function fails to store date data, then it will not be a greater value
        XCTAssertTrue(p.currentLogin.pay!.clockOut! > timeNow)
    }
    
    func testOverviewController_stringFromTimeInterval() {
        
        let p = Team_1_Payroll.OverviewViewController()

        
        var currentTime: Double
        var stringTime: String
        currentTime = 7267
        stringTime = "02:01:07"
        
        XCTAssertTrue(stringTime == p.stringFromTimeInterval(time: currentTime))
        
    }
    
    func test_overviewViewController_calcFedIncomeTax() {
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        var pay, tax: Float
        var empsInfo:[Employee_Info]!
        let p = Team_1_Payroll.OverviewViewController()
        
        //set the value of the current login as a married status
        p.empsInfo = [currentInfo]
        currentInfo.married = true
        
        //testing condition where the value made is lower than normal bound to test outside if statement
        pay = 0
        tax = -71
        if tax > 0{
            
        }
        else{
            tax = 0
        }
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket ranging up to 588 (anything too low gets caught by outside if
        pay = 500
        tax = pay - 222
        tax = tax * 0.1
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 588 <= $ < 1788
        pay = 1700
        tax = pay - 283
        tax = tax * 0.12
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 1788 <= $ < 3395
        pay = 3300
        tax = pay - 932.09
        tax *= 0.22
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 3395 <= $ < 6280
        pay = 6200
        tax = pay - 1137.33
        tax *= 0.24
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 6280 <= $ < 7914
        pay = 7900
        tax = pay - 2423
        tax *= 0.32
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 7914 <= $ < 11761
        pay = 11700
        tax = pay - 2893.66
        tax *= 0.35
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 11761 <= $ < infinity
        pay = 20000
        tax = pay - 3372.97
        tax *= 0.37
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //now repeat with a married value set to false(single employees)
        
        currentInfo.married = false
        
        //tests the bracket for pay up to 254 but outside iff has been tested and catches too low of value
        pay = 250
        tax = pay - 71
        tax = tax * 0.1
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 254 <= $ < 815
        pay = 800
        tax = pay - 101.5
        tax = tax * 0.12
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 815 <= $ < 1658
        pay = 1600
        tax = pay - 425.82
        tax *= 0.22
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 1658 <= $ < 3100
        pay = 3000
        tax = pay - 528.50
        tax *= 0.24
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 3100 <= $ < 3917
        pay = 3900
        tax = pay - 1171.38
        tax *= 0.32
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 3917 <= $ < 9687
        pay = 9600
        tax = pay - 1406.71
        tax *= 0.35
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
        
        //tests the bracket from 9687 <= $ < infinity
        pay = 10000
        tax = pay - 1854.30
        tax *= 0.37
        XCTAssertTrue(tax == p.calcFedIncomeTax(grossPay: pay))
    }
    
    func testOverviewViewController_calcSocialTax(){
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        var pay, ssTax: Float
        let p = Team_1_Payroll.OverviewViewController()
        
        //expected math operations
        pay = 1000
        ssTax = pay * 0.062
        
        //tests against the function call
        XCTAssertTrue(ssTax == p.calcSocialTax(grossPay: pay))
    }
    
    func testOverviewViewController_calcMedicareTax(){
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        var pay, medTax: Float
        let p = Team_1_Payroll.OverviewViewController()
        
        //calculates what should be the Medicare tax
        pay = 1000
        medTax = pay * 0.0145
        
        
        //tests the function to the calculated value
        XCTAssertTrue(medTax == p.calcMedicareTax(grossPay: pay))
    }
    
    func testOverviewViewController_calcStateIncomeTax(){
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard managedObjectContext != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                for result in results{
                    if result.username! == "admin"{
                        currentLogin = result
                        currentInfo = result.info
                        currentSch = result.schedule
                        currentPay = result.pay
                    }
                
                }
                
            }catch{
                print("Could not retrieve")
            }
        
        var pay, tax: Float
        let p = Team_1_Payroll.OverviewViewController()
        
        //taxes are zero when $ < 2970
        pay = 0
        tax = 0
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay), "Success")
        
        //tax value when 2970 <= $ < 5940
        pay *= 52
        tax = pay * 0.03
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
        
        //tax value when 5940 <= $ < 8910
        pay = 150
        pay *= 52
        tax = pay * 0.04
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
        
        //tax value when 8910 <= $ < 11880
        pay = 200
        pay *= 52
        tax = pay * 0.05
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
        
        //tax value when 11880 <= $ < 14860
        pay = 250
        pay *= 52
        tax = pay * 0.06
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
        
        //tax value when 14860 <= $ < infinity
        pay = 1000
        pay *= 52
        tax = pay * 0.07
        XCTAssertTrue(tax == p.calcStateIncomeTax(grossPay: pay))
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

