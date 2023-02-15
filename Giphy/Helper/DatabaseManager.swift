//
//  DatabaseManager.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 15/02/23.
//

import Foundation

extension HomeViewController {
    
    func getAllItems(){
        do
        {
            gifItems = try context.fetch(GifItemList.fetchRequest())
            print("items fetched : ",gifItems)
//            DispatchQueue.main.async {
//                self.homeGifCollectionView.reloadData()
//            }
//            homeGifCollectionView.reloadData()
        }
        catch{
            // TODO: Handle Errors
        }
    }
    
    func createItem(gifItem : GifDataDB){
        
        var newItem = GifItemList(context: context)
        newItem.gifID = gifItem.gifID
        newItem.gifTitle = gifItem.gifTitle
        newItem.gifRating = gifItem.gifRating
        newItem.gifURL = gifItem.gifURL
        print("item saved : ",newItem)
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            // TODO: Handle Errors
        }
    }
    
    func deleteItem(){
        do{
            
        }
        catch{
            // TODO: Handle Errors
        }
    }
}
