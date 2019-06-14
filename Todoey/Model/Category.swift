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
    @objc dynamic var color: String = UIColor.randomFlat().hexValue()
    let items = List<Item>()
    
}
