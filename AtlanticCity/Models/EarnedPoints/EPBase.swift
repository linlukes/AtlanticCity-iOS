import Foundation
import ObjectMapper

class EPBase : Mappable {
    
	var response : EPResponse?
	var error : EPError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
