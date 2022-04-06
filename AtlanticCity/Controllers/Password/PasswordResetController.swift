//
//  PasswordResetController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 12/05/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import SVPinView
import CDAlertView

class PasswordResetController: UIViewController {

    @IBOutlet var email_txt: UITextField!
    @IBOutlet var new_pass_txt: UITextField!
    @IBOutlet var pinView: SVPinView!
    
    var codetxt:String = ""
    var email = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        email_txt.text = email
        configurePinView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit_listener(_ sender: UIButton) {
        self.verify()
        //self.performSegue(withIdentifier: "login", sender: self)
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }

    func configurePinView() {
          
          pinView.activeBorderLineThickness = 2
          pinView.fieldBackgroundColor = UIColor.black.withAlphaComponent(0.5)
          pinView.activeFieldBackgroundColor = UIColor.black.withAlphaComponent(0.5)
          pinView.fieldCornerRadius = 10
          pinView.activeFieldCornerRadius = 10
          pinView.fieldCornerRadius = 10
          pinView.activeFieldCornerRadius = 10
          pinView.pinLength = 4
          pinView.interSpace = 10
          pinView.textColor = UIColor.white
          pinView.borderLineColor = UIColor.clear
          pinView.activeBorderLineColor = Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green))
          pinView.borderLineThickness = 1
          pinView.shouldSecureText = false
          pinView.allowsWhitespaces = false
          pinView.style = .box
          pinView.becomeFirstResponderAtIndex = 0
          pinView.shouldDismissKeyboardOnEmptyFirstField = false
          
          pinView.font = UIFont.systemFont(ofSize: 30.0, weight: .heavy)
        
          pinView.keyboardType = .phonePad
          pinView.pinInputAccessoryView = { () -> UIView in
              let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
              doneToolbar.barStyle = UIBarStyle.default
              let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
              let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
              
              var items = [UIBarButtonItem]()
              items.append(flexSpace)
              items.append(done)
              
              doneToolbar.items = items
              doneToolbar.sizeToFit()
              return doneToolbar
          }()
          
          pinView.didFinishCallback = didFinishEnteringPin(pin:)
          pinView.didChangeCallback = { pin in
              print("The entered pin is \(pin)")
            self.codetxt = pin
          }
      }
    func didFinishEnteringPin(pin:String) {
        print(pin)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func verify(){
        if(new_pass_txt.text == ""){
            Helpers.showAlertView(title: "Error", message: "Please enter your new password")
            return
        }
        else if(codetxt == ""){
            Helpers.showAlertView(title: "Error", message: "Please enter pin code which we have sent you on given email address")
            return
        }
        if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            PassVerifyRequest.setPassRecovery(email: email_txt.text!, code: codetxt, pass: new_pass_txt.text!){returnJSON,error in
             if error != nil{
                 Helpers.dismissHUD(view: self.view, isAnimated: true)
                 Helpers.showAlertView(title: "Error", message: "Something went wrong")
             }else{
                if returnJSON?.error?.status == 1 {
                     Helpers.dismissHUD(view: self.view, isAnimated: true)
                     Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
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
                    self.showSuccessPopup(message: (returnJSON!.response?.message)!)
                   
                 }
             }
            }
        }else{
            Helpers.dismissHUD(view: self.view, isAnimated: true)
            Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
    }
    func showSuccessPopup(message:String){
           let alert = CDAlertView(title: "Success", message: message, type: .success)
           let doneAction = CDAlertViewAction(title: "OK", handler: { action in
               self.performSegue(withIdentifier: "main", sender: self)
               return true
           })
           alert.add(action: doneAction)
           alert.show()
       }
}

