//
//  DatabaseConnection.swift
//  ToDoApp
//
//  Created by Charbel El Hajj on 15/01/2022.
//
import SQLite3
import UIKit

class DB {
    static func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        let fileURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("db.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening db")
        }
        return db
    }
    
    static func createTodoTable() {
        let query = "CREATE TABLE IF NOT EXISTS Todo (Id INTEGER PRIMARY KEY AUTOINCREMENT, Title TEXT, TaskDescription TEXT, IsDone INTEGER, DueDate TEXT, Category TEXT)"
        
        if sqlite3_exec(openDatabase(), query, nil, nil, nil) != SQLITE_OK {
            print("error creating table todo")
        }
    }
    
    static func createCategoryTable() {
        let query = "CREATE TABLE IF NOT EXISTS Category (Id INTEGER PRIMARY KEY AUTOINCREMENT, Category TEXT)"
        
        if sqlite3_exec(openDatabase(), query, nil, nil, nil) != SQLITE_OK {
            print("error creating table Category")
        }
    }
    
    static func insertCategory(category: String) {
        var statement: OpaquePointer?
        let query = "INSERT INTO Category (Category) VALUES (?)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy-dd HH:mm:ss"
        
        let db = openDatabase()
        
        if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(openDatabase())!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(statement, 1, category, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting category: \(errmsg)")
                    return
        }
    }
    // TODO: isDone
    static func insertTodo(todo: Todo) {
        var statement: OpaquePointer?
        let query = "INSERT INTO Todo (Title, TaskDescription, IsDone, DueDate, Category) VALUES ('\(todo.Title)', '\(todo.TaskDescription)', ?, ?, ?)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy-dd HH:mm:ss"
        
        let db = openDatabase()
        
        if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(openDatabase())!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
//        if sqlite3_bind_text(statement, 1, "aka", -1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure binding name: \(errmsg)")
//            return
//        }
//        if sqlite3_bind_text(statement, 2, "todo.d", -1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure binding name: \(errmsg)")
//            return
//        }
        if sqlite3_bind_int(statement, 1, todo.IsDone ? 1 : 0) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_text(statement, 2, dateFormatter.string(from: todo.DueDate ?? Date.today()), -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_text(statement, 3, todo.Category, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_step(statement) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting todo: \(errmsg)")
                    return
        }
    }
    
    
    static func getAllCategory() -> [String]{
        let db = openDatabase()
        
     
        //first empty the list of heroes
        var categories = [String]()
 
        //this is our select query
        let queryString = "SELECT * FROM Category"
 
        //statement pointer
        var stmt:OpaquePointer?
 
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return []
        }
 
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let Category = String(cString: sqlite3_column_text(stmt, 1))
            //adding values to list
            
            categories.append(Category)
        }
        
        return categories
     
        
    }
        
    static func getAllTodos() -> [Todo]{
        let db = openDatabase()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy-dd HH:mm:ss"
     
        //first empty the list of heroes
        var todos = [Todo]()
 
        //this is our select query
        let queryString = "SELECT * FROM Todo ORDER BY dueDate ASC"
 
        //statement pointer
        var stmt:OpaquePointer?
 
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return []
        }
 
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let id = sqlite3_column_int(stmt, 0)
            let Title = String(cString: sqlite3_column_text(stmt, 1))
            let TaskDescription = String(cString: sqlite3_column_text(stmt, 2))
            let IsDone = sqlite3_column_int(stmt, 3) == 1
            let DueDate = dateFormatter.date(from: String(cString: sqlite3_column_text(stmt, 4)))
            let Category = String(cString: sqlite3_column_text(stmt, 5))
            //adding values to list
            let todo = Todo(title: Title, desc: TaskDescription, id: Int(id), done: IsDone, date: DueDate, category: Category)
            todos.append(todo)
        }
        
        return todos
     
        
    }
    
    static func deleteCategory(category: String) {
        var statement: OpaquePointer?
        let query = "DELETE FROM Category WHERE Category = ?"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy-dd HH:mm:ss"
        
        let db = openDatabase()
        
        if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(openDatabase())!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(statement, 1, category, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting category: \(errmsg)")
                    return
        }
    }
    
    static func deleteTodo(todo: Todo) {
        var statement: OpaquePointer?
        let query = "DELETE FROM Todo WHERE id = ?"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy-dd HH:mm:ss"
        
        let db = openDatabase()
        
        if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(openDatabase())!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(statement, 1, Int32(todo.Id)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting category: \(errmsg)")
                    return
        }
    }
    
    
    static func changeStatus(todo: Todo) {
        var statement: OpaquePointer?
        let query = "Update Todo SET IsDone = 1 WHERE id = ?"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy-dd HH:mm:ss"
        
        let db = openDatabase()
        
        if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(openDatabase())!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(statement, 1, Int32(todo.Id)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting category: \(errmsg)")
                    return
        }
    }
}
