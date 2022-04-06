//
//  NRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//


import Foundation
import Alamofire

class NRequest{
    
    static func getNotifications(user_id:String,auth_id:String,success: @escaping (NBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/get-notifications-list") else {
                return
            }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        AF.request(url, method: .get,headers: headers)
                .validate(statusCode: 200..<500)
                .responseObject{ (response: AFDataResponse<NBase>) in
                    
                    switch response.result {
                    case let .success(value):
    print(value)
                        print("Notifications Validation Successful")
                        let swiftyJsonVar = value
                        success(swiftyJsonVar,nil)
                    case let .failure(error):
                        print(error)
                        success(nil,error)
                    }
            }
        }
    static func delNotifications(user_id:String,auth_id:String,notiid:String,success: @escaping (NBase?,Error?) -> ()) {
              guard let url = URL(string: Helpers.main_url+"api/v1/delete_notification") else {
                      return
                  }
              let headers: HTTPHeaders = [
                  "user-id":user_id,
                  "auth-id":auth_id
              ]
                let params:Parameters = [
                  "notification_id":notiid
                ]
              AF.request(url, method: .post,parameters: params, encoding: URLEncoding.default,headers: headers)
                      .validate(statusCode: 200..<500)
                      .responseObject{ (response: AFDataResponse<NBase>) in
                          
                          switch response.result {
                          case let .success(value):
    print(value)
                              print("Delete Notifications Validation Successful")
                              let swiftyJsonVar = value
                              success(swiftyJsonVar,nil)
                          case let .failure(error):
                              print(error)
                              success(nil,error)
                          }
                  }
              }
    
}
