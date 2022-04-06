//
//  ListEarnPointsCell.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 09/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class ListEarnPointsCell: UITableViewCell {

    @IBOutlet var title_lbl: UILabel!
    @IBOutlet var description_lbl: UILabel!
    @IBOutlet var points_lbl: UILabel!
    @IBOutlet var point_img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
