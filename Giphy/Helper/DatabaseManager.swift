//
//  DatabaseManager.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 15/02/23.
//

import Foundation

extension HomeViewController {
    
    func createItem(gifItem : GifDataDB){
        
        var newItem = GifItemList(context: homeViewContext)
        newItem.gifID = gifItem.gifID
        newItem.gifTitle = gifItem.gifTitle
        newItem.gifRating = gifItem.gifRating
        newItem.gifURL = gifItem.gifURL
        print("item saved : ",newItem)
        
        do{
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
//            print("items fetched : ",favGifItems)
            DispatchQueue.main.async {
                self.FavCollectionView.reloadData()
            }
        }
        catch{
            // TODO: Handle Errors
        }
    }
    
    func getFavGifURL(){
        for i in favGifItems{
//            print(i.gifURL!)
            favGifLinks.append(i.gifURL!)
        }
        DispatchQueue.main.async {
            self.FavCollectionView.reloadData()
        }
    }
    
    
}
