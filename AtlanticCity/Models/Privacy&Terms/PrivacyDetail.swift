import Foundation
import ObjectMapper

class PrivacyDetail : Mappable {
	var key : String?
	var value : String?

    init() {
        
    }
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		key <- map["key"]
		value <- map["value"]
	}

}
