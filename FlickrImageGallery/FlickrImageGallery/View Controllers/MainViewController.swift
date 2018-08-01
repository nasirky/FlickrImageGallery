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
    
    //NOTE:Defining FeedsService object here (as it is not used by any other ViewController)
    //
    let feedsService = Service(with: Urls.FlickrApi.feeds)
    
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

        if let listViewModel =  listViewModels[indexPath.section], !listViewModel.hasExpired {
            let itemViewModels = listViewModel.itemViewModels(sortBy: Constants.TableView.ItemSortOrder)
            cell.update(with: itemViewModels, section: indexPath.section)
        } else {
            cell.update(with: [ItemViewModel](), section: indexPath.section)

            let tag = Constants.TableView.Tags[indexPath.section]
            
            PublicPhotosTask(with: tag).execute(in: feedsService, onSuccess: { list in
                // Fetch the section index (which list to update) on the basis of the tags. This will not work if two sections have the exactly same tags in same order (but that use case does not make sense here)
                self.refreshControl.endRefreshing()
                
                guard let index = Constants.TableView.Tags.index(of: list.tags) else {
                    return
                }
                if let listViewModel = self.listViewModels[index] {
                    listViewModel.update(withList: list)
                } else {
                    self.listViewModels[index] = ListViewModel(withList: list, expiry:Constants.TableView.Ttl)
                }
                
                let indexPath = IndexPath(row: 0, section: index)
                self.updateCellIfVisible(at: indexPath)
            },  onFailure: { error in
                    self.showAlert(error.localizedDescription)
                    self.refreshControl.endRefreshing()
            })
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

extension MainViewController {
    func updateCellIfVisible(at indexPath: IndexPath) {
        let cell = self.tvLists.cellForRow(at: indexPath) as? ListTableViewCell
        
        //Updating the cell only if it is visible
        guard let count = self.tvLists.indexPathsForVisibleRows?.filter({$0 == indexPath}).count, count > 0 else {
            return
        }
        
        guard let itemViewModels = self.listViewModels[indexPath.section]?.itemViewModels(sortBy: Constants.TableView.ItemSortOrder) else {
            return
        }
        
        cell?.update(with:itemViewModels, section: indexPath.section)
    }
}
