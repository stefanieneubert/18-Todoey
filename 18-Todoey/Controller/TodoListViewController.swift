//
//  ViewController.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 20.09.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    let defaults: UserDefaults = UserDefaults.standard
    // init the item array as an array of items
    var itemArray = [Item]()
    
    // create the Items.plist in the file manager of the app
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        //install datum free
    }
    
    // MARK Tableview Datasource Methods
    // What the cells display, how many rows displayed
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    // MARK TableVies Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // update:
        // itemArray[indexPath.row].setValue("", forKey: "title")
        
        // delete
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens if the user clicks "add item" on the alert
            if let text = textField.text {
                
                // newItem now has to be initialized with the context of the app delegate
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                self.itemArray.append(newItem)
//                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.saveItems()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK Save data to app storage
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        // reload the data in the table view
        tableView.reloadData()
    }
    
    // with = external parameter name, request = internal parameter name
    // default value = Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching context: \(error)")
        }
        
        // reload the data in the table view
        tableView.reloadData()
    }
    
}

// MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // uses Objective C to search database. More to find on NSPredicate cheat sheets
        // [cd] = insensitive to case and diacritic
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
         // sort the result by title
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
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

