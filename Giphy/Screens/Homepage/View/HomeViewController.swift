//
//  HomeViewController.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 15/02/23.
//

import UIKit
import Combine
import SDWebImage

class HomeViewController: UIViewController{
    
    private var homeViewModel = HomeViewModel()
    private var gifData:GifData?
    private var gifLinks = [String]()
    var gifItems = [GifItemList]()

    
    private var cancellables = Set<AnyCancellable>()
    private var tapGesture : UITapGestureRecognizer!
    
    @IBOutlet var homeGifCollectionView: UICollectionView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
}


extension HomeViewController {
    func configuration() {
        initViewModel()
        getAllItems()
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


extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            cell.gifImgView.layer.cornerRadius = 5
            
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
            tapGesture.numberOfTapsRequired = 2
            cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
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
    }
}
