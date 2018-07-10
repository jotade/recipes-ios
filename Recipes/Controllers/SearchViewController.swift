//
//  SearchViewController.swift
//  Recipes
//
//  Created by IM Development on 7/8/18.
//  Copyright © 2018 Juan Parra. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataServiceDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var recipes = [Recipe]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipes"
        DataService.shared.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.recipe = recipes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRecipe", sender: recipes[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipe" {
            let vc = segue.destination as! RecipeViewController
            vc.recipe = sender as? Recipe
        }
    }
    
    func search(needle: String) {
        DataService.shared.searchRecipe(needle: needle){ [unowned self] done in
            if !done {
                let alert = UIAlertController(title: "Error", message: "something went wrong, try again later", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func load() {
        recipes = []
        recipes = Recipe.fetchRecipes(isFavorite: false)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        search(needle: searchField.text!)
        searchField.resignFirstResponder()
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text{
            search(needle: text)
        }
        searchField.resignFirstResponder()
        return true
    }
}

