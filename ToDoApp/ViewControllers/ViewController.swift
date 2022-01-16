//
//  ViewController.swift
//  ToDoApp
//
//  Created by Clara Elkreidy on 03/12/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TASKS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtask", for: indexPath) as! TaskCell
        
        cell.TaskTitle?.text = TASKS[indexPath.row].Title
        cell.Status?.isChecked = TASKS[indexPath.row].IsDone
        return cell
    }
    
    @IBOutlet weak var tasksDataView: UITableView!
    @IBOutlet weak var PageTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = DB.openDatabase()
        DB.createTodoTable()
        DB.createCategoryTable()
        PageTitle.text = "Todo List"
        TASKS = DB.getAllTodos()
        CATEGORIES = DB.getAllCategory()
        tasksDataView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func loadList(notification: NSNotification){
        self.tasksDataView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TaskViewController {
            let row = tasksDataView.indexPathForSelectedRow!.row
            viewController.data = TASKS[row]
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let row = indexPath.row
                DB.deleteTodo(todo: TASKS[row])
                TASKS = DB.getAllTodos()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
}

