//
//  Constants.swift
//  TMDb
//
//  Created by Maxim on 21.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation
import UIKit

struct Constants {

    //***************************************************
    //MARK: - Network Manager -
    //***************************************************

    
    struct languages {
        static let enUS = "en-US"
        static let enUK = "en-UK"
    }
    
    struct timezones {
        static let newYork = "America%2FNew_York"
        
    }
    
    static let get = "GET"
    static let post = "POST"

    static let apiKey = "api_key"
    
    static let results = "results"
    
    static let searchText = "searchText"

    static let baseURL = "https://api.themoviedb.org/3"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500/"
    static let accessKey = "2c83ce5eeb20caa717b3641b0dd1287f"

    static let movieURL = "/discover/movie"
    static let seriesURL = "/discover/tv"
    static let searchURL = "/search/"
    static let queryURL = "query"
    
    static let language = "language"
    static let includeAdult = "include_adult"
    static let includeVideo = "include_video"
    static let includeNullFirstAirDates = "include_null_first_air_dates"

    static let page = "page"
    static let sortBy = "sort_by"
    static let popularityDesc = "popularity.desc"
    static let timezone = "timezone"
    
    static let errorFetchingData = "Error while fetching data:"
    static let invalidInformationRecivedFromTheService = "Invalid information received from the service"
    static let downloadError = "download error"
    
    static let placeholderImage = "poster-placeholder"



    //***************************************************
    //MARK: - UIViewControllers -
    //***************************************************

    static let films = "Films".localized
    static let release = "Release: ".localized
    static let rate = "Rate: ".localized
    static let addToFavorites = "Add to favorites".localized
    
    static let favoriteWasSawed = "Favorite was saved".localized
    static let cool = "Сool!".localized
    static let whoopsSomethingWentWrong = "Whoops Something Went Wrong".localized    
    
    static let movie = "movie"
    static let film = "Film"

    static let main = "Main"

    static let noResultsMessage = "No results".localized
    static let okMessage = "Ok".localized
    
    static let series = "Series".localized
    static let serial = "Serial".localized
    static let tv = "tv".localized

    static let favorites = "Favorites".localized
    static let elementWasDeleted = "Element was deleted".localized
    static let favorite = "Favorite".localized
    
    static let cell = "Cell"
    static let titleFilter = "title == %@"
    
    static let movieAlreadySaved = "The movie has already been added to the favorites".localized
    static let seriesAlreadySaved = "The series is already been added to the favorites".localized


    // -
    
    static let one = 1
    static let three = 3

    static let halfWidth = UIScreen.main.bounds.width/2.15
    static let halfHeight = UIScreen.main.bounds.height/2.15

    static let standartCellHeight: CGFloat = 140.0

    static let standartCollectionViewInsets = UIEdgeInsets.init(top: 0, left: 6.0, bottom: 0, right: 6.0)

}
