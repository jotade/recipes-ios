//
//  DataService.swift
//  Recipes
//
//  Created by IM Development on 7/8/18.
//  Copyright © 2018 Juan Parra. All rights reserved.
//

import Foundation
import Alamofire

protocol DataServiceDelegate {
    func load()
}

class DataService {
    
    lazy var apiURL = "http://food2fork.com/api/search?key=\(key)"
    lazy var key = "69bb07d90a6fca99b6dfa3e022c91df3"
    
    static let shared = DataService()
    var delegate: DataServiceDelegate?
    
    func searchRecipe(needle:String, completion: @escaping (_ done: Bool)->()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let  url =  "\(apiURL)&q=\(needle)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            Alamofire.request(url).responseJSON { response in
                if let recipes = response.result.value as? [String: Any] {
                    Recipe.parseRecipes(res: recipes)
                    self.delegate?.load()
                    completion(true)
                } else {
                    completion(false)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        } else {
            completion(false)
        }
    }
}
