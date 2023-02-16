//
//  DatabaseManager.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 15/02/23.
//

import Foundation
import CoreData

extension HomeViewController {
    
    func createItem(gifItem : GifDataDB){
        
        let fetchRequest: NSFetchRequest<GifItemList>
        fetchRequest = GifItemList.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "gifID = %@",gifItem.gifID
        )
        do{
            
            let objects = try homeViewContext.fetch(fetchRequest)
            if(!objects.isEmpty){
//                print("found : ",objects) // found duplicate object
                return
            }else{
                let newItem = GifItemList(context: homeViewContext)
                newItem.gifID = gifItem.gifID
                newItem.gifTitle = gifItem.gifTitle
                newItem.gifRating = gifItem.gifRating
                newItem.gifURL = gifItem.gifURL
            }
            try homeViewContext.save()
        }
        catch{
            // TODO: Handle Errors
        }
    }
}


extension FavoriteViewController {
    
    func getAllItems() {
        do
        {
            favGifItems = try favViewContext.fetch(GifItemList.fetchRequest())
            DispatchQueue.main.async {
                self.FavCollectionView.reloadData()
            }
        }
        catch{
            // TODO: Handle Errors
        }
    }
    
    func deleteItem(item : GifItemList){
        favViewContext.delete(item)
        do{
            try favViewContext.save()
            getAllItems()
        }
        catch{
            // TODO: Handle Errors
        }
    }
}
