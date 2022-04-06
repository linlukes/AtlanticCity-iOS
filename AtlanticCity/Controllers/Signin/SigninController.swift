//
//  SigninController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 27/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class SigninController: UIViewController,GIDSignInDelegate {

     @IBOutlet weak var email_txt: UITextField!
     @IBOutlet weak var password_txt: UITextField!
    
     @IBOutlet var facebookview: UIView!
     @IBOutlet var googleview: UIView!
    var newstatus = "0"
     override func viewDidLoad() {
         super.viewDidLoad()
        let facebooktap = UITapGestureRecognizer(target: self, action: #selector(self.facebook_tap(_:)))
          facebookview.addGestureRecognizer(facebooktap)
        let googletap = UITapGestureRecognizer(target: self, action: #selector(self.google_tap(_:)))
           googleview.addGestureRecognizer(googletap)
         // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().clientID = "938020712951-rjnm55bb1ele0p6e806mphhbgteugr9d.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
     }
    
    @IBAction func forgot_pass_listener(_ sender: UIButton) {
        self.performSegue(withIdentifier: "forgot", sender: self)
    }
    
    
     @objc func facebook_tap(_ sender: UITapGestureRecognizer){
         let fbLoginManager : LoginManager = LoginManager()
         fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
           if (error == nil){
             let fbloginresult : LoginManagerLoginResult = result!
             // if user cancel the login
             if (result?.isCancelled)!{
                     return
             }
             if(fbloginresult.grantedPermissions.contains("email"))
             {
               self.getFBUserData()
             }
           }
         }
     }
  
     func getFBUserData(){
         if((AccessToken.current) != nil){
             GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
              //everything works print the user data
            
             guard let Info = result as? [String: Any] else { return }
             self.performFacebookSign(facebookid: (Info["id"] as? String)!, email: (Info["email"] as? String)!, firstname: (Info["first_name"] as? String)!, lastname: (Info["last_name"] as? String)!)
            }
          })
        }
      }
     
     @objc func google_tap(_ sender: UITapGestureRecognizer){
         GIDSignIn.sharedInstance()?.signIn()
     }
     func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if let error = error {
              if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
              } else {
                print("\(error.localizedDescription)")
              }
              return
            }
            
            // Perform any operations on signed in user here.
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let email = user.profile.email
            self.performGoogleSign(googleid: idToken!, email: email!, firstname: fullName!, lastname: givenName!)
     }
     func submit_email(){
        if(!validateEmail(enteredEmail: email_txt.text!)){
            Helpers.showAlertView(title: "Error", message: "Your email eddress is invalid")
        }else if(password_txt.text == ""){
            Helpers.showAlertView(title: "Error", message: "Please enter your password")
        }else{
            performSign()
        }
    }
     
     func performSign(){
         if(Connectivity.isConnectedToInternet()){
             Helpers.showHUD(view: self.view, progressLabel: "Loading...")
             SigninRequest.Signin(email: email_txt.text!, password: password_txt.text!){returnJSON,error in
                 if error != nil{
                     Helpers.dismissHUD(view: self.view, isAnimated: true)
                     Helpers.showAlertView(title: "Error", message: "Something went wrong")
                 }else{
                     
                    if returnJSON?.error?.status == 1 {
                         Helpers.dismissHUD(view: self.view, isAnimated: true)
                         if(returnJSON?.error?.detail != nil){
                             Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.detail?.email![0])!+(returnJSON!.error?.detail?.password![0])!)
                         }else{
                             Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                         }
                     }else{
                        Helpers.writePreference(key: "id", data: String((returnJSON?.response?.detail?.id)!))
                        if(returnJSON?.response?.detail?.first_name != nil){
                            Helpers.writePreference(key: "name", data: String((returnJSON?.response?.detail?.first_name)!))
                        }else{
                            Helpers.writePreference(key: "name", data: "N/A")
                        }
                        Helpers.writePreference(key: "user_id", data: (returnJSON?.response?.detail?.user_id)!)
                        Helpers.writePreference(key: "auth_id", data: (returnJSON?.response?.detail?.auth_id)!)
                        Helpers.writePreference(key: "email", data: (returnJSON?.response?.detail?.email)!)
                        Helpers.writePreference(key: "points", data: String((returnJSON?.response?.detail?.points)!))
                        Helpers.writePreference(key: "new_entry_status", data: String((returnJSON?.response?.detail?.newentrystatus)!))
                        if(returnJSON?.response?.detail?.zipcode == nil || returnJSON?.response?.detail?.zipcode == ""){
                            Helpers.writePreference(key: "zipcode", data: "0")
                        }else{
                            Helpers.writePreference(key: "zipcode", data: "1")
                        }
                        if(returnJSON?.response?.detail?.date_of_birth == nil || returnJSON?.response?.detail?.date_of_birth == ""){
                           Helpers.writePreference(key: "dateofbirth", data: "0")
                        }else{
                           Helpers.writePreference(key: "dateofbirth", data: "1")
                        }
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "main", sender: self)
                        }
                     }
                 }
             }
         }else{
             Helpers.dismissHUD(view: self.view, isAnimated: true)
             Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
         }
     }
     
     //email validator
     func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
     }
     @IBAction func back_listener(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
     }
     @IBAction func login_listener(_ sender: UIButton) {
         submit_email()
     }
    @IBAction func move_to_signup(_ sender: UIButton) {
        performSegue(withIdentifier: "signup", sender: self)
    }
    func performFacebookSign(facebookid:String,email:String,firstname:String,lastname:String){
     if(Connectivity.isConnectedToInternet()){
         Helpers.showHUD(view: self.view, progressLabel: "Loading...")
        let device_id = UIDevice.current.identifierForVendor?.uuidString
        let referral_id = Helpers.readPreference(key: "referral_user_id", defualt: "")
        SigninRequest.SigninFacebook(facebookid: facebookid, email: email, firstname: firstname, lastname: lastname,id: referral_id,device_id: device_id!){returnJSON,error in
             if error != nil{
                 Helpers.dismissHUD(view: self.view, isAnimated: true)
                 Helpers.showAlertView(title: "Error", message: "Something went wrong")
             }else{
                 
                if returnJSON?.error?.status == 1 {
                     Helpers.dismissHUD(view: self.view, isAnimated: true)
                     if(returnJSON?.error?.detail != nil){
                         Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.detail?.email![0])!+(returnJSON!.error?.detail?.password![0])!)
                     }else{
                         Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                     }
                 }else{
                    print("loggedin");
                    Helpers.writePreference(key: "id", data: String((returnJSON?.response?.detail?.id)!))
                    if(returnJSON?.response?.detail?.first_name != nil){
                        Helpers.writePreference(key: "name", data: String((returnJSON?.response?.detail?.first_name)!))
                    }else{
                        Helpers.writePreference(key: "name", data: "N/A")
                    }
                    Helpers.writePreference(key: "user_id", data: (returnJSON?.response?.detail?.user_id)!)
                    Helpers.writePreference(key: "auth_id", data: (returnJSON?.response?.detail?.auth_id)!)
                    Helpers.writePreference(key: "email", data: (returnJSON?.response?.detail?.email)!)
                    if(returnJSON?.response?.detail?.points != nil){
                    Helpers.writePreference(key: "points", data: String((returnJSON?.response?.detail?.points)!))
                    }
                    Helpers.writePreference(key: "new_entry_status", data: String((returnJSON?.response?.detail?.newentrystatus)!))
                    if(returnJSON?.response?.detail?.zipcode == nil || returnJSON?.response?.detail?.zipcode == ""){
                        Helpers.writePreference(key: "zipcode", data: "0")
                    }else{
                        Helpers.writePreference(key: "zipcode", data: "1")
                    }
                    if(returnJSON?.response?.detail?.date_of_birth == nil || returnJSON?.response?.detail?.date_of_birth == ""){
                       Helpers.writePreference(key: "dateofbirth", data: "0")
                    }else{
                       Helpers.writePreference(key: "dateofbirth", data: "1")
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "main", sender: self)
                    }
                    
                 }
             }
         }
     }else{
         Helpers.dismissHUD(view: self.view, isAnimated: true)
         Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
     }
    }
    func performGoogleSign(googleid:String,email:String,firstname:String,lastname:String){
     if(Connectivity.isConnectedToInternet()){
         Helpers.showHUD(view: self.view, progressLabel: "Loading...")
        let device_id = UIDevice.current.identifierForVendor?.uuidString
        let referral_id = Helpers.readPreference(key: "referral_user_id", defualt: "")
        SigninRequest.SigninGoogle(googleid: googleid, email: email, firstname: firstname, lastname: lastname,id: referral_id,device_id: device_id!){returnJSON,error in
             if error != nil{
                 Helpers.dismissHUD(view: self.view, isAnimated: true)
                 Helpers.showAlertView(title: "Error", message: "Something went wrong")
             }else{
                 
                if returnJSON?.error?.status == 1 {
                     Helpers.dismissHUD(view: self.view, isAnimated: true)
                     if(returnJSON?.error?.detail != nil){
                         Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.detail?.email![0])!+(returnJSON!.error?.detail?.password![0])!)
                     }else{
                         Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                     }
                 }else{
                    print("loggedin");
                    Helpers.writePreference(key: "id", data: String((returnJSON?.response?.detail?.id)!))
                    if(returnJSON?.response?.detail?.first_name != nil){
                        Helpers.writePreference(key: "name", data: String((returnJSON?.response?.detail?.first_name)!))
                    }else{
                        Helpers.writePreference(key: "name", data: "N/A")
                    }
                    Helpers.writePreference(key: "user_id", data: (returnJSON?.response?.detail?.user_id)!)
                    Helpers.writePreference(key: "auth_id", data: (returnJSON?.response?.detail?.auth_id)!)
                    Helpers.writePreference(key: "email", data: (returnJSON?.response?.detail?.email)!)
                    if(returnJSON?.response?.detail?.points != nil){
                        Helpers.writePreference(key: "points", data: String((returnJSON?.response?.detail?.points)!))
                    }
                    if(returnJSON?.response?.detail?.points != nil){
                        Helpers.writePreference(key: "new_entry_status", data: String((returnJSON?.response?.detail?.newentrystatus)!))
                    }
                    
                    if(returnJSON?.response?.detail?.zipcode == nil || returnJSON?.response?.detail?.zipcode == ""){
                        Helpers.writePreference(key: "zipcode", data: "0")
                    }else{
                        Helpers.writePreference(key: "zipcode", data: "1")
                    }
                    if(returnJSON?.response?.detail?.date_of_birth == nil || returnJSON?.response?.detail?.date_of_birth == ""){
                       Helpers.writePreference(key: "dateofbirth", data: "0")
                    }else{
                       Helpers.writePreference(key: "dateofbirth", data: "1")
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "main", sender: self)
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
