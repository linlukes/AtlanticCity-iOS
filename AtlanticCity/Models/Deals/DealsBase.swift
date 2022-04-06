import Foundation
import ObjectMapper

class DealsBase : Mappable {
	var response : DealsResponse?
	var error : DealsError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
