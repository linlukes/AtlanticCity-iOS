//
//  PhoneContacts.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 26/08/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Contacts


class PhoneContacts{
    var isSent = false
    var contact = CNContact()
    
    init(sent:Bool,contact:CNContact) {
        self.isSent = sent
        self.contact = contact
    }
}
