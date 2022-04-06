import Foundation
import ObjectMapper

class BDBase : Mappable {
	var response : BDResponse?
	var error : BDError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
