//
//  NotificationController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import CDAlertView
import SideMenu

protocol DelNotifi {
    func delNotification(id:String)
}

class NotificationController: UIViewController,DelNotifi {

    

    @IBOutlet var notification_tableview: UITableView!
    var itemid = ""
    var userid = ""
    var click_action = ""
    var body = ""
    var notifytitle = ""
    var notiarray = [NDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(itemid + userid + click_action)
        if(itemid != "" && click_action != ""){
            showSuccessPopup()
        }
        notification_tableview.delegate = self
        notification_tableview.dataSource = self
        fetchNotification()
        // Do any additional setup after loading the view.
    }
    func showSuccessPopup(){
        let alert = CDAlertView(title: notifytitle, message: body, type: .success)
        let doneAction = CDAlertViewAction(title: "OK", handler: { action in
            self.performSegue(withIdentifier: "dealsdetail", sender: self)
            return true
        })
        alert.add(action: doneAction)
        alert.show()
    }
    func fetchNotification(){
           if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            NRequest.getNotifications(user_id: userid, auth_id: authid){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           self.notiarray = returnJSON?.response?.detail as! [NDetail]
                           self.notification_tableview.reloadData()
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    func delNotification(id: String) {
        delNotifi(id: id)
    }
    func delNotifi(id:String){
       if(Connectivity.isConnectedToInternet()){
        Helpers.showHUD(view: self.view, progressLabel: "Loading...")
        let userid = Helpers.readPreference(key: "user_id", defualt: "0")
        let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
        NRequest.delNotifications(user_id: userid, auth_id: authid, notiid: id){returnJSON,error in
               if error != nil{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Error", message: "Something went wrong")
               }else{
                  if returnJSON?.error?.status == 1 {
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                   }else{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       self.notiarray.removeAll()
                       self.fetchNotification()
                   }
               }
           }
       }else{
           Helpers.dismissHUD(view: self.view, isAnimated: true)
           Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
       }
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        if(itemid != "" && click_action != ""){
            let menuAlert = UIAlertController(title: "Menu", message: "Please select one option", preferredStyle: UIAlertController.Style.actionSheet)

            let businessAction = UIAlertAction(title: "Businesses", style: .default) { (action: UIAlertAction) in
                self.setupBusiness()
            }
            let favAction = UIAlertAction(title: "Favorites", style: .default) { (action: UIAlertAction) in
                self.setupFav()
            }
            let settAction = UIAlertAction(title: "Settings", style: .default) { (action: UIAlertAction) in
                //self.performSegue(withIdentifier: "menu", sender: self)
                self.setUpSideBar()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            menuAlert.addAction(businessAction)
            menuAlert.addAction(favAction)
            menuAlert.addAction(settAction)
            menuAlert.addAction(cancelAction)
            self.present(menuAlert, animated: true, completion: nil)
        }else{
            Helpers.writePreference(key: "isMenu", data: "1")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "dealsdetail"){
           let destinationVC = segue.destination as! UINavigationController
           let newVC = destinationVC.viewControllers.first as! SingleDealController
             newVC.item_id = itemid
             newVC.dealid = itemid
        }
    }
    func setUpSideBar(){
            let menu = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
            menu?.presentationStyle = .menuSlideIn
            menu?.menuWidth = 300
            menu?.statusBarEndAlpha = 0
            present(menu!, animated: true, completion: nil)
        }
        func setupFav(){
            let menu = storyboard?.instantiateViewController(withIdentifier: "fav") as? UINavigationController
            menu?.modalPresentationStyle = .fullScreen
            present(menu!, animated: true, completion: nil)
        }
      func setupBusiness(){
          let menu = storyboard?.instantiateViewController(withIdentifier: "tabs") as? UITabBarController
          menu?.modalPresentationStyle = .fullScreen
          present(menu!, animated: true, completion: nil)
      }

}
extension NotificationController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notiarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NCell = tableView.dequeueReusableCell(withIdentifier: "NCell") as! NCell
        cell.delegate = self
        cell.title.text = self.notiarray[indexPath.row].title
        cell.message_lbl.text = self.notiarray[indexPath.row].description
        cell.date_lbl.text = self.notiarray[indexPath.row].created_at
        cell.id = String(self.notiarray[indexPath.row].id!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.notiarray[indexPath.row].item_id != nil){
            itemid = self.notiarray[indexPath.row].item_id!
            self.performSegue(withIdentifier: "dealsdetail", sender: self)
        }else{
            Helpers.showAlertView(title: "Error", message: "Details not found")
        }
    }
    
}
