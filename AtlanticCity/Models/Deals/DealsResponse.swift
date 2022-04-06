

import Foundation
import ObjectMapper

class DealsResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [DealsDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
