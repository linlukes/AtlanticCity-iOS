//
//  RoundView.swift
//  groceryapp
//
//  Created by Hamza Arif on 31/12/2019.
//  Copyright © 2019 Hixol. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius=cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth=borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor=borderColor.cgColor
        }
    }
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }
    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
}
