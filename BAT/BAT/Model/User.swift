//
//  User.swift
//  BAT
//
//  Created by Tobias Lewinzon on 20/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import Foundation

class User {
    var email: String
    var ID: String
    var favorites: [Article] = []
    var notes: [Note] = []
    
    public init(ID: String, email: String) {
        self.email = email
        self.ID = ID
    }
    
    public init(dictonary: [String : AnyObject]) {
        self.email = dictonary["email"] as? String ?? "No dataaa"
        self.ID = dictonary["ID"] as? String ?? "No dataaa"
        self.favorites = self.convertArrayOfDictonariesToArrayOfObjects(array: dictonary["favorites"] as? [[String : AnyObject]] ?? [[:]])
        self.notes = self.convertArrayOfDictonariesToArrayOfObjectsNotes(array: dictonary["notes"] as? [[String : AnyObject]] ?? [[:]])
    }
    
    //Estas dos funcione me convierten un objeto usuario en un diccionairo para subir a firebase
    func getArrayDeDiccionariosQueSonArticles() -> [[String : AnyObject]] {
        var array: [[String : AnyObject]] = []
        for oneArticle in self.favorites {
            let dictonary = oneArticle.convertToDictonary()
            array.append(dictonary)
        }
        return array
    }
    //Estas funcion get es para traer las notes de firebase
    func getArrayDeDiccionariosQueSonNotes() -> [[String : AnyObject]] {
        var array: [[String : AnyObject]] = []
        for oneNote in self.notes {
            let dictonary = oneNote.convertToDictonary()
            array.append(dictonary)
        }
        return array
    }
    
    //Convierto articulo a diccionario para subir a firebase
    func convertArrayOfDictonariesToArrayOfObjects(array: [[String : AnyObject]]) -> [Article] {
        var articles: [Article] = []
        for oneDictonary in array {
            let favoriteArticle = Article(dictonary: oneDictonary)
            articles.append(favoriteArticle)
        }
        return articles
    }
    
    //Convierto la nota a diccionario para subir a firebase
    func convertArrayOfDictonariesToArrayOfObjectsNotes(array: [[String : AnyObject]]) -> [Note] {
        var notes: [Note] = []
        for oneDictonary in array {
            let favoriteArticle = Note(dictionary: oneDictonary)
            notes.append(favoriteArticle)
        }
        return notes
    }
    
    //Necesito convertir un array de articulos a un array de diccionarios, esto lo hace. Lo que retorna se lo doy como parametro aca abajo
    func convertToDictonary() -> [String : AnyObject] {
        return ["email" : email, "ID": ID, "favorites" : self.getArrayDeDiccionariosQueSonArticles(), "notes" : self.getArrayDeDiccionariosQueSonNotes()] as [String : AnyObject]
    }
    //funcion para appendear notas
    func appendNewNote (newNote:Note) {
        notes.append(newNote)
    }
}
