//
//  AboutController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 19/05/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import SideMenu

class AboutController: UIViewController {

    @IBOutlet var privacypolicy_view: UIView!
    @IBOutlet var termsofservice_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let privacytap = UITapGestureRecognizer(target: self, action: #selector(self.privacy_tap(_:)))
        privacypolicy_view.addGestureRecognizer(privacytap)
        let termstap = UITapGestureRecognizer(target: self, action: #selector(self.terms_tap(_:)))
        termsofservice_view.addGestureRecognizer(termstap)
        // Do any additional setup after loading the view.
    }
    @objc func privacy_tap(_ sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "privacy", sender: self)
      }
    @objc func terms_tap(_ sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "terms", sender: self)
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "privacy"){
           let destinationVC = segue.destination as! UINavigationController
           let newVC = destinationVC.viewControllers.first as! PrivacyController
            newVC.isTerm = false
        }
        if(segue.identifier == "terms"){
           let destinationVC = segue.destination as! UINavigationController
           let newVC = destinationVC.viewControllers.first as! PrivacyController
            newVC.isTerm = true
        }
    }
    

}
