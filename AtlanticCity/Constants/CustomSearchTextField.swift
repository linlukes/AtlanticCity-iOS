//
//  CustomSearchTextField.swift
//  SdTransferts
//
//  Created by Hamza Arif on 22/10/2019.
//  Copyright © 2019 Hixol. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps


class CustomSearchTextField: UITextField{
    
    
    
    var resultsList = [String]()
    var tableView: UITableView?
    var databasePath :String = ""
    var currentLocation: CLLocation?
    var location_history = [PlacesModel]()
    var locationManager = CLLocationManager()
    var placesClient = GMSPlacesClient()
    var placesList = [PlacesModel]()
    var start_latlong = CLLocationCoordinate2D()
    var dest_latlong = CLLocationCoordinate2D()
    let token = GMSAutocompleteSessionToken.init()
    // Create a type filter.
    let gfilter = GMSAutocompleteFilter()
    var locationDetail = GMSAddress()
    var home : HomeController?
    var isDest = false
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
          UInt(GMSPlaceField.placeID.rawValue)|UInt(GMSPlaceField.coordinate.rawValue)|UInt(GMSPlaceField.formattedAddress.rawValue))!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
        
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
        initMaps()
    }
    
    
    @objc open func textFieldDidChange(){
        print("Text changed ...")
        filter()
        self.updateSearchTableView()
        
    }
    
    @objc open func textFieldDidBeginEditing() {
        print("Begin Editing")
    }
    
    @objc open func textFieldDidEndEditing() {
        print("End editing")

    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        print("End on Exit")
    }
    
    
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    // MARK: Filtering methods
    
    fileprivate func filter() {
        //getAutoCompletePlaces(searchtxt: text!)
        Network.GoogleAPI.Map.autocomplete(request: text!,current_loc: currentLocation!,kilometers: 10) {
            returnJSON in
            
            self.resultsList.removeAll()
            self.resultsList  = returnJSON!
            self.updateSearchTableView()
            self.tableView?.isHidden = false
        }
       
    }
    func initMaps(){
        
        //Maps Initialization
        currentLocation = CLLocation(latitude: 0, longitude: 0)
        
        //getAddressFromLatLong(latitude: 26.414990, longitude: -80.120610)

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
       
       
    }
   


    override func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }
}
//MARK: - Extention Map
extension CustomSearchTextField: CLLocationManagerDelegate {
    
    //MARK: - Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        currentLocation = locations.last!
       

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
extension CustomSearchTextField: UITableViewDelegate, UITableViewDataSource {
    

    // MARK: TableView creation and updating
    
    // Create SearchTableview
    func buildSearchTableView() {

        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)

        } else {
            //addData()
            print("tableView created")
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    
    // Updating SearchtableView
    func updateSearchTableView() {
        if(resultsList.count == 0){
            let screenSize = UIScreen.main.bounds
            let screenwidth = screenSize.width
            let newsize = (screenwidth - frame.size.width) / 2
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width + (newsize/10), height: 0)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 0
            tableViewFrame.origin.y += frame.size.height + 8
            
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            return
        }
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            let screenSize = UIScreen.main.bounds
            let screenwidth = screenSize.width
            let newsize = (screenwidth - frame.size.width) / 2
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width + (newsize/10), height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 0
            tableViewFrame.origin.y += frame.size.height + 8
            
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.layer.borderColor = Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.black)).cgColor
            tableView.layer.borderWidth = 1.0
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(1)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: TableViewDataSource methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Result Count:"+String(resultsList.count))
        return resultsList.count
    }
    
    // MARK: TableViewDelegate methods
    
    //Adding rows in the tableview with the data from dataList

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        if(resultsList.count != 0){
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = resultsList[indexPath.row]
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
        if(resultsList.count != 0){
          self.text = resultsList[indexPath.row]
        }
//        self.insertItems(iid: resultsList[indexPath.row].id, med: resultsList[indexPath.row].name)
        tableView.isHidden = true
        //self.viewContainingController()?.performSegue(withIdentifier: "med", sender: self)
        self.endEditing(true)
    }
    
    
       @IBInspectable var placeHolderColor: UIColor? {
          get {
              return self.placeHolderColor
          }
          set {
              self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
          }
       }
  
     

}
