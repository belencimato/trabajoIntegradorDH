//
//  ImageTableViewCell.swift
//  BAT
//
//  Created by Tobias Lewinzon on 05/06/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseAuth
import DCAnimationKit

class GenericTableViewCell: UITableViewCell {
        
    var article: Article?
    var delegateFavoriter: ArticleFavoriter?
    var delegateHomeTable: UITableViewController?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var isFavoriteBtn: UIButton!
    @IBOutlet weak var publishedAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func makeFavorite(_ sender: UIButton) {
        delegateFavoriter?.toggleFavorite(inCell: self)
        if let theArticle = article {
            if theArticle.isFavorite {
                isFavoriteBtn.setImage(UIImage(named: "heart-new-big-red"), for: .normal)
                sender.pulse(nil)
            } else {
                isFavoriteBtn.setImage(UIImage(named: "heart-new-big"), for: .normal)
            }
        }
    }
    
    @IBAction func share(_ sender: UIButton) {
        sender.swing(nil)
        let text = "Compartir artículo"
        if let url = URL(string: article!.url) {
        let activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
            delegateHomeTable?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func setup(article: Article, delegateFavoriter: ArticleFavoriter?, delegateHomeVC: UITableViewController?) {
        
        self.article = article
        self.delegateFavoriter = delegateFavoriter
        self.delegateHomeTable = delegateHomeVC
        titleLabel.text = article.title
        sourceLabel.text = article.source
        descriptionLabel.text = article.description
        publishedAtLabel.text = article.publishedAt
        
        
        //traigo img con kingfisher
        let imageURL = URL(string: "\(article.urlToImage)")
        imageLabel.kf.setImage(with: imageURL,
        placeholder: UIImage(named: "placeHolder-square"),
        options: [
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(1)),
        .cacheOriginalImage
        ])
        
        //cambio la img de favoritos en celda segun bool
        if article.isFavorite {
            // poner una imagen
            isFavoriteBtn.setImage(UIImage(named: "heart-new-big-red"), for: .normal)
        } else {
            // poner otra imagen
            isFavoriteBtn.setImage(UIImage(named: "heart-new-big"), for: .normal)
        }
    }
}
