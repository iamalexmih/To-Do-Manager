
import Foundation
import CoreData


class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "TaskModel")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("An error occurred while save: \(error.localizedDescription)")
            }
            
        }
    }
}

// MARK: - Helpers functions

extension CoreDataManager {
    func saveTask(newTask: OneTask) {
        let tasksCoreData = TasksCoreData(context: viewContext)
        
//        let title = tasksCoreData.title ?? "empty"
//        let priority: TaskPriority = (tasksCoreData.priority == "important") ? .important : .normal
//        let status: TaskStatus = (tasksCoreData.status == "planned") ? .planned : .completed
//
//        let newTask = OneTask(title: title, priority: priority, status: status)
        tasksCoreData.title = newTask.title
        tasksCoreData.priority = (newTask.priority == .important) ? "important" : "normal"
        tasksCoreData.status = (newTask.status == .planned) ? "planned" : "completed"
        
        save()
        print("saveTask, tasksCoreData = \(tasksCoreData)")
    }


    func fetchTask(filter: String? = nil) -> [TaskModelProtokol] {
        let request: NSFetchRequest<TasksCoreData> = TasksCoreData.fetchRequest()
        var arrayCoreData: [TasksCoreData] = []
        do {
            arrayCoreData = try viewContext.fetch(request)
        } catch let error {
            print("Error load fetchTask: \(error.localizedDescription)")
        }
        
        return convertCoreDataToTaskModel(arrayCoreData: arrayCoreData)
    }

    
    private func convertCoreDataToTaskModel(arrayCoreData: [TasksCoreData]) -> [TaskModelProtokol] {
        var tasksListExtractCoreData: [TaskModelProtokol] = []
        if arrayCoreData.isEmpty {
            return tasksListExtractCoreData
        }
        for i in 0..<arrayCoreData.count {
            let title = arrayCoreData[i].title ?? "empty"
            let priority: TaskPriority = (arrayCoreData[i].priority == "important") ? .important : .normal
            let status: TaskStatus = (arrayCoreData[i].status == "planned") ? .planned : .completed
            
            let newTask = OneTask(title: title, priority: priority, status: status)
            tasksListExtractCoreData.append(newTask)
        }
        
        return tasksListExtractCoreData
    }
//    func deleteNote(_ note: Note) {
//        viewContext.delete(note)
//        save()
//    }
}
