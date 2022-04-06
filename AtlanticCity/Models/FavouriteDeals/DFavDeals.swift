//
//  DFavDeals.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

class DFavDeals : Mappable {
    
    var id : Int?
    var item_id : String?
    var business_user_id : String?
    var title : String?
    var description : String?
    var price : String?
    var discount : String?
    var deal_expire_at : String?
    var avatar : String?
    var dealtype_id : String?
    var approved : String?
    var created_at : String?
    var updated_at : String?
    var is_favorited_count : Bool?
    var business : DFavBusiness?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id <- map["id"]
        item_id <- map["item_id"]
        business_user_id <- map["business_user_id"]
        title <- map["title"]
        description <- map["description"]
        price <- map["price"]
        discount <- map["discount"]
        deal_expire_at <- map["deal_expire_at"]
        avatar <- map["avatar"]
        dealtype_id <- map["dealtype_id"]
        approved <- map["approved"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }

}
