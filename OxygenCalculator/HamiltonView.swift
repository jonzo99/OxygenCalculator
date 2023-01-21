//
//  HamiltonView.swift
//  Oxgen Calculator
//
//  Created by Jonzo Jimenez on 12/27/22.
//

import SwiftUI

import SwiftUI
import Foundation
///every time I change a value I should do all the calculations to get the time. In order the user does not have to edit. This way whenever the user enters the last empty input field it automatically shows Time left. Like if they pressed the "CALC" button. This is better user experience.
///When the user presses reset show an alert just so they do not reset by accident.


struct HamiltonView: View {
    
    func getTotalSecondsLeft() -> Int {
        let numPsiTextField  = Double(psiTextField)  ?? 0
        let numRateTextField = Double(rateTextField) ?? 0
        let numVtTextField   = Double(vtTextField)   ?? 0
        let numFi02TextField = Double(fi02TextField) ?? 0
        
        let a = selectedTankSize * numPsiTextField
        let b = (numRateTextField * numVtTextField / 1000 * 1.1) + selectedPatient
        let c = (numFi02TextField - 20.9) / 79.1
        let totalTimeInSeconds = (1 / (b * c) * a) * 60
        
        return Int(round(totalTimeInSeconds))
    }
    
    @ObservedObject var notificationManager = LocalNotificationManager()
    let userNotificationCenter = UNUserNotificationCenter.current()
    @AppStorage("HamSelectedTankSize") var selectedTankSize = 0.16
    @AppStorage("HamSelectedSelectedPatient") var selectedPatient = 3.0
    @AppStorage("HampsiTextField") var psiTextField = ""
    @AppStorage("Hamfi02TextField") var fi02TextField = ""
    @AppStorage("HamrateTextField") var rateTextField = ""
    @AppStorage("HamvtTextField") var vtTextField   = ""
    @State private var stopStartText = "START"
    @AppStorage("HamTimeLeft") var timeText = "00:00:00"
    @State private var showAlert: Bool = false
    @FocusState private var focusedField: Field?
    @EnvironmentObject var oxegenTimerHelper: OxegenTimeHelper
    var body: some View {
        VStack(spacing: 8) {
            
            Text("Hamilton")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Spacer()
            
            patientPicker
            
            TankSizePicker(selectedTankSize: $selectedTankSize)
            
            Group {
                timerTextField(leftLabel: "Tank Psi:", placeholder: "tank psi", text: $psiTextField, focused: $focusedField, nextFocusedValue: .psiTextField)
            
                timerTextField(leftLabel: "Fi02%:", placeholder: "fi02%", text: $fi02TextField, focused: $focusedField, nextFocusedValue: .fi02TextField)
            
                timerTextField(leftLabel: "Rate:", placeholder: "rate", text: $rateTextField, focused: $focusedField, nextFocusedValue: .rateTextField)
            
                timerTextField(leftLabel: "Vt (ml):", placeholder: "Vt(ml)", text: $vtTextField, focused: $focusedField, nextFocusedValue: .vtTextField)
            }
            
            CaluclatedTime(displayTimeText: $timeText)
            
            Text(oxegenTimerHelper.hamiltonTimerText)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .frame(alignment: .center)
            Spacer()
            HStack {
                resetButton
                    .padding()
                calcButton
                    .padding()
                startStopButton
                    .padding()
            }
        }
        .onSubmit {
            switch focusedField {
            case .psiTextField:
                focusedField = .fi02TextField
            case .fi02TextField:
                focusedField = .rateTextField
            case .rateTextField:
                focusedField = .vtTextField
            default:
                var total = getTotalSecondsLeft()
                if (total <= 0) {
                    showAlert = true
                    total = 0
                }
                if (oxegenTimerHelper.isHamiltonCounting == false) {
                    oxegenTimerHelper.hamiltonCountDown = total
                }
                let time = oxegenTimerHelper.secondsToHoursMinutesSeconds(seconds: total)
                let timeString = oxegenTimerHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                timeText = timeString
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Calculation needs to be greater than 0"), dismissButton: .default(Text("OK")))
        }
        
    }
    var calcButton: some View {
        Button("CALC ") {
            var total = getTotalSecondsLeft()
            if (total <= 0) {
                showAlert = true
                total = 0
            }
            if (oxegenTimerHelper.isHamiltonCounting == false) {
                oxegenTimerHelper.hamiltonCountDown = total
            }
            let time = oxegenTimerHelper.secondsToHoursMinutesSeconds(seconds: total)
            let timeString = oxegenTimerHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            timeText = timeString
            hideKeyboard()
        }
        .foregroundColor(.red)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    var startStopButton: some View {
        Button(stopStartText) {
            if oxegenTimerHelper.hamiltonCountDown <= 0 {
                self.oxegenTimerHelper.hamiltonCountDown = getTotalSecondsLeft()
            }
            if (oxegenTimerHelper.isHamiltonCounting) {
                oxegenTimerHelper.isHamiltonCounting = false
                stopStartText = "START"
                userNotificationCenter.removeAllPendingNotificationRequests()
            } else {
                if oxegenTimerHelper.hamiltonCountDown >= 600 {
                    let minuteLeft = oxegenTimerHelper.hamiltonCountDown - 599
                    notificationManager.sendLocalNotification(timeInterval: Double(minuteLeft), title: "10 mins Left", body: "HAMILTON there is 10 mins left", sound: "critalAlarm.wav")
                }
                if oxegenTimerHelper.hamiltonCountDown >= 60 {
                    let tenseconds = oxegenTimerHelper.hamiltonCountDown - 59
                    print(oxegenTimerHelper.hamiltonCountDown)
                    notificationManager.sendLocalNotification(timeInterval: Double(tenseconds), title: "1 min Left", body: "HAMILTON there is 1 mins left", sound: "critalAlarm.wav")
                }
                
                if oxegenTimerHelper.hamiltonCountDown >= 2 {
                    let twoSeconds = oxegenTimerHelper.hamiltonCountDown - 1
                    notificationManager.sendLocalNotification(timeInterval: Double(twoSeconds), title: "Timer is Done", body: "HAMILTON Timer is done", sound: "critalAlarm.wav")
                }
                
                oxegenTimerHelper.isHamiltonCounting = true
                stopStartText = "STOP  "
                hideKeyboard()
            }
        }
        .foregroundColor(Color(.red))
        .padding()
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    
    var resetButton: some View {
        Button("RESET") {
            oxegenTimerHelper.hamiltonCountDown = 0
            oxegenTimerHelper.isHamiltonCounting = false
            stopStartText = "START"
            userNotificationCenter.removeAllPendingNotificationRequests()
            psiTextField  = ""
            fi02TextField = ""
            rateTextField = ""
            vtTextField   = ""
            oxegenTimerHelper.hamiltonTimerText = oxegenTimerHelper.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            timeText = oxegenTimerHelper.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            hideKeyboard()
        }
        .foregroundColor(Color(.red))
        .padding()
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    var patientPicker: some View {
        HStack {
            Text("Patient:   ")
                .modifier(PrimaryLabel())
            Spacer()
            VStack {
                Picker("patient", selection: $selectedPatient) {
                    Text("Adult/Ped").tag(3.0)
                    Text("Neonate").tag(4.0)
                }.pickerStyle(SegmentedPickerStyle())
            }
            .frame(width:200)
            .multilineTextAlignment(.center)
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
    }
}

struct HamiltonView_Previews: PreviewProvider {
    static var previews: some View {
        HamiltonView()
    }
}
extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()

    public var rawValue: String {
        Date.formatter.string(from: self)
    }

    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
