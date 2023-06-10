//
//  UIExtension.swift
//  Currency
//
//  Created by Mariam Moataz on 05/06/2023.
//

import Foundation
import UIKit
import iOSDropDown

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

extension DropDown{
    func dropDownDefaultStyling(){
        self.selectedRowColor = UIColor(named: "color1")!
        self.rowBackgroundColor = UIColor.white
        self.arrowSize = 15
        self.arrowColor = UIColor(named: "color1")!
        self.textColor = UIColor.black
        self.checkMarkEnabled = false
    }
}
