//
//  DSError.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 04/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class DSError : Mappable {
    var status : Int?
    var message : String?
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
    }

}
