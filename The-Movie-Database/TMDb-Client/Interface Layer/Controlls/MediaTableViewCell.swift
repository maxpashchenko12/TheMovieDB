//
//  MediaTableViewCell.swift
//  TMDb
//
//  Created by Maxim on 21.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {

    let networkManager = NetworkManager.shared

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    

    func configure(mediaObject: Media) {
        
        self.titleLabel.text = mediaObject.title
        self.dateLabel.text = Constants.release + mediaObject.releaseDate
        
        self.networkManager.getImage(imageName: mediaObject.image) { (image) in
            self.posterImageView?.image = image
            self.setNeedsLayout()
        }
                
        let rateString = String(describing: mediaObject.rate)
        self.rateLabel.text = rateString
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        
        self.posterImageView.image = nil
        self.titleLabel.text = nil
        self.dateLabel.text = nil
        self.rateLabel.text = nil
    }    
}
