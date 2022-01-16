//
//  TaskViewCell.swift
//  ToDoApp
//
//  Created by Clara Elkreidy on 15/12/2021.
//

import UIKit

class TaskViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var TaskTitle: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
