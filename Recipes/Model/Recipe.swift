//
//  Recipe.swift
//  Recipes
//
//  Created by IM Development on 7/8/18.
//  Copyright © 2018 Juan Parra. All rights reserved.
//

import Foundation
import CoreData

extension Recipe {
    
    static func parseRecipes(res: [String:Any]) {
        
        if let recipes = res["recipes"] as? [[String: Any]] {
            deleteRecipes()
            cdManager.context.performAndWait {
                for recipe in recipes {
                    
                    let recipeNew = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: cdManager.context) as! Recipe
                    recipeNew.title = recipe["title"] as? String ?? ""
                    recipeNew.image_url = recipe["image_url"] as? String ?? ""
                    recipeNew.publisher = recipe["publisher"] as? String ?? ""
                    recipeNew.publisher_url = recipe["publisher_url"] as? String ?? ""
                    recipeNew.f2f_url = recipe["f2f_url"] as? String ?? ""
                    recipeNew.recipe_id = recipe["recipe_id"] as? String ?? ""
                    recipeNew.source_url = recipe["source_url"] as? String ?? ""
                    recipeNew.social_rank = recipe["social_rank"] as? Int16 ?? 0
                    recipeNew.isFavorite = false
                }
                try? cdManager.saveContext()
            }
            
        }
    }
    
    static func fetchRecipes(isFavorite: Bool?) -> [Recipe] {
        var recipes = [Recipe]()
        let recipeFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        if let isFavorite = isFavorite {
            let predicate = NSPredicate(format: "isFavorite ==  %@", NSNumber(value: isFavorite))
            recipeFetch.predicate = predicate
        }
        recipes = try! cdManager.context.fetch(recipeFetch) as! [Recipe]
        return recipes
    }
    
    static func deleteRecipes() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        let predicate = NSPredicate(format: "isFavorite ==  %@", NSNumber(value: false))
        fetch.predicate = predicate
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try cdManager.context.execute(request)
        } catch {
            print(error)
        }
    }
}
