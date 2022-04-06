//
//  MenuCell.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var image_icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
