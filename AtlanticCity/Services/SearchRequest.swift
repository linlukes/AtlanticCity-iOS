//
//  SearchRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class SearchRequest{
    static func getSearchBusiness(user_id:String,auth_id:String,searchtxt:String,success: @escaping (SearchBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/search") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
       let params: Parameters = [
            "searched_value": searchtxt,
            "type": "business"
        ]
        
        AF.request(url, method: .post,parameters: params,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<SearchBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("getSearch Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
    static func getSearchDeals(user_id:String,auth_id:String,searchtxt:String,success: @escaping (DSearchBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/search") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
       let params: Parameters = [
            "searched_value": searchtxt,
            "type": "deals"
        ]
        
        AF.request(url, method: .post,parameters: params,encoding: URLEncoding.default,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<DSearchBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("getSearch Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
