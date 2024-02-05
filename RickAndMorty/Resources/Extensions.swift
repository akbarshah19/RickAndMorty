//
//  Extensioins.swift
//  RickAndMorty
//
//  Created by Akbarshah Jumanazarov on 2/5/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}


