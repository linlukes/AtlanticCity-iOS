
import Foundation
import ObjectMapper

class ReferralResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [ReferralDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
