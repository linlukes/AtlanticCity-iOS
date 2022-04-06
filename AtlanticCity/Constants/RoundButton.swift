//
//  RoundButton.swift
//  groceryapp
//
//  Created by Hamza Arif on 30/12/2019.
//  Copyright © 2019 Hixol. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
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
}
