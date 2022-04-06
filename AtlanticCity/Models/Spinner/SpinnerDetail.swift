import Foundation
import ObjectMapper

class SpinnerDetail : Mappable {
    
	var id : Int?
	var spinner_id : String?
	var prize_title : String?
	var prize : String?
	var status : Int?
    var activestatus : Int?
	var created_at : String?
	var updated_at : String?

    init() {
        
    }
    required init?(map: Map) {
        
	}

    func mapping(map: Map) {

		id <- map["id"]
		spinner_id <- map["spinner_id"]
		prize_title <- map["prize_title"]
		prize <- map["prize"]
		status <- map["status"]
        activestatus <- map["active_status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
