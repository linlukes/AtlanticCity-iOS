//
//  CollectPrizeResponse.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 08/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class CollectPrizeResponse : Mappable {
    var status : Int?
    var message : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
    }

}
