//
//  ViewController.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 20.09.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
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
        return items?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
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
        self.tableView.reloadData()
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
    
    // with = external parameter name, request = internal parameter name
    // default value = Item.fetchRequest()
    func loadItems() {

        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        // reload the data in the table view
        tableView.reloadData()
    }
    
}

// MARK: - Search bar methods
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        // uses Objective C to search database. More to find on NSPredicate cheat sheets
//        // [cd] = insensitive to case and diacritic
//        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//         // sort the result by title
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: searchPredicate)
//    }
//
//    // reload all items if search text is deleted
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.count == 0 {
//            loadItems()
//
//            // run this explicitly on the main thread
//            DispatchQueue.main.async {
//                // original state before search bar was focused
//                // (no keyboard showing, search bar not focused)
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//}

