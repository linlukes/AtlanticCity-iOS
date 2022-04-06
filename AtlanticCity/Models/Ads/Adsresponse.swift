import Foundation
import ObjectMapper

class Adsresponse : Mappable {
	var status : Int?
	var message : String?
	var detail : AdsDetail?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
