//
//  File.swift
//  BAT
//
//  Created by Belen Cimato on 05/08/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import Foundation

class Note {
    
    var title:String?
    var text: String
    
    init(title:String, text: String) {
        self.title = title
        self.text = text
    }
    
    init(dictionary: [String: AnyObject]) {
        self.title = dictionary["title"] as? String ?? "No title"
        self.text = dictionary["text"] as? String ?? "No note"
    }
    
    func convertToDictonary() -> [String: AnyObject] {
        return ["title": title, "text": text] as [String: AnyObject]
    }
    
}
