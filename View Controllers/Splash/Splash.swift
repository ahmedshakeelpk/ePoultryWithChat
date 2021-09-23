//
//  Splash.swift
//  AMPL
//
//  Created by Paragon Marketing on 20/06/2017.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import CoreLocation
import GoogleMaps


class Splash: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Marks: - Buttons Cornor Radius
        self.navigationController?.isNavigationBarHidden = true
//        funFetchAllContacts(notification: Notification(name: Notification.Name(rawValue: "contactrefresh")))
//        return
        
      if let temp = defaults.value(forKey: "arrGuserid") as? NSMutableArray {
          if temp.count != 0 {
              arrGfullname = defaults.value(forKey: "arrGfullname") as! [String]
              arrGfname = defaults.value(forKey: "arrGfname") as! [String]
              arrGlname = defaults.value(forKey: "arrGlname") as! [String]
              arrGnumber = defaults.value(forKey: "arrGnumber") as! [String]

              let decoded  = defaults.object(forKey: "arrGpic") as! Data
              arrGpic = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSMutableArray
              //arrGpic = defaults.value(forKey: "arrGpic") as! NSMutableArray
              arrGnumberWithoutSpaces = defaults.value(forKey: "arrGnumberWithoutSpaces") as! NSMutableArray
              //////////
              arrGRectifyPhone = defaults.value(forKey: "arrGRectifyPhone") as! NSMutableArray
              arrGuserphone = defaults.value(forKey: "arrGuserphone") as! NSMutableArray
              arrGuserid = defaults.value(forKey: "arrGuserid") as! NSMutableArray

              arrGuserid = defaults.value(forKey: "arrGuserUid") as! NSMutableArray
              arrGRectifyPhone = defaults.value(forKey: "arrGRectifyPhone") as! NSMutableArray
              let decoded2  = defaults.object(forKey: "arrGuserpic") as! Data
              arrGuserpic = NSKeyedUnarchiver.unarchiveObject(with: decoded2) as! NSMutableArray

              //arrGuserpic = defaults.value(forKey: "arrGuserpic") as! NSMutableArray
              arrGusername = defaults.value(forKey: "arrGusername") as! NSMutableArray
              arrGuserphone = defaults.value(forKey: "arrGuserphone") as! NSMutableArray
              arrGuserFBToken = defaults.value(forKey: "arrGuserFBToken") as! NSMutableArray
              arrGuserUid =  defaults.value(forKey: "arrGuserUid") as! NSMutableArray


              arrGfullname_AppUser = defaults.value(forKey: "arrGfullname_AppUser") as! [String]
              arrGfname_AppUser = defaults.value(forKey: "arrGfname_AppUser") as! [String]
              arrGlname_AppUser = defaults.value(forKey: "arrGlname_AppUser") as! [String]
              arrGnumber_AppUser = defaults.value(forKey: "arrGnumber_AppUser") as! [String]

              let decoded_AppUser  = defaults.object(forKey: "arrGpic_AppUser") as! Data
              arrGpic_AppUser = NSKeyedUnarchiver.unarchiveObject(with: decoded_AppUser) as! NSMutableArray
              //arrGpic = defaults.value(forKey: "arrGpic") as! NSMutableArray
              arrGnumberWithoutSpaces_AppUser = defaults.value(forKey: "arrGnumberWithoutSpaces_AppUser") as! NSMutableArray
          }
      }

      if arrGnumber.count == 0 {
          funFetchAllContacts(notification: Notification(name: Notification.Name(rawValue: "contactrefresh")))
      }
      else if arrGuserphone.count == 0 {
          funRectifyUser()
      }
      else {
          // self.funSortData()
          DispatchQueue.main.async {
              self.funViewAppear()
          }
      }
    }

    override func viewDidLoad() {
        NAVIGATIONBAR_HEIGHT = (self.navigationController?.navigationBar.frame.maxY)!
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let login  = defaults.value(forKey: "islogin") as? String {
            if login == "1" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
                self.navigationController?.pushViewController(vc, animated: true)
                //callSoapAPI()
                
                funGetUserProfile()
            }
            else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
            self.navigationController?.pushViewController(vc, animated: true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(funFetchAllContacts(notification:)), name: NSNotification.Name(rawValue: "contactrefresh"), object: nil)
    }
    
    // User Authentication
    func callSoapAPI(){
        
        // Soap Boday
        let mobileno = defaults.value(forKey: "mobileno") as! String
        let pass = defaults.value(forKey: "password") as! String
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><AuthenticateUser xmlns='http://threepin.org/'><mobileNo>\(mobileno)</mobileNo><password>\(pass)</password></AuthenticateUser></soap12:Body></soap12:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Users.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
            DispatchQueue.global(qos: .background).async
                {
                    
            }
            
           // self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "AuthenticateUserResponse")! as Any) as AnyObject).object(forKey:"AuthenticateUserResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! [AnyHashable: Any])
                    
                    let myString: String = mainD.value(forKey: "text") as! String
                    if myString == "-1"
                    {
                        obj.showAlert(title: "Alert!", message: "Invalid username or password", viewController: self)
                    }
                    else
                    {
                        let myStringArr = myString.components(separatedBy: "---")
                        
                        let idd: String = myStringArr [0]
                        let token: String = myStringArr [1]
                        //let mobileno: String = myStringArr [1]
                        // self.performSegue(withIdentifier: "details", sender: mainD)
                        
                        self.updatefcm(idd: idd, token: token)
                    }
                }
                else{
                    
                    obj.showAlert(title: "Alert", message: "try again", viewController: self)
                }
            }
            catch
            {
                print("Your Dictionary value nil")
            }
            if error != nil
            {
                //self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        task.resume()
    }
    
    // Update FCM ID
    func updatefcm(idd: String, token: String) {
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><updateGCM xmlns='http://threepin.org/'><id>\(idd)</id><gcm_id>\(token)</gcm_id></updateGCM></soap:Body></soap:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Users.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        //andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
            //self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "updateGCMResponse")! as Any) as AnyObject).object(forKey:"updateGCMResult")   ?? NSDictionary()
                
                
                
                if (mainDict as AnyObject).count > 0{
                    
                    // let mainD = NSDictionary(dictionary: mainDict as! [AnyHashable: Any])
                    
                    self.getuserdetails(idd: idd)
                }
                else{
                    
                    obj.showAlert(title: "Alert", message: "try again", viewController: self)
                    
                }
                
            }
            catch
            {
                print("Your Dictionary value nil")
            }
            if error != nil
            {
               // self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }
    
    // Get User Details
    func getuserdetails(idd: String){
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UserDetails xmlns='http://threepin.org/'><user_id>\(idd)</user_id></UserDetails></soap:Body></soap:Envelope>"
        
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/ProfileService.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
        
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        
        let session = URLSession.shared
        
        
       // andicator.startAnimating()
        
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Body: \(strData)")
            
            
            //self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UserDetailsResponse")! as Any) as AnyObject).object(forKey:"UserDetailsResult")   ?? NSDictionary()
                
                
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    var text = mainD.value(forKey: "text") as! NSString
                    
                    
                    
                    text = text.replacingOccurrences(of: "[", with: "") as NSString
                    text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    
                    var json = NSDictionary()
                    if let data = text.data(using: String.Encoding.utf8.rawValue) {
                        do {
                            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                            //print(json.value(forKey: "id"))
                            
                        } catch {
                            print("Something went wrong")
                        }
                    }
                    
                    if let name = json.value(forKey: "Name") as? String
                    {
                        defaults.setValue(name, forKey: "name")
                    }
                    if let roletitle = json.value(forKey: "RoleTitle") as? String
                    {
                        defaults.setValue(roletitle, forKey: "role")
                    }
                    if let username = json.value(forKey: "username") as? String
                    {
                        defaults.setValue(username, forKey: "username")
                    }
                    if let email = json.value(forKey: "email") as? String
                    {
                        defaults.setValue(email, forKey: "email")
                    }
                    if let mobile = json.value(forKey: "mobile") as? String
                    {
                        defaults.setValue(mobile, forKey: "mobile")
                    }
                    var idd = String()
                    if let userid = json.value(forKey: "id") as? Int
                    {
                        defaults.setValue(String(userid), forKey: "userid")
                        idd  = String(userid)
                    }
                    if let profile_img = json.value(forKey: "profile_img") as? String
                    {
                        defaults.setValue(profile_img, forKey: "profileimg")
                    }
                    
//                    defaults.setValue("1", forKey: "islogin")
//                    defaults.setValue(self.txtusername.text!, forKey: "mobileno")
//                    defaults.setValue(self.txtpassword.text!, forKey: "password")
                    // let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
                    // self.navigationController?.pushViewController(vc, animated: true)
                    
                    self.getuserrole(idd: String(idd))
                    
                }
                else{
                    
                    obj.showAlert(title: "Alert", message: "try again", viewController: self)
                    
                }
                
            }
            catch
            {
                print("Your Dictionary value nil")
            }
            
            if error != nil
            {
                //self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }
    
    // Get User Role
    func getuserrole(idd: String){
        
        let version = "1.5.7"
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><CheckForFunctionalities xmlns='http://threepin.org/'><id>\(idd)</id><version>\(version)</version></CheckForFunctionalities></soap:Body></soap:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Users.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
        
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        //andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Body: \(strData)")
            
           // self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "CheckForFunctionalitiesResponse")! as Any) as AnyObject).object(forKey:"CheckForFunctionalitiesResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    var text = mainD.value(forKey: "text") as! NSString
                    
                    text = text.replacingOccurrences(of: "[", with: "") as NSString
                    text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    
                    var json = NSDictionary()
                    if let data = text.data(using: String.Encoding.utf8.rawValue) {
                        do {
                            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                            //print(json.value(forKey: "id"))
                            
                        } catch {
                            print("Something went wrong")
                        }
                    }
                    
                    if let IsAdmin = json.value(forKey: "IsAdmin") as? Int
                    {
                        defaults.setValue(String(IsAdmin), forKey: "isadmin")
                    }
                    if let IsMember = json.value(forKey: "IsMember") as? String
                    {
                        defaults.setValue(IsMember, forKey: "ismember")
                    }
                    if let IsNews = json.value(forKey: "IsNews") as? String
                    {
                        defaults.setValue(IsNews, forKey: "isnews")
                    }
                    if let Tray1 = json.value(forKey: "Tray1") as? String
                    {
                        defaults.setValue(Tray1, forKey: "tray1")
                    }
                    if let Tray2 = json.value(forKey: "Tray2") as? String
                    {
                        defaults.setValue(Tray2, forKey: "tray2")
                    }
                    if let membershiprequest = json.value(forKey: "membershiprequest") as? String
                    {
                        defaults.setValue(membershiprequest, forKey: "membershiprequest")
                    }
                    if let role = json.value(forKey: "role") as? String
                    {
                        defaults.setValue(role, forKey: "role")
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    
                    obj.showAlert(title: "Alert", message: "try again", viewController: self)
                    
                }
            }
            catch
            {
                print("Your Dictionary value nil")
            }
            if error != nil
            {
                //self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }
    
    func sinchLogin(userid: String) {
           //MARK: - Post notification when user login for sinch calling
           NotificationCenter.default.post(name: Notification.Name("UserDidLoginNotification"), object: nil, userInfo: ["userId":userid])
           //END SENDING push notification to observer Sinch Call
       }
    
    // Get Location Name from Latitude and Longitude
    func funGetUserProfile() {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"user/\(userid)?userId=\(userid)"
        //http://epoultryapi.zederp.net/api/user/35907?userId=35907
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let tempdataDic = (responseObject?.value(forKey: "Data") as! NSArray)[0] as! NSMutableDictionary
                            
                            if let IsAdmin = tempdataDic.value(forKey: "IsAdmin") as? Int {
                                defaults.setValue(String(IsAdmin), forKey: "isadmin")
                            }
                            if let role = tempdataDic.value(forKey: "role") as? String {
                                defaults.setValue(role, forKey: "role")
                            }
                            if let IsMember = tempdataDic.value(forKey: "IsMember") as? String {
                                defaults.setValue(IsMember, forKey: "ismember")
                            }
                            if let IsNews = tempdataDic.value(forKey: "IsNews") as? String {
                                defaults.setValue(IsNews, forKey: "isnews")
                            }
                            if let Tray1 = tempdataDic.value(forKey: "Tray1") as? String {
                                defaults.setValue(Tray1, forKey: "tray1")
                            }
                            if let Tray2 = tempdataDic.value(forKey: "Tray2") as? String {
                                defaults.setValue(Tray2, forKey: "tray2")
                            }
                            if let membershiprequest = tempdataDic.value(forKey: "membershiprequest") as? String {
                                defaults.setValue(membershiprequest, forKey: "membershiprequest")
                            }
//                            self.dataDic = [
//                                "Username":"\(tempdataDic.value(forKey: "username") as? String ?? "")",
//                                "First Name":"\(tempdataDic.value(forKey: "FirstName") as? String ?? "")",
//                                "Last Name":"\(tempdataDic.value(forKey: "LastName") as? String ?? "")",
//                                "Gender":"\(tempdataDic.value(forKey: "gender") as? String ?? "")",
//                                "Date of Birth":"\(tempdataDic.value(forKey: "dob") as? String ?? "")",
//                                "CNIC No":"\(tempdataDic.value(forKey: "CNIC") as? String ?? "")",
//                                "Qulification":"\(tempdataDic.value(forKey: "Qualification") as? String ?? "")",
//                                "Profession":"\(tempdataDic.value(forKey: "Profession") as? String ?? "")",
//                                "Address":"\(tempdataDic.value(forKey: "address") as? String ?? "")",
//                                "City / Town":"\(tempdataDic.value(forKey: "City") as? String ?? "")",
//                                "State / Provance / Region":"\(tempdataDic.value(forKey: "Province") as? String ?? "")",
//                                "Country":"\(tempdataDic.value(forKey: "Country") as? String ?? "")",
//                                "Contact No (Landline)":"\(tempdataDic.value(forKey: "ContactNo") as? String ?? "")",
//                                "Mobile No":"\(tempdataDic.value(forKey: "mobile") as? String ?? "")",
//                                "Email":"\(tempdataDic.value(forKey: "email") as? String ?? "")"]
                            //print(self.dataDic)
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    
    //////////////////////MARK:- User Contacts Get///////////////////////
    
    var isSplash = 0
    var arrGfullname_temp = [String]()
    var arrGfname_temp = [String]()
    var arrGlname_temp = [String]()
    var arrGnumber_temp = [String]()
    var arrGpic_temp = NSMutableArray()
    var arrGnumberWithoutSpaces_temp = NSMutableArray()
    
    var arrGRectifyPhone_temp = NSMutableArray()
    var arrGuserphone_temp = NSMutableArray()
    var arrGuserid_temp = NSMutableArray()
    var pull = ""
    @objc func funFetchAllContacts(notification: Notification) {
        if let datadic = notification.object as? NSDictionary {
            if let temp = datadic.value(forKey: "isPull") as? String {
                if temp == "1" {
                    pull = temp
                }
            }
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startAndicator"), object: nil)
        }
        
        let temp2ndarrGfullname = arrGfullname_temp
        let temp2ndarrGfname = arrGfname_temp
        let temp2ndarrGlname = arrGlname_temp
        let temp2ndarrGnumber = arrGnumber_temp
        let temp2ndarrGpic = arrGpic_temp
        let temp2ndarrGnumberWithoutSpaces = arrGnumberWithoutSpaces_temp
        
        arrGfullname_temp = [String]()
        arrGfname_temp = [String]()
        arrGlname_temp = [String]()
        arrGnumber_temp = [String]()
        arrGpic_temp = NSMutableArray()
        arrGnumberWithoutSpaces_temp = NSMutableArray()
        
        var temparrfullname = [String]()
        var temparrfname = [String]()
        var temparrlname = [String]()
        var temparrnumber = [String]()
        let temparrpic = NSMutableArray()
        //MARK:- Fetch Phone numbers from Phone
        
        obj.fetchContacts(completion: {contacts,error  in
            if error != ""{
                if self.isSplash == 1 {
                    DispatchQueue.main.async {
                        // create the alert
                        let alert = UIAlertController(title: "Contact!", message: "You may not see the Contact Permission is required to show your friends names", preferredStyle: UIAlertController.Style.alert)

                        // add the actions (buttons)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Setting", style: UIAlertAction.Style.destructive, handler: { action in
                            obj.funOpenAppSetting()
                        }))
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    self.funViewAppear()
                }
                return
            }
            contacts.forEach({print("FullNAme: \($0.value(forKey: "fullName") as Any) Name: \($0.givenName), Number: \($0.phoneNumbers.first?.value.stringValue ?? "nil")")
                //MARK:- Phone Number
                var tempphone = ""
                if let temp = $0.phoneNumbers.first?.value.stringValue {
                    temparrnumber.append(temp)
                    tempphone = temp
                }
                else {
                    if $0.phoneNumbers.first?.value.stringValue == nil{
                        return
                    }
                    temparrnumber.append(
                        "\($0.phoneNumbers.first?.value.stringValue ?? "nil")")
                }
                if let fullname = $0.value(forKey: "fullName") as Any as? String {
                    temparrfullname.append(fullname)
                }
                else if (($0.phoneNumbers.first?.value.stringValue) != nil){
                    temparrfullname.append(
                        ($0.phoneNumbers.first?.value.stringValue)!)
                }
                else {
                    temparrfullname.append("")
                }
                temparrfname.append("\($0.givenName)")
                temparrlname.append("\($0.familyName)")
                
                var img = UIImage()
                if $0.thumbnailImageData != nil {
                    img = UIImage.init(data: $0.thumbnailImageData!)!
                    temparrpic.add(img)
                }
                else {
                    if let fullname = $0.value(forKey: "fullName") as Any as? String {
                        temparrpic.add(fullname)
                    }
                    else {
                        temparrpic.add("\($0.givenName) \($0.familyName)")
                    }
                }
                
                tempphone = tempphone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                if tempphone.first == "0" || tempphone.first == "+" {
                    tempphone.removeFirst()
                }
                if tempphone.first == "0" {
                    tempphone.removeFirst()
                }
                self.arrGnumberWithoutSpaces_temp.add(tempphone)
                // let searchToSearch = tempphone
            })
            
            if temparrnumber.count > self.arrGnumber_temp.count {
                self.arrGfullname_temp = temparrfullname
                self.arrGfname_temp = temparrfname
                self.arrGlname_temp = temparrlname
                self.arrGnumber_temp = temparrnumber
                self.arrGpic_temp = temparrpic
            }
            else {
                self.arrGfullname_temp = temp2ndarrGfullname
                self.arrGfname_temp = temp2ndarrGfname
                self.arrGlname_temp = temp2ndarrGlname
                self.arrGnumber_temp = temp2ndarrGnumber
                self.arrGpic_temp = temp2ndarrGpic
                self.arrGnumberWithoutSpaces_temp = temp2ndarrGnumberWithoutSpaces
            }
            
            defaults.setValue(self.arrGfullname_temp, forKey: "arrGfullname")
            defaults.setValue(self.arrGfname_temp, forKey: "arrGfname")
            defaults.setValue(self.arrGlname_temp, forKey: "arrGlname")
            defaults.setValue(self.arrGnumber_temp, forKey: "arrGnumber")
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.arrGpic_temp)
            defaults.set(encodedData, forKey: "arrGpic")
            //defaults.setValue(arrGpic, forKey: "arrGpic")
            defaults.setValue(self.arrGnumberWithoutSpaces_temp, forKey: "arrGnumberWithoutSpaces")
            
            if contacts.count > 0 {
                DispatchQueue.main.async {
                    self.funRectifyUser()
                }
            }
            else {
                
            }
        })
        
        DispatchQueue.main.async{
            self.funViewAppear()
        }
    }
    //2
    ////////////////////////////Register in Our Own Server
    func funRectifyUser() {
        return()
        arrGRectifyPhone_temp = NSMutableArray()
        arrGuserphone_temp = NSMutableArray()
        arrGuserid_temp = NSMutableArray()
        
        var tempnumberarray = [String]()
        for tempno in arrGnumber_temp {
            var tempno2 = tempno as String
            if tempno2.first == "0" {
                tempno2.removeFirst()
            }
            if tempno2.first == "0" {
                tempno2.removeFirst()
            }
            tempnumberarray.append(tempno2)
        }
        
        var allcontactArray = tempnumberarray.joined(separator:",")
        
        allcontactArray = allcontactArray.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        allcontactArray = allcontactArray.trimmingCharacters(in: .whitespaces)
        allcontactArray = allcontactArray.replacingOccurrences(of: " ", with: "")
        allcontactArray = allcontactArray.replacingOccurrences(of: "+", with: "")
        allcontactArray = allcontactArray.replacingOccurrences(of: "-", with: "")
        allcontactArray = allcontactArray.replacingOccurrences(of: "(", with: "")
        allcontactArray = allcontactArray.replacingOccurrences(of: ")", with: "")
        print (allcontactArray)
        let parameters : Parameters =
            ["AllContacts": allcontactArray]
        print (parameters)
        
        obj.webService2(url: RECTIFYUSER, parameters: parameters, completionHandler:{ responseObject, error, responseObject2nd  in
            
            if error == nil {
                if (responseObject?.count)! > 0 {
                    let dataarr = responseObject! as NSArray
                    if dataarr.count > 0 {
                        arrGuserpic = (dataarr.value(forKey: "ProfilePic") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGuserFBToken = (dataarr.value(forKey: "fcmId") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGuserUid = (dataarr.value(forKey: "firebaseUserId") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGuserid = (dataarr.value(forKey: "id") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGusername = (dataarr.value(forKey: "name") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGRectifyPhone = (dataarr.value(forKey: "username") as! NSArray).mutableCopy() as! NSMutableArray
                        arrGuserphone = (dataarr.value(forKey: "username") as! NSArray).mutableCopy() as! NSMutableArray
                        
                        self.funSortData()
                    }
                    else {
                        //obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                    }
                }
                else {
                    self.funViewAppear()
                }
            }
            else {
                //obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                self.funRectifyUser()
            }
        })
    }
    
    func funSortData() {
        var temparrGfullname =  arrGfullname_temp
        var temparrGfname = arrGfname_temp
        var temparrGlname = arrGlname_temp
        var temparrGnumber = arrGnumber_temp
        var temparrGpic = arrGpic_temp as! [Any]
        var temparrGnumberWithoutSpaces = arrGnumberWithoutSpaces_temp as! [Any]
        
        let sortedOrder = (arrGfullname_temp).enumerated().sorted(by: {$0.1>$1.1}).map({$0.0})
        
        temparrGfullname = ((sortedOrder.map({temparrGfullname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
        temparrGfname = ((sortedOrder.map({temparrGfname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
        
        temparrGlname = ((sortedOrder.map({temparrGlname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
        temparrGnumber = ((sortedOrder.map({temparrGnumber[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
        temparrGpic = ((sortedOrder.map({temparrGpic[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed()
        temparrGnumberWithoutSpaces = ((sortedOrder.map({temparrGnumberWithoutSpaces[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed()
        
        arrGfullname_temp = temparrGfullname
        arrGfname_temp = temparrGfname
        arrGlname_temp = temparrGlname
        arrGnumber_temp = temparrGnumber
        arrGpic_temp = (temparrGpic as NSArray).mutableCopy() as! NSMutableArray
        
        self.funSortIssChatContact()
    }
    @objc func funSortIssChatContact() {
        
        var temparrfullname = arrGfullname_temp
        var temparrfname = arrGfname_temp
        var temparrlname = arrGlname_temp
        var temparrnumber = arrGnumber_temp
        let temparrpic = arrGpic_temp
        let temparrnumberWithoutSpaces = arrGnumberWithoutSpaces_temp
        
        var temparrfullnameFind = [String]()
        var temparrfnameFind = [String]()
        var temparrlnameFind = [String]()
        var temparrnumberFind = [String]()
        var temparrpicFind = NSMutableArray()
        var temparrnumberWithoutSpacesFind = NSMutableArray()
        
        
        //MARK:- Find All Local number in Rectify Phone Numbers
        for (_,temp) in arrGRectifyPhone.enumerated() {
            let contactUserNo = obj.getContactNumberFromGlobalNumber(contactNumber:"\(temp)")
            print(contactUserNo)
            if contactUserNo != "" {
                var itemsArray = temparrnumber
                var searchToSearch = contactUserNo
                if searchToSearch.first == "0"{
                    searchToSearch.removeFirst()
                }
                self.find(value: searchToSearch, in: itemsArray) { userindex in
                    guard let userindex = userindex else { return }
                    //Mark:- Index Find
                    
                    let  tempfullname = temparrfullname[userindex]
                    let  tempfname = temparrfname[userindex]
                    let  templname = temparrlname[userindex]
                    let  tempnumber = temparrnumber[userindex]
                    let  temppic = temparrpic[userindex]
                    let  temptempphone = temparrnumberWithoutSpaces[userindex]
                    
                    temparrfullnameFind.append(tempfullname)
                    temparrfnameFind.append(tempfname)
                    temparrlnameFind.append(templname)
                    temparrnumberFind.append(tempnumber)
                    temparrpicFind.add(temppic)
                    temparrnumberWithoutSpacesFind.add(temptempphone)
                    
                    temparrfullname.remove(at: userindex)
                    temparrfname.remove(at: userindex)
                    temparrlname.remove(at: userindex)
                    temparrnumber.remove(at: userindex)
                    temparrpic.removeObject(at: userindex)
                    temparrnumberWithoutSpaces.remove(userindex)
                    
                    itemsArray = temparrnumber
                }
            }
            else{
                
            }
        }//MARK:- End of for loop
        
        //MARK:- Sort Find Contacts In Rectify Phone Numbers
        if temparrnumberFind.count > 0 {
            var temparrGfullname =  temparrfullnameFind
            var temparrGfname = temparrfnameFind
            var temparrGlname = temparrlnameFind
            var temparrGnumber = temparrnumberFind
            var temparrGpic = temparrpicFind as! [Any]
            var temparrGnumberWithoutSpaces = temparrnumberWithoutSpacesFind as! [Any]
            
            let sortedOrder = (temparrfullnameFind).enumerated().sorted(by: {$0.1>$1.1}).map({$0.0})
            
            temparrGfullname = ((sortedOrder.map({temparrGfullname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
            temparrGfname = ((sortedOrder.map({temparrGfname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
            
            temparrGlname = ((sortedOrder.map({temparrGlname[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
            temparrGnumber = ((sortedOrder.map({temparrGnumber[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed() as! [String]
            temparrGpic = ((sortedOrder.map({temparrGpic[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed()
            temparrGnumberWithoutSpaces = ((sortedOrder.map({temparrGnumberWithoutSpaces[$0]}) as NSArray).mutableCopy() as! NSMutableArray).reversed()
            
            temparrfullnameFind = temparrGfullname
            temparrfnameFind = temparrGfname
            temparrlnameFind = temparrGlname
            temparrnumberFind = temparrGnumber
            temparrpicFind = (temparrGpic as NSArray).mutableCopy() as! NSMutableArray
            temparrnumberWithoutSpacesFind = (temparrGnumberWithoutSpaces as NSArray).mutableCopy() as! NSMutableArray
        }
        
        //Remove own number from contact numbers
        if let ownnumber = defaults.value(forKey: "phoneno") as? String {
            let contactUserNo = obj.getContactNumberFromGlobalNumber(contactNumber:"\(ownnumber)")
            print(contactUserNo)
            if contactUserNo != ""{
                let itemsArray = temparrnumberFind
                var searchToSearch = contactUserNo
                if searchToSearch.first == "0"{
                    searchToSearch.removeFirst()
                }
                
                self.find(value: searchToSearch, in: itemsArray) { userindex in
                    guard let userindex = userindex else { return }
                    //Mark:- Index Find
                    temparrfullnameFind.remove(at: userindex)
                    temparrfnameFind.remove(at: userindex)
                    temparrlnameFind.remove(at: userindex)
                    temparrnumberFind.remove(at: userindex)
                    temparrpicFind.removeObject(at: userindex)
                    temparrnumberWithoutSpacesFind.remove(userindex)
                }
            }
        }
        
        var temp_arrGuserpic = [Any]()
        var temp_arrGuserFBToken = [Any]()
        var temp_arrGuserUid = [Any]()
        var temp_arrGuserid = [Any]()
        var temp_arrGusername = [Any]()
        var temp_arrGRectifyPhone = [Any]()
        var temp_arrGuserphone = [Any]()
        
        //MARK:- Sort Rectify Numbers from Server
        for (_,temp) in temparrnumberFind.enumerated() {
            let contactUserNo = obj.getContactNumberFromGlobalNumber(contactNumber:"\(temp)")
            print(contactUserNo)
            if contactUserNo != "" {
                let itemsArray = arrGuserphone
                var searchToSearch = contactUserNo
                searchToSearch = searchToSearch.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                if searchToSearch.first == "0" || searchToSearch.first == "+" {
                    searchToSearch.removeFirst()
                }
                if searchToSearch.first == "0" {
                    searchToSearch.removeFirst()
                }
                
                self.find(value: searchToSearch, in: itemsArray as! [String]) { userindex in
                    guard let userindex = userindex else { return }
                    //Mark:- Index Find
                    
                    let  temp_userpic = arrGuserpic[userindex]
                    let  temp_userFBToken = arrGuserFBToken[userindex]
                    let  temp_userUid = arrGuserUid[userindex]
                    let  temp_userid = arrGuserid[userindex]
                    let  temp_username = arrGusername[userindex]
                    let  temp_phone = arrGRectifyPhone[userindex]
                    let  temp_userphone = arrGuserphone[userindex]
                    
                    temp_arrGuserpic.append(temp_userpic)
                    temp_arrGuserFBToken.append(temp_userFBToken)
                    temp_arrGuserUid.append(temp_userUid)
                    temp_arrGuserid.append(temp_userid)
                    temp_arrGusername.append(temp_username)
                    temp_arrGRectifyPhone.append(temp_phone)
                    temp_arrGuserphone.append(temp_userphone)
                }
            }
            else {
                
            }
        }//MARK:- End of for loop
        //MARK:- Sort Rectify Numbers from Server
        arrGuserpic = (temp_arrGuserpic as NSArray).mutableCopy() as! NSMutableArray
        arrGuserFBToken = (temp_arrGuserFBToken as NSArray).mutableCopy() as! NSMutableArray
        arrGuserUid = (temp_arrGuserUid as NSArray).mutableCopy() as! NSMutableArray
        arrGuserid = (temp_arrGuserid as NSArray).mutableCopy() as! NSMutableArray
        arrGusername = (temp_arrGusername as NSArray).mutableCopy() as! NSMutableArray
        arrGRectifyPhone = (temp_arrGRectifyPhone as NSArray).mutableCopy() as! NSMutableArray
        arrGuserphone = (temp_arrGuserphone as NSArray).mutableCopy() as! NSMutableArray

        defaults.setValue(arrGuserUid, forKey: "arrGuserUid")
        defaults.setValue(arrGuserid, forKey: "arrGuserid")
        defaults.setValue(arrGRectifyPhone, forKey: "arrGRectifyPhone")
        group_defaults.setValue(arrGuserUid, forKey: "arrGuserUid")
        group_defaults.setValue(arrGuserid, forKey: "arrGuserid")
        group_defaults.setValue(arrGRectifyPhone, forKey: "arrGRectifyPhone")
        
        let encodedData2nd = NSKeyedArchiver.archivedData(withRootObject: arrGuserpic)
        
        defaults.setValue(encodedData2nd, forKey: "arrGuserpic")
        defaults.setValue(arrGusername, forKey: "arrGusername")
        defaults.setValue(arrGuserFBToken, forKey: "arrGuserFBToken")
        group_defaults.setValue(encodedData2nd, forKey: "arrGuserpic")
        group_defaults.setValue(arrGusername, forKey: "arrGusername")
        group_defaults.setValue(arrGuserFBToken, forKey: "arrGuserFBToken")
        
        defaults.setValue(arrGRectifyPhone, forKey: "arrGRectifyPhone")
        defaults.setValue(arrGuserphone, forKey: "arrGuserphone")
        group_defaults.setValue(arrGRectifyPhone, forKey: "arrGRectifyPhone")
        group_defaults.setValue(arrGuserphone, forKey: "arrGuserphone")
        
        arrGfullname_temp = temparrfullnameFind + temparrfullname
        arrGfname_temp  = temparrfnameFind + temparrfname
        arrGlname_temp  = temparrlnameFind + temparrlname
        arrGnumber_temp = temparrnumberFind + temparrnumber
        let arrPicOne = temparrpicFind as! [Any]
        let arrPicTwo = temparrpic as! [Any]
        let picResult = arrPicOne + arrPicTwo
        arrGpic_temp = NSMutableArray(array:picResult)
        let arrNoOne = temparrnumberWithoutSpacesFind as! [Any]
        let arrNoTwo = temparrnumberWithoutSpaces as! [Any]
        let noResult = arrNoOne + arrNoTwo
        arrGnumberWithoutSpaces_temp = NSMutableArray(array:noResult)
        
        //AppUsers in this case invite button will not show in Contacts List
        arrGfullname_AppUser = temparrfullnameFind
        arrGfname_AppUser = temparrfnameFind
        arrGlname_AppUser = temparrlnameFind
        arrGnumber_AppUser = temparrnumberFind
        arrGnumberWithoutSpaces_AppUser = temparrnumberWithoutSpacesFind
        arrGpic_AppUser = temparrpicFind
        
        defaults.setValue(arrGfullname_AppUser, forKey: "arrGfullname_AppUser")
        defaults.setValue(arrGfname_AppUser, forKey: "arrGfname_AppUser")
        defaults.setValue(arrGlname_AppUser, forKey: "arrGlname_AppUser")
        defaults.setValue(arrGnumber_AppUser, forKey: "arrGnumber_AppUser")
        
        group_defaults.setValue(arrGfullname_AppUser, forKey: "arrGfullname_AppUser")
        group_defaults.setValue(arrGfname_AppUser, forKey: "arrGfname_AppUser")
        group_defaults.setValue(arrGlname_AppUser, forKey: "arrGlname_AppUser")
        group_defaults.setValue(arrGnumber_AppUser, forKey: "arrGnumber_AppUser")
        
        let encodedData_AppUser = NSKeyedArchiver.archivedData(withRootObject: arrGpic_AppUser)
        defaults.set(encodedData_AppUser, forKey: "arrGpic_AppUser")
        group_defaults.set(encodedData_AppUser, forKey: "arrGpic_AppUser")
        //defaults.setValue(arrGpic, forKey: "arrGpic")
        defaults.setValue(arrGnumberWithoutSpaces_AppUser, forKey: "arrGnumberWithoutSpaces_AppUser")
        group_defaults.setValue(arrGnumberWithoutSpaces_AppUser, forKey: "arrGnumberWithoutSpaces_AppUser")
        
        arrGfullname = arrGfullname_temp
        arrGfname = arrGfname_temp
        arrGlname = arrGlname_temp
        arrGnumber = arrGnumber_temp
        arrGpic = arrGpic_temp
        arrGnumberWithoutSpaces = arrGnumberWithoutSpaces_temp
        
        defaults.setValue(arrGfullname, forKey: "arrGfullname")
        defaults.setValue(arrGfname, forKey: "arrGfname")
        defaults.setValue(arrGlname, forKey: "arrGlname")
        defaults.setValue(arrGnumber, forKey: "arrGnumber")
        group_defaults.setValue(arrGfullname, forKey: "arrGfullname")
        group_defaults.setValue(arrGfname, forKey: "arrGfname")
        group_defaults.setValue(arrGlname, forKey: "arrGlname")
        group_defaults.setValue(arrGnumber, forKey: "arrGnumber")
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: arrGpic)
        defaults.set(encodedData, forKey: "arrGpic")
        group_defaults.set(encodedData, forKey: "arrGpic")
        //defaults.setValue(arrGpic, forKey: "arrGpic")
        defaults.setValue(arrGnumberWithoutSpaces, forKey: "arrGnumberWithoutSpaces")
        group_defaults.setValue(arrGnumberWithoutSpaces, forKey: "arrGnumberWithoutSpaces")
        
        if pull == "1" {
            pull = ""
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endRefresh"), object: nil)
        }
        else {
            pull = ""
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopAndicator"), object: nil)
        }
        self.funViewAppear()
    }
    
    func funViewAppear() {
        if isSplash == 0 {
            isSplash = 1
            //openviewConroller()
        }
    }
    func find(value searchValue: String, in array: [String], completion: @escaping (_ userindex: Int?) -> Void) {
        
        let itemsArray = array
        var searchToSearch = searchValue
//        searchToSearch = searchToSearch.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
//        searchToSearch = searchToSearch.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
//        searchToSearch = searchToSearch.trimmingCharacters(in: .whitespaces)
//        searchToSearch = searchToSearch.replacingOccurrences(of: " ", with: "")
//        
        let filteredStrings = itemsArray.filter({(item: String) -> Bool in
            
            let stringMatch = item.lowercased().range(of: searchToSearch.lowercased())
            return stringMatch != nil ? true : false
        })
        
        if filteredStrings.count > 0
        {
            let temparray = array
            for (_, temp) in filteredStrings.enumerated() {
                if temparray.contains(temp){
                    let tempindex = temparray.firstIndex(of: temp)!
                    completion(tempindex)
                }
            }
        }
        else{
            completion(nil)
        }
    }
}

