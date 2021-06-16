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
