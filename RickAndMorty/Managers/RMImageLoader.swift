//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 3/24/24.
//

import Foundation

final class RMImageLoader {
    static let shared = RMImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> (Void)) {
        let key = url.absoluteString as NSString //cache key
        
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            //Caching image...
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        .resume()
    }
}
