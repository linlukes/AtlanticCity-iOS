import Foundation
import ObjectMapper

class AdsFavDetail : Mappable {
    
	var id : Int?
	var fav_add_id : String?
	var user_id : String?
	var add_id : String?
	var created_at : String?
	var updated_at : String?
    var adds : AdsFavAdds?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		fav_add_id <- map["fav_add_id"]
		user_id <- map["user_id"]
		add_id <- map["add_id"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		adds <- map["adds"]
	}

}
