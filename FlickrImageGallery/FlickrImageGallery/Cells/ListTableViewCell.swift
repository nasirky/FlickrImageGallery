//
//  ListTableViewCell.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit

/// Cell for Displaying the lists (as UICollectionView)
class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var cvPhotos: UICollectionView!

    var itemViewModels = [ItemViewModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Updates the items and section (parent) index and reloads the list.
    /// - Parameters:
    ///   - items: List/Array of 'ItemViewModel' objects
    public func update(with itemViewModels: [ItemViewModel]) {
        self.itemViewModels = itemViewModels

        cvPhotos.reloadData()
    }
}

extension ListTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.ListItemCell, for: indexPath) as! ListItemCollectionViewCell
        
        let itemViewModel = itemViewModels[indexPath.row]
        cell.configure(with: itemViewModel.title, image: itemViewModel.thumbnailUrl)

        return cell
    }
}

extension ListTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Using Notifications instead of delegation as I think Notification is much cleaner approach in this case. Otherwise each ListItem cell would have reference to the parent
        
        NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.ItemSelected), object: itemViewModels[indexPath.row], userInfo: nil)
    }
}
