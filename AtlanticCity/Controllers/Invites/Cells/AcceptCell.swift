//
//  AcceptCell.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 06/07/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class AcceptCell: UITableViewCell {

    @IBOutlet var email_lbl: UILabel!
    @IBOutlet var phone_lbl: UILabel!
    @IBOutlet var date_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
