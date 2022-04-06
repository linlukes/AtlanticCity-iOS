import Foundation
import ObjectMapper

class EarnPointsBase : Mappable {
    
	var response : EarnPointsResponse?
	var error : EarnPointsError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
