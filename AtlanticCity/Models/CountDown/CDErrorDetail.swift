//
//  CDErrorDetail.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//
import Foundation
import ObjectMapper

class CDErrorDetail : Mappable {
   
    var deal_id : [String]?

    init() {
        
    }
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {

        deal_id <- map["deal_id"]
        
    }
}
