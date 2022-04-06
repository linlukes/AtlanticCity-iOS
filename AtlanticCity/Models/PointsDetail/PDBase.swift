import Foundation
import ObjectMapper

class PDBase : Mappable {
	var response : PDResponse?
	var error : PDError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
