//
//  Login.swift
//  AMPL
//
//  Created by sameer on 31/05/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Alamofire
import FlagPhoneNumber

// MARKS:- Companies
var arrCAddress = NSArray()
var arrCCity = NSArray()
var arrCSubCategory = NSArray()
var arrCCompany = NSArray()
var arrCCompanyId = NSArray()

//MARK:- SubCategories
var arrSubCName = NSArray()
var arrSubCId = NSArray()
var arrSubIcon = NSArray()
var arrSubIsActive = NSArray()
var arrSubOldId = NSArray()
var arrSubType = NSArray()


class Login: UIViewController, UITextFieldDelegate, PopupDelegate {
    ////////////////////////////////
    var iconClick = Bool()
    var mobilenumber = ""
    ///////////////////////////////
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var txtdisplayname: UITextField!
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var txtphone: FPNTextField!
    
    var txtmobileX = 0.0
    var txtmobileMaxX = 0.0
    
    @IBOutlet weak var btnlogin: UIButton!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  txtusername.text = "03219525315"
      //  txtpassword.text = "123"
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        BottomLineofTextFields()
        //MARK:- Defaults selected country
        self.txtphone.setFlag(key: FPNOBJCCountryKey.PK)
        DispatchQueue.main.async {
            self.txtmobileX = Double(self.txtphone.frame.minX)
            self.txtmobileMaxX = Double(self.txtphone.frame.maxX)
        }
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(funGetCompany), name: NSNotification.Name(rawValue: "funGetCompany"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funGetSubCategories), name: NSNotification.Name(rawValue: "funGetSubCategories"), object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(funSignUp), name: NSNotification.Name(rawValue: "signup"), object: nil)
        
        callCompanies()
    }

    @objc func funSignUp(){
        self.funVerifyNumberInServer()
    }
    @objc func callCompanies(){
        DispatchQueue.main.async {
            if arrCCompanyId.count == 0 {
                self.funGetCompany()
            }
            if arrSubCId.count == 0 {
                self.funGetSubCategories()
            }
        }
    }

    // Marks: - Bottom line of text field
    func BottomLineofTextFields() {
        // Marks: - Buttons Cornor Radius
        btnlogin.layer.cornerRadius = 4
        
       // let color = UIColor(red:66/255.0, green: 165/255.0, blue: 245/255.0, alpha: 1.0).cgColor
        obj.txtbottomline(textfield: txtphone)
        ///////////////////////////
        
//        //MARK : - Button in text field
//        let rightuser = UIView()
//        rightuser.frame = CGRect(x:0, y:0, width:40, height:30)
//        //Set button in the Text Filed right side
//        let btnName = UIButton(type: .custom)
//        btnName.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
//        // btnName.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 20, 20)
//        btnName.setImage(UIImage(named: "showhide"), for: .normal)
//        btnName.addTarget(self, action: #selector(iconAction(sender:)), for: .touchUpInside)
//        rightuser.addSubview(btnName)
//        txtphone.rightView = rightuser
//        txtphone.rightViewMode = .unlessEditing
        /////////////////////////
        //Cornor Raius of only one corner
    }
    
    // Show and hide textfiled passwod text
    @IBAction func iconAction(sender: AnyObject) {
        if(iconClick == true) {
            txtphone.isSecureTextEntry = false
            iconClick = false
        }
        else {
            txtphone.isSecureTextEntry = true
            iconClick = true
        }
    }
    
    //Button Login
    @IBAction func btnlogin(_ sender: Any) {
        //login()
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        //self.navigationController?.pushViewController(vc, animated: true)
//
//        return
        if txtphone.text == "" {
           obj.showAlert(title: "Alert!", message: "Please enter Phone Number", viewController: self)
        }
        else {
            self.funSendPhoneAuth()
        }
    }
    
    // Update FCM ID
    

    func updatefcmOld(idd: String, token: String) {
    
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
        andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
           
            self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "updateGCMResponse")! as Any) as AnyObject).object(forKey:"updateGCMResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    // let mainD = NSDictionary(dictionary: mainDict as! [AnyHashable: Any])
                    
                    self.getuserdetails(idd: idd)
                }
                else{
                    DispatchQueue.main.async {
                           obj.showAlert(title: "Alert", message: "try again", viewController: self)
                    }
                }
            }
            catch {
                print("Your Dictionary value nil")
            }
            if error != nil {
                self.andicator.stopAnimating()
                DispatchQueue.main.async {
                        obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                }

            }
        })
        
        task.resume()
    }
    
    // Get User Details
    func getuserdetails(idd: String) {
        
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
        
        andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Body: \(strData)")
            
           
            self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do {
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
                    
                    if let name = json.value(forKey: "Name") as? String {
                        defaults.setValue(name, forKey: "name")
                    }
                    if let roletitle = json.value(forKey: "RoleTitle") as? String {
                        defaults.setValue(roletitle, forKey: "role")
                    }
                    if let username = json.value(forKey: "username") as? String {
                        defaults.setValue(username, forKey: "username")
                    }
                    if let email = json.value(forKey: "email") as? String {
                        defaults.setValue(email, forKey: "email")
                    }
                    if let mobile = json.value(forKey: "mobile") as? String {
                        defaults.setValue(mobile, forKey: "mobile")
                    }
                    var idd = String()
                    if let userid = json.value(forKey: "id") as? Int {
                        defaults.setValue(String(userid), forKey: "userid")
                        group_defaults.setValue(String(userid), forKey: "userid")
                        idd  = String(userid)
                    }
                    if let profile_img = json.value(forKey: "profile_img") as? String {
                        defaults.setValue(profile_img, forKey: "profileimg")
                    }
                    
                    defaults.setValue("1", forKey: "islogin")
                    defaults.setValue(self.mobilenumber, forKey: "mobileno")
                    defaults.setValue(COUNTRYCODE, forKey: "countrycode")
                    //defaults.setValue(self.txtphone.text!, forKey: "password")
                    // let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
                    // self.navigationController?.pushViewController(vc, animated: true)
                    self.getuserrole(idd: String(idd))
                }
                else{
                    DispatchQueue.main.async {
                            obj.showAlert(title: "Alert", message: "try again", viewController: self)
                    }
                }
                
            }
            catch {
                print("Your Dictionary value nil")
            }

            if error != nil {
                self.andicator.stopAnimating()
                DispatchQueue.main.async
                    {
                        obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                }
            }
        })
        task.resume()
    }
    
    func loginVC() {
        defaults.setValue("1", forKey: "islogin")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        DispatchQueue.main.async{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Get User Role
    func getuserrole(idd: String){
        
        let version = appver
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
        
        andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Body: \(strData)")
            
                        self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "CheckForFunctionalitiesResponse")! as Any) as AnyObject).object(forKey:"CheckForFunctionalitiesResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0 {
                    
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
                    
                    if let IsAdmin = json.value(forKey: "IsAdmin") as? Int {
                        defaults.setValue(String(IsAdmin), forKey: "isadmin")
                    }
                    if let IsMember = json.value(forKey: "IsMember") as? String {
                        defaults.setValue(IsMember, forKey: "ismember")
                    }
                    if let IsNews = json.value(forKey: "IsNews") as? String {
                        defaults.setValue(IsNews, forKey: "isnews")
                    }
                    if let Tray1 = json.value(forKey: "Tray1") as? String {
                        defaults.setValue(Tray1, forKey: "tray1")
                    }
                    if let Tray2 = json.value(forKey: "Tray2") as? String {
                        defaults.setValue(Tray2, forKey: "tray2")
                    }
                    if let membershiprequest = json.value(forKey: "membershiprequest") as? String {
                        defaults.setValue(membershiprequest, forKey: "membershiprequest")
                    }
                    if let role = json.value(forKey: "role") as? String
                    {
                        defaults.setValue(role, forKey: "role")
                    }
                    defaults.setValue("1", forKey: "islogin")
                    defaults.setValue(self.mobilenumber, forKey: "mobileno")
                    defaults.setValue(COUNTRYCODE, forKey: "countrycode")
                    //defaults.setValue(self.txtphone.text!, forKey: "password")
                    defaults.setValue(nil, forKey: "logout")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
                    DispatchQueue.main.async {
                            self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    DispatchQueue.main.async
                        {
                           obj.showAlert(title: "Alert", message: "try again", viewController: self)
                    }
                }
            }
            catch {
                print("Your Dictionary value nil")
            }
            if error != nil {
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        task.resume()
    }
    
    // Get Location Name from Latitude and Longitude
    func funLogin() {
        mobilenumber = mobilenumber.replacingOccurrences(of: " ", with: "")
        
        let url = BASEURL+"user/AuthenticateUsers?mobileNo=\(mobilenumber)&userName=\(mobilenumber)&password=\(txtdisplayname.text!)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGet(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSArray)[0] as! NSDictionary
                            if datadic.count == 1 {
                                let success = datadic.value(forKey: "r") as! String
                                if success == "-1" {
                                    //Not Register
                                    obj.showAlert(title: "Alert!", message: "Invalid username or password", viewController: self)
                                }
                            }
                            else
                            {
                                if let tempr = datadic.value(forKey: "r") as? String{
                                    if tempr == "-3" {
                                        obj.showAlert(title: "Alert!", message: datadic.value(forKey: "message" ) as! String, viewController: self)
                                    }
                                    else if tempr == "-1" {
                                        obj.showAlert(title: "Alert!", message: datadic.value(forKey: "message" ) as! String, viewController: self)
                                    }
                                    else if tempr == "-2" {
                                        obj.showAlert(title: "Alert!", message: datadic.value(forKey: "message" ) as! String, viewController: self)
                                    }
                                }
                                else{
                                    let tempuserid = "\(datadic.value(forKey: "id") as! Int)"
                                    if let isvarified = datadic.value(forKey: "is_verified") as? String {
                                        defaults.setValue(isvarified, forKey: "is_verified")
                                    }
                                    else {
                                        defaults.setValue("0", forKey: "is_verified")
                                    }
                                    defaults.setValue(tempuserid, forKey: "userid")
                                    group_defaults.setValue(String(tempuserid), forKey: "userid")
                                    defaults.setValue("1", forKey: "islogin")
                                    defaults.setValue(self.mobilenumber, forKey: "mobileno")
                                    defaults.setValue(COUNTRYCODE, forKey: "countrycode")
                                    self.loginVC()
                                }
                            }
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
    
    
    // Marks: - textfield Delegates Resign all fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Marks: - Uitextfields delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.view.endEditing(true)
        if textField == txtdisplayname { // Switch focus to other text field
           // txtphone.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        eview.dismiss()
        return true
    }
    
    @objc func funGetCompany() {
        let url = BASEURL+"company/get"
        //andicator.startAnimating()
        
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary).value(forKey: "data") as! NSArray
                            if datadic.count > 0 {
                                arrCAddress = datadic.value(forKey: "Address") as! NSArray
                                arrCCity = datadic.value(forKey: "City") as! NSArray
                                arrCSubCategory = datadic.value(forKey: "SubCategory") as! NSArray
                                arrCCompany = datadic.value(forKey: "company") as! NSArray
                                arrCCompanyId = datadic.value(forKey: "company_id") as! NSArray
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funCompanyRefresh"), object: nil)
                            }
                            else {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                        self.funGetCompany()
                    }
                }
        })
    }
 
    @objc func funGetSubCategories() {
        let url = BASEURL+"subcategory/get"
        //andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                //self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary).value(forKey: "data") as! NSArray
                            if datadic.count > 0 {
                                arrSubCName = datadic.value(forKey: "BSCategory") as! NSArray
                                arrSubCId = datadic.value(forKey: "BSCategoryId") as! NSArray
                                arrSubIcon = datadic.value(forKey: "ImgSrc") as! NSArray
                                arrSubIsActive = datadic.value(forKey: "IsActive") as! NSArray
                                arrSubOldId = datadic.value(forKey: "OldID") as! NSArray
                                arrSubType = datadic.value(forKey: "Type") as! NSArray
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funCompanyRefresh"), object: nil)
                            }
                            else {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                        self.funGetSubCategories()
                    }
                }
        })
    }
    
    // Get Location Name from Latitude and Longitude
    func funVerifyNumberInServer() {
        mobilenumber = mobilenumber.replacingOccurrences(of: "+", with: "")
        mobilenumber = mobilenumber.replacingOccurrences(of: " ", with: "")
        let url = BASEURL+"user/VerifyMobileNo?mobileNo=\(mobilenumber)"
        //http://epoultryapi.zederp.net/api/user/34
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGet(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSArray)[0] as! NSDictionary
                            if datadic.count == 1 {
                                let success = datadic.value(forKey: "r") as! String
                                if success == "-1" {
                                    //Not Register
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Signup") as! Signup
                                    vc.mobilenumber = self.mobilenumber
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else {
                                //Already Register
                                let tempuserid = "\(datadic.value(forKey: "id") as! Int)"
                                if let isvarified = datadic.value(forKey: "is_verified") as? String {
                                    defaults.setValue(isvarified, forKey: "is_verified")
                                }
                                else {
                                    defaults.setValue("0", forKey: "is_verified")
                                }
                                
                                group_defaults.setValue(tempuserid, forKey: "userid")
                                defaults.setValue(tempuserid, forKey: "userid")
                                defaults.setValue(datadic.value(forKey: "FirstName") as? String, forKey: "fullname")
                                group_defaults.setValue(datadic.value(forKey: "FirstName") as? String, forKey: "fullname")
                                defaults.setValue(self.mobilenumber, forKey: "mobileno")
                                defaults.setValue(COUNTRYCODE, forKey: "countrycode")
                                self.fbRegistration(mobileNo: self.mobilenumber)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                            }
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            obj.showAlert(title: "Error", message: error?.debugDescription ?? "Error Occurred! try again" , viewController: self)
                        }
                     }
                }
        })
    }
    
    
    func funSendPhoneAuth() {
        andicator.startAnimating()
        var code = "\(self.txtphone.selectedCountry!.phoneCode)"
        COUNTRYCODE = code
        mobilenumber = code + txtphone.text!
        code = code.replacingOccurrences(of: "+", with: "")
        mobilenumber = mobilenumber.replacingOccurrences(of: " ", with: "")
        objG.showVerificationPopup(string: "textstring", viewController: self)
        DispatchQueue.main.async {
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(("\(self.mobilenumber)"), uiDelegate: nil){
                    (verificationID, error) in
                self.andicator.stopAnimating()
                if error != nil {
                    obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                    return
                }
                else {
                    GlobalFireBaseverficationID = verificationID!
                    objG.showVerificationPopup(string: "textstring", viewController: self)
                }
            }
        }
    }
    
    func btnConfirmPressed(code: String) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: GlobalFireBaseverficationID,
            verificationCode: code)
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            if error != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopandicator"), object: nil)
                
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                return
            }
            else {
                objG.removeVerificationPopup()
                self.funVerifyNumberInServer()
            }
        })
    }
    
    
    //MARK:- Firebase Registration Check
    @objc func fbRegistration(mobileNo: String) {
        var fcmtoken = ""
        if let token = defaults.value(forKey: "fcmtoken") as? String {
            fcmtoken = token
        }
        else
        { fcmtoken = "texttoken"}
        let url = "\(BASEURLaONECHAT)User/RegisterUserV3"
        print(url)
        let fullname = defaults.value(forKey: "fullname")
        guard let userID = Auth.auth().currentUser?.uid else {
            obj.showAlert(title: "Alert!", message: "Please wait try again!", viewController: self)
            return
        }
        let parameters : Parameters =
            ["id":defaults.value(forKey: "userid")!,
             "profilePic": "default.jpg",
             "token": fcmtoken,
             "mac": "\(String(UIDevice.current.identifierForVendor!.uuidString))",
             "cellNum": mobileNo,
             "email": "",
             "version": APPVERSIONNUMBER!,
             "name":fullname!,
             "firebaseUserId":userID,
             "source": "ios",
             "osVersion": IPHONESOSVERSION,
             "brand": "APPLE",
             "imei": "\(String(UIDevice.current.identifierForVendor!.uuidString))"]
        
        obj.webService(url: url, parameters: parameters, completionHandler: { responseObject, error in
            
            if error == nil && responseObject != nil {
                if (responseObject!.value(forKey: "data") as? Int) != nil {
                    obj.showAlert(title: "Alert!", message: responseObject?.value(forKey: "message") as! String, viewController: self)
                    return
                }
                
                if responseObject!.value(forKey: "data") is NSArray {
                    let dataarr = responseObject!.value(forKey: "data") as! NSArray
                    let datadic = dataarr[0] as! NSDictionary
                    if datadic.count > 0 {
                        self.funUserUpdate()
                    }
                    else {
                        obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                    }
                }
                else {
                    if responseObject != nil && ((responseObject?.value(forKey: "Message") as? String) != nil) {
                        //MARK:- Its means there is error
                        self.funUserUpdate()
                        return
                    }
                }
            }
            else {
                if error == nil {
                    obj.showAlert(title: "Error!", message: ("error?.description"), viewController: self)
                    return
                }
                obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
            }
        })
    }
    
    func funUserUpdate() {
     let timespam = Date().currentTimeMillis()!
     var fcmtoken = ""
     if let token = defaults.value(forKey: "fcmtoken") as? String {
         fcmtoken = token
     }
     else { fcmtoken = "texttoken"}
     //let url = DataContainer.baseUrl()+"/user"
     
     let fullname = defaults.value(forKey: "fullname") as! String
     
     guard let userID = Auth.auth().currentUser?.uid else {
         obj.showAlert(title: "Alert!", message: "Please wait try again!", viewController: self)
         return }
     ///// Save user Info
     UserDB.child(userID).setValue([
         "UserName"              : fullname,
         "UserLink"              : "1.png",
         "UserStatus"            : "",
         "UserPhoneNumber"       : defaults.value(forKey: "mobileno") as! String,
         "UserCountryCode"       : COUNTRYCODE!,
         "user_id"               : USERID,
         "UserDeviceId"          : DEVICEID,
         "fcmId"                 : fcmtoken,
         "Source"                : "ios",
         "onLine"                : timespam,
         "onLineUpdatedAt"       : timespam]
         as [String :Any], withCompletionBlock: { error, ref in
             
             if error == nil {
                 ///// Save user Location
                 defaults.setValue(ref.key, forKey: "uid")
                 defaults.setValue(userID, forKey: "uidIfLogout")
                 defaults.setValue(fullname, forKey: "username")
                 defaults.setValue("", forKey: "userstatus")
                 
                 defaults.setValue("\(defaults.value(forKey: "mobileno") as! String)", forKey: "phoneno")
                 let splashObj = Splash()
                 splashObj.sinchLogin(userid: "\(defaults.value(forKey: "mobileno") as! String)" + "_" + "\(defaults.value(forKey: "userid") as! String)")
                
                self.funUserLogin()
             }
             else {
                 obj.showAlert(title: "Error", message: error.debugDescription, viewController: self)
             }
        })
    }
    func funUserLogin() {
        let url = BASEURL+"user/\(USERID)"
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:{
                       responseObject, error in
                       self.andicator.stopAnimating()
                       //print(responseObject)
                       DispatchQueue.main.async {
                           if error == nil && responseObject != nil{
                               if responseObject!.count > 0 {
                                   let datadic = (responseObject! as NSDictionary)
                                   if datadic.count == 1 {
                                    let tempdata = (datadic.value(forKey: "Data") as! NSArray)[0] as! NSDictionary
                                        if tempdata.count > 0 {
                                            if let roletitle = tempdata.value(forKey: "IsAdmin") as? Int
                                             {
                                                 defaults.setValue("\(roletitle)", forKey: "role")
                                             }
                                            defaults.setValue("1", forKey: "autologin")
                                            self.loginVC()
                                        } else{
                                            obj.showAlert(title: "Error!", message: "try again please..", viewController: self)
                                        }
                                   }
                                   else {
                                       //Already Register
                                       let tempuserid = "\(datadic.value(forKey: "id") as! Int)"
                                       if let isvarified = datadic.value(forKey: "is_verified") as? String {
                                           defaults.setValue(isvarified, forKey: "is_verified")
                                       }
                                       else
                                       {
                                           defaults.setValue("0", forKey: "is_verified")
                                       }
                                       
                                       group_defaults.setValue(tempuserid, forKey: "userid")
                                       defaults.setValue(tempuserid, forKey: "userid")
                                       defaults.setValue(datadic.value(forKey: "FirstName") as? String, forKey: "fullname")
                                       group_defaults.setValue(datadic.value(forKey: "FirstName") as? String, forKey: "fullname")
                                       defaults.setValue(self.mobilenumber, forKey: "mobileno")
                                       defaults.setValue(COUNTRYCODE, forKey: "countrycode")
                                    //self.funUserLogin()
                                    //if chat implmented
                                       DispatchQueue.main.async{
                                           self.fbRegistration(mobileNo: self.mobilenumber)
                                       }
                                   }
                               }
                               else {
                                    obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                                }
                           }
                           else {
                            obj.showAlert(title: "Error", message: error?.debugDescription ?? "Error Occurred! try again" , viewController: self)
                        }
            }
        })
    }
}
extension Login: FPNTextFieldDelegate {
    func fpnDisplayCountryList() {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.rightViewMode = .always
        //textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "flag") : #imageLiteral(resourceName: "PK"))
        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
            textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
            textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
            textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
            textField.getRawPhoneNumber() ?? "Raw: nil"
        )
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }
}
