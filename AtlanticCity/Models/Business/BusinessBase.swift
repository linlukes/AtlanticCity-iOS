

import Foundation
import ObjectMapper

class BusinessBase : Mappable {
	var response : BusinessResponse?
	var error : BusinessError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
