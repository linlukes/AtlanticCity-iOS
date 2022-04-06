import Foundation
import ObjectMapper

class AdsFavResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [AdsFavDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
