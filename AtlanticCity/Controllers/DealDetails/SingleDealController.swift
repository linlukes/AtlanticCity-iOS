//
//  SingleDealController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 11/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import SideMenu

class SingleDealController: UIViewController {

    @IBOutlet var fvbtn: UIButton!
    @IBOutlet var deal_main_img: UIImageView!
    @IBOutlet var deal_img: UIImageView!
    @IBOutlet var deal_name: UILabel!
    @IBOutlet var deal_address: UILabel!
    @IBOutlet var deal_description: UILabel!
    @IBOutlet var noofviews: UILabel!
    @IBOutlet var description_lbl: UILabel!
    
    var dealid = ""
    var item_id = ""
    var deal_info = SingleDealDetail()
    override func viewWillAppear(_ animated: Bool) {
        getSingleDeal(item_id: item_id)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //getSingleDeal(item_id: item_id)
        // Do any additional setup after loading the view.
        if(deal_info.is_favorited_count != nil){
            if(deal_info.is_favorited_count!){
                fvbtn.setImage(UIImage(named: "heart_red_2"), for: .normal)
            }
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
    @IBAction func three_dot_listener(_ sender: UIBarButtonItem) {
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
    }
    @IBAction func get_this_deal_listener(_ sender: UIButton) {
        dealid  = item_id
        self.performSegue(withIdentifier: "dealsdetail", sender: self)
    }
    
    @IBAction func share_btn_listener(_ sender: UIButton) {
        if let name = URL(string: "https://itunes.apple.com/us/app/myapp/com.hixol.atalanticcity?ls=1&mt=8"), !name.absoluteString.isEmpty {
               let objectsToShare = [name]
               let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

               self.present(activityVC, animated: true, completion: nil)
           }else  {
               // show alert for not available
           }
    }
    
    @IBAction func heart_listener(_ sender: UIButton) {
        doFavDeal(item_id: item_id, button: sender)
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func getSingleDeal(item_id:String){
        if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            SingleDealRequest.getSingleDeal(user_id: userid, auth_id: authid, item_id: item_id){returnJSON,error in
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
                           self.deal_info = (returnJSON?.response!.detail)!
                           self.setData()
                        }else{
                            Helpers.showSuccessView(title: "Success", message: (returnJSON?.response?.message)!)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }else{
            Helpers.dismissHUD(view: self.view, isAnimated: true)
            Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
    }
    func setData(){
        deal_name.text = deal_info.business?.business_name
        let original = deal_info.avatar!
       if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
         let url = URL(string: encoded)
       {
         let imageView = UIImageView()
         imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
           DispatchQueue.main.async {
             if(downloadImage != nil){
               self.deal_main_img.image = downloadImage!
             }
           }
         })
       }
       let logolink = deal_info.business?.logo!
          if let encoded = logolink!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
          let url = URL(string: encoded)
        {
          let imageView = UIImageView()
          imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            DispatchQueue.main.async {
                if(downloadImage != nil){
                    self.deal_img.image = downloadImage!
                }
            }
          })
        }
        self.deal_address.text = (self.deal_info.business?.address)!
//        +","+(self.deal_info.business?.city)!
        self.deal_description.text = self.deal_info.title
        self.description_lbl.text = self.deal_info.description
        if(deal_info.is_favorited_count != nil){
           if(deal_info.is_favorited_count!){
               fvbtn.setImage(UIImage(named: "heart_red_2"), for: .normal)
           }else{
               fvbtn.setImage(UIImage(named: "heart_gray"), for: .normal)
           }
        }
        if(deal_info.deal_views_count != nil){
            noofviews.text = String(deal_info.deal_views_count!)+" \nViews"
        }else{
            noofviews.text = "0 \nViews"
        }
    }
    func doFavDeal(item_id:String,button:UIButton){
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
                        if(returnJSON?.response?.message == "Successfully deal un-favorited"){
                            button.setImage(UIImage(named: "heart_gray"), for: .normal)
                        }else{
                            button.setImage(UIImage(named: "heart_red_2"), for: .normal)
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
        if(segue.identifier == "dealsdetail"){
            let destinationVC = segue.destination as! UINavigationController
            let newVC = destinationVC.viewControllers.first as! DealsDetailController
            newVC.itemid = item_id
            newVC.dealid = item_id
        }
    }
    

}
