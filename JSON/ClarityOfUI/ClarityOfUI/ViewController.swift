//
//  ViewController.swift
//  ClarityOfUI
//
//  Created by robert on 3/3/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let navigationManager = NavigationManager()
    
    navigationManager.fectch{
      let vc = TableScreenViewController(screen: $0)
      vc.navigationManager = navigationManager
      navigationController?.viewControllers = [vc]
    }
  }

}

