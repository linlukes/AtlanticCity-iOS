//
//  CollectPrizeRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 08/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class CollectPrizeRequest{
    static func submitPrize(user_id:String,auth_id:String,spinner_id:String,success: @escaping (PDBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/collect-spinner-prize") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        let params: Parameters = [
            "spinner_id":spinner_id
        ]
        AF.request(url, method: .post, parameters: params,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<PDBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("submit prize Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }

}
