//
//  Category.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 27/07/24.
//

import Foundation

struct Category: Hashable {
    let name : String
    let imageName: String
}

let categories = [
    Category(name: "Add Money", imageName: "add_money"),
    Category(name: "Food and Drinks", imageName: "food_and_drinks"),
    Category(name: "Party", imageName: "party"),
    Category(name: "Rent", imageName: "rent"),
    Category(name: "Travel", imageName: "travel"),
    Category(name: "Others", imageName: "others")
]
