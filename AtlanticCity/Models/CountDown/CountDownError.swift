//
//  CountDownError.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class CountDownError : Mappable {
    
    var status : Int?
    var message : String?
    var detail : CDErrorDetail?
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
        detail <- map["detail"]
    }

}
