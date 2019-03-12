//
//  FriendDataSource.swift
//  FriendFace
//
//  Created by robert on 2/20/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class FriendDataSource: NSObject, UITableViewDataSource {
  var friends = [Friend]()
  var filterFriends = [Friend]()
  var dataChanged: (() -> Void)?
  
  var filterText: String?{
    didSet{
      filterFriends = friends.matching(filterText)
      dataChanged?()
    }
  }
  
  func fetch(_ urlString: String) {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.decode([Friend].self, fromURL: urlString){ [unowned self] friends in
      self.friends = friends
      self.filterFriends = friends
      self.dataChanged?()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filterFriends.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let friend = filterFriends[indexPath.row]
    
    cell.textLabel?.text = friend.name
    cell.detailTextLabel?.text = friend.friendList
    return cell
  }
}

