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

    }
}
