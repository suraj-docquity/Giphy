//
//  GifDataDB.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 15/02/23.
//

import Foundation


class GifDataDB {
    var gifID: String
    var gifTitle: String
    var gifRating: String
    var gifURL: String
    
    init(gifID : String, gifTitle : String, gifRating : String, gifURL : String) {
        self.gifID = gifID
        self.gifTitle = gifTitle
        self.gifRating = gifRating
        self.gifURL = gifURL
    }
}
