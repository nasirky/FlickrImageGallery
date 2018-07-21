//
//  ListItemCollectionViewCell.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit
import SDWebImage

class ListItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    
    public func setup(with title: String, image url: URL?) {
        lblTitle.text = title

        //Setting up activity indicator (spinner) on the imageview (which is shown when image is not loaded)
        ivImage.sd_setShowActivityIndicatorView(true)
        ivImage.sd_setIndicatorStyle(.gray)

        //Using progressiveDownload so that the image starts loading as it is downloaded. It gives user the visual look of the progress.
        ivImage.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload, completed: nil)
    }
}
