//
//  SignupController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 27/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import CDAlertView
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import CountryPickerView

protocol isSignUpPreform {
    func preformSignup(isVerfiy:Bool)
}

class SignupController: UIViewController,isSignUpPreform,GIDSignInDelegate,UITextFieldDelegate {
   
    
    @IBOutlet var firstname_txt: UITextField!
    @IBOutlet var lastname_txt: UITextField!
    @IBOutlet weak var email_txt: UITextField!
    @IBOutlet weak var mobile_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet var password_count_lbl_01: UILabel!
    @IBOutlet var countrypicker: CountryPickerView!
    @IBOutlet var facebookview: UIView!
    @IBOutlet var googleview: UIView!
    var newstatus = "0"
    var isOpen = true
    var isOpenS = true
    var countrycode = ""
    var isVerify = false
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
        password_txt.delegate = self
        countrypicker.textColor = UIColor.white
        countrypicker.setCountryByCode("US")
        countrypicker.delegate = self
        countrypicker.dataSource = self
        if #available(iOS 12, *) {
            // iOS 12 & 13: Not the best solution, but it works.
            password_txt.textContentType = .oneTimeCode
        } else {
            // iOS 11: Disables the autofill accessory view.
            // For more information see the explanation below.
            password_txt.textContentType = .init(rawValue: "")
        }
        countrycode = countrypicker.selectedCountry.phoneCode
        password_txt.isSecureTextEntry = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "pincode"){
           let destinationVC = segue.destination as! UINavigationController
           let newVC = destinationVC.viewControllers.first as! PincodeController
           newVC.phoneno = mobile_txt.text!
           newVC.countrycode = countrycode
           newVC.delegate = self
        }
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
    //Validation
    func check_fields_data(){
        
        if(firstname_txt.text == ""){
            Helpers.showAlertView(title: "Email", message: "Please enter your firstname.")
            return
        }
        if(lastname_txt.text == ""){
            Helpers.showAlertView(title: "Email", message: "Please enter your firstname.")
            return
        }
        
        if(email_txt.text == ""){
            Helpers.showAlertView(title: "Email", message: "Please enter your email address")
            return
        }
        else if(!validateEmail(enteredEmail:email_txt.text!.whiteSpacesRemoved())){
            Helpers.showAlertView(title: "Email", message: "Your email address is invalid")
            return
        }
        else if(mobile_txt.text == ""){
            Helpers.showAlertView(title: "Mobile No", message: "Please enter your last")
            return
        }
        else if (password_txt.text == ""){
            Helpers.showAlertView(title: "Password", message: "Please enter your password")
            return
        }else if(password_txt.text!.count < 6 ){
            Helpers.showAlertView(title: "Password", message: "Please enter six digit password.")
            return
        }else{
            if(isVerify){
                submitdata()
            }else{
                self.performSegue(withIdentifier: "pincode", sender: self)
            }
            //submitdata()
        }
    }
    
    //email validator
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    
    }
    
    func preformSignup(isVerfiy: Bool) {
        self.isVerify = isVerfiy
        if(isVerfiy == true){
            submitdata()
        }else{
            Helpers.showAlertView(title: "Error", message: "Phone has not verified")
        }
    }
    
    func submitdata(){
           if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let device_id = UIDevice.current.identifierForVendor?.uuidString
            let referral_id = Helpers.readPreference(key: "referral_user_id", defualt: "")
            print("referral"+referral_id)
           
            SignupRequest.Signup(firstname:firstname_txt.text!,lastname: lastname_txt.text!,usermobile: mobile_txt.text!, email: email_txt.text!.whiteSpacesRemoved(), password: password_txt.text!,id: referral_id,device_id: device_id!) { returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                        Helpers.showAlertView(title: "Error", message:("Server Error"))
                   }else{
                        if returnJSON?.error?.status == 1 {
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            if(returnJSON?.error?.detail != nil){
                                Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.detail?.email![0])!+(returnJSON!.error?.detail?.password![0])!)
                            }else{
                                Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                            }
                        }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
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
                            self.showSuccessPopup()
                        }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message: "Please check your internet connection!")
           }
       }
    func successSignup(){
        self.performSegue(withIdentifier: "signin", sender: self)
    }
    func showSuccessPopup(){
        let alert = CDAlertView(title: "Success", message: "Successfully Registered", type: .success)
        let doneAction = CDAlertViewAction(title: "OK", handler: { action in
            self.performSegue(withIdentifier: "main", sender: self)
            return true
        })
        alert.add(action: doneAction)
        alert.show()
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
    @IBAction func register_listener(_ sender: UIButton) {
        check_fields_data()
    }
    @IBAction func move_to_login(_ sender: UIButton) {
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    @IBAction func show_password(_ sender: UIButton) {
        if(!isOpen){
            isOpen = true
            password_txt.isSecureTextEntry = false
        }else{
            isOpen = false
            password_txt.isSecureTextEntry = true
        }
    }
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let textFieldText = textField.text,
               let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                   return false
           }
           let substringToReplace = textFieldText[rangeOfTextToReplace]
           let count = textFieldText.count - substringToReplace.count + string.count
            if(textField == password_txt && count <= 6){
               password_count_lbl_01.text = String(count)+"/6"
            }
           return count <= 6
       }
}
extension SignupController : CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country.code)
        countrycode = country.phoneCode
    }
    
    
}
