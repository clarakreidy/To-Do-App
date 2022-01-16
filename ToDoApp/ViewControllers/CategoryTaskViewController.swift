//
//  CategoryTaskViewController.swift
//  ToDoApp
//
//  Created by Clara Elkreidy on 15/01/2022.
//

import UIKit

class CategoryTaskViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtask", for: indexPath) as! TaskCell
        
        cell.TaskTitle?.text = data[indexPath.row].Title
        cell.Status?.isChecked = data[indexPath.row].IsDone
        return cell
    }
    
    
    var category : String?
    var data = [Todo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Category.text = category ?? ""
        TaskTable.dataSource = self
        Search.delegate = self
        getCategoryTask()
        NotificationCenter.default.addObserver(self, selector: #selector(loadCategoryTasks), name: NSNotification.Name(rawValue: "loadCategoryTasks"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var Category: UILabel!
    @IBOutlet weak var TaskTable: UITableView!
    @IBOutlet weak var Search: UISearchBar!
    
    func getCategoryTask() {
        data = TASKS.filter{ (task: Todo) -> Bool in
            task.Category == category
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TaskViewController {
            let row = TaskTable.indexPathForSelectedRow!.row
            viewController.data = data[row]
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getCategoryTask()
        data = searchText.isEmpty ? data : data.filter { $0.Title.contains(searchText) }
        TaskTable.reloadData()
    }
    
    @objc func loadCategoryTasks(notification: NSNotification){
        getCategoryTask()
        self.TaskTable.reloadData()
    }
}
