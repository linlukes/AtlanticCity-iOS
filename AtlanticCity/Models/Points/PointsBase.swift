import Foundation
import ObjectMapper

class PointsBase : Mappable {
	var response : PointsResponse?
	var error : PointsError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
