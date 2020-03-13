//
//  Models.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-11.
//  Copyright © 2020 JRE. All rights reserved.
//

import Foundation
import Mapper

struct Category: Mappable {
    let id: Int
    let name: String
    let count: Int
    
    init(map: Mapper) throws {
        id = try map.from("id")
        name = try map.from("name")
        count = try map.from("count")
    }
}

struct Ad: Mappable {
    let id: Int
    let title: String
    let price: String
    let imageUrl: URL?
    
    init(map: Mapper) throws {
        id = try map.from("id")
        title = try map.from("title")
        price = try map.from("price")
        imageUrl = try map.from("imageUrl")
    }
}
