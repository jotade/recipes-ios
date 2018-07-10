//
//  RecipeViewController.swift
//  Recipes
//
//  Created by IM Development on 7/8/18.
//  Copyright © 2018 Juan Parra. All rights reserved.
//

import UIKit
import WebKit

class RecipeViewController: UIViewController, WKNavigationDelegate {
    
    var recipe: Recipe?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webkitWebView: WKWebView!
    
    lazy var rightButton = {
        return UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.showModalSelect))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (navigationController?.previousViewController() is SearchViewController) {
            navigationItem.rightBarButtonItem = rightButton()
        }
        webkitWebView.navigationDelegate = self
        if let recipe = recipe {
            title = recipe.title
            webkitWebView.load(URLRequest(url: URL(string: recipe.source_url!)!))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    @objc func showModalSelect() {
        let alertViewController = UIAlertController(title: "Add To Favorite?", message: "", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "YES", style: .default) {[unowned self] (action) in
            self.recipe?.isFavorite = true
            try? cdManager.context.save()
        }
        let action2 = UIAlertAction(title: "NO", style: .default) { (action) in
            
        }
        alertViewController.addAction(action1)
        alertViewController.addAction(action2)
        present(alertViewController, animated: true, completion: nil)
    }
}

extension UINavigationController {
    
    func previousViewController() -> UIViewController?{
        let lenght = self.viewControllers.count
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        return previousViewController
    }
}
