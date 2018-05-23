//
//  SeriesCollectionViewCell.swift
//  TMDb-Client
//
//  Created by Maxim on 21.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class SeriesCollectionViewCell: UICollectionViewCell {

    let networkManager = NetworkManager.shared

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    

    func configure(mediaObject: Media) {
        
        self.titleLabel.text = mediaObject.title
        self.releaseLabel.text = mediaObject.releaseDate
        
        self.networkManager.getImage(imageName: mediaObject.image) { (image) in
            
            self.posterImageView?.image = image
            self.setNeedsLayout()
        }
        
        let rateString = String(describing: mediaObject.rate)
        self.rateLabel.text = rateString
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.posterImageView.image = nil
        self.titleLabel.text = nil
        self.releaseLabel.text = nil
        self.rateLabel.text = nil
    }
}
