import Foundation
import ObjectMapper

class DDDealtypes : Mappable {
	var id : Int?
	var dealtype_id : String?
	var deal_type : String?
	var status : String?
	var created_at : String?
	var updated_at : String?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		dealtype_id <- map["dealtype_id"]
		deal_type <- map["deal_type"]
		status <- map["status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
