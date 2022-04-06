import Foundation
import ObjectMapper

class PrivacyResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [PrivacyDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
