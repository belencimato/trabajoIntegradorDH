//
//  ArticlesPlistDAO.swift
//  BAT
//
//  Created by Tobias Lewinzon on 19/06/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import Foundation
import Alamofire

class ArticlesDAO {
    
    var articlesArray: [Article] = []
    var sourcesArray: [Source] = []
    
    /* Función getArticlesFromAPI: La usa el homeTableViewController para traer los articulos (a traves del service). Toma como parametros source y section, que los setea el usuario en el FilterVC. Se inicializan como "", asi la primera vez que se abre la tabla carga algo. La API del orto no permite un request con source y section, por ende tuve que ingeniarmelas para generar diferentes requests en los diferentes casos. Estan en orden
     CASO A: Source y section son "", hago un request sin parametros. Esto pasa cuando la app recien arranca o el usuario selecciono "any"  y "all sources" en el FitlerVC.
     CASO B: Source NO es "" (o sea contiene una source), y NECESARIAMENTE section debe ser "". Se hace un request con source unicamente.
     CASO C: Es exactamnte al reves que B.
    */
    //CASO A
    func getArticlesFromAPI(source: String, section: String, completiton: @escaping ([Article]) -> Void) {
        if source == "" && section == "" {
            Alamofire.request("https://newsapi.org/v2/top-headlines?country=ar&pageSize=50&apiKey=7f72cbed6a4e4af7aa0e8eda5e79b2b3").responseJSON { (response) in
                if let rootDictionary = response.value as? [String : AnyObject] {
                    if let arrayOfDictionaries = rootDictionary["articles"] as? [[String : AnyObject]] { //Cada diccionario representa un article
                        for oneDictionary in arrayOfDictionaries {
                            let theArticle = Article(dictonary: oneDictionary)
                            self.articlesArray.append(theArticle)
                        }
                        completiton(self.articlesArray)
                    }
                }
            }
        } else
        //CASO B
        if source != "" && section == "" {
            Alamofire.request("https://newsapi.org/v2/top-headlines\(source)&pageSize=50&apiKey=7f72cbed6a4e4af7aa0e8eda5e79b2b3").responseJSON { (response) in
                if let rootDictionary = response.value as? [String : AnyObject] {
                    if let arrayOfDictionaries = rootDictionary["articles"] as? [[String : AnyObject]] { //Cada diccionario representa un article
                        for oneDictionary in arrayOfDictionaries {
                            let theArticle = Article(dictonary: oneDictionary)
                            self.articlesArray.append(theArticle)
                        }
                        completiton(self.articlesArray)
                    }
                }
            }
        } else
        //CASO C
        if source == "" && section != "" {
            Alamofire.request("https://newsapi.org/v2/top-headlines?country=ar&pageSize=50&\(section)&apiKey=7f72cbed6a4e4af7aa0e8eda5e79b2b3").responseJSON { (response) in
                if let rootDictionary = response.value as? [String : AnyObject] {
                    if let arrayOfDictionaries = rootDictionary["articles"] as? [[String : AnyObject]] { //Cada diccionario representa un article
                        for oneDictionary in arrayOfDictionaries {
                            let theArticle = Article(dictonary: oneDictionary)
                            self.articlesArray.append(theArticle)
                        }
                        completiton(self.articlesArray)
                    }
                }
            }
        }
    }
    
    //Funcion para buscar con palabras
    func getArticlesBySearch(query: String, completion: @escaping ([Article]) -> Void) {
        
        let parameters = ["q" : query]
        
        Alamofire.request("https://newsapi.org/v2/everything?apiKey=7f72cbed6a4e4af7aa0e8eda5e79b2b3", parameters: parameters).responseJSON {
            (response) in
            if let rootDictionary = response.value as? [String : AnyObject] {
                if let arrayOfDictionaries = rootDictionary["articles"] as? [[String : AnyObject]] { //Cada diccionario representa un article
                    for oneDictionary in arrayOfDictionaries {
                        let theArticle = Article(dictonary: oneDictionary)
                        self.articlesArray.append(theArticle)
                    }
                    completion(self.articlesArray)
                }
            }
        }
    }
    
    //Función getSourcesFromAPI: Trae todos los sources para que los tome el sourcesTableView dentro de FilterViewController.
    func getSourcesFromAPI(completion: @escaping ([Source]) -> Void) {
        Alamofire.request("https://newsapi.org/v2/sources?apiKey=7f72cbed6a4e4af7aa0e8eda5e79b2b3").responseJSON { (response) in
            if let rootDictonary = response.value as? [String : AnyObject] {
                if let arrayOfDictionaries = rootDictonary["sources"] as? [[String : AnyObject]] { //Cada diccionario representa una source
                    for oneDictionary in arrayOfDictionaries {
                        let theSoure = Source(dictonary: oneDictionary)
                        self.sourcesArray.append(theSoure)
                    }
                    completion(self.sourcesArray)
                }
            }
        }
    }
    
}
