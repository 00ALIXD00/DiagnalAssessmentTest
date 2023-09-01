//
//  UIViewcontroller+Extension.swift
//  StarWebTV
//
//  Created by Ahmed Abbas on 01/09/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Show toast message
    func showToast(title: String = "Failed", message: String, status: MessageAlertState = .failure, duration: Double = 2.0,completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            ToastAlert.show(title: title, delay: duration, message: message, state: status, completion: completion)
        }
    }
    
}

class MarqueeLabel: UILabel {
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        return CGSize(width: originalContentSize.width, height: originalContentSize.height)
    }
    
    override func drawText(in rect: CGRect) {
        let newRect = CGRect(x: 0, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        super.drawText(in: newRect)
    }
    
//    func startMarqueeAnimation() {
//            let animationDuration: TimeInterval = 10.0
//
//            let endX = intrinsicContentSize.width - bounds.width
//            let requiredWidth = intrinsicContentSize.width + bounds.width
//
//            frame.size.width = requiredWidth
//            textAlignment = .left
//
//            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveLinear, .repeat], animations: {
//                self.transform = CGAffineTransform(translationX: -endX, y: 0)
//            })
//        }

    
    func startMarqueeAnimation() {
            let animationDuration: TimeInterval = 10.0
            
            let endX = intrinsicContentSize.width - bounds.width
            let requiredWidth = intrinsicContentSize.width
            
            frame.size.width = requiredWidth
            textAlignment = .left
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveLinear, .repeat], animations: {
                self.transform = CGAffineTransform(translationX: -endX, y: 0)
            }) { _ in
                self.transform = .identity
                self.frame.size.width = self.bounds.width
                self.textAlignment = .center
                self.startMarqueeAnimation()
            }
        }

    
    func stopMarqueeAnimation() {
        layer.removeAllAnimations()
        transform = .identity
    }
}
