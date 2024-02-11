//
//  RMCharacterDetailViewVM.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 2/11/24.
//

import Foundation

final class RMCharacterDetailViewVM {
    let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        return character.name.uppercased()
    }
}
