//
//  TaskEdit_TableViewController.swift
//  Usov_Alex_To-Do Manager
//
//  Created by Алексей Попроцкий on 26.05.2022.
//

import UIKit

class TaskEdit_TableViewController: UITableViewController {
    var taskText: String = ""
    var taskPriority: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    var idTask: UUID?
    var namePriorityForTask: [TaskPriority : String] = [
        .important : "Важная",
        .normal : "Текущая"
    ]
    
    
    var doAfterEdit: ((String, TaskPriority, TaskStatus, UUID) -> Void)? // замыкание для передачи данных
    
    @IBOutlet weak var labelTitleTask: UITextField!
    @IBOutlet weak var labelTaskPriority: UILabel!
    @IBOutlet weak var taskStatusSwitch: UISwitch!
    
    func setupForEditAction(tasksList: [TaskPriority : [TaskModelProtokol]],
                            getTaskPriority: TaskPriority,
                            indexPath: IndexPath) {
        taskText = tasksList[getTaskPriority]![indexPath.row].title
        taskPriority = tasksList[getTaskPriority]![indexPath.row].priority
        taskStatus = tasksList[getTaskPriority]![indexPath.row].status
        idTask = tasksList[getTaskPriority]![indexPath.row].id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitleTask?.text = taskText
        labelTaskPriority?.text = namePriorityForTask[taskPriority]
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }
    }


    
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        //получаем актуальные значения
        
        if labelTitleTask.text?.trimmingCharacters(in: .whitespaces) == "" { //очистка строки от пробелов в начале
            let alert = UIAlertController (title: "Задача не Сохранена", message: "Название задачи отсутствует", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let title = labelTitleTask?.text ?? ""
            let priority = taskPriority
            let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
            let id: UUID = idTask ?? UUID()
            doAfterEdit?(title, priority, status, id)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Segue Prepare

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskPriorityScreen" {
            let destination = segue.destination as! PriorityTask_TableViewController
            destination.selectPriority = taskPriority
                //определяем действия/логику для замыкания. Само замыкание вызывается в PriorityTask_TableViewController. Таким образом этот контроллер TaskEdit_TableViewController, определяет действие.
            destination.doAfterPrioritySelected = { [unowned self] selectedPriority in
                taskPriority = selectedPriority
                labelTaskPriority.text = namePriorityForTask[taskPriority]
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            tableView.deselectRow(at: indexPath, animated: true) //снять выделение строки со строки Задача выполнена
        }
    }
    
}
