

import Foundation
import ObjectMapper

class DealsBusiness : Mappable {
	var business_user_id : String?
	var business_name : String?
	var logo : String?
	var address : String?
    var city : String?
    var state : String?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		business_user_id <- map["business_user_id"]
		business_name <- map["business_name"]
		logo <- map["logo"]
		address <- map["address"]
        city <- map["city"]
        state <- map["state"]
	}

}
