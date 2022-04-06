
import Foundation
import ObjectMapper

class CLResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [CLDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
