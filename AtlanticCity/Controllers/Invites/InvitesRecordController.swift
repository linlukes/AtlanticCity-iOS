//
//  InvitesRecordController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 06/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class InvitesRecordController: UIViewController {

    
    @IBOutlet var sagment_menu: UISegmentedControl!
    @IBOutlet var earned_view: UIView!
    @IBOutlet var accepted_view: UIView!
    @IBOutlet var sent_view: UIView!
    @IBOutlet var earned_lbl: UILabel!
    @IBOutlet var accept_lbl: UILabel!
    @IBOutlet var sent_lbl: UILabel!
    @IBOutlet var accept_tableview: UITableView!
    @IBOutlet var earned_child_01: UIView!
    @IBOutlet var earned_child_02: UIView!
    
    var accept_array = [ReferralDetail]()
    var profile_detail = ProfileDetail()
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfile()
        accept_tableview.delegate = self
        accept_tableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    @IBAction func sagment_listener(_ sender: UISegmentedControl) {
        switch sagment_menu.selectedSegmentIndex{
        case 0:
            self.earned_view.isHidden = false
            self.accepted_view.isHidden = true
            self.sent_view.isHidden = true
            getProfile()
        case 1:
            self.earned_view.isHidden = true
            self.accepted_view.isHidden = false
            self.sent_view.isHidden = true
            getAcceptedInvites()
        case 2:
            self.earned_view.isHidden = true
            self.accepted_view.isHidden = true
            self.sent_view.isHidden = false
            getProfile()
        default:
            break;
        }
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func getProfile(){
        
        if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            ProfileRequest.getProfile(userid: userid, authid: authid){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            self.profile_detail = returnJSON?.response?.detail as! ProfileDetail
                            if((returnJSON?.response?.detail?.referral_sent_count)! > 0){
                               self.sent_lbl.text = "You have sent invites to "+String((returnJSON?.response?.detail?.referral_sent_count)!)+"/10 friends."
                            }
                             if((returnJSON?.response?.detail?.referral_accept_count)! >= 1){
                                
                                self.earned_child_01.isHidden = true
                                self.earned_child_02.isHidden = false
                            }
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    @IBAction func claim_btn_listener(_ sender: UIButton) {
        if((self.profile_detail.guru_status)! == 1){
            Helpers.showSuccessView(title: "Success", message: "You have already claimed the prize!")
            return
        }
        self.performSegue(withIdentifier: "prize", sender: self)
    }
    func getAcceptedInvites(){
         
         if(Connectivity.isConnectedToInternet()){
             Helpers.showHUD(view: self.view, progressLabel: "Loading...")
             let id = Helpers.readPreference(key: "id", defualt: "0")

             ReferralRequest.getReferral(id: id){returnJSON,error in
                    if error != nil{
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        Helpers.showAlertView(title: "Error", message: "Something went wrong")
                    }else{
                       if returnJSON?.error?.status == 1 {
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                        }else{
                             Helpers.dismissHUD(view: self.view, isAnimated: true)
                             self.accept_array = returnJSON?.response?.detail as! [ReferralDetail]
                            if(self.accept_array.count == 0){
                                self.accept_tableview.isHidden = true
                            }else{
                                self.accept_tableview.reloadData()
                            }
                        }
                    }
                }
            }else{
                Helpers.dismissHUD(view: self.view, isAnimated: true)
                Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
            }
       }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "prize"){
             let destinationVC = segue.destination as! UINavigationController
             let newVC = destinationVC.viewControllers.first as! PrizeController
             newVC.isInviteprize = true
        }
    }
    

}

extension InvitesRecordController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accept_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AcceptCell  = tableView.dequeueReusableCell(withIdentifier: "AcceptCell") as! AcceptCell
        
        cell.email_lbl.text = self.accept_array[indexPath.row].email
        cell.phone_lbl.text = self.accept_array[indexPath.row].phoneno
        cell.date_lbl.text = self.accept_array[indexPath.row].created_at
            
        return cell
    }
    
    
}
