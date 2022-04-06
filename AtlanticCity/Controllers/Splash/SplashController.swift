//
//  SplashController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 26/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class SplashController: UIViewController {
    
   static var dealsarray = [DealsDetail]()
   static var adsarray = [AdsDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("URL:"+Helpers.readPreference(key: "referral_link", defualt: ""))
        // Do any additional setup after loading the view.
        let user_id = Helpers.readPreference(key: "user_id", defualt: "0")
        let auth_id = Helpers.readPreference(key: "auth_id", defualt: "0")
        if(auth_id == "0" && user_id == "0" ||  auth_id == "" && user_id == ""){
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
              
                  self.performSegue(withIdentifier: "welcome", sender: self)
            })
        }else{
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//
//                  self.performSegue(withIdentifier: "main", sender: self)
//            })
            fetchDeals()
        }
    }
    func fetchDeals(){
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            DealsRequest.getDeals(user_id: userid, auth_id: authid){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                          //Helpers.dismissHUD(view: self.view, isAnimated: true)
                            if(returnJSON?.response!.detail != nil){
                                SplashController.dealsarray = (returnJSON?.response!.detail)!
                                DispatchQueue.main.async {
                                    self.fetchSpinnerDetails()
                                }
                            }
                            
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    

    
    func fetchSpinnerDetails(){
           if(Connectivity.isConnectedToInternet()){
               //Helpers.showHUD(view: self.view, progressLabel: "Loading...")
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            SpinnerRequest.getSpinnerDetails(user_id: userid, auth_id: authid){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            SpinnerRequest.spinner_array = (returnJSON?.response!.detail)!
                            if(SplashController.dealsarray.count > 0){
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentView") as! PageViewController
                                vc.modalPresentationStyle = .fullScreen
                                vc.pages = SplashController.dealsarray
                                self.present(vc, animated: true, completion: nil)
                            }
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
}

