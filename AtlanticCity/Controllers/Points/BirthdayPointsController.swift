//
//  BirthdayPointsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 30/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import AAPickerView

class BirthdayPointsController: UIViewController {

    @IBOutlet var dob_view: UIView!
    @IBOutlet var dob_txt: AAPickerView!
    
    var points = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        dob_txt.pickerType = .date
        dob_txt.datePicker?.datePickerMode = .date
        dob_txt.datePicker?.setDate(Date.init("2002-01-01"), animated: true)
        dob_txt.datePicker?.setLimit(forCalendarComponent: .year, minimumUnit: 0, maximumUnit: 100)
        //dob_txt.dateFormatter.dateFormat = "MM/dd/YYYY"
        
        
        //dob_txt.dateFormatter.date(from: "01/01/2002")

        dob_txt.valueDidSelected = { date in
            print("selectedDate ", date as! Date )
        }
        
        dob_txt.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let image = UIImage(named: "calendar_icon_30x30")
        imageView.image = image
        dob_txt.rightView = imageView
        
//        let dobtap = UITapGestureRecognizer(target: self, action: #selector(self.dob_tap(_:)))
//        dob_view.addGestureRecognizer(dobtap)
        
    }
    
//    @objc func dob_tap(_ sender: UITapGestureRecognizer){
//        print("Calendar Image tapped")
//      datePickerTapped()
//    }
//    func datePickerTapped() {
//        let currentDate = Date()
//        var dateComponents = DateComponents()
//        dateComponents.month = -3
//        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
//
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if(segue.identifier == "congrats"){
          let destinationVC = segue.destination as! UINavigationController
          let newVC = destinationVC.viewControllers.first as! RegisterPointsController
          newVC.points = points
          newVC.formessage = "birthday"
       }
    }
    @IBAction func save_listener(_ sender: UIButton) {
        performPointsBirthday(dob: self.dob_txt.text!)
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        let zipcodeskip = Helpers.readPreference(key: "zipcodeskip", defualt: "0")
        if(zipcodeskip == "1"){
            self.dismiss(animated: true, completion: nil)
        }
        Helpers.writePreference(key: "zipcodeskip", data: "1")
        Helpers.writePreference(key: "dobskip", data: "1")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabs") as! TabsController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func skip_btn_listener(_ sender: UIButton) {
        Helpers.writePreference(key: "zipcodeskip", data: "1")
        Helpers.writePreference(key: "dobskip", data: "1")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabs") as! TabsController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    func performPointsBirthday(dob:String){
           if(Connectivity.isConnectedToInternet()){
               Helpers.showHUD(view: self.view, progressLabel: "Loading...")
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            PointsRequest.addBirthdayPoints(authid: authid, userid: userid, dateofbirth: dob){returnJSON,error in
                   if error != nil{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:"Date of bith already exists")
                       }else{
                          Helpers.dismissHUD(view: self.view, isAnimated: true)
                          self.points = (returnJSON?.response!.detail)!
                          Helpers.writePreference(key: "dateofbirth", data: "1")
                          Helpers.writePreference(key: "dobadded", data: "1")
                          self.performSegue(withIdentifier: "congrats", sender: self)
                       }
                   }
               }
           }else{
               Helpers.dismissHUD(view: self.view, isAnimated: true)
               Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
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

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}
extension UIDatePicker {

    func setLimit(forCalendarComponent component:Calendar.Component, minimumUnit min: Int, maximumUnit max: Int) {

        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)

        guard let timeZone = TimeZone(identifier: "UTC") else { return }
        calendar.timeZone = timeZone

        var components: DateComponents = DateComponents()
        components.calendar = calendar

        components.setValue(-min, for: component)
        if let maxDate: Date = calendar.date(byAdding: components, to: currentDate) {
            self.maximumDate = maxDate
        }

        components.setValue(-max, for: component)
        if let minDate: Date = calendar.date(byAdding: components, to: currentDate) {
            self.minimumDate = minDate
        }
    }

}
