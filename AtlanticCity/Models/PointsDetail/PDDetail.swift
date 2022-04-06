import Foundation
import ObjectMapper

class PDDetail : Mappable {
	var earned_points : Int?
	var spinner_points : String?

    init() {
        
    }
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		earned_points <- map["earned_points"]
		spinner_points <- map["spinner_points"]
	}

}
