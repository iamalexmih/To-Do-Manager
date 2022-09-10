import UIKit

class TaskListControllerUITableView: UITableViewController {

    var tasksList: [TaskPriority : [TaskModelProtokol]] = [:] // Актуальный список задач
    var sectionsPositionForPriorityTask: [TaskPriority] = [.important, .normal] //для секции в таблице
    let cellID = "taskCellid"
    let cellidForEmptyTask = "CellForEmptyTask"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBaseTasks()
        navigationItem.leftBarButtonItem = editButtonItem
        sortingTasks()
    }
    
    // MARK: - CoreData Load
    private func loadBaseTasks() {
        sectionsPositionForPriorityTask.forEach { taskPriority in
            tasksList[taskPriority] = []
            // создаем пустой массив для каждого ключа
        }
        let arrayCoreData = CoreDataManager.shared.fetchTask()
        arrayCoreData.forEach { task in
            tasksList[task.priority]?.append(task)
            //tasksList[task.priority] используя ключ (task.priority) для словаря tasksList, получаем массив, поэтому append.
        }
    }
    
    // MARK: - Segue Prepare and CoreData save
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateScreen" {
            let destination = segue.destination as! TaskEdit_TableViewController
            destination.doAfterEdit = { [unowned self] title, priority, status, id in
                //замыкание будет вызвано после того как будет сохранена задача!
                let newTask = OneTask(title: title, priority: priority, status: status, id: id)
                tasksList[priority]?.append(newTask) //добавить в словарь tasksList, новую задачу newTask по ключу priority.
                CoreDataManager.shared.saveTask(newTask: newTask)
                sortingTasks()
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsPositionForPriorityTask.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // из массива [.important, .normal] получаем значение по индексу секции
        let getTaskPriorityOutSection = sectionsPositionForPriorityTask[section]
        //используя полученное значение, как ключ для словаря, получаем массив задач
        guard let getCurrentTasksPriority = tasksList[getTaskPriorityOutSection] else {
            return 0
        }
        if getCurrentTasksPriority.isEmpty {
            return 1
        } else {
            return getCurrentTasksPriority.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let getPriorityTask = sectionsPositionForPriorityTask[indexPath.section]
        let arrayTasksInSectionPriority = tasksList[getPriorityTask]!
        
        if arrayTasksInSectionPriority.isEmpty {
            return createEmptyCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TaskCellPrototype
        guard let currentTask = tasksList[getPriorityTask]?[indexPath.row]
            else {
                return cell
            }
        cell.setup(currentTask: currentTask)

        return cell
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (sectionsPositionForPriorityTask[section] == .important) ? "Важные" : "Все задачи"
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let getTaskPriority = sectionsPositionForPriorityTask[indexPath.section]
        if tasksList[getTaskPriority]!.isEmpty {
            tableView.deselectRow(at: indexPath, animated: true)
          return
        }
        //проверка наличия задачи
        guard let _ = tasksList[getTaskPriority]?[indexPath.row] else { return }
        
        //TODO: - Update CoreData после смены Статуса задачи
        
        guard tasksList[getTaskPriority]![indexPath.row].status == .planned else {
            //снимаем выделение строки
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        //Отмечаем задачу как выполненную
        tasksList[getTaskPriority]![indexPath.row].status = .completed
        CoreDataManager.shared.updateTaskInContext(task: tasksList[getTaskPriority]![indexPath.row])
        sortingTasks()
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let getTaskPriority = sectionsPositionForPriorityTask[indexPath.section]
        guard let _ = tasksList[getTaskPriority]?[indexPath.row] else { return nil }

        //действие для изм статуса на Запланирована
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Не выполнена") { [weak self] _, _, _ in
            guard let self = self else { return }
            self.tasksList[getTaskPriority]![indexPath.row].status = .planned
            CoreDataManager.shared.updateTaskInContext(task: self.tasksList[getTaskPriority]![indexPath.row])
            self.sortingTasks()
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }

        //действие для перехода к экрану редактирования
        let actionEditSwipeInstance = UIContextualAction(style: .normal, title: "Изменить") { [weak self] _, _, _ in
            guard let self = self else { return }
            //загрузка сцены со Сториборда
            let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskEditScreen") as! TaskEdit_TableViewController
            //передача значений редактируемой задачи
            editScreen.setupForEditAction(tasksList: self.tasksList,
                                          getTaskPriority: getTaskPriority,
                                          indexPath: indexPath)
            
            editScreen.doAfterEdit = { title, priority, status, id in
                self.afterEditAction(title: title,
                                     priority: priority,
                                     status: status,
                                     id: id,
                                     getTaskPriority: getTaskPriority,
                                     indexPath: indexPath)
                tableView.reloadData()
            }
            self.navigationController?.pushViewController(editScreen, animated: true)
        }

        actionEditSwipeInstance.backgroundColor = .gray

        //создаем объект описывающий доступные действия
        let actionsConfig: UISwipeActionsConfiguration
        if tasksList[getTaskPriority]![indexPath.row].status == .completed {
            actionsConfig = UISwipeActionsConfiguration(actions: [actionSwipeInstance, actionEditSwipeInstance])
        } else {
            actionsConfig = UISwipeActionsConfiguration(actions: [actionEditSwipeInstance])
        }
        return actionsConfig
    }

    // Метод разрешить/запретить редактировать таблицу
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let getTaskPriority = sectionsPositionForPriorityTask[indexPath.section]
        if tasksList[getTaskPriority]!.isEmpty {
            return false // отключить редактирование строки, если задач нет, чтоб не удалить строку с сообщение "список пуст"
        }
        return true
    }
    
    //метод удаления данных с таблицы
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        let getTaskPriority = sectionsPositionForPriorityTask[indexPath.section]
        let task = tasksList[getTaskPriority]![indexPath.row]
        if editingStyle == .delete {
            if indexPath.row == 0 { // если это последняя строка, то ее не удалять, чтоб сошлось количество ячеек в numberOfRowsInSection
                tasksList[getTaskPriority]?.remove(at: indexPath.row)
                tableView.reloadData()
                CoreDataManager.shared.deleteNote(id: task.id)
            } else {
                tasksList[getTaskPriority]?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                CoreDataManager.shared.deleteNote(id: task.id)
            }
        }
    }
    
    //метод перемещения данных между рядами.
    override func tableView(_ tableView: UITableView, moveRowAt startIndexPath: IndexPath, to finishIndexPath: IndexPath) {
        //получаем секция из которой происходит перемещение
        let startPositionTaskPriority = sectionsPositionForPriorityTask[startIndexPath.section]
        //секция К которой происходит перемещение
        let finishPositionTaskPriority = sectionsPositionForPriorityTask[finishIndexPath.section]

        guard let movedTask = tasksList[startPositionTaskPriority]?[startIndexPath.row] else { return }
        // удаляем задачу из стартовой строки
        tasksList[startPositionTaskPriority]!.remove(at: startIndexPath.row)
        tasksList[finishPositionTaskPriority]!.insert(movedTask, at: finishIndexPath.row)

        if startPositionTaskPriority != finishPositionTaskPriority {
            tasksList[finishPositionTaskPriority]![finishIndexPath.row].priority = finishPositionTaskPriority
        }
        tableView.reloadData()
    }
    
    
