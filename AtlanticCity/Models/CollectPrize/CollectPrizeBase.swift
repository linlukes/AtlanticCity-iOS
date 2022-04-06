//
//  CollectPrizeBase.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 08/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class CollectPrizeBase : Mappable {
    var response : PDResponse?
    var error : PDError?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        response <- map["response"]
        error <- map["error"]
    }

}
