//
//  Media.swift
//  TMDb-Client
//
//  Created by Maxim on 23.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation

struct Media: MediaBaseProtocol {
    
    var title: String = ""
    var rate: NSNumber = 0.0
    var image: String = ""
    var releaseDate: String = ""
    var overview: String = ""
    var type: String = ""

}
