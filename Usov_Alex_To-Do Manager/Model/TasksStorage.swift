//
//  TasksStorage.swift
//  Usov_Alex_To-Do Manager
//
//  Created by Алексей Попроцкий on 25.05.2022.
//

import Foundation

protocol TasksStorageProtocol {
    func loadTasks() -> [TaskModelProtokol]
    func saveTasks(_ tasks: [TaskModelProtokol])
}

class TasksStorage: TasksStorageProtocol {
    
    func loadTasks() -> [TaskModelProtokol] {
        
        let testListTasks: [TaskModelProtokol] = [
            OneTask(title: "Купить хлеб", priority: .normal, status: .planned),
//            OneTask(title: "Помыть кота", priority: .normal, status: .planned),
//            OneTask(title: "Поиграть в Героев", priority: .normal, status: .completed),
//            OneTask(title: "Позаниматься гантелями", priority: .important, status: .completed),
//            OneTask(title: "Помыть посуду", priority: .normal, status: .planned),
//            OneTask(title: "Проявить пленку", priority: .important, status: .planned),
//            OneTask(title: "Оплатить кредит", priority: .normal, status: .planned)
        ]
        
        return testListTasks
        
    }
    
    func saveTasks(_ tasks: [TaskModelProtokol]) {
        
    }
}
