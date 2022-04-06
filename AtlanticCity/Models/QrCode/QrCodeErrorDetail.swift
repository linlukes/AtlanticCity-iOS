//
//  QrCodeErrorDetail.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 02/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class QrCodeErrorDetail : Mappable {
   
    var deal_id : [String]?
    var business_id : [String]?
    var qrcode_id : [String]?
    init() {
        
    }
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {

        deal_id <- map["deal_id"]
        business_id <- map["business_id"]
        qrcode_id <- map["qrcode_id"]
    }
}
