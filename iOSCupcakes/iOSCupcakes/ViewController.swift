//
//  ViewController.swift
//  iOSCupcakes
//
//  Created by robert on 3/12/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  var cupcakes = [Cupcake]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cupcakes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let cupcake = cupcakes[indexPath.row]
    
    cell.textLabel?.text = cupcake.name
    cell.detailTextLabel?.text = cupcake.description
    
    return cell
  }
  func fetchData(){
    let url = URL(string: "http://localhost:8080/cupcakes")!
    URLSession.shared.dataTask(with: url){data, response, error in
      guard let data = data else{
        print(error?.localizedDescription ?? "Unknown error")
        return
      }
      
      let decoder = JSONDecoder()
      if let cakes = try? decoder.decode([Cupcake].self, from: data){
        DispatchQueue.main.async {
          self.cupcakes = cakes
          self.tableView.reloadData()
          print("Loaded \(cakes.count) cupcakes")
        }
      }else{
        print("Unable to parse JSON")
      }
    }.resume()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cake = cupcakes[indexPath.row]
    
    let ac = UIAlertController(title:"Order \(cake.name)?", message: "Please enter your name", preferredStyle: .alert)
    ac.addTextField()
    
    let action = UIAlertAction(title: "Order!", style: .default, handler: { (action) in
      guard let name = ac.textFields?[0].text else{ return }
       self.order(cake, name: name)
    })
    ac.addAction(action)
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  
  func order(_ cake: Cupcake, name: String) {
    let order = Order(cakeName: cake.name, buyerName: name)
    let url = URL(string: "http://localhost:8080/order")!
    let request = buildRequest(url, order: order)
    
    URLSession.shared.dataTask(with: request){ data, resp, error in
      guard let data = data else { return }
      let decoder = JSONDecoder()
      
      if let item = try? decoder.decode(Order.self, from: data){
        print(item.buyerName)
      }else{
        print("Bad Json")
      }
    }.resume()
    
  }
  
  func buildRequest(_ url: URL, order: Order) -> URLRequest{
    let encoder = JSONEncoder()

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? encoder.encode(order)
    
    return request
  }
  
}

