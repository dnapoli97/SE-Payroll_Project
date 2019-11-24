//
//  FirstLaunch.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 10/22/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//  Code reviewed by Evan Scruggs 11/20/19

import Foundation

final class FirstLaunch {
    
    var userDefault: UserDefaults!
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init(getWasLaunchedBefore: () -> Bool,
         setWasLaunchedBefore: (Bool) -> ()) {
        let wasLaunchedBefore = getWasLaunchedBefore()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            setWasLaunchedBefore(true)
        }
    }
    
    convenience init(userDefaults: UserDefaults, key: String) {
        self.init(getWasLaunchedBefore: { userDefaults.bool(forKey: key) },
                  setWasLaunchedBefore: { userDefaults.set($0, forKey: key) })
        userDefault = userDefaults
        
    }
    
    var getUserDefault: UserDefaults{
        return userDefault
    }
    
}
