//
//  EarnedPointsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 09/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import SideMenu

protocol DelEarnedPoints {
    func delEarned(id:Int)
}

class EarnedPointsController: UIViewController,UITableViewDelegate,UITableViewDataSource,DelEarnedPoints {
    
    

    @IBOutlet var earned_points_lbl: UILabel!
    @IBOutlet var earned__points_tableview: UITableView!
    @IBOutlet var available_points_lbl: UILabel!
    var earnedpointslist = [EPDetail]()
    var earnedpointslistfull = [EPDetail]()
     override func viewDidLoad() {
         super.viewDidLoad()
         
         earned__points_tableview.delegate = self
         earned__points_tableview.dataSource = self
         
         fetchEarnedPointsDetails()
         // Do any additional setup after loading the view.
     }

    
     func fetchEarnedPointsDetails(){
            if(Connectivity.isConnectedToInternet()){
                Helpers.showHUD(view: self.view, progressLabel: "Loading...")
                let userid = Helpers.readPreference(key: "user_id", defualt: "0")
                let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
                EPRequest.getEarnedPoints(user_id: userid, auth_id: authid){returnJSON,error in
                    if error != nil{
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        Helpers.showAlertView(title: "Error", message: "Something went wrong")
                    }else{
                       if returnJSON?.error?.status == 1 {
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                        }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            for data in returnJSON!.response!.detail!{
                                if(data.status == 1){
                                    self.earnedpointslist.append(data)
                                }
                            }
                            self.earnedpointslistfull = (returnJSON?.response!.detail)!
                            self.setData()
                            self.earned__points_tableview.reloadData()
                        }
                    }
                }
            }else{
                Helpers.dismissHUD(view: self.view, isAnimated: true)
                Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
            }
     }
    func delEarned(id: Int) {
        delEarnedPointsDetails(id: id)
    }
    func delEarnedPointsDetails(id:Int){
               if(Connectivity.isConnectedToInternet()){
                   Helpers.showHUD(view: self.view, progressLabel: "Loading...")
                   let userid = Helpers.readPreference(key: "user_id", defualt: "0")
                   let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
                   EPRequest.delEarnedPoints(id: id,user_id: userid, auth_id: authid){returnJSON,error in
                       if error != nil{
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message: "Something went wrong")
                       }else{
                          if returnJSON?.error?.status == 1 {
                               Helpers.dismissHUD(view: self.view, isAnimated: true)
                               Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                           }else{
                               Helpers.dismissHUD(view: self.view, isAnimated: true)
                               self.fetchEarnedPointsDetails()
                           }
                       }
                   }
               }else{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
               }
        }
    func setData(){
        var sum = 0
        for detail in earnedpointslistfull{
            sum += detail.points!
        }
        earned_points_lbl.text = String(sum)
        available_points_lbl.text  = String((earnedpointslistfull [0].user?.points)!)
        
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return earnedpointslist.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell:EarnedPointsCell = tableView.dequeueReusableCell(withIdentifier: "EarnedPointsCell") as! EarnedPointsCell

        if(earnedpointslist[indexPath.row].type == 4){
//            29B171
            let image = UIImage(systemName: "doc.richtext")
            image?.withTintColor(UIColor(red: 41, green: 177, blue: 113, alpha: 1))
            cell.points_img.image = image
            cell.title_lbl.text = "Registration Points"
        }else if(earnedpointslist[indexPath.row].type == 2){
            cell.points_img.image = UIImage(named: "cake")
            cell.title_lbl.text = "Birthday Points"
        }else if(earnedpointslist[indexPath.row].type == 3){
            cell.points_img.image = UIImage(named: "location_ico")
            cell.title_lbl.text = "Zipcode Points"
        }else{
            if(earnedpointslist[indexPath.row].item != nil){
                let original = earnedpointslist[indexPath.row].item?.avatar
                if let encoded = original!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                   let url = URL(string: encoded)
                {
                   let imageView = UIImageView()
                   imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_bm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                      if(error != nil){
                           cell.points_img.image = UIImage(named: "account_bm")
                      }else{
                        if (downloadImage != nil) {
                          cell.points_img.image = downloadImage!
                        }
                      }
                   })
                }
                cell.title_lbl.text = earnedpointslist[indexPath.row].item?.title
            }
        }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "y-m-d h:m:s"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        if let date = dateFormatterGet.date(from: earnedpointslist[indexPath.row].created_at!){
            cell.date_lbl.text = dateFormatterPrint.string(from: date)
        } else {
            print("Not formatted")
        }
        cell.delegate = self
        cell.id = earnedpointslist[indexPath.row].id!
        cell.earnpoints_lbl.text = String(earnedpointslist[indexPath.row].points!)
         return cell
     }
     @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
     }

}
