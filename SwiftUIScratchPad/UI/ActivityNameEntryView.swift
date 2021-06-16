//
//  ActivityNameEntryView.swift
//  SwiftUIScratchPad
//
//  Created by Parker Rushton on 6/16/21.
//

import SwiftUI

struct ActivityEntryView: View {
    
    @Binding var text: String
    @FocusState var focusedField: ActivityCreationView.Field?
    
    private let title: String
    private let field: ActivityCreationView.Field
    
    init(title: String, text: Binding<String>, focusField: ActivityCreationView.Field, currentField: FocusState<ActivityCreationView.Field?>) {
        self.title = title
        _text = text
        self.field = focusField
        _focusedField = currentField
    }
    
    var body: some View {
        Text(title)
            .font(.title3)
            .bold()
        
        TextField("Title", text: $text)
//            .focused($focusedField, equals: field)
    }
    
}
