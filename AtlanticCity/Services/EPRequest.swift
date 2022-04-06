//
//  EPRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 09/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class EPRequest{
    static func getEarnedPoints(user_id:String,auth_id:String,success: @escaping (EPBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/earned-point-list") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        AF.request(url, method: .post,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<EPBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("getEarnedPoints Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
    static func delEarnedPoints(id:Int,user_id:String,auth_id:String,success: @escaping (EPDeleteBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/remove_earned_point") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        let params:Parameters = [
            "id":id
        ]
        AF.request(url, method: .post,parameters: params,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<EPDeleteBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("delEarnedPoints Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
