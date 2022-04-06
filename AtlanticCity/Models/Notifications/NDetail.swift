
import Foundation
import ObjectMapper

class NDetail : Mappable {
	var id : Int?
	var title : String?
	var description : String?
	var url : String?
	var status : Int?
	var user_id : String?
	var item_id : String?
	var business_user_id : String?
	var deal_status : Int?
	var created_at : String?
	var updated_at : String?

    init(){
        
    }
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		title <- map["title"]
		description <- map["description"]
		url <- map["url"]
		status <- map["status"]
		user_id <- map["user_id"]
		item_id <- map["item_id"]
		business_user_id <- map["business_user_id"]
		deal_status <- map["deal_status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
