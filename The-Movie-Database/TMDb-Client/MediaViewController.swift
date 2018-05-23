//
//  MediaViewController.swift
//  TMDb-Client
//
//  Created by Maxim on 23.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit


//MARK: - MediaViewControllerDelegate -
//***************************************************


protocol MediaViewControllerDelegate: class {
    
    func filmsListWasUpdated()
    func seriesListWasUpdated()
}

extension MediaViewControllerDelegate {
    
    func filmsListWasUpdated() {}
    func seriesListWasUpdated() {}
}


//MARK: - Parent Class -
//***************************************************


class MediaViewController: UIViewController {

    weak var delegate: MediaViewControllerDelegate?
    
    let networkManager = NetworkManager.shared
    let dataManager = DataManager.shared
    
    var currentFilm = Media()
    var filmsList = [Media]()
    
    var currentSeries = Media()
    var seriesList = [Media]()
    
    var currentPageNumber: Int = 1
    var isPageRefresing: Bool = false

    
    //MARK: - View Controller Methods -
    //***************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureViewController()
    }

    
    func configureViewController(){
        
        self.getFilmsList(currentPage: currentPageNumber)
        self.getSeriesList(currentPage: currentPageNumber)
    }

    
    //MARK: - Loading Film list -
    //***************************************************
    
    func getFilmsList(currentPage: Int){
        
        self.startAnimating()
        
        self.networkManager.getFilmsList(page: currentPage) { [weak self] (filmsList, error) in
            
            guard let `self` = self else { return }
            
            if error == nil {
                self.filmsList.append(contentsOf: filmsList!)
                self.delegate?.filmsListWasUpdated()
            }
            
            self.stopAnimating()
//            self.isPageRefresing = false
        }
    }
    
    func getFilmsSearchList(searchText: String){
        
        self.startAnimating()
        
        self.networkManager.getSearchResult(mediaType: Constants.movie, page: Constants.one, searchText: searchText) { [weak self] (filmsList, error) in
            
            guard let `self` = self else { return }
            
            self.stopAnimating()
            
            if filmsList != nil {
                self.filmsList = filmsList!
            } else {
                self.showMessage(message: Constants.noResultsMessage, responce: Constants.okMessage)
            }
            
            self.delegate?.filmsListWasUpdated()
        }
    }
    
    
    //MARK: - Load Series list -
    //***************************************************
    
    func getSeriesList(currentPage: Int){
        
        self.startAnimating()
        
        self.networkManager.getSeriesList(page: currentPage) { [weak self] (seriesList, error) in
            
            guard let `self` = self else { return }
            
            self.stopAnimating()
//            self.isPageRefresing = false
            
            guard error == nil else {
                self.showMessage(message: Constants.noResultsMessage, responce: Constants.okMessage)
                return
            }
            
            self.seriesList.append(contentsOf: seriesList!)
            self.delegate?.seriesListWasUpdated()
        }
    }
    
    func getSeriesSearchList(searchText: String) {
        
        self.startAnimating()
        
        self.networkManager.getSearchResult(mediaType: Constants.tv, page: Constants.one, searchText: searchText) { [weak self] (seriesList, error) in
            
            guard let `self` = self else { return }
            
            self.stopAnimating()
            
            guard seriesList != nil else {
                self.showMessage(message: Constants.noResultsMessage, responce: Constants.okMessage)
                return
            }

            self.delegate?.seriesListWasUpdated()
        }
    }
    
}
