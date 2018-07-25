//
//  ListTableViewCell.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit
import FlickrFetcherSDK

/// Cell for Displaying the lists (as UICollectionView)
class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var cvPhotos: UICollectionView!

    var items = [Item]()
    var section: Int = -1   //the corresponding parent section

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Updates the items and section (parent) index and reloads the list.
    /// - Parameters:
    ///   - items: List/Array of 'Item' objects
    ///   - section: Section Index for the list. It is used to identify which section (of the tableview) this list belongs to. It is useful when communicating which item of which list was tapped (inside `didSelectItemAt`).

    public func update(with items: [Item], section index: Int) {
        self.items = items
        self.section = index

        cvPhotos.reloadData()
    }

}

extension ListTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.ListItemCell, for: indexPath) as! ListItemCollectionViewCell
        
        let listItem = items[indexPath.row]
        cell.setup(with: listItem.title, image: listItem.media.thumbnailUrl)

        return cell
    }
}

extension ListTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Using Notifications instead of delegation as I think Notification is much cleaner approach in this case
        // Otherwise each ListItem cell would have reference to the parent
        let userInfo = ["indexPath": IndexPath.init(row: indexPath.row, section: section)]
        
        NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.ItemSelected), object: nil, userInfo: userInfo)
    }
}
