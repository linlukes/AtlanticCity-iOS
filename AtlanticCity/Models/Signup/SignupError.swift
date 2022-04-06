import Foundation
import AlamofireObjectMapper
import ObjectMapper

class SignupError : Mappable {
    
	var status : Int?
    var message : String?
    var detail : SignupErrorDetail?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
        detail <- map["detail"]
    }

}
