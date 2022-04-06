import Foundation
import ObjectMapper

class EarnPointsResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [EarnPointsDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
