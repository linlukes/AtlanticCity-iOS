import Foundation
import ObjectMapper

class SigninError : Mappable {
	var status : Int?
    var message : String?
    var detail : SigninErrorDetail?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
        detail <- map["detail"]
    }

}
