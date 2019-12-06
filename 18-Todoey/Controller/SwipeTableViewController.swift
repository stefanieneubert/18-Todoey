//
//  SwipeTableViewController.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 03.12.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import UIKit
import SwipeCellKit

// This is the super class
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    // In the Main.storyboard, select the
    // Todoey Scene - Todoey - Table View - Cell and
    // on the attributes inspector, give it the identifier "Cell"
    // as well for Item Scene - Item - Table View - Cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    // TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // Also, go to Main.storyboard, select the category cell in the list
        // and (in the identity inspector on the right) set the class to SwipeTableViewCell
        // and the module to SwipeCellKit

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        print("SwipeTableViewController updateModel called")
    }
}
