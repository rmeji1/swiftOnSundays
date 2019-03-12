//
//  Types.swift
//  ClarityOfUI
//
//  Created by robert on 3/3/19.
//  Copyright © 2019 Mejia. All rights reserved.
//
import AVKit
import Foundation
import UIKit
import SafariServices

struct Application: Decodable{
  let screens: [Screen]

}

struct Screen: Decodable{
  let id: String
  let title: String
  let type: String
  let rows: [Row]
}

struct Row: Decodable{
  enum ActionCodingKeys: String, CodingKey {
    case title
    case actionType
    case action
  }
  
  var title: String
  let action: Action?
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ActionCodingKeys.self)
    title = try container.decode(String.self, forKey: .title)
    
    if let actionType =  try container.decodeIfPresent(String.self, forKey: .actionType){
      switch actionType{
        case "alert":
          action = try container.decode(AlertAction.self, forKey: .action)
        case "showWebSite":
          action = try container.decode(ShowWebSiteAction.self, forKey: .action)
        case "showSecondScreen":
          action = try container.decode(ShowScreenAction.self, forKey: .action)
        case "share":
          action = try container.decode(ShareAction.self, forKey: .action)
        case "playMovie":
          action = try container.decode(PlayMovieAction.self, forKey: .action)
        default:
          fatalError("Unknon action type: \(actionType).")
      }
    }else{
      action = nil
    }
  }
}

struct ShowScreenAction: Action{
  var presentNewScreen: Bool{
    return true
  }
  
  let id: String
}


struct ShowWebSiteAction: Action{
  let url : URL
  var presentNewScreen: Bool{
    return true
  }
}

struct AlertAction: Action{
  let title : String
  let message: String
  var presentNewScreen: Bool{
    return false
  }
}

struct ShareAction: Action{
  let text: String?
  let url: URL?
  
  var presentNewScreen: Bool{
    return false
  }
}

struct PlayMovieAction: Action{
  let url: URL
  
  var presentNewScreen: Bool{
    return true
  }
}

protocol Action: Decodable {
  var presentNewScreen: Bool { get }
}
class NavigationManager{
  private var screens = [String: Screen]()
  
  func execute(_ action: Action?, from viewController: UIViewController){
    guard let action = action else { return }
    
    if let action = action as? AlertAction{
      let ac = UIAlertController(title: action.title, message: action.message, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Ok", style: .default))
      viewController.present(ac, animated: true)
    } else if let action = action as? ShowWebSiteAction{
      let vc =  SFSafariViewController(url: action.url)
      viewController.navigationController?.present(vc, animated: true)
    }else if let action = action as? ShowScreenAction{
      guard let screen = screens[action.id] else{
        fatalError("Unkown screen")
      }
      let vc = TableScreenViewController(screen: screen)
      vc.navigationManager = self
      viewController.navigationController?.pushViewController(vc, animated: true)
    }else if let action = action as? PlayMovieAction{
      let player = AVPlayer(url: action.url)
      let playerViewController = AVPlayerViewController()
      playerViewController.player = player
      player.play()
      viewController.present(playerViewController, animated: true)
    }else if let action = action as? ShareAction{
      var items = [Any]()
      
      if let text = action.text{
        items.append(text)
      if let url = action.url{
        items.append(url)
      }
        
        if items.isEmpty == false{
          let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
          viewController.present(ac, animated: true)
        }
    }
  }
  
  
  
  func fectch(completion: (Screen) -> Void){
    let url = URL(string: "http://localhost:8090/index.json")!
    let data = try! Data(contentsOf: url)
    let decoder = JSONDecoder()
    
    let app = try! decoder.decode(Application.self, from: data)
    
    for screen in app.screens{
      screens[screen.id] = screen
    }
    
    completion(app.screens[0])
  }
}
