//
//  ViewController.swift
//  Todoey
//
//  Created by Ashish Kakkad on 05/06/19.
//  Copyright © 2019 hemangi. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK: Table View data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
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
            
            let newItem = Item(context: self.context)
            newItem.title = newTextField.text!
            newItem.parentCategory = self.selectedCategory
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
        do{
            try context.save()
        }catch{
            print("Error saving context..\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ){
       
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error loading context..\(error)")
        }
        tableView.reloadData()
    }
    
}
//MARK: Search bar methods
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with : request , predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
    
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }else{
            
        }
    }
}


