//
//  UICollectionView+Extension.swift
//  StarWebTV
//
//  Created by Ahmed Abbas on 01/09/23.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func setEmptyMessage(_ message: String, image: String = "") {
        
        // Create the stack view
        
        let mainView = UIView(frame: bounds)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        mainView.addSubview(stackView)
        
        // Center the stack view horizontally and vertically within the custom view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: -50).isActive = true
        
        // Create the image view
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: mainView.frame.width).isActive = true
        
        // Create the label
        let label = UILabel()
        label.text = message
        label.font = FontBook.Regular.of(size: 16)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.white
        stackView.addArrangedSubview(label)
        
        self.backgroundView = mainView
    }
    
}


extension UICollectionViewCell{
    
    /// Start animation skeleton loading
    func startCollSkeleton(){
        DispatchQueue.main.async {
            let subView = self.contentView.subviews.filter({$0.isKind(of: UILabel.self)})
            SkeletonLoading.startForViews(for: subView)
        }
    }
    
    /// Stop skeleton loading
    func stopCollSkeleton() {
        DispatchQueue.main.async {
            let subView = self.contentView.subviews.filter({$0.isKind(of: UILabel.self)})
            SkeletonLoading.stopForViews(for: subView)
        }
    }
}

extension UICollectionView {
        
    /// Reload collectionView with animation
    func reloadCollectionWithAnimation(duration: CGFloat = 1.0) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {self.reloadData()}, completion: nil)
    }
}
