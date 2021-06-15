//
//  ActivityCodable.swift
//  SwiftUIScratchPad
//
//  Created by Parker Rushton on 6/15/21.
//

import Foundation

struct Activity: Identifiable, Hashable {
    let id: String
    let name: String
    let participants: Int
    let type: String
}

extension Activity: Codable {
    
    enum CodingKeys: String, CodingKey {
        case participants, type
        case id = "key"
        case name = "activity"
    }
    
}
