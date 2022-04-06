//
//  SigninErrorDetail.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 27/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class SigninErrorDetail : Mappable {
    var email : [String]?
    var password : [String]?

    init() {
        
    }
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {

        email <- map["email"]
        password <- map["password"]
        
    }
}
