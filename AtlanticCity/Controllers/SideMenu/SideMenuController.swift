//
//  SideMenuController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var delegate:isDrawerOpen?
    @IBOutlet var menu_tableview: UITableView!
    var menuOptions = ["Deals","Notifications","Earned Points","How to earn points?","View Invites","Options","About Us","Sign Out"]
        var menuIcons = ["deals","notification","earnedpoints","howto","howto","settings","about","signout"]
        
    override func viewWillAppear(_ animated: Bool) {
        let isMenu = Helpers.readPreference(key: "isMenu", defualt: "0")
        if(isMenu == "1"){
            Helpers.writePreference(key: "isMenu", data: "0")
            //self.dismiss(animated: true, completion: nil)
            
        }
        print("called")
    }
    func setUpSideBar(){
          let menu = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
          menu?.presentationStyle = .menuSlideIn
          menu?.menuWidth = 300
          menu?.statusBarEndAlpha = 0
          present(menu!, animated: true, completion: nil)
      }
        override func viewDidLoad() {
            super.viewDidLoad()
            menu_tableview.delegate = self
            menu_tableview.dataSource = self
         
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            if(indexPath.row == 0){
                performSegue(withIdentifier: "deals", sender: self)
            }
            if(indexPath.row == 1){
                performSegue(withIdentifier: "notifications", sender: self)
            }
            if(indexPath.row == 2){
               performSegue(withIdentifier: "earnedpoints", sender: self)
            }
            if(indexPath.row == 3){
                performSegue(withIdentifier: "howtoearnpoints", sender: self)
            }
            if(indexPath.row == 4){
                self.performSegue(withIdentifier: "shareinvite", sender: self)

            }
            if(indexPath.row ==  5){
                performSegue(withIdentifier: "settings", sender: self)
            }
            if(indexPath.row ==  6){
                performSegue(withIdentifier: "about", sender: self)
            }
            if(indexPath.row == 7){
                Helpers.writePreference(key: "zipcodeskip", data: "0")
                Helpers.writePreference(key: "dobskip", data: "0")
                Helpers.writePreference(key: "user_id", data: "")
                Helpers.writePreference(key: "auth_id", data: "")
                Helpers.writePreference(key: "zipcode", data: "")
                Helpers.writePreference(key: "dateofbirth", data: "")
                Helpers.writePreference(key: "referral_user_id", data: "")
                performSegue(withIdentifier: "login", sender: self)
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return menuOptions.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell : MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
            cell.menu_name.text =  menuOptions[indexPath.row]
            cell.image_icon.image = UIImage(named: menuIcons[indexPath.row])
            
            return cell
        }
       
}
