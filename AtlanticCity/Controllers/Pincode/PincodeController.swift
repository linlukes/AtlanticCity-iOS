//
//  PincodeController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 28/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVPinView

class PincodeController: UIViewController {

    @IBOutlet var pinView: SVPinView!
    @IBOutlet var phone_lbl: UILabel!
    var delegate:isSignUpPreform?
    @IBOutlet var first_digit: UITextField!
    @IBOutlet var second_digit: UITextField!
    @IBOutlet var third_digit: UITextField!
    @IBOutlet var fourth_digit: UITextField!
    @IBOutlet var fifth_digit: UITextField!
    @IBOutlet var sixth_digit: UITextField!
    
    @IBOutlet weak var first_digit_view: RoundView!
    @IBOutlet weak var second_digit_view: RoundView!
    @IBOutlet weak var third_digit_view: RoundView!
    @IBOutlet weak var fourth_digit_view: RoundView!
    @IBOutlet weak var fivth_digit_view: RoundView!
    @IBOutlet weak var sixth_digit_view: RoundView!
    
    var phoneno = ""
    var countrycode = ""
    var codetxt:String = ""
    var verification_id = ""
    var pincode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        phone_lbl.text = phoneno
//        first_digit.delegate = self
//        second_digit.delegate = self
//        third_digit.delegate = self
//        fourth_digit.delegate = self
//        fifth_digit.delegate = self
//        sixth_digit.delegate = self
        
//        first_digit_view.borderColor = UIColor.white
//        first_digit_view.borderWidth = 2.0
//        first_digit.becomeFirstResponder()
        // Do any additional setup after loading the view.
        sendPinCode()
        configurePinView()
    }
    func configurePinView() {
          
          pinView.activeBorderLineThickness = 2
          pinView.fieldBackgroundColor = UIColor.white.withAlphaComponent(0.2)
          pinView.activeFieldBackgroundColor = UIColor.white.withAlphaComponent(0.2)
          pinView.fieldCornerRadius = 10
          pinView.activeFieldCornerRadius = 10
          pinView.fieldCornerRadius = 10
          pinView.activeFieldCornerRadius = 10
          pinView.pinLength = 6
          pinView.interSpace = 10
          pinView.textColor = UIColor.white
          pinView.borderLineColor = UIColor.clear
          pinView.activeBorderLineColor = UIColor.white
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
    func sendPinCode(){
        
        sendCode()
        
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneno, uiDelegate: nil) { (verificationID, error) in
//          if let error = error {
//            print((error.localizedDescription))
//            Helpers.showAlertView(title: "Error", message: "Pincode Error")
//            return
//          }else{
//            self.verification_id = verificationID!
//          }
//        }
        
    }
    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    @IBAction func change_phone_listener(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func verify_listener(_ sender: UIButton) {
        if (codetxt.count == 6) {
            dismissKeyboard()
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            if(codetxt == pincode){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.dismiss(animated: true) {
                        self.delegate?.preformSignup(isVerfiy: true)
                    }
                }
            }else{
                Helpers.dismissHUD(view: self.view, isAnimated: true)
                Helpers.showAlertView(title: "Error", message: "Your pincode is incorrect.")
            }

        }else{
            codetxt = ""
        }
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resend_otp_listener(_ sender: UIButton) {
        self.sendCode()
    }
    
    func sendCode(){
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            pincode = generateRandomDigits(6)
            let message = "Your AtlanticCity id Verification Code is: \n"+pincode
            PincodeRequest.sendPin(message: message, phoneno: countrycode+phoneno){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                          Helpers.dismissHUD(view: self.view, isAnimated: true)
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
    
}
