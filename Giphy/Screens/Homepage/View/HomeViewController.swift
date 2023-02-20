//
//  HomeViewController.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 15/02/23.
//

import UIKit
import Combine
import SDWebImage
import Toast

class HomeViewController: UIViewController{
    
    private var homeViewModel = HomeViewModel()
    private var gifData:GifData?
    private var gifLinks = [String]()

    private var cancellables = Set<AnyCancellable>()
    private var tapGesture : UITapGestureRecognizer!
    
    @IBOutlet var homeGifCollectionView: UICollectionView!
    
    let homeViewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
//        homeGifCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
}


extension HomeViewController {
    func configuration() {
        initViewModel()
    }
    
    
    func initViewModel(){
        homeViewModel.fetchGifData()
        homeViewModel.$gifLinks
            .sink(receiveValue: { [weak self] data in
                
                self?.gifLinks = data
                DispatchQueue.main.async {
                    self?.homeGifCollectionView.reloadData()
                }
                
            })
            .store(in: &cancellables)
        
        
        homeViewModel.$gifData
            .sink(receiveValue: { [weak self] data in
                
                self?.gifData=data
                DispatchQueue.main.async {
                    self?.homeGifCollectionView.reloadData()
                }
                
            })
            .store(in: &cancellables)
    }
}


extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return gifLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = homeGifCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeGifCollectionViewCell
        
        guard let gifImgURL = URL(string: self.gifLinks[indexPath.row]) else {
            cell.gifImgView.image = UIImage(named: "empty-img.png")
            return cell
        }
            
        cell.gifImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.gifImgView.sd_imageIndicator?.startAnimatingIndicator()
        cell.gifImgView.sd_setImage(with: gifImgURL, placeholderImage: UIImage(named: "empty-img.png"),options: .continueInBackground,completed: nil)
        
        cell.gifImgView.contentMode = .scaleToFill
        cell.gifImgView.layer.cornerRadius = 3
        
        cell.layer.cornerRadius = 5
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let spacing:CGFloat = 16
//        let numberOfItemsPerRow:CGFloat = 2
//        let spacingBetweenCells:CGFloat = 8
//
//        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
//
//        if let collection = self.homeGifCollectionView{
//            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
//            return CGSize(width: width, height: width)
//        }else{
//            return CGSize(width: 0, height: 0)
//        }
//    }
    
}

extension HomeViewController {
    
    @objc func didDoubleTap(_ gesture: UITapGestureRecognizer){
        // tap to location to get index of cell in collection
        let tap = gesture.location(in: self.homeGifCollectionView)
        let indexPath : NSIndexPath = self.homeGifCollectionView.indexPathForItem(at: tap)! as NSIndexPath
        
//        print("Double tapped index \(indexPath.row) ",gifLinks[indexPath.row])
//        print("Double tapped index \(indexPath.row) ",gifData?.data[indexPath.row])

        let gifTappedData = gifData?.data[indexPath.row]
        
        let newGif = GifDataDB(gifID: gifTappedData!.id, gifTitle: gifTappedData!.title, gifRating: gifTappedData!.rating, gifURL: (gifTappedData?.images.downsized.url)!)

        createItem(gifItem: newGif)
        showHeart(gesture)
        
        self.view.makeToast("Added to favorites",duration: 2)

    }
    
    func showHeart(_ gesture: UITapGestureRecognizer){
        
        guard let gestureView = gesture.view else{
            return
        }
        
        let size = gestureView.frame.size.width/4
        let heart = UIImageView(image: UIImage(systemName: "heart.circle.fill"))
        heart.frame = CGRect(x: (gestureView.frame.size.width - size)/2, y: (gestureView.frame.size.height - size)/2, width: size, height: size)
        
        heart.tintColor = .white
        heart.alpha = 0
        gestureView.addSubview(heart)
        
        UIView.animate(withDuration: 0.2,animations: {
            heart.alpha = 1
        }, completion: { done in
            if(done){
                UIView.animate(withDuration: 1, animations: {
                    heart.alpha = 0
                }, completion: { done in
                    if(done){
                        heart.removeFromSuperview()
                    }
                })
            }
        })
    }
    
    
}
