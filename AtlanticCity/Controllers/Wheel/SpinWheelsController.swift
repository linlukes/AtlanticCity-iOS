//
//  SpinWheelsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 30/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import TTFortuneWheel
import Alamofire

class SpinWheelsController: UIViewController {

    @IBOutlet var spinnerview: TTFortuneWheel!
    @IBOutlet var spin_info_lbl: UILabel!
    
    var spinner_array = [SpinnerDetail]()
    var slices = [CarnivalWheelSlice]()
    var index_spinner = [Int]()
    var index_prize = [SpinnerIndex]()
    var total_points = ""
    var deduct_points  = ""
    var id = 0
    var isRun = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spin_info_lbl.isHidden = true
        setUpSpinWheels()
        fetchPointsDetails()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       if(id == 0){
           self.navigationItem.leftBarButtonItem = nil
       }
    }
    
    func setUpSpinWheels(){
        var index = 2
        for detail in SpinnerRequest.spinner_array{
            print(detail.prize_title!)
            slices.append(CarnivalWheelSlice.init(title: detail.prize_title!,sectitle: detail.prize!))
            if(detail.activestatus == 1 && index != 6 && index != 7){
                index_spinner.append(index)
                index_prize.append(SpinnerIndex(index: index, prize: detail.prize_title!))
            }else{
                if(detail.activestatus == 1 && index != 0){
                     index_spinner.append(0)
                     index_prize.append(SpinnerIndex(index: 0, prize: detail.prize_title!))
                }
                if(detail.activestatus == 1 && index != 1){
                     index_spinner.append(1)
                     index_prize.append(SpinnerIndex(index: 1, prize: detail.prize_title!))
                }
            }
            index = index + 1;
        }
        
        spinnerview.slices = slices
        spinnerview.equalSlices = true
        spinnerview.frameStroke.width = 0
        spinnerview.titleRotation = 80.0
//        spinnerview.secTitleRotation = 270.0
        
        spinnerview.slices.enumerated().forEach { (pair) in
            let slice = pair.element as! CarnivalWheelSlice
            let offset = pair.offset
            switch offset % 4 {
            case 0: slice.style = .brickRed
            case 1: slice.style = .sandYellow
            case 2: slice.style = .babyBlue
            case 3: slice.style = .deepBlue
            default: slice.style = .brickRed
            }
        }
        
        let rotationDegrees =  180.0
        let rotationAngle = CGFloat(rotationDegrees * .pi / 180.0)
        spinnerview.transform = CGAffineTransform(rotationAngle: rotationAngle)

    }
   
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        if(isRun){
            Helpers.showToast(view: self.view, msg: "Please wait for spinner result")
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func spin_btn_listener(_ sender: UIButton) {
        if(Int(self.total_points)! > 0){
            spinnerview.startAnimating()
            isRun = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    let rand = self.index_spinner.randomElement()!
                    print(rand)
                    var spinner = ""
                    self.spinnerview.startAnimating(fininshIndex: rand) { (finished) in
                    print(finished)
                    var index = 0
                    for detail in SpinnerRequest.spinner_array{
                        for data in self.index_prize{
                            if(detail.prize_title == data.prize && rand == data.index){
                                spinner = SpinnerRequest.spinner_array[index].spinner_id!
                                break
                            }
                        }
                    index = index + 1
                    }
                    self.isRun = false
                    self.submitPrize(spinner_id: spinner)
                }
            }
        }else{
            Helpers.showAlertView(title: "Error", message: "You don't have enough points to spin wheel!")
        }
    }
    func fetchPointsDetails(){
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            PDRequest.getPointsDetails(user_id: userid, auth_id: authid){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            self.spin_info_lbl.isHidden = false
                            self.total_points = String((returnJSON?.response?.detail!.earned_points)!)
                            self.deduct_points = (returnJSON?.response?.detail!.spinner_points)!
                            let infostr = "You have "+self.total_points+" points to spin and win"
                            self.changeText(label: self.spin_info_lbl, text: infostr)
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    func submitPrize(spinner_id:String){
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            CollectPrizeRequest.submitPrize(user_id: userid, auth_id: authid, spinner_id: spinner_id){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            Helpers.showSuccessView(title: "success", message: (returnJSON?.response!.message)!)
                            self.performSegue(withIdentifier: "prize", sender: self)
                            self.fetchPointsDetails()
                            
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    func changeText(label:UILabel,text:String){
        let numbers = ["0","1","2","3","4","5","6","7","8","9"]
        let myAttributedString = NSMutableAttributedString(string: text)
           var locations: [Int] = []
           let characters = Array(text)
           var i = 0
           for letter in characters {
               i = i + 1
               letter.debugDescription
               if numbers.contains(String(letter)) {
                   locations.append(i)
               }
           }

           for item in locations {
               print(item)
               let myRange = NSRange(location: item - 1, length: 1)
            myAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: myRange)
           }
           label.attributedText = myAttributedString
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
