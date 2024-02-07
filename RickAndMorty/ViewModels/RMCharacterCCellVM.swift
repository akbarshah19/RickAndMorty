//
//  RMCharacterCCellVM.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 2/7/24.
//

import Foundation

final class RMCharacterCCellVM {
    public let charName: String
    private let charStatus: RMCharacterStatus
    private let charImageUrl: URL?
    
    init(charName: String, charStatus: RMCharacterStatus, charImageUrl: URL?) {
        self.charName = charName
        self.charStatus = charStatus
        self.charImageUrl = charImageUrl
    }
    
    public var charStatusText: String {
        return "Status: \(charStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> (Void)) {
        guard let url = charImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
