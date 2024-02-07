//
//  RMCharacterViewControllerVM.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 2/5/24.
//

import UIKit

protocol RMCharacterListViewControllerVMDelegate: AnyObject {
    func didLoadInitialChars()
}

final class RMCharacterListViewControllerVM: NSObject {
    
    public weak var delegate: RMCharacterListViewControllerVMDelegate?
    
    private var chars: [RMCharacter] = [] {
        didSet {
            for char in chars {
                let vm = RMCharacterCCellVM(charName: char.name,
                                            charStatus: char.status,
                                            charImageUrl: URL(string: char.image))
                cellVMs.append(vm)
            }
        }
    }
    
    private var cellVMs: [RMCharacterCCellVM] = []
    
    public func fetchCharacters() {
        RMService.shared.execute(.listCharacterReuquest, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.chars = results
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialChars()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension RMCharacterListViewControllerVM: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCCell.id,
                                                            for: indexPath) as? RMCharacterCCell else {
            fatalError("Unsupported cell")
        }
        let vm = cellVMs[indexPath.row]
        cell.configure(with: vm)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width,
                      height: width*1.5)
    }
}
