import Foundation
import ObjectMapper

class CLBase : Mappable {
	var response : CLResponse?
	var error : CLError?

    required init?(map: Map) {

	}
    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
