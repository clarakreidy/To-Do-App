//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Clara Elkreidy on 05/12/2021.
//

import UIKit

class AddTaskViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CATEGORIES.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CATEGORIES[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskDescription.delegate = self

        taskDescription.text = "More info..."
        taskDescription.textColor = UIColor.lightGray
        
        category.dataSource = self
        category.delegate = self
    }

    @IBAction func saveButton(_ sender: UIButton) {
        let category = CATEGORIES.count>0 ? CATEGORIES[category.selectedRow(inComponent: 0)] : ""
        
        let todo = Todo(
            title: (taskTitle.text!.isEmpty ? "Untitled" : taskTitle.text) ?? "Untitled",
            desc: taskDescription.text.elementsEqual("More info...") ? "" : taskDescription.text,
            id: TASKS.count + 1,
            done: false,
            date: dueDate.date,
            category: category)
        DB.insertTodo(todo: todo)
        TASKS = DB.getAllTodos()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        navigationController?.popViewController(animated: true)
        
    }

    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var category: UIPickerView!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "More info..."
            textView.textColor = UIColor.lightGray
        }
    }

}
