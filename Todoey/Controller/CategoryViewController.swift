//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ashish Kakkad on 08/06/19.
//  Copyright © 2019 hemangi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var realm = try! Realm()
    
    var catgories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catgories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel!.text = catgories?[indexPath.row].name ?? "No Categories added yet"
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catgories?[indexPath.row]
        }
    }
    
    //MARK: Data Manipulation Methods
    
    func loadCategories(){
       catgories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error Saving Data \(error)")
        }
        tableView.reloadData()
    }
    //MARK: Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newCategoryTextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = newCategoryTextField.text!
          
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new Category"
            newCategoryTextField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    
    
    
    
    
}
