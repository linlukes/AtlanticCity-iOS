//
//  PasswordRecController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 12/05/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class PasswordRecController: UIViewController {

    @IBOutlet var email_txt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit_email_listener(_ sender: RoundButton) {
        if(email_txt.text == ""){
            Helpers.showAlertView(title: "Email", message: "Please enter your email address")
            return
        }
        else if(!validateEmail(enteredEmail: email_txt.text!)){
            Helpers.showAlertView(title: "Email", message: "Your email address is invalid")
            return
        }else{
            submitEmail()
        }
    }
    //email validator
      func validateEmail(enteredEmail:String) -> Bool {
          
          let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
          return emailPredicate.evaluate(with: enteredEmail)
      
      }
    func submitEmail(){
        
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            PassRecoveryRequest.getPassRecovery(email: email_txt.text!){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                          Helpers.dismissHUD(view: self.view, isAnimated: true)
                         self.performSegue(withIdentifier: "reset", sender: self)
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "reset"){
         let destinationVC = segue.destination as! UINavigationController
         let newVC = destinationVC.viewControllers.first as! PasswordResetController
            newVC.email = email_txt.text!
        }
    }
    

}
