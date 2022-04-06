import Foundation
import ObjectMapper

class BDResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [BDDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
