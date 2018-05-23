//
//  DataManager.swift
//  TMDb-Client
//
//  Created by Alexander Slobodjanjuk on 28.06.17.
//  Copyright © 2017 Alexander Slobodjanjuk. All rights reserved.
//

import Foundation
import CoreData

final class DataManager {
    
    private init() { }

    static let shared = DataManager()

    var favorites: [NSManagedObject] = []
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "TMDb_Client")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Public Functions
    
    func saveObject(title: String, poster: String, rate: String, releaseDate: String, complete: (Bool) -> ()){
        
        let managedContext = self.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Favorites",
                                                in: managedContext)!
        
        let favorite = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        favorite.setValue(title, forKeyPath: "title")
        favorite.setValue(rate, forKeyPath: "rate")
        favorite.setValue(releaseDate, forKeyPath: "releaseDate")
        favorite.setValue(poster, forKeyPath: "poster")
        
        do {
            try managedContext.save()
            favorites.append(favorite)
            complete(true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchData (fetchResult: ([Media]) -> ()) {
        
        let managedContext = self.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        do {
            favorites = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        fetchResult(convertData())
    }
    
    func deleteData (row: Int, fetchResult: ([Media]) -> ()){

        let managedContext = self.persistentContainer.viewContext
        
        let favorite = favorites[row]
        
        self.persistentContainer.viewContext.delete(favorite)
        favorites.remove(at: row)
        
        print(favorites)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        fetchResult(convertData())
    }
    
    
    // MARK: - Convert Data

    
    func convertData() -> [Media]{
        
        var favoriteList = [Media]()
        
        guard favorites.count != 0 else {
            return favoriteList
        }
        
        for object in 0...favorites.count - 1 {
            
            let favorite = Media()
            
            favorite.title = favorites[object].value(forKey: "title") as! String
            favorite.image = favorites[object].value(forKey: "poster") as! String
            favorite.releaseDate = favorites[object].value(forKey: "releaseDate") as! String
            
            let rateStr = favorites[object].value(forKey: "rate") as! String
            
            if let rateInt = Int(rateStr) {
                let rateNuber = NSNumber(value:rateInt)
                favorite.rate = rateNuber
            } //!
            
            favoriteList.append(favorite)
        }
        return favoriteList
    }

}
