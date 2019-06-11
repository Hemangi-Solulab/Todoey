//
//  Item.swift
//  Todoey
//
//  Created by Ashish Kakkad on 10/06/19.
//  Copyright © 2019 hemangi. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date = Date()
    
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
    
}
