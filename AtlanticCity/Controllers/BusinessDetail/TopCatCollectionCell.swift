//
//  TopCatCollectionCell.swift
//  groceryapp
//
//  Created by Hamza Arif on 01/01/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import Foundation

class TopCatCollectionCell: UICollectionViewCell {

    @IBOutlet weak var MainView: UIView!
    @IBOutlet var productimg: UIImageView!
    @IBOutlet var deal_name: UILabel!
    
    
    override func awakeFromNib() {

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor

        contentView.layer.masksToBounds = true
        layer.cornerRadius = 10
        
        MainView.layer.cornerRadius = 10
    }
}
