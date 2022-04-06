import Foundation
import ObjectMapper

class SpinnerResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [SpinnerDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
