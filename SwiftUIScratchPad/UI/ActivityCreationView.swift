//
//  ActivityCreationView.swift
//  SwiftUIScratchPad
//
//  Created by Parker Rushton on 6/16/21.
//

import SwiftUI

struct ActivityCreationView: View {
    
    // MARK: - Enums
    
    enum Field: Int, Hashable, CaseIterable {
        case name, type
    }
    
    
    // MARK: - State
    
    @State private var nameText = ""
    @State private var typeText = ""
    @State private var participantsCount = 1
    @State private var costSelection = 1
    @State private var accessibilitySelection = 0.5
    
    
    // MARK: - Focus State
    
    @FocusState private var focusedField: Field?
    
    
    // MARK: - Properties
    
    private var newActivityCreated: ((Activity) -> Void)?
    private var canSave: Bool {
        !nameText.isEmpty && !typeText.isEmpty
    }
    
    
    // MARK: - Init
    
    init(onCreation: @escaping ((Activity) -> Void)) {
        self.newActivityCreated = onCreation
    }
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                
                ActivityEntryView(title: "Whats the activity called?", text: $nameText, focusField: .name, currentField: _focusedField)
                
                ActivityEntryView(title: "What type of activity?", text: $typeText, focusField: .type, currentField: _focusedField)
                
                Text("How many people?")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                
                Stepper("\(participantsCount)", value: $participantsCount, in: 1...99)
                
                Text("How expensive?")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                
                Picker("", selection: $costSelection) {
                    Text("$").tag(1)
                    Text("$$").tag(2)
                    Text("$$$").tag(3)
                    Text("$$$$").tag(4)
                }
                .pickerStyle(.segmented)
                .foregroundColor(.green)
                
                HStack {
                Text("How accessible?")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                    
                    Spacer()
                    
                    Text(String(format: "%.1f", accessibilitySelection))
                }
                
                HStack {
                    Image(systemName: "tortoise.fill")
                    Slider(value: $accessibilitySelection, in: 0...1)
                    Image(systemName: "figure.walk")
                }
                
                Spacer()
                
                Button(action: save) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Rectangle().background(Color.blue))
                        .opacity(canSave ? 1 : 0.3)
                        .cornerRadius(5)
                        
                }
                .disabled(!canSave)

            }
            .padding()
            .navigationBarTitle("New Activity")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: selectPreviousField) {
                        Label("Previous", systemImage: "chevron.up")
                    }
//                    .disabled(!canSelectPreviousField)
                    
                    Button(action: selectNextField) {
                        Label("Next", systemImage: "chevron.down")
                    }
//                    .disabled(!canSelectNextField)
                }
            }
        }
    }
    
}


private extension ActivityCreationView {
    
    func save() {
        let type = Activity.ActivityType(rawValue: typeText.lowercased()) ?? Activity.ActivityType.busywork
        
        let newActivity = Activity(id: UUID().uuidString, name: nameText, participants: participantsCount, type: type, accessibilityFactor: accessibilitySelection, priceFactor: Double(costSelection) / 4.0)
        newActivityCreated?(newActivity)
    }
    
    private func selectPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1)!
        }
    }
    
    private var canSelectPreviousField: Bool {
        focusedField == .type
    }
    
    private func selectNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1)!
        }
    }
    
    private var canSelectNextField: Bool {
        focusedField == .name
    }
    
}


// MARK: - Previews

struct ActivityCreationView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ActivityCreationView { activity in
                print(activity)
            }
            
            // Landscape preview
            ActivityCreationView { activity in
                print(activity)
            }
            .previewInterfaceOrientation(.landscapeLeft)
            
        }
    }
    
}
