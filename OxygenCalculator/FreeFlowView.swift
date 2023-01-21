//
//  FreeFlowView.swift
//  Oxgen Calculator
//
//  Created by Jonzo Jimenez on 12/27/22.
//

import SwiftUI

@available(iOS 15.0, *)
struct FreeFlowView: View {
    
    func getTotalSecondsLeft() -> Int {
        let numPsiTextField = Double(psiTextField) ?? 0
        let numRateTextField = Double(rateTextField) ?? 0
        
        if (numPsiTextField == 0.0 || numRateTextField == 0.0) {
            return 0
        } else {
            let totalTimeInSeconds = ((numPsiTextField - 200) * selectedTankSize / numRateTextField) * 60
            return Int(round(totalTimeInSeconds))
        }
    }
    
    @ObservedObject var notificationManager = LocalNotificationManager()
    @State var userNotificationCenter = UNUserNotificationCenter.current()
    @AppStorage("FreeSelectedTankSize") var selectedTankSize = 0.16
    @AppStorage("FreepsiTextField") var psiTextField = ""
    @AppStorage("FreerateTextField") var rateTextField = ""
    @AppStorage("FreeTimeLeft") var timeText  = "00:00:00"
    @State private var stopStartText = "START"
    @EnvironmentObject var oxygenTimeHelper: OxygenTimeHelper
    @State private var showAlert: Bool = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            Text("Free Flow")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Spacer()
            TankSizePicker(selectedTankSize: $selectedTankSize)
            
            timerTextField(leftLabel: "Tank Psi:", placeholder: "tank psi", text: $psiTextField, focused: $focusedField, nextFocusedValue: .psiTextField)
            
            timerTextField(leftLabel: "Rate:", placeholder: "rate", text: $rateTextField, focused: $focusedField, nextFocusedValue: .rateTextField)
            
            CaluclatedTime(displayTimeText: $timeText)
            
            Text(oxygenTimeHelper.freeFlowTimerText)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .frame(alignment: .center)
            Spacer()
            HStack {
                Spacer()
                resetButton
                    .padding()
                calcButton
                    .padding()
                startStopButton
                    .padding()
                Spacer()
            }
        }
        .onSubmit {
            switch focusedField {
            case .psiTextField:
                focusedField = .rateTextField
            default:
                print("you have submitted")
                var total = getTotalSecondsLeft()
                if (total <= 0) {
                    showAlert = true
                    total = 0
                }
                if (oxygenTimeHelper.isFreeFlowCounting == false) {
                    oxygenTimeHelper.freeFlowCountDown = total
                }
                let time = oxygenTimeHelper.secondsToHoursMinutesSeconds(seconds: total)
                let timeString = oxygenTimeHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                timeText = timeString
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Calculation needs to be greater than 0"), dismissButton: .default(Text("OK")))
        }
    }
    
    
    var startStopButton: some View {
        Button(stopStartText) {
            if oxygenTimeHelper.freeFlowCountDown <= 0 {
                self.oxygenTimeHelper.freeFlowCountDown = getTotalSecondsLeft()
            }
            if (oxygenTimeHelper.isFreeFlowCounting) {
                oxygenTimeHelper.isFreeFlowCounting = false
                stopStartText = "START"
                userNotificationCenter.removeAllPendingNotificationRequests()
            } else {
                if oxygenTimeHelper.freeFlowCountDown >= 600 {
                    let minuteLeft = oxygenTimeHelper.freeFlowCountDown - 599
                    notificationManager.sendLocalNotification(timeInterval: Double(minuteLeft), title: "10 mins Left", body: "FREE FLOW there is 10 mins left", sound: "critalAlarm.wav")
                }
                if oxygenTimeHelper.freeFlowCountDown >= 60 {
                    let tenseconds = oxygenTimeHelper.freeFlowCountDown - 59
                    print(oxygenTimeHelper.freeFlowCountDown)
                    notificationManager.sendLocalNotification(timeInterval: Double(tenseconds), title: "1 min Left", body: "FREE FLOW there is 1 mins left", sound: "critalAlarm.wav")
                }
                if oxygenTimeHelper.freeFlowCountDown >= 2 {
                    let twoSeconds = oxygenTimeHelper.freeFlowCountDown - 1
                    notificationManager.sendLocalNotification(timeInterval: Double(twoSeconds), title: "Timer is Done", body: "FREE FLOW Timer is done", sound: "critalAlarm.wav")
                }
                
                oxygenTimeHelper.isFreeFlowCounting = true
                stopStartText = "STOP  "
                hideKeyboard()
            }
        }
        .foregroundColor(.red)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    var calcButton: some View {
        Button("CALC ") {
            var total = getTotalSecondsLeft()
            if (total <= 0) {
                showAlert = true
                total = 0
            }
            if (oxygenTimeHelper.isFreeFlowCounting == false) {
                oxygenTimeHelper.freeFlowCountDown = total
            }
            let time = oxygenTimeHelper.secondsToHoursMinutesSeconds(seconds: total)
            let timeString = oxygenTimeHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            timeText = timeString
            hideKeyboard()
        }
        .foregroundColor(.red)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    var resetButton: some View {
        Button("RESET") {
            oxygenTimeHelper.freeFlowCountDown = 0
            oxygenTimeHelper.isFreeFlowCounting = false
            oxygenTimeHelper.freeFlowTimerText = oxygenTimeHelper.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            stopStartText = "START"
            userNotificationCenter.removeAllPendingNotificationRequests()
            psiTextField = ""
            rateTextField = ""
            timeText = oxygenTimeHelper.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            hideKeyboard()
        }
        .foregroundColor(.red)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct FreeFlowView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            FreeFlowView()
        } else {
            // Fallback on earlier versions
        }
    }
}

