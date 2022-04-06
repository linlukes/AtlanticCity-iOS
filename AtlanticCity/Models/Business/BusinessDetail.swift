
import Foundation
import ObjectMapper

class BusinessDetail : Mappable {
	var id : Int?
	var business_user_id : String?
	var name : String?
	var email : String?
	var business_name : String?
	var business_detail : String?
	var logo : String?
	var color : String?
	var cover : String?
	var address : String?
	var state : String?
	var city : String?
	var zipcode : String?
	var phone_number : String?
	var website : String?
	var social_link : String?
	var open_time : String?
	var close_time : String?
	var expire_date : String?
	var membership_id : String?
	var category_id : String?
	var sub_category_id : String?
	var qr_code : String?
	var lat : String?
	var lng : String?
	var status : String?
	var created_at : String?
	var updated_at : String?
	var is_favorited_count : Bool?
	var deals_count : Int?
	var deals : [String]?

    init() {
        
    }
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		business_user_id <- map["business_user_id"]
		name <- map["name"]
		email <- map["email"]
		business_name <- map["business_name"]
		business_detail <- map["business_detail"]
		logo <- map["logo"]
		color <- map["color"]
		cover <- map["cover"]
		address <- map["address"]
		state <- map["state"]
		city <- map["city"]
		zipcode <- map["zipcode"]
		phone_number <- map["phone_number"]
		website <- map["website"]
		social_link <- map["social_link"]
		open_time <- map["open_time"]
		close_time <- map["close_time"]
		expire_date <- map["expire_date"]
		membership_id <- map["membership_id"]
		category_id <- map["category_id"]
		sub_category_id <- map["sub_category_id"]
		qr_code <- map["qr_code"]
		lat <- map["lat"]
		lng <- map["lng"]
		status <- map["status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		is_favorited_count <- map["is_favorited_count"]
		deals_count <- map["deals_count"]
		deals <- map["deals"]
	}

}
