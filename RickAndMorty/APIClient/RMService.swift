//
//  RMService.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 2/3/24.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    private init() {}
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request insatance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> (Void)
    ) {
        
    }
}
