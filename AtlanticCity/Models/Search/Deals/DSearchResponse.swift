

import Foundation
import ObjectMapper

class DSearchResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [DSearchDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
