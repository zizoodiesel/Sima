//
//  MoviesResponse.swift
//  Sima
//
//  Created by Zizoo diesel on 10/4/2023.
//

import Foundation

struct MoviesResponse: Codable {
    
    var page: Int
    var results: [MovieItem]
    var total_pages: Int
    var total_results: Int

    
}
