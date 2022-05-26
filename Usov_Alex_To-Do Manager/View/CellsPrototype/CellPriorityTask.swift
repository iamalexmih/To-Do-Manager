//
//  CellPriorityTask.swift
//  Usov_Alex_To-Do Manager
//
//  Created by Алексей Попроцкий on 26.05.2022.
//

import UIKit

class CellPriorityTask: UITableViewCell {

    
    @IBOutlet weak var labelPriorityTitle: UILabel!
    @IBOutlet weak var labelDescriptionPriority: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
