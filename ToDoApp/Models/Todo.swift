//
//  Task.swift
//  ToDoApp
//
//  Created by Clara Elkreidy on 03/12/2021.
//

import UIKit

class Todo: NSObject {
    
    var Id : Int = 0
    var Title : String = ""
    var TaskDescription : String = ""
    var IsDone : Bool = false
    var DueDate : Date? = nil
    var Category : String = ""

    init(title: String, desc: String, id: Int, done: Bool = false, date: Date? = nil, category: String = "") {
        self.Id = id
        self.Title = title
        self.TaskDescription = desc
        self.IsDone = done
        self.DueDate = date
        self.Category = category
    }
}

var TASKS = [Todo]()
