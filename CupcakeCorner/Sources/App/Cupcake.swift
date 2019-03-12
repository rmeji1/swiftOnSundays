//
//  Cupcake.swift
//  App
//
//  Created by robert on 3/12/19.
//

import FluentSQLite
import Foundation
import Vapor

struct Cupcake: Content, SQLiteModel, Migration{
  var id: Int?
  var name: String
  var description: String
  var price: Int
}
