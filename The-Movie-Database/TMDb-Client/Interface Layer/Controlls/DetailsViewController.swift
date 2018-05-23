//
//  DetailsViewController.swift
//  TMDb-Client
//
//  Created by Maxim on 22.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var postarImageView: UIImageView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addToFavoritesButton: UIButton!
    
    var media: MediaBaseProtocol = Media()
    
    var typeMedia: String!
    
    let networkManager = NetworkManager.shared
    let dataManager = DataManager.shared
    
    
    //MARK: - View Controller Methods -
    //***************************************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewController()
    }
    
    
    //MARK: - Private -
    //***************************************************
    
    
    private func configureViewController() {
                
        self.typeLabel.text = media.type
        self.titleLabel.text = media.title
        
        self.networkManager.getImage(imageName: self.media.image) { [weak self](image) in
            guard let `self` = self else { return }

            self.postarImageView.image = image
        }
        
        self.overviewTextView.text = self.media.overview
        self.rateLabel.text = Constants.rate + String(describing: self.media.rate)
        self.releaseLabel.text = Constants.release + self.media.releaseDate
        
        self.overviewTextView.isEditable = false
        
        if typeMedia == Constants.favorite {
            addToFavoritesButton.isHidden = true
        }
    }
    
    
    //MARK: - Actions -
    //***************************************************
    
    
    @IBAction func addToFavoritesButtonPressed(_ sender: Any) {
        
        if DataManager.shared.favoriteIsSaved(favorite: self.media as! Media){
            self.showMessage(message: Constants.movieAlreadySaved, responce: Constants.okMessage)
        } else {
            if DataManager.shared.addToFavorites(mediaObject: self.media as! Media) {
                self.showMessage(message: Constants.favoriteWasSawed, responce: Constants.cool)
            } else {
                self.showMessage(message: Constants.whoopsSomethingWentWrong, responce: Constants.okMessage)
            }
        }

        self.showMessage(message: Constants.favoriteWasSawed, responce: Constants.cool)
    }
}
