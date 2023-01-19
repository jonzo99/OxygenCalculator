//
//  OxygenTimeHelper.swift
//  Oxgen Calculator
//
//  Created by Jonzo Jimenez on 12/27/22.
//

import Foundation

class OxegenTimeHelper: ObservableObject {
    @Published var freeCountDown: Int {
        didSet {
            UserDefaults.standard.set(freeCountDown, forKey: "FreeCountDown")
        }
    }
    @Published var freeTimerText: String = "00:00:00"
    @Published var hamCountDown: Int {
        didSet {
            UserDefaults.standard.set(hamCountDown, forKey: "HamCountDown")
        }
    }
    @Published var hamTimerText: String = "00:00:00"
    @Published var timeExitedScreen: Date? {
        didSet {
            UserDefaults.standard.set(timeExitedScreen, forKey: "timeExitedScreen")
        }
    }
    @Published var timer: Timer?
    @Published var timerCountingFree: Bool {
        didSet {
            UserDefaults.standard.set(timerCountingFree, forKey: "timerCountingFree")
        }
    }
    @Published var timerCountingHamilton: Bool {
        didSet {
            UserDefaults.standard.set(timerCountingHamilton, forKey: "timerCountingHamilton")
        }
    }
    
    init() {
        self.timeExitedScreen = UserDefaults.standard.object(forKey: "timeExitedScreen") as? Date
        self.hamCountDown = UserDefaults.standard.integer(forKey: "HamCountDown")
        self.freeCountDown = UserDefaults.standard.integer(forKey: "FreeCountDown")
        self.timerCountingFree = UserDefaults.standard.bool(forKey: "timerCountingFree")
        self.timerCountingHamilton = UserDefaults.standard.bool(forKey: "timerCountingHamilton")
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerFired() {
        if timerCountingHamilton {
            if (hamCountDown > 0) {
                hamCountDown -= 1
            }
            if (hamCountDown <= 0) {
                timerCountingHamilton = false
            }
            // if i want to add a message when it hits a certain amount of seconds i should make phone vibrate show notification
            let time = secondsToHoursMinutesSeconds(seconds: hamCountDown)
            let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            hamTimerText = timeString
        }
        
        if timerCountingFree {
            if (freeCountDown > 0) {
                freeCountDown -= 1
            }
            if (freeCountDown <= 0) {
                timerCountingFree = false
            }
            // if i want to add a message when it hits a certain amount of seconds i should make phone vibrate show notification
            let time = secondsToHoursMinutesSeconds(seconds: freeCountDown)
            let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            freeTimerText = timeString
        }
    }
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
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
