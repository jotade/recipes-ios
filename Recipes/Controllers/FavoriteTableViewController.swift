//
//  FavoriteTableViewController.swift
//  Recipes
//
//  Created by IM Development on 7/9/18.
//  Copyright © 2018 Juan Parra. All rights reserved.
//

import UIKit
import CoreData

class FavoriteTableViewController: UITableViewController {

    var favoriteRecipes = [Recipe](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite"
        clearsSelectionOnViewWillAppear = false
        navigationItem.rightBarButtonItem = editButtonItem
        favoriteRecipes = Recipe.fetchRecipes(isFavorite: true)
        configureObserver()
    }
    
    func configureObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: cdManager.context, queue: nil) {[weak this = self] notification in
            
            guard let userInfo = notification.userInfo else { return }
            if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
                this?.favoriteRecipes.removeAll()
                this?.favoriteRecipes = Recipe.fetchRecipes(isFavorite: true)
                this?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell

        cell.recipe = favoriteRecipes[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRecipe", sender: favoriteRecipes[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipe" {
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.recipe = sender as? Recipe
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = favoriteRecipes[indexPath.row]
            recipe.isFavorite = false
            try? cdManager.saveContext()
        }
    }
}
