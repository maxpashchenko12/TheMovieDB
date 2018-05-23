//
//  MediaBaseProtocol.swift
//  TMDb
//
//  Created by Maxim on 21.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation

protocol MediaBaseProtocol {
    
    var title: String { get set }
    var rate: NSNumber { get set }
    var image: String { get set }
    var releaseDate: String { get set }
    var overview: String { get set }
    var type: String { get set }

}
