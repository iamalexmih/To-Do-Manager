//
//  TasksCoreData+CoreDataProperties.swift
//  Usov_Alex_To-Do Manager
//
//  Created by Алексей Попроцкий on 09.09.2022.
//
//

import Foundation
import CoreData


extension TasksCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TasksCoreData> {
        return NSFetchRequest<TasksCoreData>(entityName: "TasksCoreData")
    }

    @NSManaged public var priority: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?

}

extension TasksCoreData : Identifiable {

}
