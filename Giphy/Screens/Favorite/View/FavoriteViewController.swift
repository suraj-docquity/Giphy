//
//  FavoriteViewController.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 13/02/23.
//

import UIKit
import SDWebImage

class FavoriteViewController: UIViewController {
    
    private var tapGesture : UITapGestureRecognizer!
    
    var favGifItems = [GifItemList]()

    let favViewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBOutlet var FavCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllItems()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
    }
}


extension FavoriteViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favGifItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = FavCollectionView.dequeueReusableCell(withReuseIdentifier: "fav-cell", for: indexPath) as! FavoriteCollectionViewCell
        
        guard let gifImgURL = URL(string: self.favGifItems[indexPath.row].gifURL!) else {
            cell.favGifImgView.image = UIImage(named: "empty-img.png")
            return cell
        }
            
            cell.favGifImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.favGifImgView.sd_imageIndicator?.startAnimatingIndicator()
            cell.favGifImgView.sd_setImage(with: gifImgURL, placeholderImage: UIImage(named: "empty-img.png"),options: .continueInBackground,completed: nil)
            
            cell.favGifImgView.contentMode = .scaleToFill
            cell.favGifImgView.layer.cornerRadius = 5
            
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
            tapGesture.numberOfTapsRequired = 2
            cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
}


extension FavoriteViewController {
    
    @objc func didDoubleTap(_ gesture: UITapGestureRecognizer){
        
        // tap to location to get index of cell in collection
        let tap = gesture.location(in: self.FavCollectionView)
        let indexPath : NSIndexPath = self.FavCollectionView.indexPathForItem(at: tap)! as NSIndexPath

        let dItem = self.favGifItems[indexPath.row]
        deleteItem(item: dItem)
    }
}






