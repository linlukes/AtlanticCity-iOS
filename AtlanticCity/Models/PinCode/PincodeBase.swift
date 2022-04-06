import Foundation
import ObjectMapper

class PincodeBase : Mappable {
	var response : PincodeResponse?
	var error : PincodeError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
