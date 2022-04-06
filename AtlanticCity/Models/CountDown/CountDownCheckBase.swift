//
//  CountDownCheckBase.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class CountDownCheckBase : Mappable {
    var time : Int?
    var error : CountDownError?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        time <- map["time"]
        error <- map["error"]
    }

}
