
import Foundation
import ObjectMapper

class SearchBase : Mappable {
	var response : SearchResponse?
	var error : SearchError?

    required init?(map: Map) {

	}

    func mapping(map: Map) {

		response <- map["response"]
		error <- map["error"]
	}

}
