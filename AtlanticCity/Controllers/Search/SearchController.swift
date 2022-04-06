//
//  SearchController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class SearchController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var business_view: UIView!
    @IBOutlet var deals_view: UIView!
    @IBOutlet var deals_tableview: UITableView!
    var search_txt = ""
    var type = ""
    var deals_array = [DSearchDetail]()
    var business_array = [SearchDetail]()
    var itemid = ""
    var dealid = ""
    var bid = ""
    @IBOutlet var business_tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        business_tableview.delegate = self
        deals_tableview.delegate = self
        business_tableview.dataSource = self
        deals_tableview.dataSource = self
        if(type == "business"){
            business_view.isHidden = false
            self.fetchSearchBusiness(search_txt: search_txt)
        }else{
            deals_view.isHidden = false
            self.fetchSearchDeals(search_txt: search_txt)
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == business_tableview){
            return business_array.count
        }else{
            return deals_array.count
        }
        return 0
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if(tableView == business_tableview){
          let cell:BusinessCell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
          cell.business_name.text = business_array[indexPath.row].business_name
          cell.business_desc.text = business_array[indexPath.row].business_detail
          let original = business_array[indexPath.row].logo
          if let encoded = original!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
          let url = URL(string: encoded)
          {
          let imageView = UIImageView()
          imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            DispatchQueue.main.async {
                if (downloadImage != nil) {
                cell.business_img.image = downloadImage!
                }
            }
          })
          }
          cell.business_hours.text = business_array[indexPath.row].open_time
            if(business_array[indexPath.row].deals_count != nil){
                cell.deals_count.text = String(business_array[indexPath.row].deals_count!)+" Deals"
            }else{
                cell.deals_count.text = "0 Deals"
            }

          return cell
        }else{
          let cell:SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
          cell.business_name.text = deals_array[indexPath.row].title
          cell.business_desc.text = deals_array[indexPath.row].description
          let original = deals_array[indexPath.row].avatar
          if let encoded = original!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
          let url = URL(string: encoded)
          {
          let imageView = UIImageView()
              imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                DispatchQueue.main.async {
                    if (downloadImage != nil) {
                   cell.business_img.image = downloadImage!
                    }
                }
              })
          }
          cell.business_dates.text = deals_array[indexPath.row].deal_expire_at
          return cell
        }

        return cell
     }

    func fetchSearchBusiness(search_txt:String){
             if(Connectivity.isConnectedToInternet()){
                 Helpers.showHUD(view: self.view, progressLabel: "Loading...")
                 let userid = Helpers.readPreference(key: "user_id", defualt: "0")
                 let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
                SearchRequest.getSearchBusiness(user_id: userid, auth_id: authid, searchtxt: search_txt){returnJSON,error in
                     if error != nil{
                         Helpers.dismissHUD(view: self.view, isAnimated: true)
                         Helpers.showAlertView(title: "Error", message: "Something went wrong")
                     }else{
                        if returnJSON?.error?.status == 1 {
                             Helpers.dismissHUD(view: self.view, isAnimated: true)
                             Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                         }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            if(returnJSON?.response!.detail != nil){
                                self.business_array = (returnJSON?.response!.detail)!
                            }else{
                                Helpers.showToast(view: self.view, msg: "No record found.")
                            }
                            DispatchQueue.main.async {
                                self.business_tableview.reloadData()
                            }
                         }
                     }
                 }
             }else{
                 Helpers.dismissHUD(view: self.view, isAnimated: true)
                 Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
             }
        }
    func fetchSearchDeals(search_txt:String){
               if(Connectivity.isConnectedToInternet()){
                   Helpers.showHUD(view: self.view, progressLabel: "Loading...")
                   let userid = Helpers.readPreference(key: "user_id", defualt: "0")
                   let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
                SearchRequest.getSearchDeals(user_id: userid, auth_id: authid, searchtxt: search_txt){returnJSON,error in
                       if error != nil{
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message: "Something went wrong")
                       }else{
                          if returnJSON?.error?.status == 1 {
                               Helpers.dismissHUD(view: self.view, isAnimated: true)
                               Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                           }else{
                              Helpers.dismissHUD(view: self.view, isAnimated: true)
                                if(returnJSON?.response!.detail != nil){
                                  self.deals_array = (returnJSON?.response!.detail)!
                                    DispatchQueue.main.async {
                                      self.deals_tableview.reloadData()
                                    }
                                }else{
                                    Helpers.showAlertView(title: "Error", message:"No record found")
                                }
                           }
                       }
                   }
               }else{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
               }
          }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == deals_tableview){
            itemid = deals_array[indexPath.row].item_id!
            self.performSegue(withIdentifier: "dealsdetail", sender: self)
        }else{
            bid = business_array[indexPath.row].business_user_id!
            self.performSegue(withIdentifier: "businessdetail", sender: self)
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
        if(segue.identifier == "businessdetail"){
             let destinationVC = segue.destination as! UINavigationController
             let newVC = destinationVC.viewControllers.first as! BusinessDetailController
             newVC.business_id = bid
         }
    }
    


}
