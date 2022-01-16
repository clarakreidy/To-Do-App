//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Clara Elkreidy on 03/12/2021.
//

import UIKit

class TaskCell: UITableViewCell {


    @IBOutlet weak var Status: Checkbox!
    @IBOutlet weak var TaskTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
