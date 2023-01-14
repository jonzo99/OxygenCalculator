//
//  OxygenTimeHelper.swift
//  Oxgen Calculator
//
//  Created by Jonzo Jimenez on 12/27/22.
//

import Foundation

class OxegenTimeHelper: ObservableObject {
    
    // my hamilton timer is working great i only got off by 3 seconds
    // after multiple times leaving and entering.
    
    // @AppStorage("timerCountingFree") var timerCounting = false
    
    /*fddf
     I will also need to put the values of if they are counting down to be stored here
     */
    @Published var timeExitedScreen: Date {
        didSet {
            UserDefaults.standard.set(timeExitedScreen, forKey: "timeExitedScreen")
        }
    }
    @Published var hamCountDown: Int {
        didSet {
            UserDefaults.standard.set(hamCountDown, forKey: "HamCountDown")
        }
    }
    @Published var hamTimerText: String = "00:00:00"
    
    
    @Published var freeCountDown: Int {
        didSet {
            UserDefaults.standard.set(freeCountDown, forKey: "FreeCountDown")
        }
    }
    @Published var freeTimerText: String = "00:00:00"
    init() {
        //self.hamTimerCounting = UserDefaults.standard.bool(forKey: "timerCountingHamilton")
        self.timeExitedScreen = UserDefaults.standard.object(forKey: "timeExitedScreen") as? Date ?? Date()
        self.hamCountDown = UserDefaults.standard.integer(forKey: "HamCountDown")
        self.freeCountDown = UserDefaults.standard.integer(forKey: "FreeCountDown")
        
    }
     func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    // I dont think I should make these static functions
    // But I would need to do more researh
     func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}
