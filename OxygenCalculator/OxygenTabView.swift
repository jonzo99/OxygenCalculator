//
//  OxygenTabView.swift
//  OxygenCalculator
//
//  Created by Jonzo Jimenez on 1/13/23.
//

import SwiftUI

import SwiftUI
import UserNotifications
import AVFAudio

struct OxygenTabView: View {
    @EnvironmentObject var oxygenTimeHelper: OxygenTimeHelper
    @State var selectedTab = 1
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HamiltonView()
                    .tabItem{
                        Image(systemName: "square.fill")
                        Text("HAMILTON")
                    }
                    .tag(1)
                FreeFlowView()
                    .tabItem {
                        Image(systemName: "square.fill")
                        Text("Free Flow")
                    }
                    .tag(2)
            }
            .onAppear(){
                if oxygenTimeHelper.isHamiltonCounting {
                    selectedTab = 1
                } else if oxygenTimeHelper.isFreeFlowCounting {
                    selectedTab = 2
                }
            }
        }
    }
}


struct PrimaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 26, weight: .medium, design: .rounded))
    }
}
struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(1)
            .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
        //.shadow(color: .gray, radius: 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OxygenTabView()
    }
}

