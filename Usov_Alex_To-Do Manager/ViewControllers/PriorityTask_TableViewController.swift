import UIKit

class PriorityTask_TableViewController: UITableViewController {
  
    let cellNibID = "CellPriorityTask"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellTypeNib = UINib(nibName: cellNibID, bundle: nil)
        tableView.register(cellTypeNib, forCellReuseIdentifier: cellNibID)
    }

    typealias PriorityCellDescription = (priority: TaskPriority, title: String, description: String)
    
    private var taskPriorityInformation: [PriorityCellDescription] = [
        (priority: .important, title: "Важная", description: "   Такой тип задач является наиболее приоритетным для выполнения. Все важные задачи выводятся в самом верху списка задач."),
        (priority: .normal, title: "Текущая", description: "   Задача с обычным приоритетом.")
    ]
    
    var selectPriority: TaskPriority = .normal
    var doAfterPrioritySelected: ((TaskPriority) -> Void)?
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectPriority = taskPriorityInformation[indexPath.row].priority
        doAfterPrioritySelected?(selectPriority)
        navigationController?.popViewController(animated: true)
    }
    
}
