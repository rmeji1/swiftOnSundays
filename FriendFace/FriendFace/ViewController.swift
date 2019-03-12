//
//  ViewController.swift
//  FriendFace
//
//  Created by robert on 2/20/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {
  let dataSource = FriendDataSource()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource.dataChanged =  {[weak self] in
      self?.tableView.reloadData()
    }
    dataSource.fetch("https://www.hackingwithswift.com/samples/friendface.json")
    tableView.dataSource = dataSource
    
    addSearchBar()
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    dataSource.filterText = searchController.searchBar.text
  }
  
  fileprivate func addSearchBar() {
    let search = UISearchController(searchResultsController: nil)
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = "Find a Friend"
    search.searchResultsUpdater = self
    navigationItem.searchController = search
  }
}

