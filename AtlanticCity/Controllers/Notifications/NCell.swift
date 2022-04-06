//
//  NCell.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class NCell: UITableViewCell {
    var delegate : DelNotifi?

    var id = ""
    @IBOutlet var title: UILabel!
    @IBOutlet var message_lbl: UILabel!
    @IBOutlet var date_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func delete_btn_listener(_ sender: UIButton) {
        delegate?.delNotification(id: id)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
