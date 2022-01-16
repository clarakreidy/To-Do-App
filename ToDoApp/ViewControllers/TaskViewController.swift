//
//  TaskViewController.swift
//  ToDoApp
//
//  Created by Clara Elkreidy on 03/12/2021.
//

import UIKit

class TaskViewController: UIViewController {
    
    var data: Todo?
    
    lazy private var dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateStyle = .short
            df.timeStyle = .short
            return df
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = data {
            TaskTitle.text = task.Title
            TaskDescription.text = task.TaskDescription
            Category.text = task.Category
            if (data?.DueDate != nil) {
                DueDate.text = dateFormatter.string(from: task.DueDate!)
            } else {
                DueDate.text = "Date not set..."
            }
            
        } else {
            TaskTitle.text = "404 ERROR"
            TaskDescription.text = ""
        }
        TaskDescription.isEditable = false
    }

    @IBAction func SetDone(_ sender: UIButton) {
        if let todo = data {
            DB.changeStatus(todo: todo)
            TASKS = DB.getAllTodos()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadCalendar"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadCategoryTasks"), object: nil)
        
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var TaskTitle: UILabel!
    @IBOutlet weak var TaskDescription: UITextView!
    @IBOutlet weak var DueDate: UILabel!
    @IBOutlet weak var Category: UILabel!
    
}
