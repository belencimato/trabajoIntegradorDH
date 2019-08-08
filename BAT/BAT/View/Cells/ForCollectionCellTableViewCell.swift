//
//  ForCollectionCellTableViewCell.swift
//  BAT
//
//  Created by Belen Cimato on 26/07/2019.
//  Copyright © 2019 BAT. All rights reserved.
//

import UIKit
import SafariServices

protocol UserTapActionDelegate {
    func tappedItem(article: Article)
}

class ForCollectionCellTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, SFSafariViewControllerDelegate {
    
    var delegateHomeTable: HomeTableViewController?
    
    @IBOutlet weak var collectionCell: UICollectionView!
    
    var articlesArray: [Article] = []
    
    var tapDelegate: UserTapActionDelegate?
    
    func setup(articles: [Article], delegate: UserTapActionDelegate) {
        collectionCell.delegate = self
        collectionCell.dataSource = self
        
        articlesArray = articles
        tapDelegate = delegate
        
        collectionCell.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! ForYouCollectionViewCell
        let valor = articlesArray[indexPath.item]
        cell.setup(article: valor) //VER CON MARIANO ESTO NO ENTIENDO COMO ES
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapDelegate?.tappedItem(article: articlesArray[indexPath.item])
        let article = articlesArray[indexPath.row]
        if let url = URL(string: article.url) {
            let safariVC = SFSafariViewController(url: url)
            if let delegate = delegateHomeTable {
                delegate.present(safariVC, animated: true, completion: nil)
            }
        }
    }
    

}
