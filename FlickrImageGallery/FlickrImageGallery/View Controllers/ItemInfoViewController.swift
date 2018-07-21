//
//  ItemInfoViewController.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit
import FlickrFetcherSDK

class ItemInfoViewController: UIViewController {
    //MARK: UIControls & Variables
    @IBOutlet weak var tvInfo: UITableView!

    var itemArray: [String?]!

    // MARK: Constants
    let headings = ["Title", "Description", "Date Taken", "Date Published", "Tags"]

    // MARK:- ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Item Details"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: UITableViewDataSource
extension ItemInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell")!
        
        cell.textLabel?.text = headings[indexPath.row].uppercased()
        cell.detailTextLabel?.text = itemArray[indexPath.row] ?? "-"
        
        return cell
    }
}
