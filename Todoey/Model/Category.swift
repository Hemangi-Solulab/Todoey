//
//  Category.swift
//  Todoey
//
//  Created by Ashish Kakkad on 10/06/19.
//  Copyright © 2019 hemangi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
