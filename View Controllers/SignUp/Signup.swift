//
//  Signup.swift
//  AMPL
//
//  Created by sameer on 31/05/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import CZPicker
import FirebaseAuth
import Alamofire
import FlagPhoneNumber

class Signup: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var isMobileVerify = false
    var countrycount = Int()
     var citycount = Int()
    
    var compId = String()
    var updateSubCompanyName = String()
    ///////////////////////////////////////////
    // Marks: - Countries
    var arridcon = [String]()
    var arrisactivecon = [String]()
    var arrcodecon = [String]()
    var arrnamecon = [String]()
    
    // Marks: - Cities
    var arrcity = [String]()
    var arrcityid = [String]()
    
    //////////// Marks: - Picker view in keyboard
    var pickerView = UIPickerView()
    
    var myView = UIView()
    var mobilenumber = ""
    
    //////////////////////////////////////////
    @IBOutlet weak var contentv: UIView!
    @IBOutlet weak var scrollv: UIScrollView!
    
    @IBOutlet weak var txtfname: UITextField!
    @IBOutlet weak var txtpass: UITextField!
    @IBOutlet weak var txtcpass: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtmobile: FPNTextField!
    
    @IBOutlet weak var txtcompnay: UITextField!

    @IBOutlet weak var btnsignup: UIButton!
    @IBOutlet weak var btncheck: UIButton!
    
    @IBOutlet weak var btnlogin: UIButton!
    
    @IBAction func btnlogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnAddNewCompany: UIButton!
    
    var vcontainer = UIView()
    @IBAction func btnAddNewCompany(_ sender: Any) {
        if !isMobileVerify{
            obj.showAlert(title: "Verify!", message: "Please verify you mobile number before add new company", viewController: self)
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCompany") as! AddNewCompany
        let tempnumber = "\(self.txtmobile.selectedCountry!.phoneCode)\(txtmobile.text!)"
        
        vc.phonenumber = tempnumber
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var btnverifyno: UIButton!
    
    @IBAction func btnverifyno(_ sender: Any) {
        if btnverifyno.titleLabel!.text == "CHANGE"{
            self.btnverifyno.setTitleColor(.black, for: .normal)
            self.btnverifyno.setTitle("VERIFY", for: .normal)
            self.txtmobile.isUserInteractionEnabled = true
            self.txtmobile.text = nil
            self.txtmobile.becomeFirstResponder()
            self.isMobileVerify = false
            self.txtmobile.textColor = .black
            return
        }
        if txtmobile.text?.isEmpty == true{
            obj.showAlert(title: "Mobile No!", message: "Please enter valid mobile no", viewController: self)
        }
        else{
            funVerifyNumberInServer()
        }
    }
    @IBOutlet weak var andicator: UIActivityIndicatorView!

    @IBOutlet weak var btnSelectCompany: UIButton!
    @IBAction func btnSelectCompany(_ sender: Any) {
        //MARK:- Select Company
        if arrCCompanyId.count == 0{
            obj.showAlert(title: "Alert!", message: "Please wait to upload companies", viewController: self)
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCompany") as! AddCompany
        vc.isAddCompany = true
        vc.arrCAddress = arrCAddress
        vc.arrCCity = arrCCity
        vc.arrCSubCategory = arrCSubCategory
        vc.arrCCompany = arrCCompany
        vc.arrCCompanyId = arrCCompanyId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //////////////////////////////////////////////////////
    var arrcountries = [String]()
    var arrcities = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        // Marks: - Buttons Cornor Radius
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        countrycount = 0
        citycount = 0
        self.isMobileVerify = true
        DispatchQueue.main.async{
       // self.mobilenumber = "923460754392"
            //MARK:- Defaults selected country
            self.txtmobile.set(phoneNumber: "+" + self.mobilenumber)
        }
        // Marks: - Pickerview in keyboard
//        myView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
//        
//        let doneButton = UIButton(frame: CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: 30))
//        doneButton.setTitle("Done", for: UIControlState.normal)
//        doneButton.setTitleColor(UIColor.white, for: UIControlState.normal)
//        doneButton.backgroundColor = appcolor
//        
//        // add Button to UIView
//        myView.addSubview(doneButton)
//        // set button click event
//        doneButton.addTarget(self, action: #selector(self.donePressed), for: UIControlEvents.touchUpInside)
//        
//        pickerView = UIPickerView(frame: CGRect(x: 0,y: 30,width: self.view.frame.width, height: 170))
//        
//        // add picker to UIView
//        myView.addSubview(pickerView)
//        
//        txtcountry.inputView = myView
//        txtcity.inputView = myView
//        
//        pickerView.delegate = self
//        pickerView.dataSource = self
        ////////////////////////////Pickerview in keyboard
        DispatchQueue.main.async{
            self.BottomLineofTextFields()
        }
        
        ///////////
        self.contentv.frame.size.width = self.contentv.frame.size.width
        
        self.contentv.frame.size.height = self.btnsignup.frame.maxY + 150
        
        
        var contentRect = CGRect()
        for view in self.scrollv.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.scrollv.contentSize = contentRect.size
        
        NotificationCenter.default.removeObserver(self)
       // NotificationCenter.default.addObserver(self, selector: #selector(confirmpress), name: NSNotification.Name(rawValue: "verificationconfirmed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funSelectCompany), name: NSNotification.Name(rawValue: "selectCompany"), object: nil)
       
        DispatchQueue.main.async {
//            if arrCCompanyId.count == 0{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funGetCompany"), object: nil)
//            }
//            if arrSubCId.count == 0{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funGetSubCategories"), object: nil)
//            }
        }
    }
   
    func BottomLineofTextFields()
    {
        //MARK: - Button Check
        btnverifyno.layer.cornerRadius = 3
        btnverifyno.layer.borderColor = UIColor.black.cgColor
        btnverifyno.layer.borderWidth = 1.0
        
        // Marks: - Buttons Cornor Radius
        btnsignup.layer.cornerRadius = 4
        
        // Marks: - text field border width and colotd
        
        obj.txtbottomline(textfield: txtfname)
        obj.txtbottomline(textfield: txtpass)
        obj.txtbottomline(textfield: txtcpass)
        obj.txtbottomline(textfield: txtemail)
        obj.txtbottomline(textfield: txtmobile)
        obj.txtbottomline(textfield: txtcompnay)
        
    }
    
    // MARKS: - button check
    @IBAction func btncheck(_ sender: Any) {
        
        if txtfname.text == ""
        {
            obj.showAlert(title: "Alert!", message: "Please enter first name.", viewController: self)
        }
        else
        {
            funVerifyUserNameInServer()
        }
    }
    
    // Marks: - button signup
    @IBAction func btnsignup(_ sender: Any) {
        
        if txtfname.text == "" {
            obj.showAlert(title: "Alert!", message: "Please enter first name.", viewController: self)
        }
        else if txtpass.text == "" {
            obj.showAlert(title: "Alert!", message: "Please enter password.", viewController: self)
        }
        else if txtcpass.text == "" {
            obj.showAlert(title: "Alert!", message: "Please enter confirm password.", viewController: self)
        }
        else if txtpass.text != txtcpass.text {
            obj.showAlert(title: "Alert!", message: "Your password and confirm password is not match.", viewController: self)
        }
        else if txtcompnay.text == "" {
            obj.showAlert(title: "Alert!", message: "Please enter compnay.", viewController: self)
        }
        else {
            funUserRegister()
        }
    }

    // Marks: - Uitextfields delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    // Marks: - Scroll view delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    // Marks: - Signup function
    
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
        
        andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
            self.andicator.stopAnimating()
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
                    
                    defaults.setValue("1", forKey: "islogin")
                    defaults.setValue(self.txtmobile.text!, forKey: "mobileno")
                    defaults.setValue(self.txtpass.text!, forKey: "password")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.getuserrole(idd: String(idd))
                }
                else{
                    obj.showAlert(title: "Alert!", message: "", viewController: self)
                }
                
            }
            catch
            {
                print("Your Dictionary value nil")
            }

            if error != nil
            {
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
        // AFNETWORKING REQUEST
        
        // let mn = AFHTTPRequestOperation()
        
//        let manager = AFHTTPRequestOperation(request: mutableR as URLRequest)
//        
//        andicator.startAnimating()
//        manager.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation, responseObject : Any) -> Void in
//            
//            self.andicator.stopAnimating()
//            var dictionaryData = NSDictionary()
//            
//            do
//            {
//                dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! Data)) as NSDictionary
//                
//                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UserDetailsResponse")! as Any) as AnyObject).object(forKey:"UserDetailsResult")   ?? NSDictionary()
//                
//                
//                
//                if (mainDict as AnyObject).count > 0{
//                    
//                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//                    
//                    var text = mainD.value(forKey: "text") as! NSString
//                    
//                    
//                    
//                    text = text.replacingOccurrences(of: "[", with: "") as NSString
//                    text = text.replacingOccurrences(of: "]", with: "") as NSString
//                    
//                    
//                    var json = NSDictionary()
//                    if let data = text.data(using: String.Encoding.utf8.rawValue) {
//                        do {
//                            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
//                            //print(json.value(forKey: "id"))
//                            
//                        } catch {
//                            print("Something went wrong")
//                        }
//                    }
//                    
//                    
//                    if let roletitle = json.value(forKey: "RoleTitle") as? String
//                    {
//                        defaults.setValue(roletitle, forKey: "role")
//                    }
//                    if let username = json.value(forKey: "username") as? String
//                    {
//                        defaults.setValue(username, forKey: "username")
//                    }
//                    if let email = json.value(forKey: "email") as? String
//                    {
//                        defaults.setValue(email, forKey: "email")
//                    }
//                    if let mobile = json.value(forKey: "mobile") as? String
//                    {
//                        defaults.setValue(mobile, forKey: "mobile")
//                    }
//                  var idd = String()
//                    if let userid = json.value(forKey: "id") as? Int
//                    {
//                        defaults.setValue(String(userid), forKey: "userid")
//                        idd  = String(userid)
//                    }
//                    
//                    defaults.setValue("1", forKey: "islogin")
//                    defaults.setValue(self.txtusername.text!, forKey: "mobileno")
//                    defaults.setValue(self.txtpass.text!, forKey: "password")
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    self.getuserrole(idd: String(idd))
//                }
//                else{
//                     obj.showAlert(title: "Alert!", message: "", viewController: self)
//                }
//                
//            }
//            catch
//            {
//                print("Your Dictionary value nil")
//            }
//            
//            print(dictionaryData)
//            
//            
//        }, failure: { (operation : AFHTTPRequestOperation, error :Error) -> Void in
//            
//            print(error, terminator: "")
//            self.andicator.stopAnimating()
//            obj.showAlert(title: "Alert!", message: error.localizedDescription, viewController: self)
//        })
//        
//        manager.start()
        
    }
    
    // Get User Role
    func getuserrole(idd: String){
        
        let version = "1.5.9"
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
            self.andicator.stopAnimating()
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
                    
                    defaults.setValue("1", forKey: "islogin")
                    defaults.setValue(self.txtmobile.text!, forKey: "mobileno")
                    defaults.setValue(self.txtpass.text!, forKey: "password")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    
                    obj.showAlert(title: "Alert!", message: "", viewController: self)
                }
                
            }
            catch
            {
                print("Your Dictionary value nil")
            }

            if error != nil
            {
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()

        // AFNETWORKING REQUEST
        
        // let mn = AFHTTPRequestOperation()
        
//        let manager = AFHTTPRequestOperation(request: mutableR as URLRequest)
//        
//        andicator.startAnimating()
//        manager.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation, responseObject : Any) -> Void in
//            
//            self.andicator.stopAnimating()
//            var dictionaryData = NSDictionary()
//            
//            do
//            {
//                dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! Data)) as NSDictionary
//                
//                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "CheckForFunctionalitiesResponse")! as Any) as AnyObject).object(forKey:"CheckForFunctionalitiesResult")   ?? NSDictionary()
//                
//                
//                
//                if (mainDict as AnyObject).count > 0{
//                    
//                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//                    
//                    var text = mainD.value(forKey: "text") as! NSString
//                    
//                    
//                    
//                    text = text.replacingOccurrences(of: "[", with: "") as NSString
//                    text = text.replacingOccurrences(of: "]", with: "") as NSString
//                    
//            
//                    var json = NSDictionary()
//                    if let data = text.data(using: String.Encoding.utf8.rawValue) {
//                        do {
//                            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
//                            //print(json.value(forKey: "id"))
//                            
//                        } catch {
//                            print("Something went wrong")
//                        }
//                    }
//                    
//                    if let IsAdmin = json.value(forKey: "IsAdmin") as? Int
//                    {
//                        defaults.setValue(String(IsAdmin), forKey: "isadmin")
//                    }
//                    if let IsMember = json.value(forKey: "IsMember") as? String
//                    {
//                        defaults.setValue(IsMember, forKey: "ismember")
//                    }
//                    if let IsNews = json.value(forKey: "IsNews") as? String
//                    {
//                        defaults.setValue(IsNews, forKey: "isnews")
//                    }
//                    if let Tray1 = json.value(forKey: "Tray1") as? String
//                    {
//                        defaults.setValue(Tray1, forKey: "tray1")
//                    }
//                    if let Tray2 = json.value(forKey: "Tray2") as? String
//                    {
//                        defaults.setValue(Tray2, forKey: "tray2")
//                    }
//                    if let membershiprequest = json.value(forKey: "membershiprequest") as? String
//                    {
//                        defaults.setValue(membershiprequest, forKey: "membershiprequest")
//                    }
//                    if let role = json.value(forKey: "role") as? String
//                    {
//                        defaults.setValue(role, forKey: "role")
//                    }
//                    
//                    defaults.setValue("1", forKey: "islogin")
//                    defaults.setValue(self.txtusername.text!, forKey: "mobileno")
//                    defaults.setValue(self.txtpass.text!, forKey: "password")
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    
//                }
//                else{
//                    
//                    obj.showAlert(title: "Alert!", message: "", viewController: self)
//                }
//                
//            }
//            catch
//            {
//                print("Your Dictionary value nil")
//            }
//            
//            print(dictionaryData)
//            
//            
//        }, failure: { (operation : AFHTTPRequestOperation, error :Error) -> Void in
//            
//            print(error, terminator: "")
//            self.andicator.stopAnimating()
//            obj.showAlert(title: "Alert!", message: error.localizedDescription, viewController: self)
//        })
//        
//        manager.start()
        
    }
    
    // Send message to all user from FCM
    func sendmessagealluser(idd: String){
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><CheckForFunctionalities xmlns='http://threepin.org/'><id>\(idd)</id><version>string</version></CheckForFunctionalities></soap:Body></soap:Envelope>"
        
        
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
                    
                    obj.showAlert(title: "Alert!", message: "", viewController: self)
                }
                
            }
            catch
            {
                print("Your Dictionary value nil")
            }

            if error != nil
            {
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()

        // AFNETWORKING REQUEST
        
        // let mn = AFHTTPRequestOperation()
        
//        let manager = AFHTTPRequestOperation(request: mutableR as URLRequest)
//        
//        andicator.startAnimating()
//        manager.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation, responseObject : Any) -> Void in
//            
//            self.andicator.stopAnimating()
//            var dictionaryData = NSDictionary()
//            
//            do
//            {
//                dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! Data)) as NSDictionary
//                
//                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "CheckForFunctionalitiesResponse")! as Any) as AnyObject).object(forKey:"CheckForFunctionalitiesResult")   ?? NSDictionary()
//                
//                
//                
//                if (mainDict as AnyObject).count > 0{
//                    
//                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//                    
//                    var text = mainD.value(forKey: "text") as! NSString
//                    
//                    
//                    
//                    text = text.replacingOccurrences(of: "[", with: "") as NSString
//                    text = text.replacingOccurrences(of: "]", with: "") as NSString
//                    
//                    
//                    var json = NSDictionary()
//                    if let data = text.data(using: String.Encoding.utf8.rawValue) {
//                        do {
//                            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
//                            //print(json.value(forKey: "id"))
//                            
//                        } catch {
//                            print("Something went wrong")
//                        }
//                    }
//                    
//                    if let IsAdmin = json.value(forKey: "IsAdmin") as? Int
//                    {
//                        defaults.setValue(String(IsAdmin), forKey: "isadmin")
//                    }
//                    if let IsMember = json.value(forKey: "IsMember") as? String
//                    {
//                        defaults.setValue(IsMember, forKey: "ismember")
//                    }
//                    if let IsNews = json.value(forKey: "IsNews") as? String
//                    {
//                        defaults.setValue(IsNews, forKey: "isnews")
//                    }
//                    if let Tray1 = json.value(forKey: "Tray1") as? String
//                    {
//                        defaults.setValue(Tray1, forKey: "tray1")
//                    }
//                    if let Tray2 = json.value(forKey: "Tray2") as? String
//                    {
//                        defaults.setValue(Tray2, forKey: "tray2")
//                    }
//                    if let membershiprequest = json.value(forKey: "membershiprequest") as? String
//                    {
//                        defaults.setValue(membershiprequest, forKey: "membershiprequest")
//                    }
//                    if let role = json.value(forKey: "role") as? String
//                    {
//                        defaults.setValue(role, forKey: "role")
//                    }
//                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    
//                }
//                else{
//                    
//                    obj.showAlert(title: "Alert!", message: "", viewController: self)
//                }
//                
//            }
//            catch
//            {
//                print("Your Dictionary value nil")
//            }
//            
//            print(dictionaryData)
//            
//            
//        }, failure: { (operation : AFHTTPRequestOperation, error :Error) -> Void in
//            
//            print(error, terminator: "")
//            self.andicator.stopAnimating()
//            obj.showAlert(title: "Alert!", message: error.localizedDescription, viewController: self)
//        })
//        
//        manager.start()
        
    }
    
    
    // Marks: - Get Countries
    func GetCountries()
    {
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetCountries xmlns='http://threepin.org/' /></soap:Body></soap:Envelope>"
        
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/EPoultryDirectory.asmx"
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
            DispatchQueue.main.async {
                self.andicator.stopAnimating()
            }
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetCountriesResponse")! as Any) as AnyObject).object(forKey:"GetCountriesResult")   ?? NSDictionary()
                
                
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    //text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Please try again with other user", viewController: self)
                    }
                    else
                    {
                        let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        
                        for dict in json {
                            // dump(dict)
                            
                            
                            var id = String()
                            var code = String()
                            var name = String()
                            var isactive = Bool()
                            
                            if let idtemp = dict.value(forKey: "Id") as? Int
                            {
                                id = String(idtemp) as String
                            }
                            else
                            {
                                id = ""
                            }
                            if let isactivetemp = dict.value(forKey: "IsActive") as? Bool
                            {
                                isactive = isactivetemp
                            }
                            else
                            {
                                isactive = false
                            }
                            if let countrycodetemp = dict.value(forKey: "CountryCode") as? String
                            {
                                code = countrycodetemp
                            }
                            else
                            {
                                code = ""
                            }
                            if let countrynametemp = dict.value(forKey: "CountryName") as? String
                            {
                                name = countrynametemp
                            }
                            else
                            {
                                name = ""
                            }
                            
                            self.arridcon.append(id as String)
                            self.arrcodecon.append(code)
                            self.arrcountries.append(name)
                            
                            if isactive == true
                            {
                                self.arrisactivecon.append("1")
                            }
                            else
                            {
                                self.arrisactivecon.append("0")
                            }
                            
                        }
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
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()

        
        // AFNETWORKING REQUEST
        
        // let mn = AFHTTPRequestOperation()
        
//        let manager = AFHTTPRequestOperation(request: mutableR as URLRequest)
//        
//        andicator.startAnimating()
//        manager.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation, responseObject : Any) -> Void in
//            
//            self.andicator.stopAnimating()
//            var dictionaryData = NSDictionary()
//            
//            do
//            {
//                dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! Data)) as NSDictionary
//                
//                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetCountriesResponse")! as Any) as AnyObject).object(forKey:"GetCountriesResult")   ?? NSDictionary()
//                
//                
//                
//                if (mainDict as AnyObject).count > 0{
//                    
//                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//                    
//                    let text = mainD.value(forKey: "text") as! NSString
//                   // text = text.replacingOccurrences(of: "[", with: "") as NSString
//                    //text = text.replacingOccurrences(of: "]", with: "") as NSString
//            
//                    
//                    if text == "0"
//                    {
//                        obj.showAlert(title: "Alert!", message: "Please try again with other user", viewController: self)
//                    }
//                    else
//                    {
//                        let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
//            
//                        for dict in json {
//                            // dump(dict)
//                            
//                            
//                            var id = String()
//                            var code = String()
//                            var name = String()
//                            var isactive = Bool()
//                            
//                            if let idtemp = dict.value(forKey: "Id") as? Int
//                            {
//                                id = String(idtemp) as String
//                            }
//                            else
//                            {
//                                id = ""
//                            }
//                            if let isactivetemp = dict.value(forKey: "IsActive") as? Bool
//                            {
//                                isactive = isactivetemp
//                            }
//                            else
//                            {
//                                isactive = false
//                            }
//                            if let countrycodetemp = dict.value(forKey: "CountryCode") as? String
//                            {
//                                code = countrycodetemp
//                            }
//                            else
//                            {
//                                code = ""
//                            }
//                            if let countrynametemp = dict.value(forKey: "CountryName") as? String
//                            {
//                                name = countrynametemp
//                            }
//                            else
//                            {
//                                name = ""
//                            }
//                            
//                            self.arridcon.append(id as String)
//                            self.arrcodecon.append(code)
//                            self.arrcountries.append(name)
//                            
//                            if isactive == true
//                            {
//                                self.arrisactivecon.append("1")
//                            }
//                            else
//                            {
//                                self.arrisactivecon.append("0")
//                            }
//                            
//                        }
//                    }
//                }
//                else{
//                    
//                    obj.showAlert(title: "Alert", message: "try again", viewController: self)
//                    
//                }
//                
//            }
//            catch
//            {
//                print("Your Dictionary value nil")
//            }
//            
//            print(dictionaryData)
//            
//            
//        }, failure: { (operation : AFHTTPRequestOperation, error :Error) -> Void in
//            
//            print(error, terminator: "")
//            self.andicator.stopAnimating()
//            obj.showAlert(title: "Alert!", message: error.localizedDescription, viewController: self)
//        })
//        
//        manager.start()
        
    }

    // Marks: - Get Cities
    func GetCities()
    {
        let country = "Pakistan"
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetCities xmlns='http://threepin.org/'><country>\(country)</country></GetCities></soap:Body></soap:Envelope>"
        
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/EPoultryDirectory.asmx"
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
            DispatchQueue.main.async {
                self.andicator.stopAnimating()
            }
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetCitiesResponse")! as Any) as AnyObject).object(forKey:"GetCitiesResult")   ?? NSDictionary()
                
                
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Please try again with other user", viewController: self)
                    }
                    else
                    {
                        let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        
                        for dict in json {
                            // dump(dict)
                            
                            var tempcity = String()
                            var tempcityid = String()
                            var tempisactive = String()
                            if let city = dict.value(forKey: "City") as? String
                            {
                                tempcity = city
                            }
                            else
                            {
                                tempcity = ""
                            }
                            if let cityid = dict.value(forKey: "CityId") as? Int
                            {
                                tempcityid = (String(cityid) as NSString) as String
                            }
                            else
                            {
                                tempcityid = ""
                            }
                            if let isactivetemp = dict.value(forKey: "IsActive") as? Int
                            {
                                tempisactive = (String(isactivetemp) as NSString) as String
                            }
                            else
                            {
                                tempisactive = ""
                            }
                            
                            self.arrcities.append(tempcity)
                            self.arrcityid.append(tempcityid)
                            self.arrisactivecon.append(tempisactive)
                        }
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
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }
    
    
    
    // Marks: - Picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrpickerview.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return arrpickerview[row]
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // technician = pickerarr[row]
        rowno = row
       // txtLanguage.text = arrLanguage[row]
        
    }

    func funSendPhoneAuth()
    {
        andicator.startAnimating()
        let code = "\(self.txtmobile.selectedCountry!.phoneCode)"
        PhoneAuthProvider.provider().verifyPhoneNumber(("\(code)\(txtmobile.text!)"), uiDelegate: nil){ (verificationID, error) in
            self.andicator.stopAnimating()
            if error != nil {
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                return
            }else{
                GlobalFireBaseverficationID = verificationID!
                objG.showVerificationPopup(string: "textstring", viewController: self)
            }
        }
    }
    
    @objc func confirmpress(notification: Notification) {
        let datadic = notification.object as! NSDictionary
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: GlobalFireBaseverficationID,
            verificationCode: datadic.value(forKey: "code") as! String)
        let viewController = datadic.value(forKey: "viewController") as! UIViewController
        
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            
            if error != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopandicator"), object: nil)
                
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                self.isMobileVerify = false
                return
            }
            else {
                objG.removeVerificationPopup()
                //self.funVerifyNumberInServer()
                obj.funValidationfromBottom(sender: self.txtmobile, text: "Verified...!", view: self.contentv)
                self.txtmobile.textColor = .lightGray
                self.btnverifyno.setTitle("CHANGE", for: .normal)
                self.btnverifyno.setTitleColor(.lightGray, for: .normal)
                self.txtmobile.isUserInteractionEnabled = false
                self.isMobileVerify = true
            }
        }
    }
    
    // Get Location Name from Latitude and Longitude
    func funVerifyUserNameInServer() {
        //MARK:- Not using in the app
        var code = "\(self.txtmobile.selectedCountry!.phoneCode)"
        code = code.replacingOccurrences(of: "+", with: "")
        let url = BASEURL+"User/CheckUserName?userName=\(code)\(txtmobile.text!)"
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
                                }
                            }
                            else
                            {
                                //Already Register
                                let alert = UIAlertController(title: "Username!", message: "This Username is already register:  ?\n\(self.txtmobile.text!)", preferredStyle: .alert)
                                let cancel = UIAlertAction(title: "Change", style: .default) { (action) in
                                    self.txtmobile.text! = ""
                                }
                                
                                alert.addAction(cancel)
                                
                                self.present(alert, animated: true)
                            }
                        }
                        else
                        {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    
    // Get Location Name from Latitude and Longitude
    func funVerifyNumberInServer() {
        var code = "\(self.txtmobile.selectedCountry!.phoneCode)"
        code = code.replacingOccurrences(of: "+", with: "")
        let url = BASEURL+"user/VerifyMobileNo?mobileNo=\(code)\(txtmobile.text!)"
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
                                self.funSendPhoneAuth()
                            }
                        }
                        else {
                            //Already Register
                            let alert = UIAlertController(title: "Phone No!", message: "This Phone no is already register!\n\(self.txtmobile.selectedCountry!.phoneCode + self.txtmobile.text!)", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "Change", style: .default) { (action) in
                                //self.dissmiss()
                            }
                            let Share = UIAlertAction(title: "Login", style: .default) { (action) in
                                self.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(cancel)
                            alert.addAction(Share)
                            
                            self.present(alert, animated: true)
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
    
    func funUserRegister() {
        var fcmtoken = ""
        
        if let token = defaults.value(forKey: "fcmtoken") as? String {
            fcmtoken = token
        }
        else
        { fcmtoken = "texttoken"}
        let url = BASEURL+"/user"
        
        var number = mobilenumber
        number = number.replacingOccurrences(of: "+", with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        let fullname = txtfname.text!
        defaults.setValue(fullname, forKey: "fullname")
        let namearray = fullname.components(separatedBy: " ")
        let fname = namearray[0]
        var lname = ""
        if namearray.count > 1{
            lname = namearray[1]
        }
        else if namearray.count > 2{
            lname = lname + " " + namearray[2]
        }
        else if namearray.count > 3{
            lname = lname + " " + namearray[3]
        }
        guard let userID = Auth.auth().currentUser?.uid else {
               obj.showAlert(title: "Alert!", message: "Please wait try again!", viewController: self)
               return }
        let parameters : Parameters =
            ["firstName":fname,
             "LastName": lname,
             "username": number,
             "password": txtpass.text!,
             "mobile": number,
             "fcmId": fcmtoken,
             "country": "",
             "source": "ios",
             "city": "",
             "company": txtcompnay.text! ,
             "compId": compId,
             "userCategory": updateSubCompanyName,
             "email":"",
             "state":"",
             "mac":UIDevice.current.identifierForVendor?.uuidString as Any,
             "version":APPVERSIONNUMBER!,
             "firebaseUserId":userID,
             "osVersion":IPHONESOSVERSION,
             "manufacturer":"APPLE",
             "gender":"",
             "qualification":"",
             "profession":"",
             "contactNo":"",
             "dob":"",
             "address":"",
             "lat":"",
             "lng":""]
        
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil {
                if (responseObject!.value(forKey: "data") as? Int) != nil {
                    obj.showAlert(title: "Alert!", message: responseObject?.value(forKey: "message") as! String, viewController: self)
                    return
                }
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fbRegistration"), object: nil)
                let dataarr = responseObject!.value(forKey: "data") as! NSArray
                let datadic = dataarr[0] as! NSDictionary
                if datadic.count > 0 {
                    if self.isAddNewCompany {
                        if let temp = datadic.value(forKey: "id") as? Int {
                            updatedefaultUser = "\(temp)"
                        }
                        else if let temp = datadic.value(forKey: "id") as? String{
                            updatedefaultUser = temp
                        }
                        
                        funUpdateCompany(viewController: self)
                    }
                    
                    let alertController = UIAlertController(title:"Alert!", message: "User register successfully", preferredStyle:.alert)
                    
                    let Action = UIAlertAction.init(title: "Ok", style: .default) { (UIAlertAction) in
                        // Write Your code Here
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signup"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(Action)
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
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
    var isAddNewCompany = false
    @objc func funSelectCompany(notification: Notification)
    {
        let datadic = notification.object as! NSDictionary
        let isAddCompany = datadic.value(forKey: "isAddCompany") as! Bool
        if isAddCompany {
            //MARK:- Just select company
            txtcompnay.text = datadic.value(forKey: "name") as? String ?? ""
            isAddNewCompany = datadic.value(forKey: "isAddNewCompany") as! Bool
            if let temp = datadic.value(forKey: "companyid") as? String{
                compId = temp
            }
            else if let temp = datadic.value(forKey: "companyid") as? Int{
                compId = "\(temp)"
            }
            if let temp = datadic.value(forKey: "company") as? String{
                updateSubCompanyName = temp
            }
            updateCompanyId = compId
        }
        else{
            //MARK:- ADD new company
        }
        
//        if isAddCompany{
//            datadic = ["isAddCompany" : isAddCompany,
//                       "address": arrCAddress[index],
//                       "city": arrCCity[index],
//                       "name": arrCSubCategory[index],
//                       "company": arrCCompany[index],
//                       "companyid": arrCCompanyId[index]]
//        }
//        else{
//            datadic = ["isAddCompany" : isAddCompany,
//                       "name" : arrSubCName[index],
//                       "id": arrSubCId[index],
//                       "icon": arrSubIcon[index],
//                       "isactive": arrSubIsActive[index],
//                       "oldid": arrSubOldId[index],
//                       "type": arrSubType[index]]
//        }
        
    }
}

extension Signup: CZPickerViewDelegate, CZPickerViewDataSource {
        func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
//            if pickerView == pickerWithImage {
//                return fruitImages[row]
//            }
           // return #imageLiteral(resourceName: "cancel")
            return nil
        }
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return arrpickerview.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return arrpickerview[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
        txtfield.text = arrpickerview[row]
    }
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        for row in rows {
            if let row = row as? Int {
                print(arrpickerview[row])
            }
        }
    }
}

extension Signup: FPNTextFieldDelegate {
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
