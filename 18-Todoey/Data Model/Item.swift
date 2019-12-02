//
//  Item.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 18.11.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    // Category == class, Category.type == type
    // LinkingObjects = inverse relationship to parent
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
