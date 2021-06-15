//
//  ActivityCoreDataManager.swift
//  SwiftUIScratchPad
//
//  Created by Parker Rushton on 6/15/21.
//

import CoreData

class ActivityCoreDataManager {
    
    static var shared = ActivityCoreDataManager()
    
    func addActivity(_ codable: ActivityCodable) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Activity", in: PersistenceController.shared.context) else { return }
        let newActivity = Activity(entity: entity, insertInto: PersistenceController.shared.context)
        newActivity.id = codable.key
        newActivity.name = codable.activity
        newActivity.participants = Int16(codable.participants)
        newActivity.type = codable.type
        newActivity.createdAt = Date()
    }
    
    func delete(_ activity: Activity) {
        PersistenceController.shared.context.delete(activity)
    }
    
}
