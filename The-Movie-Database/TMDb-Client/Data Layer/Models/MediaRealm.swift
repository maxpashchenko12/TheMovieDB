//
//  MediaRealm.swift
//  TMDb
//
//  Created by Maxim on 21.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation
import RealmSwift

class MediaRealm: Object, MediaBaseProtocol {
    
    dynamic var title: String = ""
    dynamic var rate: NSNumber = 0.0
    dynamic var image: String = ""
    dynamic var releaseDate: String = ""
    dynamic var overview: String = ""
    dynamic var type: String = ""

}
