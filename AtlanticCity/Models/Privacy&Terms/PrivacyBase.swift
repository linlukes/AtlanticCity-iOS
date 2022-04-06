import Foundation
import ObjectMapper

class PrivacyBase : Mappable {
	var response : PrivacyResponse?
	var error : PrivacyError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
