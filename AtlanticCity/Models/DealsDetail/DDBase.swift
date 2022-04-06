
import Foundation
import ObjectMapper

class DDBase : Mappable {
	var response : DDResponse?
	var error : DDError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
