//
//  QrCodeController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import MercariQRScanner

class QrCodeController: UIViewController {

    @IBOutlet var qrscan_view: UIView!
    var qrScannerView = QRScannerView()
    var business_id = ""
    var deal_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        qrScannerView.stopRunning()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func qrCodeScanRequest(qrscan:String){
      if(Connectivity.isConnectedToInternet()){
          Helpers.showHUD(view: self.view, progressLabel: "Loading...")
          let userid = Helpers.readPreference(key: "user_id", defualt: "0")
          let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
        QrCodeRequest.scanQrCode(user_id: userid, auth_id: authid, deals_id: deal_id, business_id: business_id, qrcode_id: qrscan){returnJSON,error in
              if error != nil{
                  self.qrScannerView.rescan()
                  Helpers.dismissHUD(view: self.view, isAnimated: true)
                  Helpers.showAlertView(title: "Error", message: "Something went wrong")
              }else{
                 if returnJSON?.error?.status == 1 {
                      self.qrScannerView.rescan()
                      Helpers.dismissHUD(view: self.view, isAnimated: true)
                      //Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                      print((returnJSON!.error?.message)!)
                      self.performSegue(withIdentifier: "qrerror", sender: self)
                  }else{
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       self.performSegue(withIdentifier: "scanned", sender: self)
                  }
              }
          }
      }else{
          Helpers.dismissHUD(view: self.view, isAnimated: true)
          Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
      }
    }
    override func viewWillAppear(_ animated: Bool) {
        Helpers.showHUD(view: self.view, progressLabel: "Please wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.qrScannerView = QRScannerView(frame: self.qrscan_view.bounds)
            self.qrscan_view.addSubview(self.qrScannerView)
            self.qrScannerView.configure(delegate: self)
            self.qrScannerView.startRunning()
            Helpers.dismissHUD(view: self.view, isAnimated: true)
        })
    }
}
extension QrCodeController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
        //self.performSegue(withIdentifier: "qrerror", sender: self)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        qrCodeScanRequest(qrscan: code)
    }
    
}
