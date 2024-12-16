//
//  Extensions.swift
//  BookMeNow
//
//  Created by Neshwa on 03/02/24.
//

import Foundation
import UIKit

extension String {
    
    func firstLettersOfWords() -> String {
        let words = components(separatedBy: .whitespaces)
        let firstLetters = words.map { $0.prefix(1) }
        return firstLetters.joined()
    }
}

extension UITextField {
    
    func addLeftText(text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: self.frame.height))
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        self.leftView = label
        self.leftViewMode = .always
    }
}

// convert hexColor code to a UIColor
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIView {
    
   static func identifier() -> String {
        return String(describing: self)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func borderForView() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 15
    }
}

// set maximum length property for all textfields
private var maxLengths = [UITextField: Int]()

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControl.Event.editingChanged
            )
        }
    }
    
    @objc func limitLength(textField: UITextField) {
    guard let prospectiveText = textField.text,
              prospectiveText.count > maxLength
    else {
      return
    }
    
    let selection = selectedTextRange
    let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
    text = prospectiveText.substring(to: maxCharIndex)
    selectedTextRange = selection
  }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Set desired format
        return dateFormatter.string(from: self)
    }
}


@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius : CGFloat {
        get{
            return self.layer.cornerRadius
        }
        set(newValue) {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(newValue) {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor : UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var offsetShadow : CGSize {
        get {
            return self.layer.shadowOffset
        }
        set(newValue) {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity : Float {
        get{
            return self.layer.shadowOpacity
        }
        set(newValue) {
            self.layer.shadowOpacity = newValue
        }
        
    }
    
    @IBInspectable
    var shadowColor : UIColor? {
        get{
            return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var maskToBounds : Bool {
        get {
            return self.layer.masksToBounds
        }
        set(newValue) {
            self.layer.masksToBounds = newValue
        }
    }
}

