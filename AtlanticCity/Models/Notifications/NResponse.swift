

import Foundation
import ObjectMapper

class NResponse : Mappable {
    
	var status : Int?
	var message : String?
	var detail : [NDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
