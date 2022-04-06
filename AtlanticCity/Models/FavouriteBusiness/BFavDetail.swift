import Foundation
import ObjectMapper

class BFavDetail : Mappable {
	var id : Int?
	var fav_business_id : String?
	var user_id : String?
	var business_id : String?
	var created_at : String?
	var updated_at : String?
	var businesses : BFavBusinesses?
    
    
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		fav_business_id <- map["fav_business_id"]
		user_id <- map["user_id"]
		business_id <- map["business_id"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		businesses <- map["businesses"]
      
	}

}