// MARK: - Helpers function
    private func afterEditAction (title: String,
                                  priority: TaskPriority,
                                  status: TaskStatus,
                                  id: UUID,
                                  getTaskPriority: TaskPriority,
                                  indexPath: IndexPath) {
        let editTask = OneTask(title: title, priority: priority, status: status, id: id)
        if getTaskPriority == editTask.priority {
            tasksList[getTaskPriority]![indexPath.row] = editTask
        } else {
            tasksList[getTaskPriority]!.remove(at: indexPath.row)
            tasksList[editTask.priority]?.append(editTask)
        }
        CoreDataManager.shared.updateTaskInContext(task: editTask)
        sortingTasks()
    }
    
    private func createEmptyCell() -> UITableViewCell {
        let cellForEmptyTask = UITableViewCell(style: .default, reuseIdentifier: cellidForEmptyTask)
        var config = cellForEmptyTask.defaultContentConfiguration()
        config.text = "список задач пуст"
        config.textProperties.color = UIColor(named: "taskPlanedColor")!
        cellForEmptyTask.contentConfiguration = config
        return cellForEmptyTask
    }
    
    private func sortingTasks() {
        for (keyDictionary, tasksGroup) in tasksList {
            tasksList[keyDictionary] = tasksGroup.sorted { taskFirst, taskNext in
                let tasksStatusPosition: [TaskStatus] = [.planned, .completed]
                let taskFirstPosition = tasksStatusPosition.firstIndex(of: taskFirst.status) ?? 0
                let taskNextPosition = tasksStatusPosition.firstIndex(of: taskNext.status) ?? 0
                
                return taskFirstPosition < taskNextPosition
            }
        }
    }
}
