//
//  PasswordController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 06/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class PasswordController: UIViewController {

    @IBOutlet var current_pass_txt: UITextField!
    @IBOutlet var new_pass_txt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
    @IBAction func change_pass_listener(_ sender: UIButton) {
        if(current_pass_txt.text == ""){
            Helpers.showAlertView(title: "Error", message: "Please enter your current password")
            return
        }
        if(new_pass_txt.text == ""){
            Helpers.showAlertView(title: "Error", message: "Please enter your new password")
            return
        }
        submitPassword()
    }
    
    func submitPassword(){
        
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            ChangePassRequest.changePass(user_id: userid, auth_id: authid, prevpass: current_pass_txt.text!, newpass: new_pass_txt.text!){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                          Helpers.dismissHUD(view: self.view, isAnimated: true)
                          Helpers.showSuccessView(title: "Success", message: (returnJSON?.response?.message!)!)
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
