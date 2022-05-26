//
//  PriorityTask_TableViewController.swift
//  Usov_Alex_To-Do Manager
//
//  Created by Алексей Попроцкий on 26.05.2022.
//

import UIKit

class PriorityTask_TableViewController: UITableViewController {
  
    let cellNibID = "CellPriorityTask" // идентификатор соответсвует имени файла .swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellTypeNib = UINib(nibName: cellNibID, bundle: nil)
        tableView.register(cellTypeNib, forCellReuseIdentifier: cellNibID) //регистрируем ячейку
    }

    typealias PriorityCellDescription = (priority: TaskPriority, title: String, description: String)
    
    private var taskPriorityInformation: [PriorityCellDescription] = [
        (priority: .important, title: "Важная", description: "   Такой тип задач является наиболее приоритетным для выполнения. Все важные задачи выводятся в самом верху списка задач."),
        (priority: .important, title: "Текущая", description: "   Задача с обычным приоритетом.")
    ]
    
    var selectPriority: TaskPriority = .normal
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskPriorityInformation.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellNibID, for: indexPath) as! CellPriorityTask
        
        let priorityDescription = taskPriorityInformation[indexPath.row]
        
        cell.labelPriorityTitle.text = priorityDescription.title
        cell.labelDescriptionPriority.text = priorityDescription.description
        
        if selectPriority == priorityDescription.priority {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    

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
