import Foundation


enum TaskPriority {
    case normal
    case important
}

enum TaskStatus: Int {
    case planned
    case completed
}

protocol TaskModelProtocol {
    var title: String {get set}
    var priority: TaskPriority {get set}
    var status: TaskStatus {get set}
    var id: UUID {get set}
}

struct OneTask: TaskModelProtocol {
    var title: String
    var priority: TaskPriority
    var status: TaskStatus
    var id = UUID()
}
