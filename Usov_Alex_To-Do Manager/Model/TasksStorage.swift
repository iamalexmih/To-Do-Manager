//
//  TasksStorage.swift
//  Usov_Alex_To-Do Manager
//
//  Created by Алексей Попроцкий on 25.05.2022.
//

import Foundation
import UIKit
import CoreData

protocol TasksStorageProtocol {
    func loadTasks() -> [TaskModelProtokol]
    func saveTasks(_ tasks: [TaskModelProtokol])
}

class TasksStorage: TasksStorageProtocol {
    
    func loadTasks() -> [TaskModelProtokol] {
        
        let testListTasks: [TaskModelProtokol] = [
            OneTask(title: "Купить хлеб", priority: .normal, status: .planned),
            OneTask(title: "Помыть кота", priority: .normal, status: .planned),
            OneTask(title: "Поиграть в Героев", priority: .normal, status: .completed),
            OneTask(title: "Позаниматься гантелями", priority: .important, status: .completed),
            OneTask(title: "Помыть посуду", priority: .normal, status: .planned),
            OneTask(title: "Проявить пленку", priority: .important, status: .planned),
            OneTask(title: "Оплатить кредит", priority: .normal, status: .planned)
        ]
        
        return testListTasks
        
    }
    
    func loadTasksCOreData() -> [TaskModelProtokol] {
        var tasksListExtractCoreData: [TaskModelProtokol] = []
    
    
        return tasksListExtractCoreData
    }
    
    
    func saveTasks(_ tasks: [TaskModelProtokol]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entityTask = NSEntityDescription.entity(forEntityName: "TasksCoreData", in: context)
        else { return print("данные не сохранены") }
        
        let taskObject = TasksCoreData(entity: entityTask, insertInto: context)
        
        tasks.forEach { taskOne in
            taskObject.title = taskOne.title
            taskObject.priority = (taskOne.priority == .important) ? "important" : "normal"
            taskObject.status = (taskOne.status == .planned) ? "planned" : "completed"
            
            do {
                try context.save()
                print("сохранение title = \(taskObject.title!)")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
