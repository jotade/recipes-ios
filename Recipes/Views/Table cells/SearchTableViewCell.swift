//
//  SearchTableViewCell.swift
//  Recipes
//
//  Created by IM Development on 7/8/18.
//  Copyright © 2018 Juan Parra. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    var recipe: Recipe! {
        didSet {
            titleLabel.text = recipe.title!
            publisherLabel.text = recipe.publisher!
            downloadImage(imageURL: recipe.image_url!)
        }
    }
    
    func downloadImage(imageURL: String) {
        Alamofire.request(imageURL).responseData(queue: .main, completionHandler: { (data) in
            let image = UIImage(data: data.data!)!
            image.af_inflate()
            let circularImage = image.af_imageRoundedIntoCircle()
            self.recipeImageView.image = circularImage
        })
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        publisherLabel.text = ""
        recipeImageView.image = nil
    }
}
