
import Foundation
import ObjectMapper

class CLDetail : Mappable {
	var id : Int?
	var user_id : String?
	var phone_no : String?
	var status : Int?
	var created_at : String?
	var updated_at : String?

    init(){
        
    }
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		user_id <- map["user_id"]
		phone_no <- map["phone_no"]
		status <- map["status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
