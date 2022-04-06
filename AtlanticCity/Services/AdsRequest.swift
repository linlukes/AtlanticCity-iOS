
//
//  AdsRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 05/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//


import Foundation
import Alamofire

class AdsRequest{
    
    static func getAds(user_id:String,auth_id:String,success: @escaping (AdsBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/advertise") else {
                return
            }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        AF.request(url, method: .post,headers: headers)
                .validate(statusCode: 200..<500)
                .responseObject{ (response: AFDataResponse<AdsBase>) in
                    
                    switch response.result {
                    case let .success(value):
    print(value)
                        print("Privacy Validation Successful")
                        let swiftyJsonVar = value
                        success(swiftyJsonVar,nil)
                    case let .failure(error):
                        print(error)
                        success(nil,error)
                    }
            }
        }
    static func getAdsCount(user_id:String,auth_id:String,add_id:String,success: @escaping (AdsBase?,Error?) -> ()) {
    guard let url = URL(string: Helpers.main_url+"api/v1/update-add-view") else {
          return
      }
    let headers: HTTPHeaders = [
      "user-id":user_id,
      "auth-id":auth_id
    ]
    let params:Parameters  =  [
        "add_id":add_id
    ]
    AF.request(url, method: .post,parameters:params,headers: headers)
          .validate(statusCode: 200..<500)
          .responseObject{ (response: AFDataResponse<AdsBase>) in
              
              switch response.result {
              case let .success(value):
    print(value)
                  print("adds count Validation Successful")
                  let swiftyJsonVar = value
                  success(swiftyJsonVar,nil)
              case let .failure(error):
                  print(error)
                  success(nil,error)
              }
      }
    }
    
}
