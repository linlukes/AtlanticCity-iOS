//
//  ProfileController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 06/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {

    @IBOutlet var birthday_lbl: UILabel!
    @IBOutlet var zipcode_lbl: UILabel!
    @IBOutlet var email_lbl: UILabel!
    
    @IBOutlet var b_view: UIView!
    @IBOutlet var z_view: UIView!
    @IBOutlet var e_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfile()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func getProfile(){
        
        if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            ProfileRequest.getProfile(userid: userid, authid: authid){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                    
                            if(returnJSON?.response?.detail?.email != ""){
                                self.email_lbl.text = returnJSON?.response?.detail?.email
                            }
                            if(returnJSON?.response?.detail?.date_of_birth != ""){
                                self.birthday_lbl.text = returnJSON?.response?.detail?.date_of_birth
                            }else{
                                self.birthday_lbl.text = "N/A"
                            }
                        if(returnJSON?.response?.detail?.zipcode != "" || returnJSON?.response?.detail?.zipcode != nil){
                                self.zipcode_lbl.text = returnJSON?.response?.detail?.zipcode
                            }else{
                                self.zipcode_lbl.text = "N/A"
                            }
                        self.b_view.isHidden = false
                        self.z_view.isHidden = false
                        self.e_view.isHidden = false
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
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
