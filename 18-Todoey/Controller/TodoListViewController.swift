//
//  ViewController.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 20.09.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults: UserDefaults = UserDefaults.standard
    // init the item array as an array of items
    var itemArray = [Item]()
    
    // create the Items.plist in the file manager of the app
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add some random items (they will be overwritten if there are items stored already below)
        let defaultItem = Item()
        defaultItem.title = "Buy cherries"
        itemArray.append(defaultItem)

        let defaultItem2 = Item()
        defaultItem2.title = "Make tea"
        itemArray.append(defaultItem2)
        
        // retrieve the items from the storage
//        if let storedItemArray = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = storedItemArray
//        }
        
        loadItems()
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
                let newItem = Item()
                newItem.title = text
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
        
        // encode the new item and save it to the file path
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encodig data: \(error)")
        }
        
        // reload the data in the table view
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                try itemArray = decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding data: \(error)")
            }
        }
    }
    
}
