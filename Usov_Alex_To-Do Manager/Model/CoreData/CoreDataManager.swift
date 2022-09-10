
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
    func saveTask(newTask: TaskModelProtokol) {
        let taskCoreData = TasksCoreData(context: viewContext)
    
        taskCoreData.title = newTask.title
        taskCoreData.priority = (newTask.priority == .important) ? "important" : "normal"
        taskCoreData.status = (newTask.status == .planned) ? "planned" : "completed"
        taskCoreData.id = newTask.id
        
        save()
    }


    func fetchTask(filter: String? = nil) -> [TaskModelProtokol] {
        return convertCoreDataToTaskModel(arrayCoreData: loadDataCoreData())
    }

    
    func loadDataCoreData(id: UUID? = nil) -> [TasksCoreData] {
        let request: NSFetchRequest<TasksCoreData> = TasksCoreData.fetchRequest()
        
        if let id = id {
            print("id = \(id)")
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
        }
        
        var arrayCoreData: [TasksCoreData] = []
        do {
            arrayCoreData = try viewContext.fetch(request)
            print("arrayCoreData = \(arrayCoreData)")
        } catch let error {
            print("Error load fetchTask: \(error.localizedDescription)")
        }
        
        return arrayCoreData
    }
    
    
    
    func deleteNote(id: UUID) {
        let delete = loadDataCoreData(id: id)
        viewContext.delete(delete.first!)
        save()
        print(#function)
    }
    
    func updateTaskInContext(task: TaskModelProtokol) {
        let fetchObject = loadDataCoreData(id: task.id)
        let updateObject = fetchObject.first!
        updateObject.title = task.title
        updateObject.status = (task.status == .planned) ? "planned" : "completed"
        updateObject.priority = (task.priority == .important) ? "important" : "normal"
        save()
    }
    
    // MARK: - Helpers function
    private func convertCoreDataToTaskModel(arrayCoreData: [TasksCoreData]) -> [TaskModelProtokol] {
        var tasksListExtractCoreData: [TaskModelProtokol] = []
        if arrayCoreData.isEmpty {
            return tasksListExtractCoreData
        }
        for i in 0..<arrayCoreData.count {
            let title = arrayCoreData[i].title ?? "empty"
            let priority: TaskPriority = (arrayCoreData[i].priority == "important") ? .important : .normal
            let status: TaskStatus = (arrayCoreData[i].status == "planned") ? .planned : .completed
            let id: UUID = arrayCoreData[i].id!
            
            let newTask = OneTask(title: title, priority: priority, status: status, id: id)
            tasksListExtractCoreData.append(newTask)
        }
        return tasksListExtractCoreData
    }
}
