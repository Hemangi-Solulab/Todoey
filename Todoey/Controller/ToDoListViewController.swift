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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadItems()
        print(dataFilePath)
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
        saveItems()
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
            
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            newTextField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    //MARK: Model manipulation methods
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }catch{
            print("error is \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print(error)
            }
        }
    }
}

