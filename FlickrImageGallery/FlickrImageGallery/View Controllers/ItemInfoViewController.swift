//
//  ItemInfoViewController.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit

class ItemInfoViewController: UIViewController {
    //MARK: UIControls & Variables
    @IBOutlet weak var tvInfo: UITableView!

    var itemArray: [String?]!

    // MARK:- ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.Titles.Info
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: UITableViewDataSource
extension ItemInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.Info.Headings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.InfoCell) as! InfoTableViewCell
        
        cell.update(with: Constants.Info.Headings[indexPath.row].uppercased(), itemArray[indexPath.row] ?? "-")
        
        return cell
    }
}
