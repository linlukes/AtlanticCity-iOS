//
//  PreViewController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 29/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia
import SideMenu

class PreViewController: UIViewController {
  

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet var location_detail_lbl: UILabel!
    @IBOutlet var description_lbl: UILabel!
    @IBOutlet var views_lbl: UILabel!
    @IBOutlet var get_more_details_view: UIView!
    @IBOutlet var fav_btn: UIButton!
    @IBOutlet var noifview: UILabel!
    
    @IBOutlet var ad_view: UIView!
    @IBOutlet var ad_imageview: UIImageView!
    @IBOutlet var ad_title: UILabel!
    @IBOutlet weak var ad_info: UILabel!
    @IBOutlet var view_ad_btn: UIView!
    @IBOutlet var ad_view_count: UILabel!
    
    var pageIndex : Int = 0
    var items: [DealsDetail] = []
    var SPB: SegmentedProgressBar!
    let loader = ImageLoader()
    var itemid = ""
    var addid = ""
    var dealid = ""
    var index = 0
    var url = ""
    
    override func viewWillAppear(_ animated: Bool) {
        print("pv vc called")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2;
        if(items[pageIndex].add_id != nil){
            ad_view.isHidden = false
            ad_title.text = items[pageIndex].title
            ad_info.text = items[pageIndex].description
            ad_view_count.text = String((items[pageIndex].add_views_count)!)+" \nViews"
            if(items[pageIndex].url != nil){
             let original = items[pageIndex].image!
             if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
              let url = URL(string: encoded)
             {
              let imageView = UIImageView()
              imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                DispatchQueue.main.async {
                     if((error) != nil){
                         self.ad_imageview.image =  UIImage(named: "account_btm")
                     }else{
                        if (downloadImage != nil) {
                         self.ad_imageview.image = downloadImage!
                        }
                     }
                }
              })
             }
            }
            
            let adtap = UITapGestureRecognizer(target: self, action: #selector(self.tapOn(_:)))
            view_ad_btn.addGestureRecognizer(adtap)
            
        }else{
            
            if(items[pageIndex].avatar != nil){
                userProfileImage.imageFromServerURL((items[pageIndex].business?.logo!)!)
            }
            print(items)
            print(pageIndex)
            print(items[pageIndex].business?.address)
            lblUserName.text = items[pageIndex].business?.business_name
            location_detail_lbl.text = (items[pageIndex].business?.address)!
//            +","+(items[pageIndex].business?.city)!
            description_lbl.text = items[pageIndex].title
            if(items[pageIndex].is_favorited_count != nil){
                if(items[pageIndex].is_favorited_count!){
                    fav_btn.setImage(UIImage(named: "heart_red"), for: .normal)
                }
            }
            if(items[pageIndex].deal_views_count != nil){
                noifview.text = String(items[pageIndex].deal_views_count!)+" \nViews"
            }else{
                noifview.text = "0 \nViews"
            }
            if(items[pageIndex].avatar != nil){
                let original = items[pageIndex].avatar!
                if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                 let url = URL(string: encoded)
                {
                 let imageView = UIImageView()
                 imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                   DispatchQueue.main.async {
                        if((error) != nil){
                            self.imagePreview.image =  UIImage(named: "account_btm")
                        }else{
                            if (downloadImage != nil) {
                            self.imagePreview.image = downloadImage!
                            }
                        }
                   }
                 })
                }
            }
