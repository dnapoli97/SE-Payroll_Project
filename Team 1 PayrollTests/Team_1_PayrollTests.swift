//
//  Team_1_PayrollTests.swift
//  Team 1 PayrollTests
//
//  Created by Dylan Napoli on 9/18/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import CoreData
import XCTest
@testable import Team_1_Payroll

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

    func testPunchCardViewController_clockInPressed() {
        
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
                        currentPay = result.pay
                        currentInfo = result.info
                        currentSch = result.schedule
                        
                    }
                }
            }catch{
                print("Could not retrieve")
            }
        
        print(currentLogin.id)
        print(currentLogin.password!)
        print(currentSch.day0!)
        
        //testPunchCard.currentLogin = employee
        //testPunchCard.firstLaunch = first
                
        
        
        
        
    }
    
    func testPunchCardViewController_clockOutPressed() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

