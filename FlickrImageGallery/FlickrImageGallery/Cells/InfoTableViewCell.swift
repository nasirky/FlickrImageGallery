//
//  InfoTableViewCell.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit

/// Cell for Displaying the List Item Information. A custom cell was not needed but I created one to get more control over formatting and the controls (maybe in the future we need to detect links in the description etc.)
class InfoTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Updates the text of title and detail labels
    /// - Parameters:
    ///   - title: Title of the Item metadata (such as title, description etc.)
    ///   - detail: Value/Detail of the item metadata
    func update(with title: String, _ detail: String) {
        lblTitle.text = title
        lblDetail.text = detail
    }
}
