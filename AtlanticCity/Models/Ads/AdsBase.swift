import Foundation
import ObjectMapper

class AdsBase : Mappable {
	var response : Adsresponse?
	var error : AdsError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
