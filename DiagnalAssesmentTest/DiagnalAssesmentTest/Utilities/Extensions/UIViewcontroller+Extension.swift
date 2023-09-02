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
