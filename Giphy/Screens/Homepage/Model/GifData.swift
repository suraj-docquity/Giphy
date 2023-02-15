//
//  GifData.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 15/02/23.
//

import Foundation


struct GifData :Codable{
    var data : [DataObject]
    var pagination : PageObject
    var meta : MetaObject
}


struct DataObject :Codable {
    var images : ImgObject
}

struct PageObject :Codable{
    
}

struct MetaObject :Codable{
    
}

struct ImgObject :Codable{
    var original : URIObject
}

struct URIObject :Codable{
    var url : String
}
