//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 2/11/24.
//

import UIKit

/// controller to show info about single character
final class RMCharacterDetailViewController: UIViewController {
    var viewModel: RMCharacterDetailViewVM
    
    init(viewModel: RMCharacterDetailViewVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }

}
