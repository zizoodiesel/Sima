//
//  MovieItem.swift
//  Sima
//
//  Created by Zizoo diesel on 10/4/2023.
//

import Foundation


struct MovieItem: Codable, Hashable {
    
    var title: String
    var overview: String?
    var release_date: String?
    var vote_average: Float
    var poster_path: String?
    var backdrop_path: String?

    
}
