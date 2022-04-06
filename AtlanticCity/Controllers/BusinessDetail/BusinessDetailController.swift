//
//  BusinessDetailController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 02/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import MapKit
import MTSlideToOpen
import SideMenu

class BusinessDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MTSlideToOpenDelegate {
    
    @IBOutlet var business_img: UIImageView!
    @IBOutlet var address_lbl: UILabel!
    @IBOutlet var country_lbl: UILabel!
    @IBOutlet var schdule_lbl: UILabel!
    @IBOutlet var status_lbl: UILabel!
    @IBOutlet var call_view: UIView!
    @IBOutlet var locaiton_view: UIView!
    @IBOutlet var fav_view: UIView!
    @IBOutlet var share_view: UIView!
    @IBOutlet weak var dealsLbl: UILabel!
    @IBOutlet var deals_tableview: UITableView!
    @IBOutlet var slide_icon: UIImageView!
    @IBOutlet var slide_view: UIView!
    @IBOutlet var favimageview: UIImageView!
    @IBOutlet var parent_view: UIView!
    
    @IBOutlet var points_detail_lbl: UILabel!
    
    @IBOutlet var hotel_view: UIView!
    @IBOutlet var show_views: UIView!
    @IBOutlet var wheel_view: UIView!
    @IBOutlet var invite_view: UIView!
    @IBOutlet var home_view: UIView!
    @IBOutlet weak var three_dot_btn: UIBarButtonItem!
    @IBOutlet var content_view: UIView!
    @IBOutlet weak var noDealLbl: UILabel!
    
    var itemid = ""

    var storedOffsets = [Int: CGFloat]()
    var business_id = ""
    var deals_array = [BDDeals]()
    var business_info = BDDetail()
    
    lazy var customizeSlideToOpen: MTSlideToOpenView = {
        let slide = MTSlideToOpenView(frame: CGRect(x: 30, y: self.slide_view.frame.height-self.parent_view.frame.height+self.slide_view.frame.height-30, width: self.parent_view.frame.width-100, height: 56))
         slide.sliderViewTopDistance = 0
         slide.thumbnailViewTopDistance = 4;
         slide.thumbnailViewStartingDistance = 4;
         slide.sliderCornerRadius = 28
         slide.thumnailImageView.backgroundColor = .white
         slide.draggedView.backgroundColor = .clear
         slide.delegate = self
         slide.textColor = .clear
         slide.thumnailImageView.image = UIImage(named: "swipe_spinwheel_ico")
         slide.sliderBackgroundColor = .clear
         return slide
     }()
     
