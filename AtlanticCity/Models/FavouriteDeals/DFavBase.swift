//
//  DFavBase.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class DFavBase : Mappable {
    
    var response : DFavResponse?
    var error : DFavError?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        response <- map["response"]
        error <- map["error"]
    }

}
