
import Foundation
import ObjectMapper

class DealsDetail : Mappable {
	var id : Int?
	var item_id : String?
    var add_id : String?
	var business_user_id : String?
	var title : String?
	var description : String?
	var price : String?
	var discount : String?
	var deal_expire_at : String?
	var avatar : String?
    var image : String?
    var url : String?
	var dealtype_id : String?
	var approved : String?
	var created_at : String?
	var updated_at : String?
	var is_favorited_count : Bool?
	var is_availed_count : Bool?
    var deal_views_count : Int?
    var add_views_count : Int?
	var business : DealsBusiness?

    init(){
        
    }
    init(title:String,descr:String,addr:String,favcount:Bool){
        self.title = title
        self.description = descr
        self.business?.address = addr
        self.is_favorited_count = favcount
    }
    
    required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		item_id <- map["item_id"]
        add_id <- map["add_id"]
		business_user_id <- map["business_user_id"]
		title <- map["title"]
		description <- map["description"]
		price <- map["price"]
		discount <- map["discount"]
		deal_expire_at <- map["deal_expire_at"]
		avatar <- map["avatar"]
        image <- map["image"]
        url <- map["url"]
		dealtype_id <- map["dealtype_id"]
		approved <- map["approved"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		is_favorited_count <- map["is_favorited_count"]
		is_availed_count <- map["is_availed_count"]
        deal_views_count <- map["deal_views_count"]
        add_views_count <- map["add_views_count"]
		business <- map["business"]
	}

}
