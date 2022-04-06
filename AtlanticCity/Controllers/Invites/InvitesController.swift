//
//  InvitesController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 30/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class InvitesController: UIViewController {

    var id = 0
    
    @IBOutlet var invite_url_lbl: UILabel!
    @IBOutlet var link_view: UIView!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateLink()
        // Do any additional setup after loading the view.
    }
    func generateLink(){
        Helpers.showHUD(view: self.view, progressLabel: "Loading...")
        let id = Helpers.readPreference(key: "id", defualt: "")
        guard let link = URL(string: "https://www.atlanticcity.com/?invitedby="+id) else { return }
        let dynamicLinksDomainURIPrefix = "https://atlanticcity1.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder!.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.floridainc.AtlanticCity")
        linkBuilder!.androidParameters = DynamicLinkAndroidParameters(packageName: "com.atlanticcity.app")
       
        let options = DynamicLinkComponentsOptions()
        options.pathLength = .short
        linkBuilder!.options = options

        linkBuilder!.shorten { (shortURL, warnings, error) in

           if let error = error {
               print(error.localizedDescription)
               return
           }

            let shortLink:String = shortURL!.absoluteString
           print(shortLink)
           self.invite_url_lbl.text = shortLink
           self.url = shortLink
           self.link_view.isHidden = false
           Helpers.dismissHUD(view: self.view, isAnimated: true)
        }
    
    }
    override func viewWillAppear(_ animated: Bool) {
      if(id == 0){
          self.navigationItem.leftBarButtonItem = nil
      }
    }
       
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invite_friends_listener(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sync", sender: self)
    }
    
    @IBAction func skip_btn_listener(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentView") as! PageViewController
         vc.modalPresentationStyle = .fullScreen
         if(SplashController.dealsarray.count == 0){
              vc.pages = HomeController.dealsarray
         }else{
              vc.pages = SplashController.dealsarray
         }        
         self.present(vc, animated: true, completion: nil)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "sync"){
            let destinationVC = segue.destination as! UINavigationController
            let newVC = destinationVC.viewControllers.first as! SyncController
            newVC.urlstring = url
        }
    }
    
}
