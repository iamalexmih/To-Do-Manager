//
//  TaskCellPrototypeTableViewCell.swift
//  Usov_Alex_To-Do Manager
//
//  Created by Алексей Попроцкий on 25.05.2022.
//

import UIKit

class TaskCellPrototype: UITableViewCell {

    @IBOutlet weak var labelForStatusTask: UILabel!
    
    @IBOutlet weak var labelTitleTask: UILabel!
    
    func setup(currentTask: TaskModelProtokol) {
        labelTitleTask.text = currentTask.title
        labelForStatusTask.text = getLabelForStatusTask(with: currentTask.status)
    }
    // MARK: - sign point for Label  Status Task
    private func getLabelForStatusTask(with status: TaskStatus) -> String {
        var resultLabel: String
        
        switch status {
            case .planned:
                resultLabel = "\u{25CB}"
                labelTitleTask.textColor = UIColor(named: "taskPlanedColor")
                labelForStatusTask.textColor = UIColor(named: "taskPlanedColor")
            case .completed:
                resultLabel = "\u{25C9}"
                labelTitleTask.textColor = UIColor(named: "taskCompledColor")
                labelForStatusTask.textColor = UIColor(named: "taskCompledColor")
        }
        return resultLabel
    }
}
