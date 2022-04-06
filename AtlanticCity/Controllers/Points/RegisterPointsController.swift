//
//  RegisterPointsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 30/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class RegisterPointsController: UIViewController {

    @IBOutlet var message_lbl: UILabel!
    @IBOutlet var more_btn: RoundButton!
    var points = "0"
    var formessage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        message_lbl.text = "You have earned "+points+" points for "+formessage
        if(formessage == "birthday"){
            more_btn.setTitle("Awesome", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        Helpers.writePreference(key: "zipcodeskip", data: "1")
        Helpers.writePreference(key: "dobskip", data: "1")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabs") as! TabsController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func get_more_points_listener(_ sender: UIButton) {
        if(formessage == "birthday"){
            Helpers.writePreference(key: "zipcode", data: "1")
            Helpers.writePreference(key: "dateofbirth", data: "1")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabs") as! TabsController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }
        if(formessage == "zipcode"){
            let zipcodepin = Helpers.readPreference(key: "zipcode", defualt: "0")
            if(zipcodepin == "0"){
               self.performSegue(withIdentifier: "zipcode", sender: self)
            }else{
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
        }
        if(formessage == "registering"){
               let zipcodepin = Helpers.readPreference(key: "zipcode", defualt: "0")
               if(zipcodepin == "0"){
                  self.performSegue(withIdentifier: "zipcode", sender: self)
               }
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
