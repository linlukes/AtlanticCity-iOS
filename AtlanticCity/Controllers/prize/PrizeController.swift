//
//  PrizeController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 12/05/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import CDAlertView
import GoogleMaps
import GooglePlaces
import Alamofire

class PrizeController: UIViewController {
    
    //var placesClient = GMSPlacesClient()

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    @IBOutlet var fname: UITextField!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var address_txt: UITextField!
    @IBOutlet var phoneno: UITextField!
    @IBOutlet var email_txt: UITextField!
    @IBOutlet var address_lbl: UILabel!
    @IBOutlet var location_view: RoundView!
    @IBOutlet var location_view_height: NSLayoutConstraint!
    @IBOutlet var top_location_view_constraint: NSLayoutConstraint!
    var isInviteprize = false
    var address = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOn(_:)))
        location_view.addGestureRecognizer(tap)
        initMaps()
        getProfile()
        // Do any additional setup after loading the view.
    }
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        self.location_view.isHidden = true
        self.location_view_height.constant = 0
        self.top_location_view_constraint.constant = 0
        self.address_txt.text = self.address
        
    }
    @IBAction func skip_btn_listener(_ sender: UIButton) {
        mainPage()
    }
    
    func mainPage(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentView") as! PageViewController
                vc.modalPresentationStyle = .fullScreen
                if(SplashController.dealsarray.count == 0){
                     vc.pages = HomeController.dealsarray
                }else{
                     vc.pages = SplashController.dealsarray
                }               
                self.present(vc, animated: true, completion: nil)
    }
    
    func initMaps(){

        //Maps Initialization
        currentLocation = CLLocation(latitude: 0, longitude: 0)
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        //getCurrentLocation()
    }
    
    func getCurrentLocation(){

         getAddressFromLatLong(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        //getAddressFromLatLong(latitude: 26.414990, longitude: -80.120610)
    }
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(Helpers.shared_maps_key)"

        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case let .success(value):
    print(value)

                let responseJson = value as! NSDictionary

                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                          self.address = (results[0]["formatted_address"] as? String)!
                          self.address_lbl.text = self.address
                        self.location_view.isHidden = false
                        self.location_view_height.constant = 60
//                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
//                            for component in addressComponents {
//                                if let temp = component.object(forKey: "types") as? [String] {
//                                    if (temp[0] == "postal_code") {
//                                        self.pincode = component["long_name"] as? String
//                                    }
//                                    if (temp[0] == "locality") {
//                                        self.city = component["long_name"] as? String
//                                    }
//                                    if (temp[0] == "administrative_area_level_1") {
//                                        self.state = component["long_name"] as? String
//                                    }
//                                    if (temp[0] == "country") {
//                                        self.country = component["long_name"] as? String
//                                    }
//                                }
//                            }
//                        }
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func claim_deal_listener(_ sender: UIButton) {
        submitPrize()
    }
    func getProfile(){
        
        if(Connectivity.isConnectedToInternet()){
            Helpers.showHUD(view: self.view, progressLabel: "Loading...")
            let userid = Helpers.readPreference(key: "user_id", defualt: "0")
            let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            ProfileRequest.getProfile(userid: userid, authid: authid){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            if(returnJSON?.response?.detail?.first_name != "" && returnJSON?.response?.detail?.first_name != nil){
                                self.fname.text = returnJSON?.response?.detail?.first_name
                                //self.fname.isUserInteractionEnabled = false
                            }else{
                                //self.fname.isUserInteractionEnabled = true

                            }
                            if(returnJSON?.response?.detail?.last_name != "" && returnJSON?.response?.detail?.last_name != nil){
                                self.lastname.text = returnJSON?.response?.detail?.last_name
                                //self.lastname.isUserInteractionEnabled = false
                            }
                            if(returnJSON?.response?.detail?.address != ""){
                                self.address_txt.text = returnJSON?.response?.detail?.address
                                //self.address_txt.isUserInteractionEnabled = false
                            }
                            if(returnJSON?.response?.detail?.phoneno != ""){
                                self.phoneno.text = returnJSON?.response?.detail?.phoneno
                                //self.phoneno.isUserInteractionEnabled = false
                            }
                            if(returnJSON?.response?.detail?.email != ""){
                                self.email_txt.text = returnJSON?.response?.detail?.email
                                self.email_txt.isUserInteractionEnabled = false
                            }
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
           }
      }
    func submitPrize(){
        
        if(fname.text == ""){
            Helpers.showAlertView(title: "First Name", message: "Please enter firstname")
            return
        }
        if(lastname.text == ""){
            Helpers.showAlertView(title: "Last name", message: "Please enter lastname")
            return
        }
        if(email_txt.text == ""){
            Helpers.showAlertView(title: "Email", message: "Please enter email")
            return
        }
        if(phoneno.text == ""){
            Helpers.showAlertView(title: "Phone no", message: "Please enter phone")
            return
        }
        if(address_txt.text == ""){
            Helpers.showAlertView(title: "Address", message: "Please enter address")
            return
        }
        if(!validateEmail(enteredEmail: email_txt.text!)){
            Helpers.showAlertView(title: "Email", message: "Your email address is invalid")
            return
        }
        if(isInviteprize){
            if(Connectivity.isConnectedToInternet()){
             Helpers.showHUD(view: self.view, progressLabel: "Loading...")
             let userid = Helpers.readPreference(key: "user_id", defualt: "0")
             let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
             ProfileRequest.addGuru(userid: userid, authid: authid, firstname: fname.text!, lastname: lastname.text!, address: address_txt.text!, email: email_txt.text!, phone: phoneno.text!){returnJSON,error in
                    if error != nil{
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        Helpers.showAlertView(title: "Error", message: "Something went wrong")
                    }else{
                       if returnJSON?.error?.status == 1 {
                            Helpers.dismissHUD(view: self.view, isAnimated: true)
                            Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                        }else{
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           self.showSuccessPopup(msg: "Prize clamied successfully,we will contact you soon.")
                        }
                    }
                }
            }else{
                Helpers.dismissHUD(view: self.view, isAnimated: true)
                Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
            }
        }else{
            if(Connectivity.isConnectedToInternet()){
                Helpers.showHUD(view: self.view, progressLabel: "Loading...")
                let userid = Helpers.readPreference(key: "user_id", defualt: "0")
                let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
                ProfileRequest.updateProfile(userid: userid, authid: authid, firstname: fname.text!, lastname: lastname.text!, address: address_txt.text!, email: email_txt.text!, phone: phoneno.text!){returnJSON,error in
                       if error != nil{
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message: "Something went wrong")
                       }else{
                          if returnJSON?.error?.status == 1 {
                               Helpers.dismissHUD(view: self.view, isAnimated: true)
                               Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                           }else{
                              Helpers.dismissHUD(view: self.view, isAnimated: true)
                              self.showSuccessPopup(msg: "Deal clamied successfully,we will contact you soon.")
                           }
                       }
                   }
               }else{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
               }
        }
      }
    func showSuccessPopup(msg:String){
        let alert = CDAlertView(title: "Success", message: msg, type: .success)
        let doneAction = CDAlertViewAction(title: "OK", handler: { action in
            self.mainPage()
            return true
        })
        alert.add(action: doneAction)
        alert.show()
    }
    //email validator
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    
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
extension PrizeController: CLLocationManagerDelegate {

    //MARK: - Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!

        currentLocation = locations.last!
        getCurrentLocation()
        locationManager.stopUpdatingLocation()
        print("Location: \(location)")

    }

    //MARK: - Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.

        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }

    //MARK: - Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
