import Foundation
import ObjectMapper

class SingleDealBase : Mappable {
	var response : SingleDealResponse?
	var error : SingleDealError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
