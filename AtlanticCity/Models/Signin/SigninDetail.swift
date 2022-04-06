import Foundation
import ObjectMapper

class SigninDetail : Mappable {
	var id : Int?
	var user_id : String?
	var auth_id : String?
	var first_name : String?
	var last_name : String?
	var email : String?
	var password : String?
	var date_of_birth : String?
	var device_token : String?
	var facebook_id : String?
	var google_id : String?
	var avatar : String?
	var points : Int?
	var notfication : Int?
	var status : Int?
	var is_first_time : Int?
	var share_app_status : Int?
	var country : String?
	var zipcode : String?
    var newentrystatus: Int?
	var created_at : String?
	var updated_at : String?

    init() {
        
    }
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		user_id <- map["user_id"]
		auth_id <- map["auth_id"]
		first_name <- map["first_name"]
		last_name <- map["last_name"]
		email <- map["email"]
		password <- map["password"]
		date_of_birth <- map["date_of_birth"]
		device_token <- map["device_token"]
		facebook_id <- map["facebook_id"]
		google_id <- map["google_id"]
		avatar <- map["avatar"]
		points <- map["points"]
		notfication <- map["notfication"]
		status <- map["status"]
		is_first_time <- map["is_first_time"]
		share_app_status <- map["share_app_status"]
		country <- map["country"]
		zipcode <- map["zipcode"]
        newentrystatus <- map["new_entry_status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
