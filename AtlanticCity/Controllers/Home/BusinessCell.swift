//
//  BusinessCell.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 31/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet var business_img: UIImageView!
    @IBOutlet var business_name: UILabel!
    @IBOutlet var business_hours: UILabel!
    @IBOutlet weak var business_address: UILabel!
    @IBOutlet var business_desc: UILabel!
    @IBOutlet var deals_count: UILabel!
    
    @IBAction func view_details_listener(_ sender: UIButton) {
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
