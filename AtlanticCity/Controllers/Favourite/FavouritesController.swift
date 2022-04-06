//
//  FavouritesController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 10/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import SideMenu

protocol FavAndUnFavDealsBusiness {
    func makeDeal(id:String)
    func makeBusiness(id:String)
    func makeAds(id:String)
    func showBusiness(name:String)
}

class FavouritesController: UIViewController,FavAndUnFavDealsBusiness,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var deals_btn_view: UIView!
    @IBOutlet var business_btn_view: UIView!
    @IBOutlet var deal_btn_lbl: UILabel!
    @IBOutlet var business_btn_lbl: UILabel!
    @IBOutlet var deals_view: UIView!
    @IBOutlet weak var dealsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var deals_tableview: UITableView!
    @IBOutlet var ads_tableview: UITableView!
    @IBOutlet var ads_mainview: UIView!
    @IBOutlet weak var adsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var business_view: UIView!
    @IBOutlet var business_tableview: UITableView!
    
    var deals_array = [DFavDetail]()
    var business_array = [BFavDetail]()
    var adsarray = [AdsFavDetail]()
    
    var itemid = ""
    var dealid = ""
    var bid = ""
    var url = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
         fetchFavDeals()
         fetchFavBusiness()
         fetchFavAds()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let dealstap = UITapGestureRecognizer(target: self, action: #selector(self.deals_tap(_:)))
        deals_btn_view.addGestureRecognizer(dealstap)
        let businesstap = UITapGestureRecognizer(target: self, action: #selector(self.business_tap(_:)))
        business_btn_view.addGestureRecognizer(businesstap)
        
        business_tableview.delegate = self
        deals_tableview.delegate = self
        business_tableview.dataSource = self
        deals_tableview.dataSource = self
        ads_tableview.delegate = self
        ads_tableview.dataSource = self
        
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deals_tap(_ sender: UITapGestureRecognizer){
        deals_view.isHidden = false
        ads_mainview.isHidden = false
        business_view.isHidden = true
        deals_btn_view.backgroundColor = Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green))
        deal_btn_lbl.textColor = UIColor.white
        business_btn_view.backgroundColor = UIColor.white
        business_btn_lbl.textColor = Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green))
        self.fetchFavDeals()
        self.fetchFavAds()
    }
    @objc func business_tap(_ sender: UITapGestureRecognizer){
        deals_view.isHidden = true
        ads_mainview.isHidden = true
        business_view.isHidden = false
        business_btn_view.backgroundColor = Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green))
        business_btn_lbl.textColor = UIColor.white
        deals_btn_view.backgroundColor = UIColor.white
        deal_btn_lbl.textColor = Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green))
        self.fetchFavBusiness()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == business_tableview){
            return business_array.count
        }else if(tableView == deals_tableview){
            return deals_array.count
        }else{
            return adsarray.count
        }
        return 0
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if(tableView == business_tableview){
          
            let cell:BFavouriteCell = tableView.dequeueReusableCell(withIdentifier: "BFavouriteCell") as! BFavouriteCell
            if(business_array[indexPath.row].businesses != nil){
                cell.delegate = self
                cell.id = business_array[indexPath.row].business_id!
                cell.business_name.text = business_array[indexPath.row].businesses!.business_name
                cell.business_desc.text = business_array[indexPath.row].businesses!.business_detail
                let original = business_array[indexPath.row].businesses!.logo
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
                cell.business_dates.text = business_array[indexPath.row].businesses!.open_time
            }
            return cell
        }else if(tableView == deals_tableview){
            let cell:DFavouritesCell = tableView.dequeueReusableCell(withIdentifier: "DFavouritesCell") as! DFavouritesCell
            if(deals_array[indexPath.row].deals != nil){
                cell.id = deals_array[indexPath.row].deals!.item_id!
                cell.delegate = self
                cell.business_name.text = deals_array[indexPath.row].deals!.title
                cell.business_desc.text = deals_array[indexPath.row].deals!.description
                if(deals_array[indexPath.row].deals!.avatar != nil){
                    let original = deals_array[indexPath.row].deals!.avatar
                    if let encoded = original!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                    let url = URL(string: encoded)
                    {
                    let imageView = UIImageView()
                        imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                          DispatchQueue.main.async {
                            if(downloadImage != nil){
                               cell.business_img.image = downloadImage!
                            }
                          }
                        })
                    }
                }
                cell.business_dates.text = deals_array[indexPath.row].deals!.deal_expire_at
                
            }
            return cell
        }else{
            let cell:AFavouriteCell = tableView.dequeueReusableCell(withIdentifier: "AFavouriteCell") as! AFavouriteCell
            if(adsarray[indexPath.row].adds != nil){
                cell.id = String(adsarray[indexPath.row].adds!.add_id!)
                cell.delegate = self
                cell.business_name.text = adsarray[indexPath.row].adds!.title
                cell.business_desc.text = adsarray[indexPath.row].adds!.description
                if(adsarray[indexPath.row].adds!.image != nil){
                   let original = adsarray[indexPath.row].adds!.image
                   if let encoded = original!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                   let url = URL(string: encoded)
                   {
                   let imageView = UIImageView()
                       imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                         DispatchQueue.main.async {
                            if(downloadImage != nil){
                                cell.business_img.image = downloadImage!
                            }
                         }
                       })
                   }
                }
                cell.business_dates.text = adsarray[indexPath.row].adds?.created_at
            }
            return cell
        }
        
        return cell
     }
    
    func fetchFavDeals(){
        if(Connectivity.isConnectedToInternet()){
           Helpers.showHUD(view: self.view, progressLabel: "Loading...")
           let userid = Helpers.readPreference(key: "user_id", defualt: "0")
           let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
        FavRequest.getFavDeals(user_id: userid, auth_id: authid){returnJSON,error in
               if error != nil{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Error", message: "Something went wrong")
               }else{
                  if returnJSON?.error?.status == 1 {
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                   }else{
                    if(returnJSON?.response!.detail != nil){
                     self.deals_array = (returnJSON?.response!.detail)!
                        DispatchQueue.main.async {
                            self.setDealsViewHeight()
                            self.deals_tableview.reloadData()
                        }
                    }else{
                        Helpers.showSuccessView(title: "Success", message: "No data found")
                    }
                   }
               }
           }
        }else{
           Helpers.dismissHUD(view: self.view, isAnimated: true)
           Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
    }
    func fetchFavAds(){
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            FavRequest.getFavAds(user_id: userid, auth_id: authid){returnJSON,error in
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
                            self.adsarray = returnJSON?.response!.detail as! [AdsFavDetail]
                            
                            DispatchQueue.main.async {
                                self.setAdsViewHeight()
                                self.setDealsViewHeight()
                                self.deals_tableview.reloadData()
                                self.ads_tableview.reloadData()
                            }
                        }else{
                            Helpers.showSuccessView(title: "Success", message: "No data found")
                        }
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    func fetchFavBusiness(){
         if(Connectivity.isConnectedToInternet()){
             Helpers.showHUD(view: self.view, progressLabel: "Loading...")
             let userid = Helpers.readPreference(key: "user_id", defualt: "0")
             let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            FavRequest.getFavBusiness(user_id: userid, auth_id: authid){returnJSON,error in
                 if error != nil{
                     Helpers.dismissHUD(view: self.view, isAnimated: true)
                     Helpers.showAlertView(title: "Error", message: "Something went wrong")
                 }else{
                    if returnJSON?.error?.status == 1 {
                         Helpers.dismissHUD(view: self.view, isAnimated: true)
                         Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                     }else{
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        self.business_array = (returnJSON?.response!.detail)!
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
    
    func setDealsViewHeight() {
        dealsViewHeightConstraint.constant = deals_tableview.rowHeight * CGFloat(deals_array.count)
    }
    
    func setAdsViewHeight() {
        adsViewHeightConstraint.constant = ads_tableview.rowHeight * CGFloat(adsarray.count)
    }
    
    func makeDeal(id: String) {
        doFavDeal(item_id: id)
    }
    
    func doFavDeal(item_id:String){
        if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            FavRequest.doFavDeal(user_id: userid, auth_id: authid, deals_id: item_id, item_id: item_id){returnJSON,error in
                if error != nil{
                    Helpers.dismissHUD(view: self.view, isAnimated: true)
                    Helpers.showAlertView(title: "Error", message: "Something went wrong")
                }else{
                   if returnJSON?.error?.status == 1 {
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                    }else{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       //Helpers.showSuccessView(title: "Success", message: (returnJSON?.response?.message)!)
                       self.fetchFavDeals()
                    }
                }
            }
        }else{
            Helpers.dismissHUD(view: self.view, isAnimated: true)
            Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
    }
    func makeBusiness(id: String) {
        print(id)
        self.doFavBusiness(businessid: id)
    }
    func showBusiness(name:String){
        Helpers.showToast(view: self.view, msg: name)
    }
    func doFavBusiness(businessid:String){
        if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            FavRequest.doFavBusiness(user_id: userid, auth_id: authid, business_id: businessid){returnJSON,error in
                if error != nil{
                    Helpers.dismissHUD(view: self.view, isAnimated: true)
                    Helpers.showAlertView(title: "Error", message: "Something went wrong")
                }else{
                   if returnJSON?.error?.status == 1 {
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                    }else{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       //Helpers.showSuccessView(title: "Success", message: (returnJSON?.response?.message)!)
                       self.business_array.removeAll()
                       self.business_tableview.reloadData()
                       self.fetchFavBusiness()
                    }
                }
            }
        }else{
            Helpers.dismissHUD(view: self.view, isAnimated: true)
            Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
    }
    func makeAds(id: String) {
        doFavAd(add_id: id)
    }
    
    func doFavAd(add_id:String){
         if(Connectivity.isConnectedToInternet()){
             Helpers.showHUD(view: self.view, progressLabel: "Loading...")
             let userid = Helpers.readPreference(key: "user_id", defualt: "0")
             let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            FavRequest.doFavAd(user_id: userid, auth_id: authid, add_id: add_id){returnJSON,error in
                 if error != nil{
                     Helpers.dismissHUD(view: self.view, isAnimated: true)
                     Helpers.showAlertView(title: "Error", message: "Something went wrong")
                 }else{
                    if returnJSON?.error?.status == 1 {
                         Helpers.dismissHUD(view: self.view, isAnimated: true)
                         Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                     }else{
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        self.adsarray.removeAll()
                        self.fetchFavAds()
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
            if(deals_array[indexPath.row].deals != nil){
                itemid = deals_array[indexPath.row].deals!.item_id!
                self.performSegue(withIdentifier: "dealsdetail", sender: self)
            }
        }else if(tableView == business_tableview){
            bid = business_array[indexPath.row].businesses!.business_user_id!
            self.performSegue(withIdentifier: "businessdetail", sender: self)
        }else if(tableView ==  ads_tableview){
            self.url = (adsarray[indexPath.row].adds?.url)!
            self.performSegue(withIdentifier: "adview", sender: self)
        }
        print("called")
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
        if(segue.identifier == "adview"){
          let destinationVC = segue.destination as! UINavigationController
          let newVC = destinationVC.viewControllers.first as! AdController
          newVC.url = url
        }
    }

}
