//
//  DetailViewController.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit
import FlickrFetcherSDK
import SDWebImage

class DetailViewController: UIViewController {
    // MARK: UIControls & Variables
    @IBOutlet weak var ivImage: UIImageView!

    var item: Item?
    //Since we are using progressiveDownload, we need a way to know if the image has downloaded/loaded completely
    //as we will allow share function only after image has been completely downloaded/loaded.
    var imageLoadingComplete = false

    // MARK:- ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = item?.title
    
        //An extra visual clue for the user to know if the image is still being loaded
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //Setting up activity indicator (spinner) on the imageview (which is shown when image is not loaded)
        ivImage.sd_setShowActivityIndicatorView(true)
        ivImage.sd_setIndicatorStyle(.gray)
        
        //Using progressiveDownload so that the image starts loading as it is downloaded. It gives user the visual look of the progress.
        ivImage.sd_setImage(with: item?.media.imageUrl, placeholderImage: nil, options: .progressiveDownload){ (_, _, _, _) in
            self.imageLoadingComplete = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

    }
    
    @IBAction func openInBrowser(_ sender: Any) {
    }

    @IBAction func share(_ sender: Any) {
    }

    // MARK: - Navigation
    /// Passing the Item to the ItemInfoViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ItemInfoViewController {
            viewController.itemArray = item?.asArray()
        }
    }
    
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

