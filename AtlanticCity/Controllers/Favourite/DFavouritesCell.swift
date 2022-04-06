//
//  DFavouritesCell.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class DFavouritesCell: UITableViewCell {
    var delegate : FavAndUnFavDealsBusiness?
    var id = ""
    @IBOutlet var business_img: UIImageView!
    @IBOutlet var business_name: UILabel!
    @IBOutlet var business_dates: UILabel!
    @IBOutlet var business_desc: UILabel!
    
    @IBOutlet var heart_btn_listener: UIButton!
    
    @IBAction func heart_btn_callback(_ sender: UIButton) {
        delegate?.makeDeal(id: id)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
