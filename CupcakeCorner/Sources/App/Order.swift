//
//  Order.swift
//  App
//
//  Created by robert on 3/12/19.
//

import FluentSQLite
import Foundation
import Vapor

struct Order: Content, SQLiteModel, Migration {
  var id: Int?
  var cakeName: String
  var buyerName: String
  var date: Date?
}
