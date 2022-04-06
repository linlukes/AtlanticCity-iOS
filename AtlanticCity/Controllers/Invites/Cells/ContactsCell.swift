//
//  ContactsCell.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import MBCheckboxButton

class ContactsCell: UITableViewCell {
    var link:ContactsController?
    @IBOutlet var person_img: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var phoneno: UILabel!
    @IBOutlet var checkbox: CheckboxButton!
    
    @IBOutlet var sent_label: UILabel!
    @IBOutlet var contentview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkbox.isUserInteractionEnabled = false
        //checkbox.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ContactsCell : CheckboxButtonDelegate{
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        //self.link?.getSelectedNumbers(number: phoneno.text!)
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        //self.link?.removeSelectedNumber(number: phoneno.text!)
    }
    
}
