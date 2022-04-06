
import Foundation
import ObjectMapper

class ReferralBase : Mappable {
	var response : ReferralResponse?
	var error : ReferralError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
