//
//  JSONDecoder+remote.swift
//  FriendFace
//
//  Created by robert on 2/20/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import Foundation


extension JSONDecoder{
  enum Error: Swift.Error {
    case requestFailed
  }
  
  func decode<T: Decodable>(_ type: T.Type, fromURL url: String, completion: @escaping (T) -> Void){
    guard let url = URL(string: url) else{
      assert(false,"Error- Invalid URL")
      return
    }
    
    let task = URLSession.shared.dataTask(with: url){data, response, error in
      do {
        guard let data = data,
          let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode,
          error == nil else {
            // Data was nil, validation failed or an error occurred.
            throw error ?? Error.requestFailed
            
        }
        let downloadedData = try self.decode(type, from: data)
        DispatchQueue.main.async {
          completion(downloadedData)
        }
      }catch let DecodingError.dataCorrupted(context) {
        print(context)
      } catch let DecodingError.keyNotFound(key, context) {
        print("Key '\(key)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
      } catch let DecodingError.valueNotFound(value, context) {
        print("Value '\(value)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
      } catch let DecodingError.typeMismatch(type, context)  {
        print("Type '\(type)' mismatch:", context.debugDescription)
        print("codingPath:", context.codingPath)
      } catch {
        print("error: ", error)
      }
    }
    task.resume()
  }
}
