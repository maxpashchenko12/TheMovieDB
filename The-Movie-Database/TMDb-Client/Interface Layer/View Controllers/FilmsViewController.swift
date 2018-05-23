//
//  FilmsViewController.swift
//  TMDb-Client
//
//  Created by Maxim on 22.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import NVActivityIndicatorView

class FilmsViewController: MediaViewController, MediaViewControllerDelegate, UISearchBarDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    let titleController = Constants.films
    
    //***************************************************
    //MARK: - View Controller Methods -
    //***************************************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewController()
    }
    
    override func configureViewController(){
        super.configureViewController()
        
        self.title = titleController
        self.delegate = self

        self.tableView.register(UINib.init(nibName: String(describing:MediaTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing:MediaTableViewCell.self))
        
        self.currentPageNumber = Constants.one
        
        self.configureSearchController()
    }
    
    func configureSearchController() {
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchController.searchBar

    }
    
    func filmsListWasUpdated() {
        
        self.tableView.reloadData()
    }

    
    //***************************************************
    // MARK: - UISearchBar Delegate -
    //***************************************************
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if (searchBar.text != ""){
            self.getFilmsSearchList(searchText: searchBar.text!)
        }
        
        self.searchBarCancelButtonClicked(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if (searchBar.text == ""){
            self.networkManager.getFilmsList(page: currentPageNumber) { [weak self] (filmsList, error) in
                
                guard let `self` = self else { return }

                self.filmsList = filmsList!
                self.tableView.reloadData()
            }
        }
    }
    
}


extension FilmsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //***************************************************
    //MARK: - UITableView Data Source -
    //***************************************************
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:MediaTableViewCell.self), for: indexPath) as? MediaTableViewCell {
            
            cell.configure(mediaObject: self.filmsList[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.one
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //***************************************************
    //MARK: - UITableView Delegate - 
    //***************************************************
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.standartCellHeight
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let addToFavorites = UITableViewRowAction(style: .normal, title: Constants.addToFavorites) { action, index in
            
            if DataManager.shared.favoriteIsSaved(favorite: self.filmsList[index.row]){
                self.showMessage(message: Constants.movieAlreadySaved, responce: Constants.okMessage)
            } else {
                if DataManager.shared.addToFavorites(mediaObject: self.filmsList[index.row]) {
                    self.showMessage(message: Constants.favoriteWasSawed, responce: Constants.cool)
                } else {
                    self.showMessage(message: Constants.whoopsSomethingWentWrong, responce: Constants.okMessage)
                }
            }
            
            tableView.setEditing(false, animated: true)
        }
        
        addToFavorites.backgroundColor = .lightGray
        
        return [addToFavorites]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.main, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: DetailsViewController.self)) as! DetailsViewController
        
        viewController.media = self.filmsList[indexPath.row]
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) { // scroll to bottom
            
            if(self.isPageRefresing == false){
                
                self.isPageRefresing = true
                //show indicator
                self.currentPageNumber += 1
                self.getFilmsList(currentPage: currentPageNumber)
            }
        }
    }
    
    
}
