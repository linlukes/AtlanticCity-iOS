import Foundation
import ObjectMapper

class BFavResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [BFavDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
