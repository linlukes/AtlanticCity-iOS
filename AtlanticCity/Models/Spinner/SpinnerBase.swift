import Foundation
import ObjectMapper

class SpinnerBase : Mappable {
    
	var response : SpinnerResponse?
	var error : SpinnerError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
