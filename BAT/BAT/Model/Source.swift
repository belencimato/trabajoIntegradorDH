//
//  Source.swift
//  BAT
//
//  Created by Tobias Lewinzon on 09/06/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import Foundation

class Source {
    var id: String
    var name: String
    var description: String
    var url: String
    var category: String
    var language: String
    var country: String
    // IDEA: Para filtrar por fuente, que los soruces tengan un array de articulos a ver si las lógicas son más faciles 🤯
    var articles: [Article]
    
    init(id: String, name: String, description: String, url: String, category: String, language: String, country: String) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.category = category
        self.language = language
        self.country = country
        self.articles = []
    }
    
    init(dictonary: [String : AnyObject]) {
        self.id = dictonary["id"] as? String ?? "No data"
        self.name = dictonary["name"] as? String ?? "No data"
        self.description = dictonary["description"] as? String ?? "No data"
        self.url = dictonary["url"] as? String ?? "No data"
        self.category = dictonary["category"] as? String ?? "No data"
        self.language = dictonary["language"] as? String ?? "No data"
        self.country = dictonary["country"] as? String ?? "No data"
        self.articles = []
    }
}
