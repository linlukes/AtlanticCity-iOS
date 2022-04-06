//
//  UITextFieldPadding.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 27/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldPadding : UITextField {

  let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
 
    @IBInspectable var placeHolderColor: UIColor? {
       get {
           return self.placeHolderColor
       }
       set {
           self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
       }
    }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
