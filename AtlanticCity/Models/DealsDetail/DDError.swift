
import Foundation
import ObjectMapper

class DDError : Mappable {
    
	var status : Int?
    var message : String?
    var detail : DDErrorDetail?
    
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		status <- map["status"]
        message <- map["message"]
        detail <- map["detail"]
	}

}
