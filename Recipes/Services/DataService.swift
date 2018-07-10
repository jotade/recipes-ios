//
//  DataService.swift
//  Recipes
//
//  Created by IM Development on 7/8/18.
//  Copyright © 2018 Juan Parra. All rights reserved.
//

import Foundation
import Alamofire

let apiURL = "http://food2fork.com/api/search?key=\(key)"
let key = "69bb07d90a6fca99b6dfa3e022c91df3"

protocol DataServiceDelegate {
    func load()
}

class DataService {
    
    static let shared = DataService()
    var delegate: DataServiceDelegate?
    
    func searchRecipe(needle:String, completion: @escaping (_ done: Bool)->()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request("\(apiURL)&q=\(needle)").responseJSON { response in
            if let recipes = response.result.value as? [String: Any] {
                Recipe.parseRecipes(res: recipes)
                self.delegate?.load()
                completion(true)
            } else {
                completion(false)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}