//
//  Data.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 18.11.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
