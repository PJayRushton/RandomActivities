//
//  ActivityCell.swift
//  SwiftUIScratchPad
//
//  Created by Parker Rushton on 6/18/21.
//

import SwiftUI

struct ActivityCell: View {
    
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(activity.name)
                .layoutPriority(1)
            
            HStack {
                Image(systemName: "person.2.fill")
                Text("\(activity.participants)")
                
                Spacer()
                
                Text(activity.dollarString)
            }
        }
        .padding()
    }
    
}


// MARK: - Preview

struct ActivityCell_Previews: PreviewProvider {
    
    static let previewActivity = Activity(id: UUID().uuidString, name: "Bowling", participants: 2, type: .social, accessibilityFactor: 0.5, priceFactor: 0.5)
    
    static var previews: some View {
        ActivityCell(activity: previewActivity)
            .previewLayout(.sizeThatFits)
    }
    
}
