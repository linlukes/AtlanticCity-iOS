import Foundation
import ObjectMapper

class PassRecoveryBase : Mappable {
    
	var response : PRResponse?
	var error : PRError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
