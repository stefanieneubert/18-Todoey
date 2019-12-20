//
//  CategoryViewController.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 08.11.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // change color of navigation bar:
    // in Main.storyboard, click on the Navigation Bar in the Navigation Controller
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        let colorHex = "E5F7FF"
        navBar.barTintColor = UIColor(hexString: colorHex) // iOS 12
        navBar.backgroundColor = UIColor(hexString: colorHex) // iOS 13
        
        if let navBarColor = UIColor(hexString: colorHex) {
            let contrastColor = ContrastColorOf(navBarColor, returnFlat: true)
            navBar.tintColor = contrastColor
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : contrastColor]
        }
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // nil coalescing operator (ternary):
        // if categories not nil return count, else return 1
        // (if this is not nil return this) ?? (else that)
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name ?? "No categories added yet"
            cell.backgroundColor = UIColor(hexString: category.color ?? "E5F7FF")
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }

        return cell
    }
    
    // MARK: - Data Manipulation Methods
    
    // Save data to app storage
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        
        // reload the data in the table view
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {

        // not required here, but this calls the super class function
        super.updateModel(at: indexPath)
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error updating item done status")
            }
        }
    }
    
    
    // MARK: - Add Categories

    // create IBAction: ctrl + drag from element to view
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                // what happens if the user clicks "add item" on the alert
                if let text = textField.text {
                    let newCategory = Category()
                    newCategory.name = text
                    newCategory.color = UIColor.randomFlat().hexValue()
                    self.save(category: newCategory)
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}