    override func viewWillAppear(_ animated: Bool) {
        getBusinessDetail()
        fetchPointsDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deals_tableview.delegate = self
        deals_tableview.dataSource = self
        
        let calltap = UITapGestureRecognizer(target: self, action: #selector(self.call_tap(_:)))
        call_view.addGestureRecognizer(calltap)
        let loctap = UITapGestureRecognizer(target: self, action: #selector(self.loc_tap(_:)))
        locaiton_view.addGestureRecognizer(loctap)
        let heartap = UITapGestureRecognizer(target: self, action: #selector(self.heart_tap(_:)))
        fav_view.addGestureRecognizer(heartap)
        let sharetap = UITapGestureRecognizer(target: self, action: #selector(self.share_tap(_:)))
        share_view.addGestureRecognizer(sharetap)
        let hometap = UITapGestureRecognizer(target: self, action: #selector(self.home(_:)))
        home_view.addGestureRecognizer(hometap)
        self.slide_view.addSubview(customizeSlideToOpen)

        
        let hoteltap = UITapGestureRecognizer(target: self, action: #selector(self.hotel(_:)))
        hotel_view.addGestureRecognizer(hoteltap)

        let showtap = UITapGestureRecognizer(target: self, action: #selector(self.shows(_:)))
        show_views.addGestureRecognizer(showtap)

        let spintap = UITapGestureRecognizer(target: self, action: #selector(self.spin(_:)))
        wheel_view.addGestureRecognizer(spintap)

        let invitetap = UITapGestureRecognizer(target: self, action: #selector(self.invite(_:)))
        invite_view.addGestureRecognizer(invitetap)
        
    }
    
    @objc func home(_ sender: UITapGestureRecognizer){
         if(HomeController.dealsarray.count != 0 || SplashController.dealsarray.count != 0){
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentView") as! PageViewController
           vc.modalPresentationStyle = .fullScreen
           if(SplashController.dealsarray.count == 0){
                vc.pages = HomeController.dealsarray
           }else{
                vc.pages = SplashController.dealsarray
           }          
           self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func hotel(_ sender: UITapGestureRecognizer){
       //self.performSegue(withIdentifier: "hotel", sender: self)
       if let url = URL(string: "https://secure.rezserver.com/cities/4453-800049132?cname=secure.atlanticcity.com") {
           UIApplication.shared.open(url)
       }
    }
    @objc func shows(_ sender: UITapGestureRecognizer){
       if let url = URL(string: "http://www.atlanticcity.com/atlantic-city-shows") {
          UIApplication.shared.open(url)
       }
       //self.performSegue(withIdentifier: "show", sender: self)
    }
    @objc func spin(_ sender: UITapGestureRecognizer){
       self.performSegue(withIdentifier: "spin", sender: self)
    }
    @objc func invite(_ sender: UITapGestureRecognizer){
       self.performSegue(withIdentifier: "invite", sender: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        //slide_icon.center = CGPoint(x: 60, y: slide_icon.center.y)

    }
    @objc func call_tap(_ sender: UITapGestureRecognizer){
        guard let number = URL(string: "tel://" + business_info.phone_number!) else { return }
        UIApplication.shared.open(number)
    }
    @objc func loc_tap(_ sender: UITapGestureRecognizer){
        coordinates(forAddress: business_info.address!) {
            (location) in
            guard let location = location else {
                // Handle error here.
                return
            }
            self.openMapForPlace(lat: location.latitude, long: location.longitude)
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
    @IBAction func three_dot_listener(_ sender: UIBarButtonItem) {
        
        let menuAlert = UIAlertController(title: "Menu", message: "Please select one option", preferredStyle: UIAlertController.Style.actionSheet)

        let businessAction = UIAlertAction(title: "Businesses", style: .default) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
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
    
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        sender.resetStateWithAnimation(false)
        self.performSegue(withIdentifier: "spinner", sender: self)
     }
    public func openMapForPlace(lat:Double = 0, long:Double = 0, placeName:String = "") {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long

        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    @objc func heart_tap(_ sender: UITapGestureRecognizer){
        self.doFavBusiness(businessid: business_id)
    }
    @objc func share_tap(_ sender: UITapGestureRecognizer){
        if let name = URL(string: "https://itunes.apple.com/us/app/myapp/com.hixol.atalanticcity?ls=1&mt=8"), !name.absoluteString.isEmpty {
           let objectsToShare = [name]
           let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

           self.present(activityVC, animated: true, completion: nil)
        }else  {
           // show alert for not available
        }
    }
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getBusinessDetail(){
         if(Connectivity.isConnectedToInternet()){
             Helpers.showHUD(view: self.view, progressLabel: "Loading...")
             let userid = Helpers.readPreference(key: "user_id", defualt: "0")
             let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            BDRequest.getBusinessDetail(user_id: userid, auth_id: authid, business_id: business_id){returnJSON,error in
                 if error != nil{
                     Helpers.dismissHUD(view: self.view, isAnimated: true)
                     Helpers.showAlertView(title: "Error", message: "Something went wrong")
                 }else{
                    if returnJSON?.error?.status == 1 {
                         Helpers.dismissHUD(view: self.view, isAnimated: true)
                         Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                     }else{
                        Helpers.dismissHUD(view: self.view, isAnimated: true)
                        self.deals_array = (returnJSON?.response?.detail?[0].deals)!
                        self.business_info = (returnJSON?.response?.detail?[0])!
                        self.setData()
                     }
                 }
             }
         }else{
             Helpers.dismissHUD(view: self.view, isAnimated: true)
             Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
         }
       }
    func setData(){
        
        if deals_array.count == 0 {
            dealsLbl.isHidden = true
            deals_tableview.heightAnchor.constraint(equalToConstant: 0.0).isActive = true
            noDealLbl.isHidden = false
        }
        
        self.title = business_info.business_name
        self.address_lbl.text = business_info.address!
        self.country_lbl.text = "\(String(describing: business_info.city ?? "")), \(String(describing: business_info.state ?? "")),\(String(describing: business_info.zipcode ?? ""))"
        self.status_lbl.text = "Hours"
        
        self.schdule_lbl.text = "\(String(describing: business_info.open_time ?? "")) - \(String(describing: business_info.close_time ?? ""))"
        
        let original = business_info.logo
        if let encoded = original!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded)
        {
           let imageView = UIImageView()
           imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_bm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
              if(error != nil){
                self.business_img.image = UIImage(named: "account_bm")
              }else{
                  self.business_img.image = downloadImage!
              }
           })
        }
        if(business_info.is_favorited_count != nil){
          if(business_info.is_favorited_count!){
              self.favimageview.image = UIImage(named: "heart_red_2")
          }else{
              self.favimageview.image = UIImage(named: "heart_bus_ico")
          }
        }
        deals_tableview.reloadData()
        content_view.isHidden = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopCatCell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? TopCatCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: 0)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       guard let tableViewCell = cell as? TopCatCell else { return }
       storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
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
                        if(returnJSON?.response?.message == "Business un-favorited"){
                          self.favimageview.image = UIImage(named: "heart_bus_ico")
                        }else{
                          self.favimageview.image = UIImage(named: "heart_red_2")
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          // Get the new view controller using segue.destination.
          // Pass the selected object to the new view controller.
           if(segue.identifier == "dealsdetail"){
             let destinationVC = segue.destination as! UINavigationController
             let newVC = destinationVC.viewControllers.first as! SingleDealController
               newVC.item_id = itemid
               newVC.dealid = itemid
          }
            if(segue.identifier == "hotel"){
               let destinationVC = segue.destination as! UINavigationController
               let newVC = destinationVC.viewControllers.first as! HotelsController
               newVC.id = 1
            }
            if(segue.identifier == "show"){
              let destinationVC = segue.destination as! UINavigationController
              let newVC = destinationVC.viewControllers.first as! ShowsController
              newVC.id = 1
            }
            if(segue.identifier == "spin"){
              let destinationVC = segue.destination as! UINavigationController
              let newVC = destinationVC.viewControllers.first as! SpinWheelsController
              newVC.id = 1
            }
            if(segue.identifier == "invite"){
              let destinationVC = segue.destination as! UINavigationController
              let newVC = destinationVC.viewControllers.first as! InvitesController
              newVC.id = 1
            }
    }
    func fetchPointsDetails(){
           if(Connectivity.isConnectedToInternet()){
               let userid = Helpers.readPreference(key: "user_id", defualt: "0")
               let authid = Helpers.readPreference(key: "auth_id", defualt: "0")
            PDRequest.getPointsDetails(user_id: userid, auth_id: authid){returnJSON,error in
                   if error != nil{
                       //Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message: "Something went wrong")
                   }else{
                      if returnJSON?.error?.status == 1 {
                           //Helpers.dismissHUD(view: self.view, isAnimated: true)
                           Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                       }else{
                            //Helpers.dismissHUD(view: self.view, isAnimated: true)
                            let total_points = String((returnJSON?.response?.detail!.earned_points)!)
                            let infostr = "You have "+total_points+" points to spin and win"
                            self.changeText(label: self.points_detail_lbl, text: infostr)
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
            myAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green)), range: myRange)
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
extension BusinessDetailController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return topProducts.count
        return deals_array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:TopCatCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "top", for: indexPath) as! TopCatCollectionCell
        
        cell.deal_name.text = deals_array[indexPath.row].title
        let original = deals_array[indexPath.row].avatar
        if let encoded = original!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded)
        {
            let imageView = UIImageView()
            imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_bm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
               if(error != nil){
                    cell.productimg.image = UIImage(named: "splashlogo")
               }else{
                if (downloadImage != nil) {
                   cell.productimg.image = downloadImage!
                }
               }
            })
        }

        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        itemid = deals_array[indexPath.row].item_id!
        self.performSegue(withIdentifier: "dealsdetail", sender: self)
         
    }
    
   
}
