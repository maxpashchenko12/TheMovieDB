//
//  SeriesViewController.swift
//  TMDb-Client
//
//  Created by Maxim on 22.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit
import CoreData

class SeriesViewController: MediaViewController, MediaViewControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
        
    let titleController = Constants.series
    
    
    //MARK: - View Controller Methods -
    //***************************************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewController()
    }
    
    override func configureViewController(){
        super.configureViewController()

        title = titleController
        self.delegate = self

        self.currentPageNumber = Constants.one

        self.collectionView.register(UINib.init(nibName: String(describing:SeriesCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing:SeriesCollectionViewCell.self))
    }
    
    func seriesListWasUpdated() {
        
        self.collectionView.reloadData()
    }
}


extension SeriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    //MARK: - UICollectionView Data Source -
    //***************************************************
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SeriesCollectionViewCell.self), for: indexPath) as? SeriesCollectionViewCell {
            
            cell.configure(mediaObject: seriesList[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.one
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seriesList.count
    }

    
    //MARK: - UICollectionView Delegete -
    //***************************************************

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: Constants.main, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: DetailsViewController.self)) as! DetailsViewController
        
        viewController.media = self.seriesList[indexPath.row]
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    //MARK: - UICollectionViewLayout Delegate -
    //***************************************************
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: Constants.halfWidth, height: Constants.halfHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return Constants.standartCollectionViewInsets
    }
}

extension SeriesViewController : UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)) { // scroll to bottom
            
            if(isPageRefresing == false){
                
                isPageRefresing = true
                //show indicator
                currentPageNumber += 1
                self.getSeriesList(currentPage: currentPageNumber)
            }
        }
    }
    
}


