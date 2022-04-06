

import Foundation
import ObjectMapper

class NBase : Mappable {
	var response : NResponse?
	var error : NError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
