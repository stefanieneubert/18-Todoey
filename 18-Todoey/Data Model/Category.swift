//
//  Category.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 18.11.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var color = ""
    let items = List<Item>() // initialize empty list of items
}
