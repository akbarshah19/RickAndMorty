//
//  RMCharacterCCellVM.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 2/7/24.
//

import Foundation

final class RMCharacterCCellVM: Hashable, Equatable {
    
    public let charName: String
    private let charStatus: RMCharacterStatus
    private let charImageUrl: URL?
    
    static func == (lhs: RMCharacterCCellVM, rhs: RMCharacterCCellVM) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(charName)
        hasher.combine(charStatus)
        hasher.combine(charImageUrl)
    }
    
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
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
}
