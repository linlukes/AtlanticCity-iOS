import Foundation
import ObjectMapper

class BFavBase : Mappable {
    
	var response : BFavResponse?
	var error : BFavError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
