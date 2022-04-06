//
//  PrivacyController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 20/05/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import WebKit

class PrivacyController: UIViewController {

    @IBOutlet var webview: WKWebView!
    var privacyarray = [PrivacyDetail]()
    var isTerm = false
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPrivacy()
        if(isTerm){
            self.title = "Terms of Service"
        }
        // Do any additional setup after loading the view.
    }
    
    func fetchPrivacy(){
           if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            PrivacyRequest.getPrivacy(){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                        self.privacyarray = (returnJSON?.response!.detail)!
                        if(self.isTerm){
                            self.webview.loadHTMLString(self.privacyarray[1].value!, baseURL: nil)
                        }else{
                            self.webview.loadHTMLString(self.privacyarray[0].value!, baseURL: nil)
                        }
                        
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
