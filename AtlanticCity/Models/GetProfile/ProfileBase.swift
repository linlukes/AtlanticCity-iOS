import Foundation
import ObjectMapper

class ProfileBase : Mappable {
	var response : ProfileResponse?
	var error : ProfileError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
