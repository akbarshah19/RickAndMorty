//
//  RMCharacterViewControllerVM.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 2/5/24.
//

import UIKit

protocol RMCharacterListViewControllerVMDelegate: AnyObject {
    func didLoadInitialChars()
    func didSelectCharacter(_ character: RMCharacter)
}

final class RMCharacterListViewVM: NSObject {
    
    public weak var delegate: RMCharacterListViewControllerVMDelegate?
    
    private var isLoadingMore = false
    
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
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    
    ///fetch initial set of characters
    public func fetchCharacters() {
        RMService.shared.execute(.listCharacterReuquest, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.apiInfo  = responseModel.info
                self?.chars = results
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialChars()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    ///paginate if needed
    public func fetchAdditionalCharacters() {
        isLoadingMore = true
        
    }
    
    public var shouldShowLoadIndicator: Bool {
        return apiInfo?.next != nil
    }
}

extension RMCharacterListViewVM: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = chars[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.id,
            for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension RMCharacterListViewVM: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadIndicator, !isLoadingMore else { return }
        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
        if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            fetchAdditionalCharacters()
        }
    }
}
