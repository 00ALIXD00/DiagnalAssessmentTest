//
//  Helper.swift
//  StarWebTV
//
//  Created by Ahmed Abbas on 01/09/23.
//

import Foundation
import UIKit

class Helper: NSObject {

    static var deviceToken = NSUUID().uuidString

    static var keyWindow: UIWindow? {
            // Get connected scenes
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
                .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
                .first(where: { $0 is UIWindowScene })
            // Get its associated windows
                .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    static var topSafeAreaHeight: CGFloat {
        return keyWindow?.safeAreaInsets.top ?? 0
    }

    static var bottomSafeAreaHeight: CGFloat {
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }

    static var apiLogEnabled = true

    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map { _ in letters.randomElement() ?? "a" })
    }

    static var screenSize: CGSize {
        UIScreen.main.bounds.size
    }

    static var appName: String {
        Bundle.main.displayName ?? ""
    }

    static var appCurrency: String {
        "₹"
    }
    
    static var deviceHasTopNotch: Bool {
        (appDel?.window?.safeAreaInsets.top ?? 0) > 20
    }

    static var deviceType = "ios"

    static var appBundle: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1.0.0"
    }

    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    static var apiUrlExtension: String {
        return "ios"
    }
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? String()
    }
}

