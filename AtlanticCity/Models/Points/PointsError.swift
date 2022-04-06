import Foundation
import ObjectMapper

struct PointsError : Mappable {
	var status : Int?
    var message : String?
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		status <- map["status"]
        message <- map["message"]
	}

}
