import Foundation
import ObjectMapper

class SigninResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : SigninDetail?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
