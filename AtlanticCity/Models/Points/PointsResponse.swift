import Foundation
import ObjectMapper

class PointsResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : String?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
