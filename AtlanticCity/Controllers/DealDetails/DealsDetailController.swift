//
//  DealsDetailController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit


class DealsDetailController: UIViewController {

    @IBOutlet var deal_img: UIImageView!
    @IBOutlet var deal_name: UILabel!
    @IBOutlet var deal_location: UILabel!
    @IBOutlet var deal_descrription: UILabel!
    @IBOutlet var deal_expiry_date: UILabel!
    @IBOutlet var minutes_lbl: UILabel!
    @IBOutlet var seconds_lbl: UILabel!
    @IBOutlet var start_btn: UIButton!
    @IBOutlet var deal_scrollview: UIScrollView!
    @IBOutlet var deal_name_lbl: UILabel!
    @IBOutlet var startcount_height: NSLayoutConstraint!
    
    var dealsInfo = DDDetail()
    var itemid = ""
    var dealid = ""
    var timer: Timer?
    var totalTime = 900
    var isTimerStarted = false
    var lat : Double?
    var lng : Double?
    var businessname : String?
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchDealsDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didResignActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        //self.fetchDealsDetails()
        // Do any additional setup after loading the view.
    }
    @objc func willResignActive(_ notification: Notification) {
        self.timer?.invalidate()
    }
    @objc func didResignActive(_ notification: Notification) {
        self.fetchDealsDetails()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "qrcode"){
             let destinationVC = segue.destination as! UINavigationController
             let newVC = destinationVC.viewControllers.first as! QrCodeController
             newVC.business_id = dealsInfo.business!.business_user_id!
             newVC.deal_id = itemid
        }
        if(segue.identifier == "businessmap"){
             let destinationVC = segue.destination as! UINavigationController
             let newVC = destinationVC.viewControllers.first as! BusinessLocController
            newVC.lat = self.lat
            newVC.lng = self.lng
            newVC.businessName = self.businessname!
        }
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func start_countdown_listener(_ sender: UIButton) {
        print("called")
        if(!isTimerStarted && dealsInfo.timer == nil){
            startCountDown()
        }else{
            sender.setTitle("Click here to get your QR", for: .normal)
            self.performSegue(withIdentifier: "qrcode", sender: self)

        }
        
    }
    
    @IBAction func location_listener(_ sender: UITapGestureRecognizer) {
        if(self.lat != nil && self.lng != nil){
            self.performSegue(withIdentifier: "businessmap", sender: self)
        }else{
            Helpers.showToast(view: self.view, msg: "Location not found")
        }
    }
    @IBAction func qr_listener(_ sender: UIButton) {
        if(isTimerStarted){
        }else{
            Helpers.showToast(view: self.view, msg: "Please Start Counter First")
        }
    }
    
    func fetchDealsDetails(){
       if(Connectivity.isConnectedToInternet()){
           Helpers.showHUD(view: self.view, progressLabel: "Loading...")
           let userid = Helpers.readPreference(key: "user_id", defualt: "0")
           let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
        DDRequest.getDealsDetails(user_id: userid, auth_id: authid, item_id: itemid, deals_id: itemid){returnJSON,error in
               if error != nil{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Error", message: "Something went wrong")
               }else{
                  if returnJSON?.error?.status == 1 {
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                   }else{
                        if(returnJSON?.response?.message == "Deal not found"){
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            Helpers.showAlertView(title: "Error", message:(returnJSON?.response?.message)!)
                        }else{
                            self.dealsInfo = (returnJSON?.response!.detail)!
                            self.setData()
                        }
                   }
               }
           }
       }else{
           Helpers.dismissHUD(view: self.view, isAnimated: true)
           Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
       }
    }
    func startCountDown(){
       if(Connectivity.isConnectedToInternet()){
           Helpers.showHUD(view: self.view, progressLabel: "Loading...")
           let userid = Helpers.readPreference(key: "user_id", defualt: "0")
           let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
        CountDownRequest.startCountDown(user_id: userid, auth_id: authid,deals_id: itemid){returnJSON,error in
               if error != nil{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Error", message: "Something went wrong")
               }else{
                  if returnJSON?.error?.status == 1 {
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                   }else{
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        //Helpers.showSuccessView(title: "Success", message:(returnJSON?.response?.message)!)
                        self.start_btn.setTitle("Click here to get your QR", for: .normal)
                    self.start_btn.setTitleColor(Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green)), for: .normal)
                    self.start_btn.backgroundColor = UIColor.white
                        self.startOtpTimer()
                        self.isTimerStarted = true
                   }
               }
           }
       }else{
           Helpers.dismissHUD(view: self.view, isAnimated: true)
           Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
       }
    }
    func setData(){
        let original = dealsInfo.business?.logo
        if let encoded = original!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded)
         {
           let imageView = UIImageView()
           imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
             DispatchQueue.main.async {
                if (downloadImage != nil) {
                    self.deal_img.image = downloadImage!
                }
             }
           })
         }
        deal_name.text = dealsInfo.business?.business_name
        deal_location.text = (dealsInfo.business?.address)!
//        +","+(dealsInfo.business?.city)!
        deal_descrription.text = dealsInfo.description
        deal_name_lbl.text = dealsInfo.title
        self.lat = dealsInfo.business?.lat
        self.lng = dealsInfo.business?.lng
        self.businessname = dealsInfo.business?.business_name
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        if let date = dateFormatterGet.date(from: dealsInfo.deal_expire_at!) {
            print(dateFormatterPrint.string(from: date))
            deal_expiry_date.text = "Valid till "+dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
        }
        
        if(dealsInfo.timer != nil){
            timeFormatted(dealsInfo.timer!)
            start_btn.setTitle("Click here to get your QR", for: .normal)
            start_btn.setTitleColor(Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green)), for: .normal)
            start_btn.backgroundColor = UIColor.white
            totalTime = dealsInfo.timer!
            startOtpTimer()
        }
        Helpers.dismissHUD(view: self.view, isAnimated: true)
        deal_scrollview.isHidden = false
    }
    private func startOtpTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
            print(self.totalTime)
            self.timeFormatted(self.totalTime) // will show timer
            if totalTime != 0 {
                totalTime -= 1  // decrease counter timer
            } else {
                if let timer = self.timer {
                    timer.invalidate()
                    self.timer = nil
                }
            }
        }
    func timeFormatted(_ totalSeconds: Int) {
        if(String(totalSeconds % 60).count == 1){
            let seconds: Int = totalSeconds % 60
            seconds_lbl.text = "0"+String(seconds)
        }else{
            let seconds: Int = totalSeconds % 60
            seconds_lbl.text = String(seconds)
        }
        if(String((totalSeconds / 60) % 60).count == 1){
            let minutes: Int = (totalSeconds / 60) % 60
            minutes_lbl.text = "0"+String(minutes)
        }else{
            let minutes: Int = (totalSeconds / 60) % 60
            minutes_lbl.text = String(minutes)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
  
    
    
}
