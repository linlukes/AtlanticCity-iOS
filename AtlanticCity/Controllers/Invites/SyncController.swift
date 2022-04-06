//
//  SyncController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import Contacts

class SyncController: UIViewController {

    var urlstring = ""
    
    @IBOutlet var synccontacts_view: UIView!
    @IBOutlet weak var syncButton: UIButton!
  
    
    override func viewWillAppear(_ animated: Bool) {
        let authStatusForContacts = CNContactStore.authorizationStatus(for: .contacts)
        if authStatusForContacts == .authorized {
            syncButton.setTitle("Resync", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       let tap = UITapGestureRecognizer(target: self, action: #selector(self.synccontacts_tap(_:)))
       synccontacts_view.addGestureRecognizer(tap)
    }
    @objc func synccontacts_tap(_ sender: UITapGestureRecognizer){
        let authStatusForContacts = CNContactStore.authorizationStatus(for: .contacts)
        if authStatusForContacts == .authorized {
           self.performSegue(withIdentifier: "contacts", sender: self)
        }else {
           self.performSegue(withIdentifier: "syncContacts", sender: self)
        }
    }
    @IBAction func contact_sync_listener(_ sender: UIButton) {
        let authStatusForContacts = CNContactStore.authorizationStatus(for: .contacts)
        if authStatusForContacts == .authorized {
            self.performSegue(withIdentifier: "contacts", sender: self)
        }else {
            self.performSegue(withIdentifier: "syncContacts", sender: self)
        }
        
    }
    
    @IBAction func facebook_sync_listener(_ sender: UIButton) {
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
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
        }else if(segue.identifier == "syncContacts"){
           let destinationVC = segue.destination as! UINavigationController
           let newVC = destinationVC.viewControllers.first as! PermissionContactsController
            newVC.urlstring = self.urlstring
        }
    }
    

}
