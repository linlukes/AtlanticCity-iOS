//
//  EarnedPointsCell.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 09/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class EarnedPointsCell: UITableViewCell {
    var delegate : DelEarnedPoints?
    @IBOutlet var points_img: UIImageView!
    @IBOutlet var title_lbl: UILabel!
    @IBOutlet var earnpoints_lbl: UILabel!
    @IBOutlet var date_lbl: UILabel!
    @IBOutlet var delete_btn: UIButton!
    var id = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func delete_btn_listener(_ sender: UIButton) {
        delegate?.delEarned(id: id)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
