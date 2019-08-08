//
//  Article.swift
//  BAT
//
//  Created by Tobias Lewinzon on 05/06/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import Foundation

class Article: Equatable {
    
    //Implementamos protocolo equatable para encontrar articles en un array de articles
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.url == rhs.url
    }
    
    var source: String
    var author: String
    var title: String
    var description: String
    var url: String // Link al articulo
    var urlToImage: String // Link a la foto
    var publishedAt: String
    var content: String
    var isFavorite: Bool
    
    init(source: String, author: String, title: String, description: String, url: String, imageUrl: String, publishedAt: String, content: String) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = imageUrl
        self.publishedAt = publishedAt
        self.content = content
        self.isFavorite = false
    }
    
    init(dictonary: [String : AnyObject]) {
        if let sourceData = dictonary["source"] as? [String : AnyObject] {
            self.source = sourceData["name"] as? String ?? "No data"
        } else {
            self.source = "No data"
        }
      //  self.source = (dictonary["source"] as? [String : AnyObject]) ["name"] as? String ?? "No data"
        self.author = dictonary["author"] as? String ?? "No data"
        self.title = dictonary["title"] as? String ?? "No data"
        self.description = dictonary["description"] as? String ?? "No data"
        self.url = dictonary["url"] as? String ?? "No data"
        self.urlToImage = dictonary["urlToImage"] as? String ?? "No data"
        self.publishedAt = dictonary["publishedAt"] as? String ?? "No data"
        self.content = dictonary["content"] as? String ?? "No content data"
        self.isFavorite = false
    }
    
    //Funcion para cambiar el estado del favorito
    func toggleFavorite() {
        // se invierte el valor del booleano
        // si era true pasa a ser false, y viceversa
        isFavorite = !isFavorite
    }
    
    func convertToDictonary() -> [String : AnyObject] {
        return ["source" : source,
                "author" : author,
                "title" : title,
                "description" : description,
                "url" : url,
                "urlToImage" : urlToImage,
                "publishedAt" : publishedAt,
                "content" : content] as [String : AnyObject]
    }
    
}