//            let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
//            tapGestureImage.numberOfTapsRequired = 1
//            tapGestureImage.numberOfTouchesRequired = 1
//            imagePreview.addGestureRecognizer(tapGestureImage)
            let detailtap = UITapGestureRecognizer(target: self, action: #selector(self.detail_tap(_:)))
            get_more_details_view.addGestureRecognizer(detailtap)
        }
        
        if(items[pageIndex].title == "No Name"){
           
            Helpers.showToast(view: self.view, msg: "There is no any deal found")
        }
        // Do any additional setup after loading the view.
    }
    func setUpSideBar(){
          let menu = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
          menu?.presentationStyle = .menuSlideIn
          menu?.menuWidth = 300
          menu?.statusBarEndAlpha = 0
          present(menu!, animated: true, completion: nil)
      }
    @IBAction func three_dot_listener(_ sender: UIButton) {
        let menuAlert = UIAlertController(title: "Menu", message: "Please select one option", preferredStyle: UIAlertController.Style.actionSheet)

        let businessAction = UIAlertAction(title: "Business", style: .default) { (action: UIAlertAction) in
            Helpers.writePreference(key: "isSet", data: "1")
            self.performSegue(withIdentifier: "main", sender: self)
        
        }
        let favAction = UIAlertAction(title: "Favorites", style: .default) { (action: UIAlertAction) in
            self.performSegue(withIdentifier: "fav", sender: self)
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
    
    @IBAction func ad_three_dot_listener(_ sender: UIButton) {
        let menuAlert = UIAlertController(title: "Menu", message: "Please select one option", preferredStyle: UIAlertController.Style.actionSheet)

              let businessAction = UIAlertAction(title: "Businesses", style: .default) { (action: UIAlertAction) in
                  Helpers.writePreference(key: "isSet", data: "1")
                  self.performSegue(withIdentifier: "main", sender: self)
              }
              let favAction = UIAlertAction(title: "Favorites", style: .default) { (action: UIAlertAction) in
                  self.performSegue(withIdentifier: "fav", sender: self)
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
    @objc func detail_tap(_ sender: UITapGestureRecognizer){
        if(items[pageIndex].item_id != nil){
            itemid = items[pageIndex].item_id!
            dealid = items[pageIndex].item_id!
            self.performSegue(withIdentifier: "dealsdetail", sender: self)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)

       }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    override var prefersStatusBarHidden: Bool {
           return true
       }
       
       //MARK: - SegmentedProgressBarDelegate
       //1
       func segmentedProgressBarChangedIndex(index: Int) {
           //playVideoOrLoadImage(index: index)
       }
       
       //2
       func segmentedProgressBarFinished() {
           if pageIndex == 0 {
               self.dismiss(animated: true, completion: nil)
           }
           else {
              // _ = ContentViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
           }
       }
       
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        update_ad_count(add_id: items[pageIndex].add_id!)
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

    @IBAction func heart_btn_listener(_ sender: UIButton) {
        itemid = items[pageIndex].item_id!
        dealid = items[pageIndex].item_id!
        self.doFavDeal(item_id: itemid, button: sender)

    }
    
    @IBAction func ad_heart_btn_listener(_ sender: UIButton) {
        addid = items[pageIndex].add_id!
        self.doFavAd(add_id: addid, button: sender)
        
    }
    @IBAction func ad_share_btn_listener(_ sender: UIButton) {
        if let name = URL(string: items[pageIndex].url!), !name.absoluteString.isEmpty {
             let objectsToShare = [name]
             let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

             self.present(activityVC, animated: true, completion: nil)
         }else  {
             // show alert for not available
         }
    }
    func update_ad_count(add_id:String){
       if(Connectivity.isConnectedToInternet()){
           Helpers.showHUD(view: self.view, progressLabel: "Loading...")
           let userid = Helpers.readPreference(key: "user_id", defualt: "0")
           let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
        AdsRequest.getAdsCount(user_id: userid, auth_id: authid, add_id: add_id){returnJSON,error in
               if error != nil{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Error", message: "Something went wrong")
               }else{
                  if returnJSON?.error?.status == 1 {
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                   }else{
                      Helpers.dismissHUD(view: self.view, isAnimated: true)
                      self.ad_view_count.text = String((returnJSON?.response?.detail?.add_views_count)!)+" \nViews"
                      self.url = self.items[self.pageIndex].url!
                      self.performSegue(withIdentifier: "addetails", sender: self)
                   }
               }
           }
       }else{
           Helpers.dismissHUD(view: self.view, isAnimated: true)
           Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
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
                        if(returnJSON?.response?.message == "Successfully deal un-favorited"){
                            let heartimg = UIImage(named: "story_heart_ico")
                            button.setImage(heartimg, for: .normal)
                        }else{
                            let heartimg = UIImage(named: "heart_red")
                            button.setImage(heartimg, for: .normal)
                        }
                       //Helpers.showSuccessView(title: "Success", message: (returnJSON?.response?.message)!)
                     
                        
                    }
                }
            }
        }else{
            Helpers.dismissHUD(view: self.view, isAnimated: true)
            Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
    }
    
    func doFavAd(add_id:String,button:UIButton){
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
                         if(returnJSON?.response?.message == "Successfully add un-favorited"){
                             let heartimg = UIImage(named: "story_heart_ico")
                             button.setImage(heartimg, for: .normal)
                         }else{
                             let heartimg = UIImage(named: "heart_red")
                             button.setImage(heartimg, for: .normal)
                         }
                        //Helpers.showSuccessView(title: "Success", message: (returnJSON?.response?.message)!)
                      
                         
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
            newVC.itemid = itemid
            newVC.dealid = dealid
        }
        if(segue.identifier == "addetails"){
          let destinationVC = segue.destination as! UINavigationController
          let newVC = destinationVC.viewControllers.first as! AdController
          newVC.url = url
        }
      
    }
    

}
