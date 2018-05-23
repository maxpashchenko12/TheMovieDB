//
//  DataManager.swift
//  TMDb-Client
//
//  Created by Maxim on 21.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation
import RealmSwift

final class DataManager {
    
    private init() { }
    
    static let shared = DataManager()
    
    let realm = try! Realm()
    
    func deleteAll() {
        DispatchQueue.global(qos: .userInteractive).sync {
            try! DataManager.shared.realm.write() {
                DataManager.shared.realm.deleteAll()
            }
        }
    }
    
    func addToFavorites(mediaObject: Media) -> Bool {
        
        let mediaRealm = MediaRealm()
        
        mediaRealm.title = mediaObject.title
        mediaRealm.image = mediaObject.image
        mediaRealm.rate = mediaObject.rate
        mediaRealm.releaseDate = mediaObject.releaseDate
        mediaRealm.overview = mediaObject.overview
        mediaRealm.type = mediaObject.type
        
        DispatchQueue.global(qos: .userInteractive).sync {
            
            try! DataManager.shared.realm.write {
                DataManager.shared.realm.add(mediaRealm)
            }
        }
        
        return true
    }
    
    func favoriteIsSaved(favorite: Media) -> Bool {
        
        if (DataManager.shared.realm.objects(MediaRealm.self).filter(Constants.titleFilter, favorite.title).first != nil) {
            return true
        }
        return false
    }
}
