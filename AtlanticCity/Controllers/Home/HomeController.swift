//
//  HomeController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 30/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import TinderSwipeView
import SideMenu

class HomeController: UIViewController,UITextFieldDelegate {
    
 
    @IBOutlet var business_view: UIView!
    @IBOutlet var business_tableview: UITableView!
    @IBOutlet var search_height: NSLayoutConstraint!
    @IBOutlet var search_txt: UITextField!
    @IBOutlet var search_view: UIView!
    
    static var dealsarray = [DealsDetail]()
    static var adsarray = [AdsDetail]()

    var businessarray = [BusinessDetail]()
    var delegate:isDrawerOpen?
    var points = "0"
    var itemid = ""
    var dealid = ""
    var bid = ""
    var isOpen = false
    var type = ""
    
    override func viewWillAppear(_ animated: Bool) {
        checkForPoints()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setToken()
        business_tableview.delegate = self
        business_tableview.dataSource = self
        search_txt.delegate = self
        let new_entry_status = Helpers.readPreference(key: "new_entry_status", defualt: "0")
        if(new_entry_status != "0"){
            let preftyep = Helpers.readPreference(key: "isSet", defualt: "0")
            if(preftyep == "1"){
               type = "business"
                Helpers.writePreference(key: "isSet", data: "0")
            }
            if(type == ""){
                type = "deals"
               // dtap()
            }
            if(type == "deals"){
                self.fetchDeals()
                //dtap()
            }else{
                //self.fetchBusiness()
                type = "business"
                btap()
            }
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search_txt.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    func performAction(){
        self.performSegue(withIdentifier: "search", sender: self)
    }
    @objc func deals_tap(_ sender: UITapGestureRecognizer){
       dtap()
    }
    func dtap(){
        business_view.isHidden = true
        self.fetchDeals()
        type = "deals"
    }
    @objc func business_tap(_ sender: UITapGestureRecognizer){
        btap()
    }
    func btap(){
        business_view.isHidden = false
        self.fetchBusiness()
        type = "business"
    }
   
   
    
    @objc func card_tap(_ sender: UITapGestureRecognizer){
        if let customView = sender.view as? CustomView, let dealModel = customView.dealsModel{
    //                    itemid = dealModel.item_id!
    //                    dealid = String(dealModel.id!)
    //                    self.performSegue(withIdentifier: "dealsdetail", sender: self)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentView") as! PageViewController
            vc.modalPresentationStyle = .fullScreen
            vc.pages = HomeController.dealsarray
            self.present(vc, animated: true, completion: nil)
       }
     }
  
   
    @IBAction func search_btn_listener(_ sender: UIBarButtonItem) {
        if(!isOpen){
            self.search_height.constant = 60
            self.search_view.alpha = 1
            isOpen = true
        }else{
            self.search_height.constant = 0
            self.search_view.alpha = 0
            isOpen = false
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
                       button.imageView?.image = UIImage(named: "heart_bus_ico")
                        
                    }
                }
            }
        }else{
            Helpers.dismissHUD(view: self.view, isAnimated: true)
            Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
    }
    func setToken(){
        if(Connectivity.isConnectedToInternet()){
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            let fcmtoken = Helpers.readPreference(key: "fcmtoken", defualt: "0")
            SigninRequest.setToken(user_id: userid, auth_id: authid, device_token: fcmtoken){returnJSON,error in
                if error != nil{
                    Helpers.dismissHUD(view: self.view, isAnimated: true)
                    Helpers.showAlertView(title: "Error", message: "Something went wrong")
                }else{
                   if returnJSON?.error?.status == 1 {
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                    }else{
                       //Helpers.showSuccessView(title: "Success", message: (returnJSON?.response?.message)!)
                    }
                }
            }
        }else{
            Helpers.dismissHUD(view: self.view, isAnimated: true)
            Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
    }
    private func attributeStringForModel(dealsModel:DealsDetail) -> NSAttributedString{
        
        let attributedText = NSMutableAttributedString(string: dealsModel.title!, attributes: [.foregroundColor: UIColor.white,.font:UIFont.boldSystemFont(ofSize: 25)])
        return attributedText
    }
    func checkForPoints(){
        let new_entry_status = Helpers.readPreference(key: "new_entry_status", defualt: "0")
        if(new_entry_status == "0"){
            performPointsRegistration()
        }else{

            let zipcodepin = Helpers.readPreference(key: "zipcode", defualt: "0")
            if(zipcodepin == "0"){
                let zipcodeskip = Helpers.readPreference(key: "zipcodeskip", defualt: "0")
                let dobskip = Helpers.readPreference(key: "dobskip", defualt: "0")
                if(zipcodeskip != "1" && dobskip != "1"){
                     self.performSegue(withIdentifier: "zipcode", sender: self)
                    
                }
            }else{
                let dobpin = Helpers.readPreference(key: "dateofbirth", defualt: "0")
                if(dobpin == "0"){
                    let dobskip = Helpers.readPreference(key: "dobskip", defualt: "0")
                    if(dobskip != "1"){
                         self.performSegue(withIdentifier: "birthday", sender: self)
                    }
                }
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
    
    
    @IBAction func back_btn_listener(_ sender: UIButton) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentView") as! PageViewController
        vc.modalPresentationStyle = .fullScreen
        if(SplashController.dealsarray.count == 0){
            vc.pages = HomeController.dealsarray
        }else{
            vc.pages = SplashController.dealsarray
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func hamburger_listener(_ sender: UIButton) {
        delegate?.openDrawer()
    }
    

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if(segue.identifier == "congrats"){
          let destinationVC = segue.destination as! UINavigationController
          let newVC = destinationVC.viewControllers.first as! RegisterPointsController
          newVC.points = points
          newVC.formessage = "registering"
       }
        if(segue.identifier == "dealsdetail"){
          let destinationVC = segue.destination as! UINavigationController
          let newVC = destinationVC.viewControllers.first as! DealsDetailController
            newVC.itemid = itemid
            newVC.dealid = dealid
       }
       if(segue.identifier == "businessdetail"){
            let destinationVC = segue.destination as! UINavigationController
            let newVC = destinationVC.viewControllers.first as! BusinessDetailController
            newVC.business_id = bid
        }
        if(segue.identifier == "search"){
            let destinationVC = segue.destination as! UINavigationController
            let newVC = destinationVC.viewControllers.first as! SearchController
            newVC.search_txt = search_txt.text!
            newVC.type = self.type
            
        }
    }
    func performPointsRegistration(){
        if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            PointsRequest.addRegistrationPoints(authid: authid, userid: userid){returnJSON,error in
                if error != nil{
                    Helpers.dismissHUD(view: self.view, isAnimated: true)
                    Helpers.showAlertView(title: "Error", message: "Something went wrong")
                }else{
                   if returnJSON?.error?.status == 1 {
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                    }else{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       self.points = (returnJSON?.response!.detail)!
                       Helpers.writePreference(key: "new_entry_status", data: "1")
                       
                       self.performSegue(withIdentifier: "congrats", sender: self)
                    }
                }
            }
        }else{
            Helpers.dismissHUD(view: self.view, isAnimated: true)
            Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
        }
   }
    func fetchDeals(){
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            DealsRequest.getDeals(user_id: userid, auth_id: authid){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                          //Helpers.dismissHUD(view: self.view, isAnimated: true)
                            if(returnJSON?.response!.detail != nil){
                               HomeController.dealsarray = (returnJSON?.response!.detail)!
                               DispatchQueue.main.async {
                                   self.fetchSpinnerDetails()
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
    func fetchBusiness(){
             if(Connectivity.isConnectedToInternet()){
                 Helpers.showHUD(view: self.view, progressLabel: "Loading...")
                 let userid = Helpers.readPreference(key: "user_id", defualt: "0")
                 let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
                BusinessRequest.getBusiness(user_id: userid, auth_id: authid){returnJSON,error in
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
                                if((returnJSON?.response!.detail!.count)! > 0){
                                    self.businessarray = (returnJSON?.response!.detail)!
                                    DispatchQueue.main.async {
                                    self.business_tableview.reloadData()
                                    }
                                }else{
                                    Helpers.showSuccessView(title: "Success", message: "No data found")
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

    func fetchSpinnerDetails(){
           if(Connectivity.isConnectedToInternet()){
               //Helpers.showHUD(view: self.view, progressLabel: "Loading...")
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            SpinnerRequest.getSpinnerDetails(user_id: userid, auth_id: authid){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            SpinnerRequest.spinner_array = (returnJSON?.response!.detail)!
                            if(HomeController.dealsarray.count > 0){
                                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentView") as! PageViewController
                                  vc.modalPresentationStyle = .fullScreen
                                  vc.pages = HomeController.dealsarray
                                  self.present(vc, animated: true, completion: nil)
                              }
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
}


extension HomeController:UITableViewDelegate{

}
extension HomeController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessarray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BusinessCell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        
        cell.business_name.text = businessarray[indexPath.row].business_name
        
        let openTime = businessarray[indexPath.row].open_time ?? ""
        let closeTime = businessarray[indexPath.row].close_time ?? ""
        cell.business_hours.text = "Hours: \(String(describing: openTime)) - \(String(describing: closeTime))"
        
        cell.business_address.text = businessarray[indexPath.row].address
        cell.business_desc.text = businessarray[indexPath.row].business_detail
        if(businessarray[indexPath.row].logo != nil){
            let original = businessarray[indexPath.row].logo
           if let encoded = original!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
              let url = URL(string: encoded)
            {
              let imageView = UIImageView()
              imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                DispatchQueue.main.async {
                    if (downloadImage != nil) {
                   cell.business_img.image = downloadImage
                    }
                }
              })
            }
        }else{
            cell.business_img.image = UIImage(named: "account_btm")
        }

        if(businessarray[indexPath.row].deals_count != nil){
            cell.deals_count.text = String(businessarray[indexPath.row].deals_count!)+" Deals"
        }else{
            cell.deals_count.text = "0 Deals"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.bid = businessarray[indexPath.row].business_user_id!
        self.performSegue(withIdentifier: "businessdetail", sender: self)
    }

}


