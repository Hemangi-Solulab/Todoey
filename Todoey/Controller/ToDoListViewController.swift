//
//  ViewController.swift
//  Todoey
//
//  Created by Ashish Kakkad on 05/06/19.
//  Copyright © 2019 hemangi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    var filteredToDoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.color else{ fatalError() }
        updateNavBar(withHexCode: colorHex)
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    //MARK: Nav Bar setup methods
    
    func updateNavBar(withHexCode colorHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else { fatalError("navigation controller does not exist") }
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        let contrastColor = ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)
      
        navBar.barTintColor = navBarColor
          navBar.isTranslucent = true
        navBar.tintColor = contrastColor
       
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
        searchBar.barTintColor = navBarColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor(hexString: colorHexCode)!.cgColor
        
    }
    
    
    //MARK: Table View data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredToDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = filteredToDoItems?[indexPath.row] {
            
            if let colour = UIColor(hexString: selectedCategory!.color).darken(byPercentage: CGFloat(indexPath.row) / CGFloat(filteredToDoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: colour, returnFlat: true)
                
            }
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating data \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: add new item
    
    @IBAction func addItemBtnPressed(_ sender: UIBarButtonItem) {
        
        var newTextField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let addNewAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = newTextField.text!
                        
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error Saving Data \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            newTextField = alertTextField
        }
        alert.addAction(addNewAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in }))
        self.present(alert, animated: true)
    }
    
    //MARK: Model manipulation methods
    
    
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        filteredToDoItems = toDoItems
        tableView.reloadData()
    }
    
    //MARK: Delete through Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = self.filteredToDoItems?[indexPath.row] {
            do{
                
                try self.realm.write {
                    self.realm.delete(item)
                    toDoItems = filteredToDoItems
                    // tableView.reloadData()
                }
            } catch {
                print("Error Deleting Item \(error)")
            }
        }
        
        
    }
    
}
//MARK: Search bar methods

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        //        tableView.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            
            filteredToDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "title", ascending: true)
            
            tableView.reloadData()
        }
    }
}

