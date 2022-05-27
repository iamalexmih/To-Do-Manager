//
//  TaskEdit_TableViewController.swift
//  Usov_Alex_To-Do Manager
//
//  Created by Алексей Попроцкий on 26.05.2022.
//

import UIKit

class TaskEdit_TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitleTask?.text = taskText
        labelTaskPriority?.text = namePriorityForTask[taskPriority]
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }
    }

    var taskText: String = ""
    var taskPriority: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    var namePriorityForTask: [TaskPriority : String] = [
        .important : "Важная",
        .normal : "Текущая"
    ]
    
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)? // замыкание для передачи данных
    
    @IBOutlet weak var labelTitleTask: UITextField!
    @IBOutlet weak var labelTaskPriority: UILabel!
    @IBOutlet weak var taskStatusSwitch: UISwitch!
    
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        //получаем актуальные значения
        let title = labelTitleTask?.text ?? ""
        let priority = taskPriority
        let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
        
        doAfterEdit?(title, priority, status)
        
        navigationController?.popViewController(animated: true)
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
