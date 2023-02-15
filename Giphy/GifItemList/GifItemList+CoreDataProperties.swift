//
//  GifItemList+CoreDataProperties.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 15/02/23.
//
//

import Foundation
import CoreData


extension GifItemList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GifItemList> {
        return NSFetchRequest<GifItemList>(entityName: "GifItemList")
    }

    @NSManaged public var gifID: String?
    @NSManaged public var gifTitle: String?
    @NSManaged public var gifRating: String?
    @NSManaged public var gifURL: String?

}

extension GifItemList : Identifiable {

}
