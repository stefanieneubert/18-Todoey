//
//  ViewController.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 20.09.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    // create segue:
    // ctrl + drag from yellow icon abore the view to the new contoller
    // click on the "Show" segue
    // click on segue, specify identifier (goToItems)
    
    // specify a new root view controller:
    // ctrl + drag from yellow icon above the view to the new controller,
    // click on Relationship Segue - root view controller
    
    let realm = try! Realm()
    var items : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // create the Items.plist in the file manager of the app
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        //install datum free
    }
    
    // MARK: - Tableview Datasource Methods
    // What the cells display, how many rows displayed
    // These methods are also called in tableView.reloadData
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    // MARK: - TableVies Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    // realm.delete(item)
                }
            } catch {
                print("Error updating item done status")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens if the user clicks "add item" on the alert
            if let text = textField.text {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = text // "done" already has default value of false
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving context: \(error)")
                    }
                }

                // reload the data in the table view
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Mark: Model manipulation methods
    // with = external parameter name, request = internal parameter name
    // default value = Item.fetchRequest()
    func loadItems() {

        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        // reload the data in the table view
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    // This method gets triggered if the user swipes a cell
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = items?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error updating item done status")
            }
        }
    }
    
}

// MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }

    // reload all items if search text is deleted
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()

            // run this explicitly on the main thread
            DispatchQueue.main.async {
                // original state before search bar was focused
                // (no keyboard showing, search bar not focused)
                searchBar.resignFirstResponder()
            }
        }
    }

}

