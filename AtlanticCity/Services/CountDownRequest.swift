//
//  CountDownRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class CountDownRequest{
    static func startCountDown(user_id:String,auth_id:String,deals_id:String,success: @escaping (CountDownBase?,Error?) -> ()) {
               guard let url = URL(string: Helpers.main_url+"api/v1/countdown-start") else {
                   return
               }
               let headers: HTTPHeaders = [
                   "user-id":user_id,
                   "auth-id":auth_id
               ]
               let params: Parameters = [
                   "deal_id":deals_id
               ]
               AF.request(url, method: .post, parameters: params,headers: headers)
                   .validate(statusCode: 200..<500)
                   .responseObject{ (response: AFDataResponse<CountDownBase>) in
                       
                       switch response.result {
                       case let .success(value):
    print(value)
                           print("CountDown Started Validation Successful")
                           let swiftyJsonVar = value
                           success(swiftyJsonVar,nil)
                       case let .failure(error):
                           print(error)
                           success(nil,error)
                       }
               }
           }
    static func startCountDownCheck(user_id:String,auth_id:String,deals_id:String,success: @escaping (CountDownBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/countdown-check") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        let params: Parameters = [
            "deal_id":deals_id
        ]
        AF.request(url, method: .post, parameters: params,encoding: URLEncoding.default,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<CountDownBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("CountDownCheck Started Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
