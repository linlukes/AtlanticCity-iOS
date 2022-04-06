import Foundation
import ObjectMapper

class ProfileResponse : Mappable {
    
	var status : Int?
	var message : String?
	var detail : ProfileDetail?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
