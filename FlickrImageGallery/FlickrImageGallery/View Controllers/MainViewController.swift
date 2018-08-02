//
//  MainViewController.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    //MARK: UIControls & Variables
    @IBOutlet weak var tvLists: UITableView!
    let refreshControl = UIRefreshControl()

    var listViewModels = [ListViewModel?](repeating: nil, count: Constants.TableView.Headers.count)
    var selectedItemViewModel:ItemViewModel?

    let feedService = Service(with: Urls.FlickrApi.feeds)
    
    // MARK:- ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tvLists.refreshControl = refreshControl
        } else {
            tvLists.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshLists(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectListItem(_:)), name: NSNotification.Name(rawValue: Constants.Notifications.ItemSelected), object: nil)

    }
    
    /// Refreshes the list (clears the current lists so that it is fetched from the server).
    @objc func refreshLists(_ sender: Any) {
        listViewModels.forEach { listViewModel in
            listViewModel?.expireForcefully()
        }
        
        tvLists.reloadData()
    }

    /// This function is called when the ListItem (photo) is tapped by the user
    @objc func didSelectListItem(_ notification: Notification) {
        guard let itemViewModel = notification.object as? ItemViewModel else {
            return
        }

        selectedItemViewModel = itemViewModel
        self.performSegue(withIdentifier: Constants.Identifiers.ShowDetailVC, sender: nil)
    }
    
    // MARK: - Navigation
    /// Passing the selected Item to the DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DetailViewController {
            viewController.itemViewModel = selectedItemViewModel
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
        return Constants.TableView.Headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.ListCell) as! ListTableViewCell

        var listViewModel = listViewModels[indexPath.section]
        if listViewModel == nil {
            listViewModel = ListViewModel(with: feedService, forTags: Constants.TableView.Tags[indexPath.section], sortBy: Constants.TableView.ItemSortOrder, ttlInSeconds: Constants.TableView.Ttl)
        }
        
        //Clearing up the cell
        cell.update(with: [ItemViewModel]())
        
        cell.tag = indexPath.section
        
        listViewModel?.itemViewModels { [unowned self] (itemViewModels, error) in
            self.refreshControl.endRefreshing()

            if let error = error {
                self.showAlert(error)
                return
            }

            // Making sure the cell is visible before we update
            guard tableView.visibleCells.filter({$0==cell}).count > 0 else {
                return
            }

            cell.update(with: itemViewModels!)
        }
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.TableView.Height.Header
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: Constants.TableView.Height.Header))

        let lblTitle = UILabel(frame: view.bounds)
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.textColor = .black
        lblTitle.text = Constants.TableView.Headers[section]
        view.addSubview(lblTitle)

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.TableView.Height.Footer
    }
}
