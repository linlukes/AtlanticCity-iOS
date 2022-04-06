import Foundation
import ObjectMapper

class AdsFavBase : Mappable {
	var response : AdsFavResponse?
	var error : AdsFavError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
