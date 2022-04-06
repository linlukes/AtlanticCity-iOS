//
//  QrCodeResponse.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 02/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class QrCodeResponse : Mappable {
    var status : Int?
    var message : String?
    var detail : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
        detail <- map["detail"]
    }

}
