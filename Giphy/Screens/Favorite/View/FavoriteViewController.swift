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
    private var layoutToggle : Bool = false
    private var spacing:CGFloat = 10

    
    var favGifItems = [GifItemList]()

    let favViewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func changeLayoutBtn(_ sender: Any) {
        layoutToggle = !layoutToggle
        changeLayout()
    }
    
    @IBOutlet var FavCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllItems()
        FavCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        changeLayout()
    }
}

extension FavoriteViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        cell.favGifImgView.layer.cornerRadius = 2
        
        cell.layer.cornerRadius = 5
        cell.backgroundColor =  .white
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfItemsPerRow:CGFloat
        var spacingBetweenCells:CGFloat
        
        if(layoutToggle){
            numberOfItemsPerRow = 1
            spacingBetweenCells = 1
        }else{
            numberOfItemsPerRow = 2
            spacingBetweenCells = 2
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) // Amount of total spacing in a row
        
        if let collection = self.FavCollectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}


extension FavoriteViewController {
    
    @objc func didDoubleTap(_ gesture: UITapGestureRecognizer){
        
        // tap to location to get index of cell in collection
        let tap = gesture.location(in: self.FavCollectionView)
        let indexPath : NSIndexPath = self.FavCollectionView.indexPathForItem(at: tap)! as NSIndexPath
        
        let dItem = self.favGifItems[indexPath.row]
        showTrash(gesture)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.deleteItem(item: dItem)
        })
    }
    
    func showTrash(_ gesture: UITapGestureRecognizer){
        
        guard let gestureView = gesture.view else{
            return
        }
        
        let size = gestureView.frame.size.width/4
        let trash = UIImageView(image: UIImage(systemName: "trash.circle.fill"))
        trash.frame = CGRect(x: (gestureView.frame.size.width - size)/2, y: (gestureView.frame.size.height - size)/2, width: size, height: size)
        trash.tintColor = .white
        trash.alpha = 0
        gestureView.addSubview(trash)
        
        UIView.animate(withDuration: 0.2,animations: {
            trash.alpha = 1
        }, completion: { done in
            if(done){
                UIView.animate(withDuration: 0.4, animations: {
                    trash.alpha = 0
                }, completion: { done in
                    if(done){
                        trash.removeFromSuperview()
                    }
                })
            }
        })
    }
}

extension FavoriteViewController {
    func changeLayout(){
        if(layoutToggle){
            FavCollectionView?.collectionViewLayout = UICollectionViewFlowLayout()
        }
        DispatchQueue.main.async {
            self.FavCollectionView?.reloadData()
        }
    }
}




