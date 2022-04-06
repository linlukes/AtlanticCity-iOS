import Foundation
import AlamofireObjectMapper
import ObjectMapper

class SignupBase : Mappable {
	var response : SignupResponse?
	var error : SignupError?

    init() {
    }
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
