import Foundation
import ObjectMapper

class EPDeleteBase : Mappable {
	var response : EPDeleteResponse?
	var error : EPDeleteError?

    required init?(map: Map) {
	}
    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
