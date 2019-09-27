//
//  Item.swift
//  18-Todoey
//
//  Created by Stefanie Neubert on 27.09.19.
//  Copyright © 2019 Stefanie Neubert. All rights reserved.
//

import Foundation

// class must be encodable to save it with the encoder to the file path
class Item: Codable { // Codable = Encodable, Decodable
    var title: String = ""
    var done: Bool = false
}
