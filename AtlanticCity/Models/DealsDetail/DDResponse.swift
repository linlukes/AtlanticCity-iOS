
import Foundation
import ObjectMapper

class DDResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : DDDetail?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
