//
//  ForYouCollectionViewCell.swift
//  BAT
//
//  Created by Belen Cimato on 26/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import Kingfisher

class ForYouCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageCollection: UIImageView!
//    @IBOutlet weak var isFavoriteBtn: UIButton!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
//    var delegateFavoriter: ArticleFavoriter?

    var article: Article?
    
    func setup(article: Article) {
        
        self.article = article
//        self.delegateFavoriter = delegate
        sourceLabel.text = "   " + article.source
        titleLabel.text = article.title
        
        
        //traigo img con kingfisher
        let imageURL = URL(string: "\(article.urlToImage)")
        imageCollection.kf.setImage(with: imageURL,
                               placeholder: UIImage(named: "placeHolder-square"),
                               options: [
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
            ])
    }
}
