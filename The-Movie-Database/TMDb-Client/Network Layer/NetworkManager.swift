//
//  NetworkManager.swift
//  TMDb-Client
//
//  Created by Maxim on 23.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

final class NetworkManager {

    private init() { }
    
    static let shared = NetworkManager()

    var mediaList = [Media]()
    typealias CompletionBlock = ([Media]?, _ error: Error?) -> Void
    
    
    //***************************************************
    //MARK: - Get Content Lists -
    //***************************************************
    
    
    func getFilmsList(page: NSInteger, completionBlock: @escaping CompletionBlock) {
        
        mediaList.removeAll()

        let url: String = Constants.baseURL + Constants.movieURL
        
        let parameters = [Constants.apiKey: Constants.accessKey,
                          Constants.language: Constants.languages.enUS,
                          Constants.sortBy: Constants.popularityDesc,
                          Constants.includeAdult: false,
                          Constants.includeVideo: false,
                          Constants.page: String(page)] as [String : Any]
        
        var urlComponent = URLComponents(string: url)!
        let queryItems = parameters.map  { URLQueryItem(name: $0.key, value: $0.value as? String) }
        urlComponent.queryItems = queryItems
        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = Constants.get

        Alamofire.request(request).responseJSON { (response: DataResponse<Any>) in
        
            guard response.result.error == nil else {
                completionBlock(nil, response.result.error)
                return
            }
        
            guard response.result.isSuccess else {
                print("\(Constants.errorFetchingData) \(String(describing: response.result.error))")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                    print(Constants.invalidInformationRecivedFromTheService)
                    return
            }
            
            if let resultJSON = responseJSON[Constants.results] as? [[String:Any]] {
                self.parsingFilmJSON(inputJSON: resultJSON)
                completionBlock(self.mediaList, nil)
            }
        }
    }
    
    
    func getSeriesList(page: NSInteger, completionBlock: @escaping CompletionBlock){
        let url: String = Constants.baseURL + Constants.seriesURL
        mediaList.removeAll()
        
        let parameters = [Constants.apiKey: Constants.accessKey,
                          Constants.language: Constants.languages.enUS,
                          Constants.sortBy: Constants.popularityDesc,
                          Constants.includeNullFirstAirDates: false,
                          Constants.timezone: Constants.timezones.newYork,
                          Constants.page: String(page)] as [String : Any]
        
        var urlComponent = URLComponents(string: url)!
        let queryItems = parameters.map  { URLQueryItem(name: $0.key, value: $0.value as? String) }
        urlComponent.queryItems = queryItems
        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = Constants.get

        Alamofire.request(request).responseJSON { (response: DataResponse<Any>) in
            
            guard response.result.error == nil else {
                completionBlock(nil, response.result.error)
                return
            }
            
            guard response.result.isSuccess else {
                print("\(Constants.errorFetchingData) \(String(describing: response.result.error))")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                    print(Constants.invalidInformationRecivedFromTheService)
                    return
            }
            
            let resultJSON = responseJSON[Constants.results] as? [[String:Any]]
            
            self.parsingSeriesJSON(inputJSON: resultJSON!)
            
            completionBlock(self.mediaList, nil)
        }
    }
    
    
    //***************************************************
    //MARK: - JSON Parsing Functions -
    //***************************************************
    
    //FIXME IF NEED IT
    // It can be parsed in model, but we use one model with realm
    
    func parsingFilmJSON(inputJSON: [[String:Any]]) {
        
        for object in inputJSON {
            
            var film = Media()
            
            film.title = object[JSONKey.originalTitle] as! String
            film.rate = object[JSONKey.voteAverage] as! NSNumber
            film.releaseDate = object[JSONKey.releaseDate] as! String
            film.overview = object[JSONKey.overview] as! String
            if let imageName = object[JSONKey.posterPath] as? String{
                film.image = imageName
            }
            self.mediaList.append(film)
        }
    }
    
    func parsingSeriesJSON(inputJSON: [[String:Any]]) {
        
        for object in inputJSON {

            var series = Media()
            
            series.title = object[JSONKey.originalName] as! String
            series.rate = object[JSONKey.voteAverage] as! NSNumber
            series.releaseDate = object[JSONKey.firstAirDate] as! String
            series.overview = object[JSONKey.overview] as! String
            if let imageName = object[JSONKey.posterPath] as? String{
                series.image = imageName
            }
            self.mediaList.append(series)
        }
    }
    
    
    //***************************************************
    //MARK: - Get Media Search Lists -
    //***************************************************
    
    
    func getSearchResult(mediaType: String, page: NSInteger, searchText: String, completionBlock: @escaping CompletionBlock){
        
        self.mediaList.removeAll()
    
        let url: String = Constants.baseURL + Constants.searchURL + mediaType
        
        let parameters = [Constants.apiKey: Constants.accessKey,
                          Constants.language: Constants.languages.enUS,
                          Constants.includeAdult: false,
                          Constants.page: String(page),
                          Constants.queryURL: searchText] as [String : Any]
        
        var urlComponent = URLComponents(string: url)!
        let queryItems = parameters.map  { URLQueryItem(name: $0.key, value: $0.value as? String) }
        urlComponent.queryItems = queryItems
        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = Constants.get
        request.allHTTPHeaderFields = nil
        
        Alamofire.request(request).responseJSON { (response: DataResponse<Any>) in
            
            guard response.result.error == nil else {
                completionBlock(nil, response.result.error)
                return
            }
            
            guard response.result.isSuccess else {
                print("\(Constants.errorFetchingData) \(String(describing: response.result.error))")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                    print(Constants.invalidInformationRecivedFromTheService)
                    return
            }
            
            let resultJSON = responseJSON[Constants.results] as? [[String:Any]]
            
            if mediaType == Constants.movie{
                self.parsingFilmJSON(inputJSON: resultJSON!)
            } else {
                self.parsingSeriesJSON(inputJSON: resultJSON!)
            }
            completionBlock(self.mediaList, nil)
        }
    }
    
    
    //***************************************************
    //MARK: - Get Image -
    //***************************************************
    
    
    public func getImage(imageName: String, completionBlock: @escaping (UIImage) -> ()){
        
        Alamofire.request(Constants.baseImageURL + imageName, method: .get).responseImage { response in
            
            guard let image = response.result.value else {
                if let placeholderImage = UIImage.init(named: Constants.placeholderImage){
                    completionBlock(placeholderImage)
                }
                print(Constants.downloadError)
                return
            }
            completionBlock(image)
        }
    }
}
