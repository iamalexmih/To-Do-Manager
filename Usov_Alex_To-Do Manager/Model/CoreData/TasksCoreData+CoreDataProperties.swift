import CoreData


extension TasksCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TasksCoreData> {
        return NSFetchRequest<TasksCoreData>(entityName: "TasksCoreData")
    }

    @NSManaged public var priority: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?

}

extension TasksCoreData : Identifiable {

}
