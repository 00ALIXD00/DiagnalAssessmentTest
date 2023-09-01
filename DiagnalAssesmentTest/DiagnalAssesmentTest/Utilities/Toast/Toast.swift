//
//  Toast.swift
//  StarWebTV
//
//  Created by Ahmed Abbas on 01/09/23.
//

import Foundation
import UIKit

enum MessageAlertState {
    case success, failure, info, theme, download
}

// MARK: - Toast Alert Images
let alertCheckImg = UIImage(systemName: "checkmark.circle.fill")
let alertCancelImg = UIImage(systemName: "xmark.circle.fill")
let alertInfoImg = UIImage(systemName: "info.circle.fill")

enum ViewComponentsTags: Int {
    case activityIndicator = 1001
    case toastView = 2002
}

struct ToastColor {
    static let success = #colorLiteral(red: 0.3803921569, green: 0.631372549, blue: 0.09019607843, alpha: 1)
    static let failure = #colorLiteral(red: 0.9764705882, green: 0.2588235294, blue: 0.1843137255, alpha: 1)
    static let info = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
    static let download = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
}

class ToastAlert {

    /// Show toast
    static func show(title: String = "", delay: Double = 2.0, message: String, state: MessageAlertState, completion: (() -> Void)? = nil) {
        guard let window = Helper.keyWindow else { return}

        let toastContainer = UIView(frame: CGRect())
        toastContainer.tag = ViewComponentsTags.toastView.rawValue
        if window.viewWithTag(ViewComponentsTags.toastView.rawValue) != nil {
            return
        }

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeUp.direction = .up
        toastContainer.addGestureRecognizer(swipeUp)

        let toastLabel = UILabel(frame: CGRect())
        let statusImage = UIImageView(frame: CGRect())
        switch state {
        case .success:
            toastContainer.backgroundColor = ToastColor.success
            statusImage.image = alertCheckImg
        case .failure:
            toastContainer.backgroundColor =  ToastColor.failure
            statusImage.image = alertCancelImg
        case .info:
            toastContainer.backgroundColor =  ToastColor.info
            statusImage.image = alertInfoImg

        case .theme:
            toastContainer.backgroundColor = .darkGray // ThemeColor.AppTheme
            statusImage.image = alertInfoImg

        case .download:
            toastContainer.backgroundColor = ToastColor.info
            statusImage.image = alertCheckImg
        }

        statusImage.layer.cornerRadius = 15
        statusImage.clipsToBounds = true

        toastContainer.alpha = 1.0
        toastContainer.layer.cornerRadius = 15
        toastContainer.clipsToBounds = true

        toastLabel.textAlignment = .left

        if title != "" {
//            toastLabel.addInterlineSpacing(title: "\(title)\n", message: message, spacingValue: 1.5)
            let messagetoPrint = NSMutableAttributedString().normal(message, fontSize: 15.0, fontColor: .white)
            toastLabel.attributedText = messagetoPrint
        } else {
            let messagetoPrint = NSMutableAttributedString().normal(message, fontSize: 15.0, fontColor: .white)
            toastLabel.attributedText = messagetoPrint
        }

        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(statusImage)
        toastContainer.addSubview(toastLabel)

        statusImage.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let ileading = NSLayoutConstraint(item: statusImage, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        statusImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        statusImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let icenterY = NSLayoutConstraint(item: statusImage, attribute: .centerY, relatedBy: .equal, toItem: toastContainer, attribute: .centerY, multiplier: 1, constant: 0)
        toastContainer.addConstraints([ileading, icenterY])

        let atrailing1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: statusImage, attribute: .trailing, multiplier: 1, constant: 15)
        let atrailing2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let abottom3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let atop4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([atrailing1, atrailing2, abottom3, atop4])

        window.addSubview(toastContainer)

        let cleading1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: window, attribute: .leading, multiplier: 1, constant: 20)
        let ctrailing2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: window, attribute: .trailing, multiplier: 1, constant: -20)
        let ctop3 = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1, constant: 0)
        window.addConstraints([cleading1, ctrailing2, ctop3])

        DispatchQueue.main.async {
            ctop3.constant = 50

            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveLinear, .allowUserInteraction]) {
                window.layoutIfNeeded()
            } completion: { _ in
                ctop3.constant = 0
                UIView.animate(withDuration: 0.1, delay: delay, options: .curveLinear) {
                    window.layoutIfNeeded()
                } completion: { _ in
                    toastContainer.removeFromSuperview()
                    completion?()
                }
            }
        }
    }

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case .up: return
                default: break
            }
        }
    }

    func removeToast() {
        if let tostVW = appDel?.window?.viewWithTag(ViewComponentsTags.toastView.rawValue) {
            tostVW.removeFromSuperview()
        }
    }
}

private extension UILabel {

    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(title: String, message: String, spacingValue: CGFloat) {

        // MARK: - Check if there's any text

        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString()
            .bold(title, fontSize: 15.0, fontColor: .white)
            .normal(message, fontSize: 14.0, fontColor: .white)

        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()

        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue

        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
                          ))

        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }

}

extension NSMutableAttributedString {
    var fontSize: CGFloat { return 18 }
    var normalFont: UIFont { return FontBook.Regular.of(size: fontSize) }

    /// Bold font attributed string
    func bold(_ value: String, fontSize: CGFloat, fontColor: UIColor = .white) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontBook.Bold.of(size: fontSize),
            .foregroundColor: fontColor
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    /// normal font attributed string
    func normal(_ value: String, fontSize: CGFloat, fontColor: UIColor = .white) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontBook.Regular.of(size: fontSize),
            .foregroundColor: fontColor
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    /* Other styling methods */
    func orangeHighlight(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: normalFont,
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    /// set black Color in attributed string.
    func blackHighlight(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: normalFont,
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.black
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    /// Underline in attributed string
    func underlined(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: normalFont,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}

