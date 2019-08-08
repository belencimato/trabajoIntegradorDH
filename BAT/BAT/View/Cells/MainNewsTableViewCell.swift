//
//  MainNewsTableViewCell.swift
//  BAT
//
//  Created by Belen Cimato on 23/06/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit

class MainNewsTableViewCell: UITableViewCell {

    var delegateFavoriter: ArticleFavoriter?
    var delegateHomeTable: UITableViewController?
    
    var article: Article?
    
    @IBOutlet weak var imgMainNews: UIImageView!
    @IBOutlet weak var titleMainNews: UILabel!
    @IBOutlet weak var txtMainNews: UILabel!
    @IBOutlet weak var sourceMainNews: UILabel!
    @IBOutlet weak var dateMainNews: UILabel!
    @IBOutlet weak var shareMainNews: UIButton!
    @IBOutlet weak var isFavoriteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(article: Article, delegateFavoriter: ArticleFavoriter, delegateHomeTable: UITableViewController) {
        self.delegateFavoriter = delegateFavoriter
        self.delegateHomeTable = delegateHomeTable
        self.article = article
        titleMainNews.text = article.title
        sourceMainNews.text = article.source
        txtMainNews.text = article.description
        let imgExist = article.urlToImage
        let url = URL(string: imgExist)
        dateMainNews.text = article.publishedAt
        
        //kingfisher for img
        imgMainNews.kf.indicatorType = .activity
        imgMainNews.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeHolder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        if article.isFavorite {
            isFavoriteBtn.setImage(UIImage(named: "heart-new-big-red"), for: .normal)
        } else {
            isFavoriteBtn.setImage(UIImage(named: "heart-new-big"), for: .normal)
        }
        
    }
    
    @IBAction func share(_ sender: UIButton) {
        sender.shake(nil)
        let text = "Compartir artículo"
        if let url = URL(string: article!.url) {
            let activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
            delegateHomeTable?.present(activityVC, animated: true, completion: nil)
        }
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
}
