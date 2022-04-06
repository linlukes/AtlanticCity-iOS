//
//  QrCodeError.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 02/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//


import Foundation
import ObjectMapper

class QrCodeError : Mappable {
    
    var status : Int?
    var message : String?
    var detail : QrCodeErrorDetail?
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
        detail <- map["detail"]
    }

}
