//
//  ContactsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 01/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import Contacts

extension String {
  func whiteSpacesRemoved() -> String {
    return self.filter { $0 != Character(" ") }
  }
}
class ContactsController: UIViewController {

    @IBOutlet var search_bar: UISearchBar!
    @IBOutlet var contact_tableview: UITableView!
    var twoDimensionalArray = [PhoneContacts]()
    var filterArray = [PhoneContacts]()
    var urlstring = ""
    var numbersList = [String]()
    var invitedNumbersList = [CLDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addDoneButtonOnKeyboard()
        getInvitedContacts()
    }

    @IBAction func invite_friends_listener(_ sender: UIButton) {
        if(numbersList.count == 0){
            Helpers.showToast(view: self.view, msg: "Please select at least one contact.")
            return
        }
        if(numbersList.count >= 11){
            Helpers.showToast(view: self.view, msg: "You can't send invite to more than 10 people.")
            return
        }
        let formattedArray = (numbersList.map{String($0)}).joined(separator: ",")
        print(formattedArray)
        sendCode(phone: formattedArray)
        contact_tableview.reloadData()
        numbersList.removeAll()
    }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func fetchContacts() {
        print("Attempting to fetch contacts today..")
        
        let authStatusForContacts = CNContactStore.authorizationStatus(for: .contacts)
        if authStatusForContacts == .authorized {
            print("Access granted")

            let store = CNContactStore()
            let keys = [CNContactGivenNameKey,CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactImageDataKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            
            do {
                var favoritableContacts = [PhoneContacts]()
                
                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                    if(!contact.givenName.isEmpty){
                        print(contact.givenName)
                    
                    print(contact.familyName)
                    print(contact.phoneNumbers.first?.value.stringValue ?? "")
                    }
                    if(contact.givenName != " " && contact.phoneNumbers.first?.value.stringValue != " "){
                        if(!contact.givenName.isEmpty){
                            if(contact.phoneNumbers.count > 0){
                                
                                favoritableContacts.append(PhoneContacts(sent: false, contact: contact))
                            }
                        }
                    }
                    
                })
                
                //self.twoDimensionalArray = favoritableContacts[0].contact.sorted(by: { $0.givenName.lowercased() < $1.givenName.lowercased() })
                for row in invitedNumbersList {
                    for nrow in favoritableContacts{
                        
                        let trimedno = (nrow.contact.phoneNumbers.first?.value.stringValue.whiteSpacesRemoved())!
                        if(row.phone_no == trimedno){
                            nrow.isSent = true
                        }
                    }
                }
                
                self.twoDimensionalArray = favoritableContacts
                DispatchQueue.main.async {
                    self.contact_tableview.delegate = self
                    self.contact_tableview.dataSource = self
                    self.search_bar.delegate = self
                    self.contact_tableview.reloadData()
                }
                
            } catch let err {
                print("Failed to enumerate contacts:", err)
            }
        }else {
            self.performSegue(withIdentifier: "syncContacts", sender: self)
        }
    }
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(ContactsController.doneButtonAction))

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.search_bar.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.search_bar.resignFirstResponder()
    }
    func getInvitedContacts(){
        if(Connectivity.isConnectedToInternet()){
         Helpers.showHUD(view: self.view, progressLabel: "Loading...")
         let user_id = Helpers.readPreference(key: "user_id", defualt: "0")
         let auth_id = Helpers.readPreference(key: "auth_id", defualt: "0")
         let id = Helpers.readPreference(key: "id", defualt: "0")

        ContactListRequest.getInvContacts(id: id,user_id: user_id,auth_id: auth_id){returnJSON,error in
              if error != nil{
                  Helpers.dismissHUD(view: self.view, isAnimated: true)
                  Helpers.showAlertView(title: "Error", message: "Something went wrong")
              }else{
                 if returnJSON?.error?.status == 1 {
                      Helpers.dismissHUD(view: self.view, isAnimated: true)
                      Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                  }else{
                     Helpers.dismissHUD(view: self.view, isAnimated: true)
                     self.invitedNumbersList = returnJSON?.response?.detail as! [CLDetail]
                     self.fetchContacts()
                  }
              }
            }
          }else{
              Helpers.dismissHUD(view: self.view, isAnimated: true)
              Helpers.showAlertView(title: "Internet", message:"Please check your internet connection!")
          }
    }

    func sendCode(phone:String){
       if(Connectivity.isConnectedToInternet()){
        Helpers.showHUD(view: self.view, progressLabel: "Loading...")
        let id = Helpers.readPreference(key: "id", defualt: "0")
        print(phone)
        let name = Helpers.readPreference(key: "name", defualt: "")
        let message = "Your friend "+name+" has invited you to become part of Atlantic City. click on the link below to join the Atlantic City family and win amazing prizes. "+urlstring
        PincodeRequest.sendInvite(message: message, phoneno: phone, id: id){returnJSON,error in
               if error != nil{
                   Helpers.dismissHUD(view: self.view, isAnimated: true)
                   Helpers.showAlertView(title: "Error", message: "Something went wrong")
               }else{
                  if returnJSON?.error?.status == 1 {
                       Helpers.dismissHUD(view: self.view, isAnimated: true)
                       Helpers.showAlertView(title: "Error", message:(returnJSON!.error?.message)!)
                   }else{
                      Helpers.dismissHUD(view: self.view, isAnimated: true)
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
    func getSelectedNumbers(number:String){
        if(numbersList.count > 0 ){
            for data in numbersList{
                if(data == number){
                    return
                }else{
                    numbersList.append(number)
                    return
                }
            }
        }else{
            numbersList.append(number)
        }

    }
    func removeSelectedNumber(number:String){
        for (index,data) in numbersList.enumerated(){
            if(data == number){
                numbersList.remove(at: index)
            }
        }
    }
    
}

extension ContactsController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(filterArray.count > 0){
            return filterArray.count
        }else{
            return twoDimensionalArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContactsCell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell") as! ContactsCell
        
        cell.link = self
        let favoritableContact:PhoneContacts!
        if(filterArray.count > 0){
            favoritableContact = filterArray[indexPath.row]
        }else{
            favoritableContact = twoDimensionalArray[indexPath.row]
        }
        
        if(favoritableContact.contact.givenName == ""){
            cell.name.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        }else{
            cell.name.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        }
        cell.phoneno.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        if(favoritableContact.contact.imageData != nil){
            cell.person_img.image = UIImage(data: favoritableContact.contact.imageData!)
        }else{
            cell.person_img.image = UIImage(systemName: "person.circle")
        }
        if(favoritableContact.isSent == true){
            cell.checkbox.isHidden = true
            cell.sent_label.isHidden = false
        }else{
            cell.sent_label.isHidden = true
            cell.checkbox.isHidden = false
            cell.checkbox.isOn = false
            for str in numbersList{
                if(str == favoritableContact.contact.phoneNumbers.first?.value.stringValue){
                    cell.checkbox.isOn = true
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! ContactsCell
        currentCell.contentView.backgroundColor = UIColor.white
        if (currentCell.checkbox.isOn){
            self.removeSelectedNumber(number: currentCell.phoneno.text!)
            currentCell.checkbox.isOn = false
        }else{
            self.getSelectedNumbers(number: currentCell.phoneno.text!)
            currentCell.checkbox.isOn = true
        }
    }
    
}
extension ContactsController:UISearchBarDelegate{
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if(searchText.isEmpty){
            searchBar.resignFirstResponder()
        }
        filterArray = searchText.isEmpty ? twoDimensionalArray : twoDimensionalArray.filter { $0.contact.givenName.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive ]) != nil ||
            $0.contact.familyName.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive ]) != nil ||
            $0.contact.phoneNumbers.first?.value.stringValue.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive ]) != nil
            
        }
        
           contact_tableview.reloadData()
       }
}

