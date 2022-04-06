

import Foundation
import ObjectMapper

class AdsDetail : Mappable {
	var id : Int?
	var add_id : String?
	var title : String?
	var description : String?
	var date : String?
	var url : String?
	var image : String?
	var type : Int?
	var status : Int?
    var is_favorited_count : Bool?
    var add_views_count : Int?
	var created_at : String?
	var updated_at : String?

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
        is_favorited_count <- map["is_favorited_count"]
        add_views_count <- map["add_views_count"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
