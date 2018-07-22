//
//  MainViewController.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit
import FlickrFetcherSDK

class MainViewController: UIViewController {
    //MARK: UIControls & Variables
    @IBOutlet weak var tvLists: UITableView!
    let refreshControl = UIRefreshControl()

    var lists = [List?](repeating: nil, count: 3)   // 3 is the count of sections (sectionHeaders)
    var selectedItem:Item?

    //MARK: Constants
    let sectionHeaders = ["Kittens", "Dogs", "Public Feed"]
    let tags = [["kitten","kittens"],["dog","dogs"],nil]

    let headerHeight:CGFloat = 40
    let footerHeight:CGFloat = 40

    // MARK:- ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tvLists.refreshControl = refreshControl
        } else {
            tvLists.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshLists(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectListItem(_:)), name: NSNotification.Name(rawValue: "DidSelectListItem"), object: nil)

    }
    
    /// Refreshes the list (clears the current lists so that it is fetched from the server).
    @objc func refreshLists(_ sender: Any) {
        for i in 0..<lists.count {
            lists[i] = nil
        }
        
        tvLists.reloadData()
    }

    /// This function is called when the ListItem (photo) is tapped by the user
    @objc func didSelectListItem(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let indexPath = userInfo["indexPath"] as? IndexPath {
                if let list = lists[indexPath.section] {
                    selectedItem = list.items[indexPath.row]
                    self.performSegue(withIdentifier: "ShowDetailVC", sender: nil)
                }
            }
        }
    }
    
    // MARK: - Navigation
    /// Passing the selected Item to the DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DetailViewController {
            viewController.item = selectedItem
        }
    }
    
    // MARK: - Memory Warning and deinit
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    deinit {
        //Removing all the Notification observers
        NotificationCenter.default.removeObserver(self)
    }

}

//MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    // I am using grouped tableview where each section represents a list (so each section has 1 row as the lists are being handled by UICollectionViews). Since I want to make use of section headers and footers, that is the reason I am using this approach (1 section per list).
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListTableViewCell

        if let list = lists[indexPath.section], !list.hasExpired {
            cell.update(with: list.items, section: indexPath.section)
        } else {
            let tag = tags[indexPath.section]
            
            PublicService.sharedInstance.fetchPublicPhotos(with: tag, onSuccess: { (items, allTags) in
                // Fetch the section index (which list to update) on the basis of the tags. This will not work if two sections have the exactly same tags in same order (but that use case does not make sense here)
                if let index = self.tags.index(of: allTags) {
                    let list = List(with: items, sortBy: .descending)
                    self.lists[index] = list
                    
                    let indexPath = IndexPath(row: 0, section: index)
                    let cell = self.tvLists.cellForRow(at: indexPath) as? ListTableViewCell
                    
                    //Updating the cell only if it is visible
                    if let count = self.tvLists.indexPathsForVisibleRows?.filter({$0 == indexPath}).count, count > 0 {
                        cell?.update(with: list.items, section: index)
                    }
                    
                    //hiding refreshControl when
                    //1. It is already being shown (isRefreshin) and
                    //2. all the lists have loaded
                    if self.refreshControl.isRefreshing && self.lists.filter({$0 == nil}).count == 0 {
                        self.refreshControl.endRefreshing()
                    }
                }
            }, onFailure: {(errorString, allTags) in
                if let index = self.tags.index(of: allTags) {
                    self.showAlert("\(self.sectionHeaders[index]):\(errorString)")
                } else {
                    self.showAlert(errorString)
                }
                
                self.refreshControl.endRefreshing()
            })
        }

        return cell
    }

}

//MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerHeight))

        let lblTitle = UILabel(frame: view.bounds)
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.textColor = .black
        lblTitle.text = sectionHeaders[section]
        view.addSubview(lblTitle)

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
}
