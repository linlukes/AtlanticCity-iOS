//
//  QrCodeBase.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 02/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class QrCodeBase : Mappable {
    var response : QrCodeResponse?
    var error : QrCodeError?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        response <- map["response"]
        error <- map["error"]
    }

}
