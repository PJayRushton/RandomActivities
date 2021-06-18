//
//  ActivityCodable.swift
//  SwiftUIScratchPad
//
//  Created by Parker Rushton on 6/15/21.
//

import Foundation

struct Activity: Identifiable, Hashable {
    
    enum ActivityType: String, Codable {
        case education, recreational, social, diy, charity, cooking, relaxation, music, busywork
    }
    
    let id: String
    let name: String
    let participants: Int
    let type: ActivityType
    let accessibilityFactor: Double
    let priceFactor: Double
    
    var numberOfDollarSigns: Int {
        guard priceFactor > 0 else { return 0 }
        return min(Int(priceFactor * 4.0), 4)
    }
    
    var dollarString: String {
        let dollars = Array(repeating: "💵", count: numberOfDollarSigns)
        return dollars.joined(separator: " ")
    }
    
}


extension Activity: Codable {
    
    enum CodingKeys: String, CodingKey {
        case participants, type
        case priceFactor = "price"
        case accessibilityFactor = "accessibility"
        case id = "key"
        case name = "activity"
    }
    
}
