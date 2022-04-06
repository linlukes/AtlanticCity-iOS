//
//  SettingsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 04/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import SideMenu

class SettingsController: UIViewController {

    @IBOutlet var notification_switch: UISwitch!
    @IBOutlet var profile_view: UIView!
    @IBOutlet var password_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profiletap = UITapGestureRecognizer(target: self, action: #selector(self.profile_tap(_:)))
        profile_view.addGestureRecognizer(profiletap)
        let passwordtap = UITapGestureRecognizer(target: self, action: #selector(self.password_tap(_:)))
        password_view.addGestureRecognizer(passwordtap)
        // Do any additional setup after loading the view.
    }
    @objc func profile_tap(_ sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "profile", sender: self)
    }
    @objc func password_tap(_ sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "password", sender: self)
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
