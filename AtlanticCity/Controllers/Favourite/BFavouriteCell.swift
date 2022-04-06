//
//  BFavouriteCell.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class BFavouriteCell: UITableViewCell {
    var delegate : FavAndUnFavDealsBusiness?
    var id = ""

    @IBOutlet var business_img: UIImageView!
    @IBOutlet var business_name: UILabel!
    @IBOutlet var business_dates: UILabel!
    @IBOutlet var business_desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func hear_btn_callback(_ sender: UIButton) {
        //delegate?.showBusiness(name: business_name.text!)
        delegate?.makeBusiness(id: id)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
