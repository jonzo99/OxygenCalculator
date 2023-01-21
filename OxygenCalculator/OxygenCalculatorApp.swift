//
//  OxygenCalculatorApp.swift
//  OxygenCalculator
//
//  Created by Jonzo Jimenez on 1/13/23.
//

import SwiftUI

@main
struct OxygenCalculatorApp: App {
    @StateObject var oxegenTimerHelper = OxegenTimeHelper()
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(oxegenTimerHelper)
                .onDisappear() {
                    oxegenTimerHelper.timeExitedScreen = Date()
                    oxegenTimerHelper.stopTimer()
                }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                print("Device: Active")
                if let timeExitedScreen = oxegenTimerHelper.timeExitedScreen {
                    let timePassedInBackground = Int(Date() - timeExitedScreen) + 1
                    print(timeExitedScreen)
                    if oxegenTimerHelper.isHamiltonCounting {
                        oxegenTimerHelper.hamiltonCountDown = oxegenTimerHelper.hamiltonCountDown - timePassedInBackground
                    }
                    
                    if oxegenTimerHelper.isFreeFlowCounting {
                        oxegenTimerHelper.freeFlowCountDown = oxegenTimerHelper.freeFlowCountDown - timePassedInBackground
                    }
                }
                oxegenTimerHelper.timeExitedScreen = nil
                oxegenTimerHelper.startTimer()
            }
            if phase == .background {
                print("Device: Background")
                oxegenTimerHelper.timeExitedScreen = Date()
                oxegenTimerHelper.stopTimer()
            }
        }
    }
}
