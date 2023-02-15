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
    var id : String
    var title : String
    var rating : String
    var images : ImgObject
}

struct PageObject :Codable{
    
}

struct MetaObject :Codable{
    
}

struct ImgObject :Codable{
    var original : URIObject
    var downsized : URIDownsizedObject
}

struct URIObject :Codable{
    var url : String
}


struct URIDownsizedObject :Codable{
    var url : String
}
