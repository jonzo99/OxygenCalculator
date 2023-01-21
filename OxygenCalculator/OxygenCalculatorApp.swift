//
//  OxygenCalculatorApp.swift
//  OxygenCalculator
//
//  Created by Jonzo Jimenez on 1/13/23.
//

import SwiftUI

@main
struct OxygenCalculatorApp: App {
    @StateObject var oxygenTimeHelper = OxygenTimeHelper()
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            OxygenTabView()
                .environmentObject(oxygenTimeHelper)
                .onDisappear() {
                    oxygenTimeHelper.timeExitedScreen = Date()
                    oxygenTimeHelper.stopTimer()
                }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                print("Device: Active")
                if let timeExitedScreen = oxygenTimeHelper.timeExitedScreen {
                    let timePassedInBackground = Int(Date() - timeExitedScreen) + 1
                    print(timeExitedScreen)
                    if oxygenTimeHelper.isHamiltonCounting {
                        oxygenTimeHelper.hamiltonCountDown = oxygenTimeHelper.hamiltonCountDown - timePassedInBackground
                    }
                    
                    if oxygenTimeHelper.isFreeFlowCounting {
                        oxygenTimeHelper.freeFlowCountDown = oxygenTimeHelper.freeFlowCountDown - timePassedInBackground
                    }
                }
                oxygenTimeHelper.timeExitedScreen = nil
                oxygenTimeHelper.startTimer()
            }
            if phase == .background {
                print("Device: Background")
                oxygenTimeHelper.timeExitedScreen = Date()
                oxygenTimeHelper.stopTimer()
            }
        }
    }
}
