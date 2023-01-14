//
//  FreeFlowView.swift
//  Oxgen Calculator
//
//  Created by Jonzo Jimenez on 12/27/22.
//

import SwiftUI

@available(iOS 15.0, *)
struct FreeFlowView: View {
    // create Local Storage
    // so I can store and always display
    // the values of the timer.
    
    // needs to be local because they go offline
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
    @AppStorage("timerCountingFree") var timerCounting = false
    @EnvironmentObject var oxegenTimerHelper: OxegenTimeHelper
    @State private var showAlert: Bool = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            /*
            Text("Free Flow Oxygen Calculator")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center) */
            Spacer()
            TankSizePicker(selectedTankSize: $selectedTankSize)
            
            timerTextField(leftLabel: "Tank Psi:", placeholder: "tank psi", text: $psiTextField, focused: $focusedField, nextFocusedValue: .psiTextField)
            
            timerTextField(leftLabel: "Rate:", placeholder: "rate", text: $rateTextField, focused: $focusedField, nextFocusedValue: .rateTextField)
            
            
            CaluclatedTime(displayTimeText: $timeText)
            
            Text(oxegenTimerHelper.freeTimerText)
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
                if (timerCounting == false) {
                    oxegenTimerHelper.freeCountDown = total
                }
                let time = oxegenTimerHelper.secondsToHoursMinutesSeconds(seconds: total)
                let timeString = oxegenTimerHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                timeText = timeString
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Calculation needs to be greater than 0"), dismissButton: .default(Text("OK")))
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            print("yeah the terminated your app boi")
            print(oxegenTimerHelper.freeCountDown)
        }
    }
    
    
    var startStopButton: some View {
        Button(stopStartText) {
            if oxegenTimerHelper.freeCountDown <= 0 {
                self.oxegenTimerHelper.freeCountDown = getTotalSecondsLeft()
            }
            if (timerCounting) {
                timerCounting = false
                stopStartText = "START"
                userNotificationCenter.removeAllPendingNotificationRequests()
            } else {
                if oxegenTimerHelper.freeCountDown >= 600 {
                    let minuteLeft = oxegenTimerHelper.freeCountDown - 599
                    print(oxegenTimerHelper.freeCountDown)
                    notificationManager.sendLocalNotification(timeInterval: Double(minuteLeft), title: "10 mins Left", body: "FREE FLOW there is 10 mins left", sound: "critalAlarm.wav")
                }
                if oxegenTimerHelper.freeCountDown >= 60 {
                    let tenseconds = oxegenTimerHelper.freeCountDown - 59
                    print(oxegenTimerHelper.freeCountDown)
                    notificationManager.sendLocalNotification(timeInterval: Double(tenseconds), title: "1 min Left", body: "FREE FLOW there is 1 mins left", sound: "critalAlarm.wav")
                }
                if oxegenTimerHelper.freeCountDown >= 2 {
                    let twoSeconds = oxegenTimerHelper.freeCountDown - 1
                    notificationManager.sendLocalNotification(timeInterval: Double(twoSeconds), title: "Timer is Done", body: "FREE FLOW Timer is done", sound: "critalAlarm.wav")
                }
                
                timerCounting = true
                stopStartText = "STOP  "
                print(oxegenTimerHelper.freeCountDown)
                hideKeyboard()
            }
        }
        .foregroundColor(Color(.red))
        .padding()
        .background(RoundedRectangle(cornerRadius: 10   , style: .continuous))
    }
    var calcButton: some View {
        Button("CALC ") {
            var total = getTotalSecondsLeft()
            if (total <= 0) {
                showAlert = true
                total = 0
            }
            if (timerCounting == false) {
                oxegenTimerHelper.freeCountDown = total
            }
            let time = oxegenTimerHelper.secondsToHoursMinutesSeconds(seconds: total)
            let timeString = oxegenTimerHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            timeText = timeString
            hideKeyboard()
        }
        .foregroundColor(Color(.red))
        .padding()
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    var resetButton: some View {
        Button("RESET") {
            oxegenTimerHelper.freeCountDown = 0
            timerCounting = false
            oxegenTimerHelper.freeTimerText = oxegenTimerHelper.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            stopStartText = "START"
            userNotificationCenter.removeAllPendingNotificationRequests()
            psiTextField = ""
            rateTextField = ""
            timeText = oxegenTimerHelper.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            hideKeyboard()
        }
        .foregroundColor(.red)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10   , style: .continuous))
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

