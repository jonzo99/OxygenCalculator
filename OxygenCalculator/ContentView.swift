//
//  ContentView.swift
//  OxygenCalculator
//
//  Created by Jonzo Jimenez on 1/13/23.
//

import SwiftUI

import SwiftUI
import UserNotifications
import AVFAudio

struct ContentView: View {
    var body: some View {
        ZStack {
            TabView {
                HamiltonView()
                    .tabItem{
                        Image(systemName: "square.fill")
                        Text("HAMILTON")
                    }
                    .navigationBarTitle("Hamilton")
                FreeFlowView()
                    .tabItem {
                        Image(systemName: "square.fill")
                        Text("Free Flow")
                    }
                    .navigationBarTitle("Hamilton")
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
        ContentView()
    }
}

