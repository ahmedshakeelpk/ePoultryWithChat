
    ///////////////////////////////////////////////////

    
    //
    //  NewGroup.swift
    //  AMPL
    //
    //  Created by Paragon Marketing on 03/07/2017.
    //  Copyright © 2017 sameer. All rights reserved.
    //
    
    import UIKit
    import Contacts
    import Kingfisher
    import Alamofire

    class NewGroup: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate,UIScrollViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate {
        
        var and = UIActivityIndicatorView()
        //MARK:- For Image Picker
        var imagePicker: UIImagePickerController!
        var popover = UIViewController()
        ////////////////////
        //MARK: - Search
        var isFiltered = Bool()
        var arrSearchIndex = NSMutableArray()
        var arrgivenname = [String]()
        var arrfamilyname = [String]()
        var arrcheck = [String]()
        
        /////////////
        //MARK:- For checking the right menu button click or not
        var btnnewgrouptag = Int()
        
        ///////
        var isaddmember = String()
        
        ///////////
        var selectedids = String()
        var phonenumbers = String()
        var arrphonenumbers = [String]()
        var arrphonename = [String]()
        ///////////////////////////
        var arrselectedids = [String]()
        /////////////////
        
        var arrcheckuncheck = [String]()
        var arrfriend = [String]()
        var arrisonline = [String]()
        var arrissponsoreduser = [String]()
        var arrname = [String]()
        var arrcity = [String]()
        var arrid = [String]()
        var arrmobile = [String]()
        var arrprofileimg = [String]()
        var arrusername = [String]()
        
        ///////////////////MARK:- Popup view
        @IBOutlet weak var andicator: UIActivityIndicatorView!
        @IBOutlet weak var popv: UIView!
        @IBOutlet weak var imgv: UIImageView!
        @IBOutlet weak var txttitle: UITextField!
        @IBOutlet weak var btnpublic: UIButton!
        
        @IBOutlet weak var btnprivate: UIButton!
        @IBOutlet weak var btnupload: UIButton!
        @IBOutlet weak var btncancel: UIButton!
        @IBOutlet weak var btnok: UIButton!
        
        @IBAction func btnupload(_ sender: Any) {
            showActionSheet(sender: sender)
        }
        @IBAction func btnprivate(_ sender: Any) {
            btnprivate.tag = 1
            btnpublic.tag = 0
            btnprivate.setImage(#imageLiteral(resourceName: "btnclicks"), for: .normal)
            btnpublic.setImage(#imageLiteral(resourceName: "btnunclicks"), for: .normal)
        }
        @IBAction func btnpublic(_ sender: Any) {
            btnprivate.tag = 0
            btnpublic.tag = 1
            btnpublic.setImage(#imageLiteral(resourceName: "btnclicks"), for: .normal)
            btnprivate.setImage(#imageLiteral(resourceName: "btnunclicks"), for: .normal)
        }
        @IBAction func btncancel(_ sender: Any) {
            btnnewgrouptag = 0
            popv.isHidden = true
            txttitle.text = ""
        }
        @IBAction func btnok(_ sender: Any) {
            if arrselectedids.count > 0
            {
                if txttitle.text! != "" && imgv.image != nil
                {
                    let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
                    uploadMedia(type: "IMAGE", object: imageData, completion: { filename in
                        
                        guard let filename = filename else { return }
                        
                        print(filename)
                        
                        self.CreatGroup(imgname: filename)
                    })
                    
                }
                else if txttitle.text! != ""
                {
                    self.CreatGroup(imgname: "")
                }
                else
                {
                    obj.showAlert(title: "Alert", message: "Group title is missing.", viewController: self)
                }
            }
            else
            {
                obj.showAlert(title: "Alert!", message: "Please select members for group.", viewController: self)
            }
            
        }
        
        
        ///////////////////////////////////
        @IBOutlet weak var tablev: UITableView!
        @IBOutlet weak var txtsearch: UITextField!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            obj.setViewShade(view: popv)
            btnnewgrouptag = 0
            btnpublic.tag = 1
            
            // Do any additional setup after loading the view.
            
            // Marks: - func for search bar
            txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
            
            // Marks: - Right Search button
            let rightbutton:UIBarButtonItem = UIBarButtonItem(title:"New Group", style: UIBarButtonItem.Style.done, target: self, action: #selector(createnewgroup))
            self.navigationItem.setRightBarButtonItems([rightbutton], animated: true)
            
            DispatchQueue.main.async {
                self.fetchcontact()
            }
            
        }
        
        //  search bar change text func
        @objc func change()
        {
            let length = txtsearch.text
            if length?.count == 0
            {
                isFiltered = false
                //searchBar.responds(to: Selector(resignFirstResponder()))
                txtsearch.resignFirstResponder()
                
            }
            else
            {
                isFiltered = true
                
                arrSearchIndex = NSMutableArray()
                for (index, name) in arrusername.enumerated() {
                    // print(name)
                    
                    //MYString is Extension in the bottom of this class you can find
                    if MyString.contains(name, substring: txtsearch.text!)
                    {
                        arrSearchIndex.add(index)
                    }
                }
            }
            
            self.tablev?.reloadData()
        }
        
        func fetchcontact()
        {
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (isGranted, error) in
                // Check the isGranted flag and proceed if true
               
                if error != nil
                {
                }
                
                DispatchQueue.main.async {
                    let contactStore = CNContactStore()
                    let keys = [CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey, CNContactPhoneNumbersKey]
                    let request1 = CNContactFetchRequest(keysToFetch: keys  as [CNKeyDescriptor])
                    
                    try? contactStore.enumerateContacts(with: request1) { (contact, error) in
                        for phone in contact.phoneNumbers {
                            
                            // Whatever you want to do with it
                            //print(phone)
                            self.phonenumbers = self.phonenumbers+phone.value.stringValue+","
                            self.arrphonenumbers.append(phone.value.stringValue)
                            self.arrphonename.append(contact.givenName+contact.familyName)
                            
                            self.arrgivenname.append(contact.givenName)
                            self.arrfamilyname.append(contact.familyName)
                        }
                        //print(self.phonenumbers)
                    }
                    DispatchQueue.main.async
                    {
                        self.newgroup()
                    }
                }
            }
        }
        
        @objc func funinvite(sender: UIButton)
        {
           // let tag = sender.tag
            let alertController = UIAlertController(title: "Share it!", message: "", preferredStyle:UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Social Media", style: UIAlertAction.Style.default)
            { action -> Void in
                // Put your code here
                
                let desc = "ePoultry install it"
               
                var activityVC = UIActivityViewController(activityItems: [], applicationActivities: nil)
                
               
                activityVC = UIActivityViewController(activityItems: [desc], applicationActivities: nil)
                
                
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
                DispatchQueue.main.async
                    {
                        // let obj = Movies()
                        // obj.Andicator.stopAnimating()
                }
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
            { action -> Void in
                // Put your code here
            })
            self.present(alertController, animated: true, completion: nil)
        }
        
        @objc func funcheck(sender: UIButton)
        {
            let tag = sender.tag
            
            let checkuncheck = arrcheckuncheck[tag]
            
            if checkuncheck == "1"
            {
                arrcheckuncheck[tag] = "0"
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: tag, section: 0)
                    self.tablev.reloadRows(at: [indexPath], with: .none)
                    
                }
                let iddd = arrid[tag]
                
                let filteredArray = arrselectedids.filter { $0 != iddd }
                
                self.arrselectedids = [String]()
                self.arrselectedids = filteredArray
            }
            else
            {
                arrcheckuncheck[tag] = "1"
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: tag, section: 0)
                    self.tablev.reloadRows(at: [indexPath], with: .none)
                    
                }
                arrselectedids.append(arrid[tag])
              
            }
        }
        
        
        //MARK: - Text field delegate
        // Marks: - Return button delegates
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return true
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        //MARK:- Scroll view Delegates
        
        
        // Marks: - Table view datasource and delegates
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isFiltered == true
            {
                return arrSearchIndex.count
            }
            else
            {
                return arrusername.count
            }
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            /////////////////////////////////////////
            if isFiltered == true
            {
                let index = arrSearchIndex[indexPath.row] as! Int
                if arrcheck[index] == "0"
                {
                    let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! NewGroupCell
                    
                    ////////////////////////////////////////
                    cell.lblusername.textColor = appcolor
                    
                    cell.lblusername.text = self.arrusername[index]
                    
                    if arrprofileimg[indexPath.row] != ""
                    {
                        let urlprofile = URL(string: arrprofileimg[index])
                        cell.imgprofile.kf.setImage(with: urlprofile)
                    }
                    
                    if self.arrcheckuncheck[index] == "1"
                    {
                        cell.imgvcheck.image = #imageLiteral(resourceName: "check")
                    }
                    else
                    {
                        cell.imgvcheck.image = #imageLiteral(resourceName: "uncheck")
                    }
                    
                    if isaddmember == "1"
                    {
                        if arrfriend[index] == "1"
                        {
                            cell.imgvadd.isHidden = false
                            cell.imgvcheck.image = #imageLiteral(resourceName: "checkg")
                        }
                        else
                        {
                            cell.imgvadd.isHidden = true
                            cell.imgvcheck.image = #imageLiteral(resourceName: "uncheck")
                            
                            cell.btncheck.tag = indexPath.row
                            cell.btncheck.addTarget(self, action: #selector(funcheck), for: UIControl.Event.touchUpInside)
                        }
                    }
                    else
                    {
                        cell.btncheck.tag = index
                        cell.btncheck.addTarget(self, action: #selector(funcheck), for: UIControl.Event.touchUpInside)
                    }
                    
                    return cell
                }
                else
                {
                    let cell = self.tablev.dequeueReusableCell(withIdentifier: "NewGroupPhoneNoCell") as! NewGroupPhoneNoCell
                    
                    cell.btninvite.tag = indexPath.row
                    cell.btninvite.addTarget(self, action: #selector(funinvite), for: UIControl.Event.touchUpInside)
                    ////////////////////////////////////////
                    cell.lblusername.textColor = appcolor
                    cell.lblusername.text = self.arrusername[index]
                    
                    cell.btninvite.layer.cornerRadius = 5
                    cell.lblnameimg.layer.cornerRadius = cell.lblnameimg.frame.width / 2
                    
                    let namme = arrusername[indexPath.row]
                    
                    var myStringArr = namme.components(separatedBy: " ")
                    
                    if myStringArr.count > 0
                    {
                        if myStringArr.count == 1
                        {
                            let a: String = myStringArr [0]
                            let firstChar = a[a.startIndex]
                            cell.lblnameimg.text = String(firstChar)
                        }
                        else if myStringArr.count == 2
                        {
                            let a: String = myStringArr [0]
                            let b: String = myStringArr [1]
                            if b == ""
                            {
                                
                                let a: String = myStringArr [0]
                                let firstChar = a[a.startIndex]
                                cell.lblnameimg.text = String(firstChar)
                            }
                            else
                            {
                                let firstChar = a[a.startIndex]
                                let secondChar = b[b.startIndex]
                                cell.lblnameimg.text = String(firstChar) + String(secondChar)
                            }
                        }
                        else
                        {
                            
                        }
                    }
                    else
                    {
                        cell.lblnameimg.text = String("")
                    }
                    return cell
                }
            }
            else
            {
                if arrcheck[indexPath.row] == "0"
                {
                    let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! NewGroupCell
                    
                    ////////////////////////////////////////
                    cell.lblusername.textColor = appcolor
                    
                    cell.lblusername.text = self.arrusername[indexPath.row]
                    if arrprofileimg[indexPath.row] != ""
                    {
                        let urlprofile = URL(string: arrprofileimg[indexPath.row])
                        cell.imgprofile.kf.setImage(with: urlprofile)
                    }
                    
                    if self.arrcheckuncheck[indexPath.row] == "1"
                    {
                        cell.imgvcheck.image = #imageLiteral(resourceName: "check")
                    }
                    else
                    {
                        cell.imgvcheck.image = #imageLiteral(resourceName: "uncheck")
                    }
                    
                    if isaddmember == "1"
                    {
                        if arrfriend[indexPath.row] == "1"
                        {
                            cell.imgvadd.isHidden = false
                            cell.imgvcheck.image = #imageLiteral(resourceName: "checkg")
                        }
                        else
                        {
                            cell.imgvadd.isHidden = true
                            cell.imgvcheck.image = #imageLiteral(resourceName: "uncheck")
                            
                            cell.btncheck.tag = indexPath.row
                            cell.btncheck.addTarget(self, action: #selector(funcheck), for: UIControl.Event.touchUpInside)
                        }
                    }
                    else
                    {
                        cell.btncheck.tag = indexPath.row
                        cell.btncheck.addTarget(self, action: #selector(funcheck), for: UIControl.Event.touchUpInside)
                        if arrfriend[indexPath.row] == "1"
                        {
                            cell.imgvadd.isHidden = false
                        }
                        else
                        {
                            cell.imgvadd.isHidden = true
                        }
                    }
                    return cell
                }
                else
                {
                    let cell = self.tablev.dequeueReusableCell(withIdentifier: "NewGroupPhoneNoCell") as! NewGroupPhoneNoCell
                    
                    cell.btninvite.tag = indexPath.row
                    cell.btninvite.addTarget(self, action: #selector(funinvite), for: UIControl.Event.touchUpInside)
                    ////////////////////////////////////////
                    cell.lblusername.textColor = appcolor
                    cell.lblusername.text = self.arrusername[indexPath.row]
                    
                    cell.btninvite.layer.cornerRadius = 5
                    cell.lblnameimg.layer.cornerRadius = cell.lblnameimg.frame.width / 2
                    
                    let namme = arrusername[indexPath.row]
                    
                    var myStringArr = namme.components(separatedBy: " ")
                    
                    if myStringArr.count > 0
                    {
                        if myStringArr.count == 1
                        {
                            let a: String = myStringArr [0]
                            let firstChar = a[a.startIndex]
                            cell.lblnameimg.text = String(firstChar)
                        }
                        else if myStringArr.count == 2
                        {
                            let a: String = myStringArr [0]
                            let b: String = myStringArr [1]
                            if b == ""
                            {
                                let a: String = myStringArr [0]
                                let firstChar = a[a.startIndex]
                                cell.lblnameimg.text = String(firstChar)
                            }
                            else
                            {
                                
                               // let firstChar = a[a.startIndex]
                               // let secondChar = b[b.startIndex]
                                
                                var firstChar = ""
                                var secondChar = ""
                                if a != ""{
                                    firstChar = "\(a[a.startIndex])"
                                }
                                if b != ""{
                                    secondChar = "\(b[b.startIndex])"
                                }
                                
                                cell.lblnameimg.text = String(firstChar) + String(secondChar)
                            }
                        }
                        else
                        {
                            
                        }
                    }
                    else
                    {
                        cell.lblnameimg.text = String("")
                    }
                    return cell
                }
            }
        }
        
        //////////////////////
        //MARK : - Scroll View Delegates
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            view.endEditing(true)
            popv.isHidden = true
            btnnewgrouptag = 0
        }
        
        func newgroup()
        {
            var userid = String()
            if let tempid = defaults.value(forKey: "userid") as? String
            {
                userid = tempid
            }
            else
            {
                userid = ""
            }
            phonenumbers = phonenumbers.replacingOccurrences(of: " ", with: "")
            phonenumbers = phonenumbers.replacingOccurrences(of: "-", with: "")
            phonenumbers = phonenumbers.replacingOccurrences(of: "(", with: "")
            phonenumbers = phonenumbers.replacingOccurrences(of: ")", with: "")
            
        
        
            let parameters : Parameters =
                ["userId": userid,
                 "allContacts":phonenumbers]
            let url = BASEURL+"user/rectify"
            andicator.startAnimating()
            obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
                self.andicator.stopAnimating()
                
                if error == nil && responseObject != nil
                {
                    if let dataarray = (responseObject!.value(forKey: "data") as? NSArray)
                    {
                        self.arrfriend = [String]()
                        self.arrisonline = [String]()
                        self.arrissponsoreduser = [String]()
                        self.arrname = [String]()
                        self.arrcity = [String]()
                        self.arrid = [String]()
                        self.arrmobile = [String]()
                        self.arrprofileimg = [String]()
                        self.arrusername = [String]()
                       
                        DispatchQueue.main.async {
                            for temp in dataarray {
                                let dict = temp as! NSDictionary
                                if let Friend = dict.value(forKey: "Friend") as? Int
                                {
                                    self.arrfriend.append(String(Friend))
                                    if self.isaddmember == "1"
                                    {
                                        self.arrcheckuncheck.append("1")
                                    }
                                    else
                                    { self.arrcheckuncheck.append("0")
                                    }
                                }
                                else
                                {
                                    self.arrfriend.append("")
                                    self.arrcheckuncheck.append("0")
                                }
                                if let IsOnline = dict.value(forKey: "IsOnline") as? String
                                {
                                    self.arrisonline.append(IsOnline)
                                }
                                else
                                {
                                    self.arrisonline.append("")
                                }
                                if let IsSponsoredUser = dict.value(forKey: "IsSponsoredUser") as? Int
                                {
                                    self.arrissponsoreduser.append(String(IsSponsoredUser))
                                }
                                else
                                {
                                    self.arrissponsoreduser.append("")
                                }
                                if let Name = dict.value(forKey: "Name") as? String
                                {
                                    self.arrname.append(Name)
                                }
                                else
                                {
                                    self.arrname.append("")
                                }
                                if let city = dict.value(forKey: "city") as? String
                                {
                                    self.arrcity.append(String(city))
                                }
                                else
                                {
                                    self.arrcity.append("")
                                }
                                if let id = dict.value(forKey: "id") as? Int
                                {
                                    self.arrid.append(String(id))
                                }
                                else
                                {
                                    self.arrid.append("")
                                }
                                if let mobile = dict.value(forKey: "mobile") as? String
                                {
                                    self.arrmobile.append(String(mobile))
                                }
                                else
                                {
                                    self.arrmobile.append("")
                                }
                                if let profile_img = dict.value(forKey: "profile_img") as? String
                                {
                                    self.arrprofileimg.append(String(profile_img))
                                }
                                else
                                {
                                    self.arrprofileimg.append("")
                                }
                                if let username = dict.value(forKey: "username") as? String
                                {
                                    self.arrusername.append(String(username))
                                }
                                else
                                {
                                    self.arrusername.append("")
                                }
                                var count = 0
                                for no in self.arrphonenumbers
                                {
                                    var tempno = no.replacingOccurrences(of: " ", with: "")
                                    if tempno.first == "0"
                                    {
                                        tempno.removeFirst()
                                        tempno = "92" + tempno
                                    }
                                    if tempno.first == "+"
                                    {
                                        tempno.removeFirst()
                                    }
                                    if let mobile = dict.value(forKey: "mobile") as? String
                                    {
                                        if String(mobile) == tempno
                                        {
                                            self.arrphonenumbers.remove(at: count)
                                            self.arrgivenname.remove(at: count)
                                            self.arrfamilyname.remove(at: count)
                                        }
                                        
                                    }
                                    else
                                    {
                                        
                                    }
                                    count = count + 1
                                }
                            }
                            for _ in self.arrusername
                            {
                                self.arrcheck.append("0")
                                
                            }
                            
                            for _ in self.arrphonenumbers
                            {
                                self.arrcheck.append("1")
                                
                            }
                            var count = 0
                            for no in self.arrphonenumbers
                            {
                                let namme = self.arrgivenname[count]+" "+self.arrfamilyname[count]
                                if namme == " "
                                {
                                    self.arrusername.append(String(no))
                                }
                                else
                                {
                                    self.arrusername.append(namme)
                                }
                                count = count + 1
                            }
                            
                            
                            self.tablev.reloadData()
                        }
                        
                    }
                    else
                    {
                        obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                    }
                }
                else
                {
                    if error == nil
                    {
                        obj.showAlert(title: "Error!", message: ("error?.description"), viewController: self)
                        return
                    }
                    obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                }
            })
        }
        //MARK: - Create New Group
        func newgroupOLD()
        {
            var userid = String()
            if let tempid = defaults.value(forKey: "userid") as? String
            {
                userid = tempid
            }
            else
            {
                userid = ""
            }
            
            
            let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><RectifyUsers xmlns='http://threepin.org/'><allContacts>\(phonenumbers)</allContacts><userId>\(userid)</userId></RectifyUsers></soap:Body></soap:Envelope>"
            
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
            mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            
            let session = URLSession.shared

            obj.startandicator(viewController: self)
            
            let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
                DispatchQueue.main.async {
                   obj.stopandicator(viewController: self)
                }
                var dictionaryData = NSDictionary()
                
                do
                {
                    //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "RectifyUsersResponse")! as Any) as AnyObject).object(forKey:"RectifyUsersResult")   ?? NSDictionary()
                    
                    if (mainDict as AnyObject).count > 0{
                        
                        let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                        
                        let text = mainD.value(forKey: "text") as! NSString
                        // text = text.replacingOccurrences(of: "[", with: "") as NSString
                        // text = text.replacingOccurrences(of: "]", with: "") as NSString
                        
                        if text == "0"
                        {
                            obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                        }
                        else
                        {
                            let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                            
                            self.arrfriend = [String]()
                            self.arrisonline = [String]()
                            self.arrissponsoreduser = [String]()
                            self.arrname = [String]()
                            self.arrcity = [String]()
                            self.arrid = [String]()
                            self.arrmobile = [String]()
                            self.arrprofileimg = [String]()
                            self.arrusername = [String]()
                            
                            DispatchQueue.main.async {
                            
                               
                                for dict in json {
                                    
                                    if let Friend = dict.value(forKey: "Friend") as? Int
                                    {
                                        self.arrfriend.append(String(Friend))
                                        if self.isaddmember == "1"
                                        {
                                            self.arrcheckuncheck.append("1")
                                        }
                                        else
                                        { self.arrcheckuncheck.append("0")
                                        }
                                    }
                                    else
                                    {
                                        self.arrfriend.append("")
                                        self.arrcheckuncheck.append("0")
                                    }
                                    if let IsOnline = dict.value(forKey: "IsOnline") as? String
                                    {
                                        self.arrisonline.append(IsOnline)
                                    }
                                    else
                                    {
                                        self.arrisonline.append("")
                                    }
                                    if let IsSponsoredUser = dict.value(forKey: "IsSponsoredUser") as? Int
                                    {
                                        self.arrissponsoreduser.append(String(IsSponsoredUser))
                                    }
                                    else
                                    {
                                        self.arrissponsoreduser.append("")
                                    }
                                    if let Name = dict.value(forKey: "Name") as? String
                                    {
                                        self.arrname.append(Name)
                                    }
                                    else
                                    {
                                        self.arrname.append("")
                                    }
                                    if let city = dict.value(forKey: "city") as? String
                                    {
                                        self.arrcity.append(String(city))
                                    }
                                    else
                                    {
                                        self.arrcity.append("")
                                    }
                                    if let id = dict.value(forKey: "id") as? Int
                                    {
                                        self.arrid.append(String(id))
                                    }
                                    else
                                    {
                                        self.arrid.append("")
                                    }
                                    if let mobile = dict.value(forKey: "mobile") as? String
                                    {
                                        self.arrmobile.append(String(mobile))
                                    }
                                    else
                                    {
                                        self.arrmobile.append("")
                                    }
                                    if let profile_img = dict.value(forKey: "profile_img") as? String
                                    {
                                        self.arrprofileimg.append(String(profile_img))
                                    }
                                    else
                                    {
                                        self.arrprofileimg.append("")
                                    }
                                    if let username = dict.value(forKey: "username") as? String
                                    {
                                        self.arrusername.append(String(username))
                                    }
                                    else
                                    {
                                        self.arrusername.append("")
                                    }
                                    var count = 0
                                    for no in self.arrphonenumbers
                                    {
                                        if let mobile = dict.value(forKey: "mobile") as? String
                                        {
                                            if String(mobile) == no
                                            {
                                                self.arrphonenumbers.remove(at: count)
                                                self.arrgivenname.remove(at: count)
                                                self.arrfamilyname.remove(at: count)
                                            }
                                        }
                                        else
                                        {
                                            
                                        }
                                        count = count + 1
                                    }
                                }
                                
                                for _ in self.arrusername
                                {
                                    self.arrcheck.append("0")
                                }
                                for _ in self.arrphonenumbers
                                {
                                    self.arrcheck.append("1")
                                }
                                var count = 0
                                for no in self.arrphonenumbers
                                {
                                    let namme = self.arrgivenname[count]+" "+self.arrfamilyname[count]
                                    if namme == " "
                                    {
                                        self.arrusername.append(String(no))
                                    }
                                    else
                                    {
                                        self.arrusername.append(namme)
                                    }
                                    count = count + 1
                                }
                                self.tablev.reloadData()
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
                    //self.andicator.stopAnimating()
                    obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                }
            })
            
            task.resume()
        }
        ///////////////////////////////////////////////
        //MARK: - Create New Group
        func CreatGroup(imgname: String)
        {
            var userid = String()
            var allselectedids = arrselectedids.joined(separator:",")
            allselectedids = allselectedids.replacingOccurrences(of: " ", with: "")
            if let tempid = defaults.value(forKey: "userid") as? String
            {
                userid = tempid
            }
            else
            {
                userid = ""
            }
            var type = String()
            if btnpublic.tag == 1
            {
                type = "Public"
            }
            else
            {
                type = "Private"
            }
            let url = BASEURL+"v1/Group"
            
            let parameters : Parameters =
                ["userId":Int(userid) as Any,
                 "title":txttitle.text!,
                 "membersIds":allselectedids,
                 "fileName":imgname,
                 "img":imgname,
                 "type":type]
            andicator.startAnimating()
            obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
                self.andicator.stopAnimating()
                
                if error == nil && responseObject != nil
                {
                    if let tempid = (responseObject!.value(forKey: "data") as? Int)
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroupstatus"), object: nil)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "leavegroup"), object: nil)
                            
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroupstatus"), object: nil)
                        
                        DispatchQueue.global(qos: .background).async {
                            self.UpdateGroupStatus(goupid: "\(tempid)", type: type, imageStr: imgname)
                        }
                        
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else
                    {
                        obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                    }
                }
                else
                {
                    if error == nil
                    {
                        obj.showAlert(title: "Error!", message: ("error?.description"), viewController: self)
                        return
                    }
                    obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                }
            })
        }
        
        //MARK: - Create New Group
        func CreatGroupOld()
        {
            selectedids = ""
            for idd in arrselectedids
            {
                self.selectedids = self.selectedids+idd+","
            }
            var type = String()
            if btnpublic.tag == 1
            {
                type = "Public"
            }
            else
            {
                type = "Private"
            }
            var userid = String()
            if let tempid = defaults.value(forKey: "userid") as? String
            {
                userid = tempid
            }
            else
            {
                userid = ""
            }
            selectedids = self.selectedids+"\(userid)"
            
            var timespam = Int64()
            //print(timespam)
            var imageStr = ""
           imageStr = "will remove this latter and uncomment upper line"
           
            let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><AddNewGroup xmlns='http://threepin.org/'><title>\(txttitle.text!)</title><userid>\(userid)</userid><membersIds>\(selectedids)</membersIds><fileName>\(String(timespam)+".jpg")</fileName><img>\(imageStr)</img><type>\(type)</type></AddNewGroup></soap:Body></soap:Envelope>"
            
            let soapLenth = String(soapMessage.count)
            let theUrlString = "http://websrv.zederp.net/Apml/GroupService.asmx"
            let theURL = URL(string: theUrlString)
            let mutableR = NSMutableURLRequest(url: theURL!)
            
            // MUTABLE REQUEST
            
            mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
            mutableR.httpMethod = "POST"
            mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
             mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            
            let session = URLSession.shared
            
            obj.startandicator(viewController: self)
            let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
                
                DispatchQueue.global(qos: .background).async {
                    obj.stopandicator(viewController: self)
                }
                var dictionaryData = NSDictionary()
                
                do
                {
                    //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "AddNewGroupResponse")! as Any) as AnyObject).object(forKey:"AddNewGroupResult")   ?? NSDictionary()
                    
                    if (mainDict as AnyObject).count > 0{
                        
                        let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                        
                        let text = mainD.value(forKey: "text") as! NSString
                        // text = text.replacingOccurrences(of: "[", with: "") as NSString
                        // text = text.replacingOccurrences(of: "]", with: "") as NSString
                        
                        if text == "0"
                        {
                            obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                        }
                        else
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroupstatus"), object: nil)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "leavegroup"), object: nil)
                                
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroupstatus"), object: nil)
                            
                            DispatchQueue.global(qos: .background).async {
                                self.UpdateGroupStatus(goupid: text as String, type: type, imageStr: imageStr)
                            }
                            
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
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
                    //self.andicator.stopAnimating()
                    obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                }
            })
            
            task.resume()
        }
        
        
        //MARK: - Update Group Status after Create New Group
        func UpdateGroupStatus(goupid : String, type : String, imageStr: String )
        {
            
            for idd in arrselectedids
            {
                self.selectedids = self.selectedids+idd+","
            }
            
            
            var userid = String()
            if let tempid = defaults.value(forKey: "userid") as? String
            {
                userid = tempid
            }
            else
            {
                userid = ""
            }
            
            let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateGroupStatus xmlns='http://threepin.org/'><filename>string</filename><user_id>\(userid)</user_id><status>\(defaults.value(forKey: "name") as! String) create new group</status><type>\("Group")</type><groupId>\(goupid)</groupId><img></img><isNew>1</isNew><tag>n</tag></UpdateGroupStatus></soap:Body></soap:Envelope>"
            
            let soapLenth = String(soapMessage.count)
            let theUrlString = "http://websrv.zederp.net/Apml/StatusService.asmx"
            let theURL = URL(string: theUrlString)
            let mutableR = NSMutableURLRequest(url: theURL!)
            
            // MUTABLE REQUEST
            
            mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
            mutableR.httpMethod = "POST"
            mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
             mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            
            let session = URLSession.shared
            
            obj.startandicator(viewController: self)
            
            let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
                
                DispatchQueue.global(qos: .background).async {
                obj.stopandicator(viewController: self)
            }
                var dictionaryData = NSDictionary()
                
                do
                {
                    //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateGroupStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateGroupStatusResult")   ?? NSDictionary()
                    
                    if (mainDict as AnyObject).count > 0{
                        
                        let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                        
                        let text = mainD.value(forKey: "text") as! NSString
                        // text = text.replacingOccurrences(of: "[", with: "") as NSString
                        // text = text.replacingOccurrences(of: "]", with: "") as NSString
                        
                        if text == "0"
                        {
                            obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                        }
                        else
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroupstatus"), object: nil)
                            
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
                   // self.andicator.stopAnimating()
                    obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                }
            })
            
            task.resume()
        }

        
        @objc func createnewgroup()
        {
            if btnnewgrouptag == 0
            {
                btnnewgrouptag = 1
                popv.isHidden = false
            }
            else
            {
                btnnewgrouptag = 0
                popv.isHidden = true
            }
        }
        
        //Open Action Sheet for Camera and Gallery
        func showActionSheet(sender: Any)
        {
            let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
            {
                UIAlertAction in
                self.OpenCamera()
            }
            let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
            {
                UIAlertAction in
                self.OpenGallary()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            {
                UIAlertAction in
            }
            // Add the actions
            imagePicker?.delegate = self
            
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)
            // Present the controller
            
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                alert.popoverPresentationController?.sourceView = sender as? UIView
                alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
                alert.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        
        func OpenCamera()
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
        func OpenGallary()
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        
        //    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
        //    {
        //        picker.dismiss(animated: true, completion: nil)
        //        imgViewTop.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        //    }
        
        ////image picker delegates
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                //            imgvselected.image = pickedImage
                //            vimgselected.isHidden = false
                print("Picture Selected")
                imgv.image = pickedImage
            }
            if imgv.image != nil
            {

            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
        {
            self.dismiss(animated: true, completion: nil);
        }
        ///////////////////////////////////////////////////
        
        
        func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
            obj.stopandicator(viewController: self)
        }
        
        //MARK:- Upload image or file to Firebase Storage
        func uploadMedia(type: String, object: NSData, completion: @escaping (_ url: String?) -> Void) {
            
            let uploadData = object
            var imgdata = Data()
            var videodatatemp = Data()
            var videofilename = String()
            let timespam = Date().currentTimeMillis()!
            var url = ""
            var imagefilename = ""
            var parameters : Parameters = ["":""]
            if type == "IMAGE"
            {
                imgdata = uploadData as Data
                imagefilename = "\("\(String(describing: timespam))").png"
                parameters = ["filename":imagefilename]
                url = BASEURL + "Upload/Post?filename=\(imagefilename)"
            }
            else if type == "VIDEO"
            {
                videodatatemp =  Data()
                imgdata = uploadData as Data
                imagefilename = "\("\(String(describing: timespam))").png"
                videofilename = "\("\(String(describing: timespam))")video.mp4"
                url = BASEURL + "Upload/PostVideo?videofilename=\(videofilename)&filename=\(imagefilename)"
                parameters = ["filename":imagefilename, "videofilename": videofilename]
            }
            
            andicator.startAnimating()
            obj.webServiceWithPictureAudio(url: url, parameters: parameters, imagefilename: imagefilename, audiofilename:"" , videofilename: videofilename, imageData: imgdata, audioData: Data(), videoData: videodatatemp, viewController: self, completionHandler:{
                
                responseObject, error in
                self.andicator.stopAnimating()
                if error == nil
                {
                    if type == "VIDEO"
                    {
                        let tmepname = "\(imagefilename),\(videofilename)"
                        completion(tmepname)
                    }else{
                        completion(imagefilename)
                    }
                }
                else
                {
                    completion("error")
                }
            })
        }
    }
    
    //MARK: - Search Case Ignore Case Sensitive
    struct MyString {
        static func contains(_ text: String, substring: String,
                             ignoreCase: Bool = true,
                             ignoreDiacritic: Bool = true) -> Bool {
            
            var options = NSString.CompareOptions()
            
            if ignoreCase { _ = options.insert(NSString.CompareOptions.caseInsensitive) }
            if ignoreDiacritic { _ = options.insert(NSString.CompareOptions.diacriticInsensitive) }
            
            return text.range(of: substring, options: options) != nil
        }
    }

    


//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//    return input.rawValue
//}
