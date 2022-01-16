//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Clara Elkreidy on 15/01/2022.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CATEGORIES.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryCell
        
        cell.Category?.text = CATEGORIES[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var CategoryInput: UITextField!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var CategoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            DB.deleteCategory(category: CATEGORIES[row])
            CATEGORIES = DB.getAllCategory()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func loadList(notification: NSNotification){
        self.CategoryTable.reloadData()
    }
    @IBAction func ButtonClick(_ sender: UIButton) {
        if (!(CategoryInput.text?.isEmpty ?? true)) {
            if (!CATEGORIES.contains(CategoryInput.text!)) {
                DB.insertCategory(category: CategoryInput.text!)
                CATEGORIES = DB.getAllCategory()
            }
        }
        CategoryTable.reloadData()
        CategoryInput.text = ""
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? CategoryTaskViewController {
            viewController.category = CATEGORIES[CategoryTable.indexPathForSelectedRow!.row]
        }
    }
}
