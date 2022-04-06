//
//  File.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class CountDownBase : Mappable {
    var response : CountDownResponse?
    var error : CountDownError?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        response <- map["response"]
        error <- map["error"]
    }

}
