import Foundation
import ObjectMapper

class DSearchBase : Mappable {
	var response : DSearchResponse?
	var error : DSError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
