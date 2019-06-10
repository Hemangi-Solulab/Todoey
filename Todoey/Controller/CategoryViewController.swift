//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ashish Kakkad on 08/06/19.
//  Copyright © 2019 hemangi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel!.text = category.name
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: Data Manipulation Methods
    
    func loadCategories(){
        do{
            /**************************************************************/
//            let request : NSFetchRequest<Category> =
            categoryArray = try context.fetch(Category.fetchRequest() as  NSFetchRequest<Category>)
        }catch{
            print("Error in fetching Data \(error)")
        }
        tableView.reloadData()
    }
    
    func saveCategories(){
        do{
            try context.save()
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
            
            let newCategory = Category(context: self.context)
            newCategory.name = newCategoryTextField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new Category"
            newCategoryTextField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    
    
    
    
    
}
