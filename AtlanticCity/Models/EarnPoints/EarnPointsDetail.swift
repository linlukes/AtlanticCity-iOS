import Foundation
import ObjectMapper

class EarnPointsDetail : Mappable {
	var id : Int?
	var key : String?
	var value : String?
	var created_at : String?
	var updated_at : String?

    init() {
        
    }
    
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		key <- map["key"]
		value <- map["value"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
