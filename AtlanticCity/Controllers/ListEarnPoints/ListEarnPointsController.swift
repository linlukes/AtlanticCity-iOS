//
//  ListEarnPointsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 09/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import SideMenu

class ListEarnPointsController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var content_list: UITableView!
    var earnpointslist = [EarnPointsDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content_list.delegate = self
        content_list.dataSource = self
        
        fetchEarnPointsDetails()
        // Do any additional setup after loading the view.
    }
    
    func fetchEarnPointsDetails(){
        if(Connectivity.isConnectedToInternet()){
           Helpers.showHUD(view: self.view, progressLabel: "Loading...")
           let userid = Helpers.readPreference(key: "user_id", defualt: "0")
           let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
        EarnPointsRequest.getEarnPoints(user_id: userid, auth_id: authid){returnJSON,error in
               if error != nil{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Error", message: "Something went wrong")
               }else{
                  if returnJSON?.error?.status == 1 {
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                   }else{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       self.earnpointslist = (returnJSON?.response!.detail)!
                        self.content_list.reloadData()
                   }
               }
           }
        }else{
           Helpers.dismissHUD(view: self.view, isAnimated: true)
           Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earnpointslist.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListEarnPointsCell = tableView.dequeueReusableCell(withIdentifier: "ListEarnPointsCell") as! ListEarnPointsCell
        if(earnpointslist[indexPath.row].id == 3){
            cell.title_lbl.text = "Enter ZipCode"
            cell.description_lbl.text = "Get points and specials deals for you."
            cell.points_lbl.text = earnpointslist[indexPath.row].value!+" POINTS"
            cell.point_img.image = UIImage(named: "dob")
         
        }
        if(earnpointslist[indexPath.row].id == 4){
            cell.title_lbl.text = "Enter DOB"
            cell.description_lbl.text = "Get a birthday deal and bonus points."
            cell.points_lbl.text = earnpointslist[indexPath.row].value!+" POINTS"
            cell.point_img.image = UIImage(named: "dob")
        }
        if(earnpointslist[indexPath.row].id == 7){
            cell.title_lbl.text = "Shop & Earn"
            cell.description_lbl.text = "Save money and get points."
            cell.points_lbl.text = earnpointslist[indexPath.row].value!+" POINTS"
            cell.point_img.image = UIImage(named: "shop")

        }
        if(earnpointslist[indexPath.row].id == 8){
            cell.title_lbl.text = "Share the app"
            cell.description_lbl.text = "Share with friends and get a huge gift."
            cell.points_lbl.text = earnpointslist[indexPath.row].value!+" POINTS"
            cell.point_img.image = UIImage(named: "shareapp")

        }
        return cell
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func check_btn_listener(_ sender: UIButton) {
        self.performSegue(withIdentifier: "earnedpoints", sender: self)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let zipadd = Helpers.readPreference(key: "zipcode", defualt: "0")
            if(zipadd == "0"){
              self.performSegue(withIdentifier: "zipcode", sender: self)
            } else {
               Helpers.showToast(view: self.view, msg: "Zipcode already exists.")
            }
            
        }
        if(indexPath.row == 1){
            let dobadd = Helpers.readPreference(key: "dateofbirth", defualt: "0")
            if(dobadd == "0"){
                self.performSegue(withIdentifier: "dob", sender: self)
            } else {
                Helpers.showToast(view: self.view, msg: "Date of birth already exists.")
            }
        }
        if(indexPath.row == 2){
            self.performSegue(withIdentifier: "main", sender: self)
        }
        if(indexPath.row == 3){
            self.performSegue(withIdentifier: "shareinvite", sender: self)
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
