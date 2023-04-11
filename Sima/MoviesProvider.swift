//
//  MoviesProvider.swift
//  Sima
//
//  Created by Zizoo diesel on 10/4/2023.
//

import Foundation


struct MoviesProvider {
    
    /**
     1. Create a function that will use the ResourceReader to read the data.json file and map the data to the corresponding models.
     2. Any feed items with the same title are considered duplicates and should be removed.
     3. Sort the FeedItem objects in alphabetical order by title.
     4. Make sure not to block the main thread when this task is performed.
     Note that this function should be used by FeedViewController to get the array of filtered and sorted FeedItem objects.
     */
    
    
    enum AlbumsFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    func fetch(page: Int) async throws -> (movies: [MovieItem], currentPage: Int, totalPages: Int) {
        
        print("url : \("https://api.themoviedb.org/3/discover/movie?api_key=c9856d0cb57c3f14bf75bdc6c063b8f3&page=" + String(page))")
    
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=c9856d0cb57c3f14bf75bdc6c063b8f3&page=" + String(page)) else {
            throw AlbumsFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        guard let moviesDBResults = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                    //print(error.localizedDescription)
                    fatalError("Failed to decode from bundle.")
                }

//        print(iTunesResult)
        
        print("returning results")
        return (moviesDBResults.results, moviesDBResults.page, moviesDBResults.total_pages)
        

        
    
    }
    
}
