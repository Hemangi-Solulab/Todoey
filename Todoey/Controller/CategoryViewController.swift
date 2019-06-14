//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ashish Kakkad on 08/06/19.
//  Copyright © 2019 hemangi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import ColorSlider


class CategoryViewController: SwipeTableViewController {
    
    
    
    var realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        loadCategories()
        
    }
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
        cell.textLabel!.text = category.name
            guard let categoryColor = UIColor(hexString: category.color) else { fatalError()}
        cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor: categoryColor, returnFlat: true)
        } else {
            cell.textLabel!.text = "No Categories added yet"
            cell.backgroundColor = UIColor(hexString: "007AFF")
        }
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    
    //MARK: Data Manipulation Methods
    
    func loadCategories(){
        categories = realm.objects(Category.self)
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
    
    //MARK: Delete data through Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryToBeDeleted = self.categories?[indexPath.row] {
            do{
                
                try self.realm.write {
                    self.realm.delete(categoryToBeDeleted)
                    // tableView.reloadData()
                }
            } catch {
                print("Error Deleting Category \(error)")
            }
        }
        
    }
    
    
    
    //MARK: Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newCategoryTextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addNewAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = newCategoryTextField.text!
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new Category"
            newCategoryTextField = alertTextField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in}
        alert.addAction(addNewAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    
}
//extension CategoryViewController : SwipeTableViewCellDelegate {
//    //MARK: Swipe Table View Cell Delegate Methods
//   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            if let item = self.catgories?[indexPath.row] {
//                do{
//
//                    try self.realm.write {
//                        self.realm.delete(item)
//                       // tableView.reloadData()
//                    }
//                } catch {
//                    print("Error Deleting Category \(error)")
//                }
//            }
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "TrashIcon")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
// 
//        return options
//    }
//}
