//
//  OxygenTimeHelper.swift
//  Oxgen Calculator
//
//  Created by Jonzo Jimenez on 12/27/22.
//

import Foundation

class OxygenTimeHelper: ObservableObject {
    @Published var freeFlowCountDown: Int {
        didSet {
            UserDefaults.standard.set(freeFlowCountDown, forKey: "freeFlowCountDown")
        }
    }
    @Published var freeFlowTimerText: String = "00:00:00"
    @Published var hamiltonCountDown: Int {
        didSet {
            UserDefaults.standard.set(hamiltonCountDown, forKey: "hamiltonCountDown")
        }
    }
    @Published var hamiltonTimerText: String = "00:00:00"
    @Published var isFreeFlowCounting: Bool {
        didSet {
            UserDefaults.standard.set(isFreeFlowCounting, forKey: "isFreeFlowCounting")
        }
    }
    @Published var isHamiltonCounting: Bool {
        didSet {
            UserDefaults.standard.set(isHamiltonCounting, forKey: "isHamiltonCounting")
        }
    }
    @Published var timeExitedScreen: Date? {
        didSet {
            UserDefaults.standard.set(timeExitedScreen, forKey: "timeExitedScreen")
        }
    }
    @Published var timer: Timer?
    
    init() {
        self.timeExitedScreen = UserDefaults.standard.object(forKey: "timeExitedScreen") as? Date
        self.hamiltonCountDown = UserDefaults.standard.integer(forKey: "hamiltonCountDown")
        self.freeFlowCountDown = UserDefaults.standard.integer(forKey: "freeFlowCountDown")
        self.isFreeFlowCounting = UserDefaults.standard.bool(forKey: "isFreeFlowCounting")
        self.isHamiltonCounting = UserDefaults.standard.bool(forKey: "isHamiltonCounting")
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
        if isHamiltonCounting {
            if (hamiltonCountDown > 0) {
                hamiltonCountDown -= 1
            }
            if (hamiltonCountDown <= 0) {
                isHamiltonCounting = false
            }
            // if i want to add a message when it hits a certain amount of seconds i should make phone vibrate show notification
            let time = secondsToHoursMinutesSeconds(seconds: hamiltonCountDown)
            let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            hamiltonTimerText = timeString
        }
        
        if isFreeFlowCounting {
            if (freeFlowCountDown > 0) {
                freeFlowCountDown -= 1
            }
            if (freeFlowCountDown <= 0) {
                isFreeFlowCounting = false
            }
            // if i want to add a message when it hits a certain amount of seconds i should make phone vibrate show notification
            let time = secondsToHoursMinutesSeconds(seconds: freeFlowCountDown)
            let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            freeFlowTimerText = timeString
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
