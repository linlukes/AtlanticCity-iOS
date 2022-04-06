import Foundation
import ObjectMapper

class AdsFavAdds : Mappable {
	var id : Int?
	var add_id : String?
	var title : String?
	var description : String?
	var date : String?
	var url : String?
	var image : String?
	var type : Int?
	var status : Int?
	var created_at : String?
	var updated_at : String?
	var is_favorited_count : Bool?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		add_id <- map["add_id"]
		title <- map["title"]
		description <- map["description"]
		date <- map["date"]
		url <- map["url"]
		image <- map["image"]
		type <- map["type"]
		status <- map["status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		is_favorited_count <- map["is_favorited_count"]
	}

}
