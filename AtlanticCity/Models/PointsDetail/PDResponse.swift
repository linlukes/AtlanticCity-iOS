import Foundation
import ObjectMapper

class PDResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : PDDetail?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
