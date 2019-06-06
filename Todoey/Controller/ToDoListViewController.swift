//
//  ViewController.swift
//  Todoey
//
//  Created by Ashish Kakkad on 05/06/19.
//  Copyright © 2019 hemangi. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
                    itemArray = items
                }
        
        var newItem = Item()
        newItem.title = "Monday"
        itemArray.append(newItem)
        
        var newItem2 = Item()
        newItem2.title = "Tuesday"
        itemArray.append(newItem2)
        
        var newItem3 = Item()
        newItem3.title = "Wednesday"
        itemArray.append(newItem3)
        
    }
    //MARK: Table View data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! UITableViewCell
        
        var item = itemArray[indexPath.row]
        cell.textLabel!.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
      
        return cell
        
    }
    
    
    //MARK: Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: add new item
    
    @IBAction func addItemBtnPressed(_ sender: UIBarButtonItem) {
        
        var newTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            var newItem = Item()
            newItem.title = newTextField.text!
            self.itemArray.append(newItem)
                 self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            newTextField = alertTextField
            
            
            
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
