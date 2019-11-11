//
//  CategoryViewController.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 08.11.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    // create the Categories.plist in the file manager of the app
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        let category = Category(context: context)
//        category.name = "Einkaufen"
//        categoryArray.append(category)
//
//        let category1 = Category(context: context)
//        category1.name = "Erledigen"
//        categoryArray.append(category1)
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching context: \(error)")
        }
        
        // reload the data in the table view
        tableView.reloadData()
        
    }
    
    // MARK: - Data Manipulation Methods
    
    // Save data to app storage
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        // reload the data in the table view
        tableView.reloadData()
    }
    
    // MARK: - Add Categories

    // create IBAction: ctrl + drag from element to view
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                // what happens if the user clicks "add item" on the alert
                if let text = textField.text {
                    
                    // newItem now has to be initialized with the context of the app delegate
                    let newCategory = Category(context: self.context)
                    newCategory.name = text
                    self.categoryArray.append(newCategory)
    //                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                    self.saveCategories()
                }
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Add new item"
                textField = alertTextField
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
}
