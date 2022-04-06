//
//  FavRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class FavRequest{
    
    static func getFavBusiness(user_id:String,auth_id:String,success: @escaping (BFavBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/get-favorites-business") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
       
        AF.request(url, method: .post,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<BFavBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("getFavBusiness Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
    static func getFavDeals(user_id:String,auth_id:String,success: @escaping (DFavBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/get-favorites-deals") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
       
        AF.request(url, method: .post,encoding: URLEncoding.default,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<DFavBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("getFavDeals Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
    static func getFavAds(user_id:String,auth_id:String,success: @escaping (AdsFavBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/get-favorites-ads") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
       
        AF.request(url, method: .post,encoding: URLEncoding.default,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<AdsFavBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("getFavAds Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
    static func doFavDeal(user_id:String,auth_id:String,deals_id:String,item_id:String,success: @escaping (BFavBase?,Error?) -> ()) {
          guard let url = URL(string: Helpers.main_url+"api/v1/do-favorite-deal") else {
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
          AF.request(url, method: .post,parameters: params,encoding: URLEncoding.default,headers: headers)
              .validate(statusCode: 200..<500)
              .responseObject{ (response: AFDataResponse<BFavBase>) in
                  
                  switch response.result {
                  case let .success(value):
    print(value)
                      print("doFavDeal Validation Successful")
                      let swiftyJsonVar = value
                      success(swiftyJsonVar,nil)
                  case let .failure(error):
                      print(error)
                      success(nil,error)
                  }
          }
      }
    static func doFavAd(user_id:String,auth_id:String,add_id:String,success: @escaping (BFavBase?,Error?) -> ()) {
           guard let url = URL(string: Helpers.main_url+"api/v1/do-favorite-add") else {
               return
           }
           let headers: HTTPHeaders = [
               "user-id":user_id,
               "auth-id":auth_id
           ]
           let params: Parameters = [
               "add_id":add_id
           ]
           AF.request(url, method: .post,parameters: params,encoding: URLEncoding.default,headers: headers)
               .validate(statusCode: 200..<500)
               .responseObject{ (response: AFDataResponse<BFavBase>) in
                   switch response.result {
                   case let .success(value):
    print(value)
                       print("doFavAdd Validation Successful")
                       let swiftyJsonVar = value
                       success(swiftyJsonVar,nil)
                   case let .failure(error):
                       print(error)
                       success(nil,error)
                   }
           }
       }
    static func doFavBusiness(user_id:String,auth_id:String,business_id:String,success: @escaping (BFavBase?,Error?) -> ()) {
          guard let url = URL(string: Helpers.main_url+"api/v1/do-favorite-business") else {
              return
          }
          let headers: HTTPHeaders = [
              "user-id":user_id,
              "auth-id":auth_id
          ]
          let params: Parameters = [
              "business_id":business_id
          ]
          AF.request(url, method: .post,parameters: params,encoding: URLEncoding.default,headers: headers)
              .validate(statusCode: 200..<500)
              .responseObject{ (response: AFDataResponse<BFavBase>) in
                  
                switch response.result {
                  case let .success(value):
    print(value)
                      print("doFavbusiness Validation Successful")
                      let swiftyJsonVar = value
                      success(swiftyJsonVar,nil)
                  case let .failure(error):
                      print(error)
                      success(nil,error)
                  }
          }
      }
}
