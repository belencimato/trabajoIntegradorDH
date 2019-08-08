//
//  articlesService.swift
//  BAT
//
//  Created by Tobias Lewinzon on 11/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import Foundation

class ArticlesService {
    
    func getArticlesFromDAO(source: String, section: String, completion: @escaping ([Article]) -> Void) {
        let theArticlesDAO = ArticlesDAO()
        theArticlesDAO.getArticlesFromAPI(source: source, section: section) { (articlesFromDAO) in
            //No hay nada q hacer x ahora
            completion(articlesFromDAO)
        }
    }
    
    func getArticlesFromDAOBySearch(query: String, completion:@escaping ([Article]) -> Void) {
        let theArticlesDAO = ArticlesDAO()
        theArticlesDAO.getArticlesBySearch(query: query) { (searchResults) in
            //Nada q hacer
            print("Soy el service y mando \(searchResults.count) articles al search")
            completion(searchResults)
        }
    }
    
    func getSourcesFromDAO(completion: @escaping ([Source]) -> Void) {
        let theArticlesDAO = ArticlesDAO()
        theArticlesDAO.getSourcesFromAPI { (sourcesFromDAO) in
            //No hay nada que hacer x ahora
            completion(sourcesFromDAO)
        }
    }
}
