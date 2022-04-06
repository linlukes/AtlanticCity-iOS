

import Foundation
import ObjectMapper

class BusinessResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [BusinessDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
