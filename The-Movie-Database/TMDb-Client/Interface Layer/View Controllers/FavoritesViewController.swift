//
//  FavoritesViewController.swift
//  TMDb-Client
//
//  Created by Maxim on 22.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkManager = NetworkManager.shared
    let dataManager = DataManager.shared
    
    var favorites: [MediaRealm] = []
    
    let titleController = Constants.favorites
    

    //MARK: - View Controller Methods -
    //***************************************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupData()
    }
    

    //MARK: - Private -
    //***************************************************
    
    private func configureViewController() {
        title = titleController
    }
    
    private func setupData(){
        
        self.favorites = []
        
        let favoritesResult = DataManager.shared.realm.objects(MediaRealm.self)
        
        for favorite in favoritesResult {
            self.favorites.append(favorite)
            print(favorite)
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: - UITableView Data Source -
    //***************************************************
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath)
        
        cell.textLabel?.text = favorites[indexPath.row].title
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        self.networkManager.getImage(imageName: (self.favorites[indexPath.row].image)) {(image) in
            cell.imageView?.image = image
            cell.setNeedsLayout()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.one
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let foundElement = DataManager.shared.realm.objects(MediaRealm.self).filter(Constants.titleFilter, self.favorites[indexPath.row].title).first
            
            try! DataManager.shared.realm.write {
                
                DataManager.shared.realm.delete(foundElement!)
                self.showMessage(message: Constants.elementWasDeleted, responce: Constants.cool)
            }
            
            self.setupData()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //MARK: - UITableView Delegate - 
    //***************************************************
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.standartCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: Constants.main, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: DetailsViewController.self)) as! DetailsViewController
        
        viewController.typeMedia = Constants.favorite
        viewController.media = (self.favorites[indexPath.row])
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
