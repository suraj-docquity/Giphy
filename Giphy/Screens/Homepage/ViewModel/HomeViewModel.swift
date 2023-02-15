//
//  HomeViewModel.swift
//  Giphy
//
//  Created by Suraj Jaiswal on 15/02/23.
//

import Foundation
import Combine

final class HomeViewModel : ObservableObject{
    
    @Published var gifLinks = [String]()
    
    @Published var gifData : GifData?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchGifData(){
        APIManager.shared.fetchGIFData()
            .receive(on: DispatchQueue.main) // perfoms receive value part in main thread
            .sink(receiveCompletion:{ completion in
                switch completion{
                case .finished:
                    print("Data receiving complete")
                case .failure(let error):
                    print("Data not recived with \(error)")
                }
                
            }, receiveValue: { [weak self] value in
                self?.gifData = value
                
                // original sizen urls
//                for i in value.data {
//                    self?.gifLinks.append(i.images.original.url)
//                }
                
                // for downsized urls
                for i in value.data {
                    self?.gifLinks.append(i.images.downsized.url)
                }
            }).store(in: &cancellables)
        
    }
    
}



