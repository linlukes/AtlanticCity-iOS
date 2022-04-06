//
//  ZipcodePointsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 30/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class ZipcodePointsController: UIViewController {

    @IBOutlet var zipcode_txt: UITextFieldPadding!
    var points = "0"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if(segue.identifier == "congrats"){
          let destinationVC = segue.destination as! UINavigationController
          let newVC = destinationVC.viewControllers.first as! RegisterPointsController
          newVC.points = points
          newVC.formessage = "zipcode"
       }
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        Helpers.writePreference(key: "zipcodeskip", data: "1")
        Helpers.writePreference(key: "dobskip", data: "1")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabs") as! TabsController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func save_listener(_ sender: UIButton) {
        if(zipcode_txt.text == ""){
            Helpers.showAlertView(title: "Error", message: "Please enter your zipcode")
        }else{
            performPointsZipcode(zipcode: zipcode_txt.text!)
        }
    }
    @IBAction func skip_btn_listener(_ sender: UIButton) {
        Helpers.writePreference(key: "zipcodeskip", data: "1")
        let dobStatus = Helpers.readPreference(key: "dateofbirth", defualt: "0")
        if dobStatus != "1" {
            self.performSegue(withIdentifier: "birthday", sender: self)
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabs") as! TabsController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    func performPointsZipcode(zipcode:String){
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            PointsRequest.addZipCodePoints(authid: authid, userid: userid, zipcode: zipcode){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                          Helpers.dismissHUD(view: self.view, isAnimated: true)
                          Helpers.writePreference(key: "zipcode", data: "1")
                          Helpers.writePreference(key: "zipadded", data: "1")
                          self.points = (returnJSON?.response!.detail)!
                          self.performSegue(withIdentifier: "congrats", sender: self)
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
