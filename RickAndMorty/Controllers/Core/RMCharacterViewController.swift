//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 2/2/24.
//

import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let req = RMRequest(endpoint: .character)
        print(req.url)
        
        RMService.shared.execute(req, expecting: RMCharacter.self) { result in
            
        }
    }
}
