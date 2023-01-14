//
//  TimerHelperFunctions.swift
//  Oxgen Calculator
//
//  Created by Jonzo Jimenez on 12/27/22.
//

import SwiftUI

enum Field {
    case psiTextField
    case fi02TextField
    case rateTextField
    case vtTextField
}
struct timerTextField: View {
    var leftLabel: String
    let placeholder: String
    @Binding var text: String
    var focused: FocusState<Field?>.Binding
    var nextFocusedValue: Field
    var body: some View {
        HStack {
            Text(leftLabel)
                .modifier(PrimaryLabel())
            Spacer()
            TextField(placeholder, text: $text, onEditingChanged: { changed in
                if (changed == true) {
                    text = ""
                }
            })
            .focused(focused, equals: nextFocusedValue)
            .frame(width: 200)
            .multilineTextAlignment(.center)
            .modifier(PrimaryLabel())
            .keyboardType(.numbersAndPunctuation)
            .textFieldStyle(OvalTextFieldStyle())
            .submitLabel(.next)
        }
        .padding(.bottom)
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}
struct TankSizePicker: View {
    @Binding var selectedTankSize: Double
    var body: some View {
        HStack {
            Text("Tank size:")
                .modifier(PrimaryLabel())
            Spacer()
            VStack {
                Picker("tanksize", selection: $selectedTankSize) {
                    Text("D").tag(0.16)
                    Text("E").tag(0.28)
                    Text("M").tag(1.56)
                    Text("K").tag(3.14)
                    
                }.pickerStyle(SegmentedPickerStyle())
            }
            .frame(width: 200)
            .multilineTextAlignment(.center)
        }
        .padding(.bottom)
        .padding(.leading,20)
        .padding(.trailing,20)
    }
}

struct CaluclatedTime: View {
    @Binding var displayTimeText: String
    var body: some View {
        HStack {
            Text("Time Left:      ")
                .modifier(PrimaryLabel())
            Spacer()
            Text(displayTimeText)
                .frame(width: 200)
                .multilineTextAlignment(.center)
                .modifier(PrimaryLabel())
                .keyboardType(.numbersAndPunctuation)
        }
        .padding(.leading,20)
        .padding(.trailing,20)
        .padding(.bottom)
    }
}
