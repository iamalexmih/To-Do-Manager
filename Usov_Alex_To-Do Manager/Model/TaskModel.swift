//
//  TaskModel.swift
//  Usov_Alex_To-Do Manager
//
//  Created by Алексей Попроцкий on 25.05.2022.
//

import Foundation


enum TaskPriority {
    case normal
    case important
}

enum TaskStatus: Int { //Int это связанное значение rawValue, первый элемент будет 0, второй 1. Будем использовать для сортировки задач
    case planned
    case completed
}

protocol TaskModelProtokol {
    var title: String {get set}
    var priority: TaskPriority {get set}
    var status: TaskStatus {get set}
    var id: UUID {get set}
}

struct OneTask: TaskModelProtokol {
    var title: String
    var priority: TaskPriority
    var status: TaskStatus
    var id = UUID()
}
