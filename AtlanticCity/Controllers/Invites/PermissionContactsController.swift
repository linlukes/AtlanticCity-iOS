//
//  PermissionContactsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 22/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import Contacts

class PermissionContactsController: UIViewController {

    
    var urlstring = ""
    
    override func viewWillAppear(_ animated: Bool) {
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sync_contacts_listener(_ sender: UIButton) {
        
        let store = CNContactStore()
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {

            store.requestAccess(for: .contacts) { (granted, err) in
                if let err = err {
                    print("Failed to request access:", err)
                    return
                }
                
                if granted {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "contacts", sender: self)
                    }
                }else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }else{
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)

        }
    }
    
    @IBAction func skip_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "contacts"){
           let destinationVC = segue.destination as! UINavigationController
           let newVC = destinationVC.viewControllers.first as! ContactsController
            newVC.urlstring = self.urlstring
        }
    }
    

}
