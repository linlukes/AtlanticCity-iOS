import Foundation
import ObjectMapper

class EPDetail : Mappable {
	var id : Int?
	var cpl_id : String?
	var user_id : String?
	var item_id : Int?
	var type : Int?
	var points : Int?
	var is_collected : Int?
	var created_at : String?
	var updated_at : String?
	var user : EPUser?
	var item : EPItem?
    var status: Int?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		cpl_id <- map["cpl_id"]
		user_id <- map["user_id"]
		item_id <- map["item_id"]
		type <- map["type"]
		points <- map["points"]
		is_collected <- map["is_collected"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		user <- map["user"]
		item <- map["item"]
        status <- map["status"]
	}

}
