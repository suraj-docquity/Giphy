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
    
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet var homeGifCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
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


extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return homeViewModel.gifLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = homeGifCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeGifCollectionViewCell
        
        guard let gifImgURL = URL(string: self.homeViewModel.gifLinks[indexPath.row]) else {
            cell.gifImgView.image = UIImage(named: "empty-img.png")
            return cell
        }
            
            cell.gifImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.gifImgView.sd_imageIndicator?.startAnimatingIndicator()
            cell.gifImgView.sd_setImage(with: gifImgURL, placeholderImage: UIImage(named: "empty-img.png"),options: .continueInBackground,completed: nil)
            
            cell.gifImgView.contentMode = .scaleToFill
            cell.gifImgView.layer.cornerRadius = 5
            
            
        
        return cell
    }
}
