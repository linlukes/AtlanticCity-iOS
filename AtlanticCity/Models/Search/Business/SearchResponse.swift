import Foundation
import ObjectMapper

class SearchResponse : Mappable {
	var status : Int?
	var message : String?
	var detail : [SearchDetail]?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
		message <- map["message"]
		detail <- map["detail"]
	}

}
