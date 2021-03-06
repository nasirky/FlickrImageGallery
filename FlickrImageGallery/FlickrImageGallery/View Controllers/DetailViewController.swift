//
//  DetailViewController.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    // MARK: UIControls & Variables
    @IBOutlet weak var ivImage: UIImageView!

    var itemViewModel: ItemViewModel?
    //Since we are using progressiveDownload, we need a way to know if the image has downloaded/loaded completely
    //as we will allow share function only after image has been completely downloaded/loaded.
    var imageLoadingComplete = false

    // MARK:- ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = itemViewModel?.title
    
        //An extra visual clue for the user to know if the image is still being loaded
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //Setting up activity indicator (spinner) on the imageview (which is shown when image is not loaded)
        ivImage.sd_setShowActivityIndicatorView(true)
        ivImage.sd_setIndicatorStyle(.gray)
        
        //Using progressiveDownload so that the image starts loading as it is downloaded. It gives user the visual look of the progress.
        ivImage.sd_setImage(with: itemViewModel?.imageUrl, placeholderImage: nil, options: .progressiveDownload){ (_, _, _, _) in
            self.imageLoadingComplete = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

    }
    
    @IBAction func openInBrowser(_ sender: Any) {
        guard let url = itemViewModel?.imageUrl, UIApplication.shared.canOpenURL(url) else {
            self.showAlert(Constants.Messages.Error.OpenInBrowser)
            return
        }
        
        UIApplication.shared.open(url, options: [String:Any](), completionHandler: nil)
    }

    @IBAction func share(_ sender: Any) {
        guard let image = ivImage.image, imageLoadingComplete else {
            self.showAlert(Constants.Messages.Error.Share)
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [(image)], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        // Excluding copy, print from share dialog
        activityVC.excludedActivityTypes = [.copyToPasteboard, .print]
        self.present(activityVC, animated: true, completion: nil)
    }

    // MARK: - Navigation
    /// Passing the Item to the ItemInfoViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ItemInfoViewController {
            viewController.itemViewModel = itemViewModel
        }
    }
    
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

