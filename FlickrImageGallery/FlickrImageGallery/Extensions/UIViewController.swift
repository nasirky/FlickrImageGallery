//
//  UIViewController.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Presents an alert with a title and message
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Message to show
    func showAlert(with title: String = "", _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        /* Only one Viewcontroller can be presented at a time, so we present the alert only if there is no other ViewController being presented.
         * Make a better option would be to queue the alerts and show them after one after the other (show the next alert after the current is dismissed).
        */
        if self.presentedViewController == nil {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
