//
//  DDRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class DDRequest{
    static func getDealsDetails(user_id:String,auth_id:String,item_id:String,deals_id:String,success: @escaping (DDBase?,Error?) -> ()) {
               guard let url = URL(string: Helpers.main_url+"api/v1/get-single-deal") else {
                   return
               }
               let headers: HTTPHeaders = [
                   "user-id":user_id,
                   "auth-id":auth_id
               ]
               let params: Parameters = [
                   "item_id":item_id,
                   "deal_id":deals_id
               ]
               AF.request(url, method: .post, parameters: params,headers: headers)
                   .validate(statusCode: 200..<500)
                   .responseObject{ (response: AFDataResponse<DDBase>) in
                       
                       switch response.result {
                       case let .success(value):
    print(value)
                           print("getDealsDetails Validation Successful")
                           let swiftyJsonVar = value
                           success(swiftyJsonVar,nil)
                       case let .failure(error):
                           print(error)
                           success(nil,error)
                       }
               }
           }
    
}
