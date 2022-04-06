import Foundation
import ObjectMapper

class SigninBase : Mappable {
	var response : SigninResponse?
	var error : SigninError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
