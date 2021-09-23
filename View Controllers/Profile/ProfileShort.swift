//
//  ProfileShort.swift
//  AMPL
//
//  Created by sameer on 11/07/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class ProfileShort: UIViewController {
    
    var userdetailid = String()
    var username = String()
    var request = String()
    var imgname = String()
    
    @IBOutlet weak var lblfname: UILabel!
    @IBOutlet weak var lbllname: UILabel!
    @IBOutlet weak var lbladd: UILabel!
    @IBOutlet weak var lblcity: UILabel!
    @IBOutlet weak var lblstate: UILabel!
    @IBOutlet weak var lblcountry: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var btnimg: UIButton!
    @IBOutlet weak var lbladdress: UILabel!
   
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var imgvadd: UIImageView!

    
    @IBOutlet weak var btnadd: UIButton!
   
    @IBOutlet weak var scrollv: UIScrollView!
    
    @IBOutlet weak var contentv: UIView!
    
    @IBOutlet weak var bgvtop: UIView!
    @IBOutlet weak var bgvbottom: UIView!
    override func viewDidLoad() {
        

        // Do any additional setup afbgter loading the view.
        
        btnadd.isHidden = true
        lbladd.isHidden = true
        imgvadd.isHidden = true
        
        self.title = "Profile"
        
        imgv.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        self.bgvtop.frame.origin.y = self.imgv.frame.maxY + 10
        self.bgvbottom.frame.origin.y = self.bgvtop.frame.maxY + 10
        self.bgvbottom.frame.size.height = self.lblcountry.frame.maxY + 60
        
        self.contentv.frame.size.height = self.bgvbottom.frame.maxY
        
        var contentRect = CGRect()
        for view in self.scrollv.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.scrollv.contentSize = (contentRect.size )
        
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        getprofile()
        super.viewDidLoad()
    }
    @objc func btnback(){
           self.navigationController?.popViewController(animated: true)
           if !IPAD{
               navigationController?.navigationBar.barTintColor = nil
           }
       }
    
    @IBAction func btnimg(_ sender: Any) {
        return
      let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        vc.videoimagetag = IMAGE
        vc.videoimagename = imgname
        
        obj.funForceDownloadPlayShow(urlString: imagepath+imgname, isProgressBarShow: true, viewController: self, completion: {
            url in
            
            if url == ""{
                vc.profilepic = UIImage(named: "tempimg")!
            }
            else{
                vc.strurl = url!
            }
            //MARK:- Reload image row after download
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    @IBAction func btnadd(_ sender: Any) {
        
        if btnadd.tag == 0
        {
            SendRequest()
        }
        else if btnadd.tag == 1
        {
            let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel Request", style: UIAlertAction.Style.default)
            { action -> Void in
                // Put your code here
                self.ConfirmRequest(accept: "0", reject: "0", cancel: "1")
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
            { action -> Void in
                
                
            })
            self.present(alertController, animated: true, completion: nil)
        }
        else if btnadd.tag == 2
        {
            
        }
    }

    // Marks: - Get All Posts
    func getprofileold()
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
        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetUserDetail xmlns='http://threepin.org/'><id>\(userdetailid)</id><userId>\(userid)</userId></GetUserDetail></soap:Body></soap:Envelope>"
        
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
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetUserDetailResponse")! as Any) as AnyObject).object(forKey:"GetUserDetailResult")   ?? NSDictionary()
                
                
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
                        for dict in json {
                            // dump(dict)
                            
                            if let FirstName = dict.value(forKey: "FirstName") as? String
                            {
                                self.lblfname.text = FirstName
                            }
                            else
                            {
                                self.lblfname.text = ""
                            }
                            if let LastName = dict.value(forKey: "LastName") as? String
                            {
                                self.lbllname.text = LastName
                            }
                            else
                            {
                                self.lbllname.text = ""
                            }
                            if let address = dict.value(forKey: "address") as? String
                            {
                                self.lbladdress.text = address
                            }
                            else
                            {
                                self.lbladdress.text = ""
                            }
                            if let City = dict.value(forKey: "City") as? String
                            {
                                self.lblcity.text = City
                            }
                            else
                            {
                                self.lblcity.text = ""
                            }
                            if let Province = dict.value(forKey: "Province") as? String
                            {
                                self.lblstate.text = Province
                            }
                            else
                            {
                                self.lblstate.text = ""
                            }
                            //
                            if let Country = dict.value(forKey: "Country") as? String
                            {
                                self.lblcountry.text = Country
                            }
                            else
                            {
                                self.lblcountry.text = ""
                            }
                            if let profile_img = dict.value(forKey: "profile_img") as? String
                            {
                                self.imgname = profile_img
                                let urlprofile = URL(string: imagepath+profile_img)
                                self.imgv.kf.setImage(with: urlprofile)
                            }
                            
                            
                            if self.request == "0"
                            {
                                self.imgvadd.image = #imageLiteral(resourceName: "addgray")
                                self.lbladd.text = "Add Friend"
                                self.btnadd.tag = 0
                                self.lbladd.textColor = appgraycolor
                            }
                            else if self.request == "1"
                            {
                                self.imgvadd.image = #imageLiteral(resourceName: "pending")
                                self.lbladd.text = "Pending Request"
                                self.btnadd.tag = 1
                                self.lbladd.textColor = apppendingcolor
                                
                            }
                            else if self.request == "2"
                            {
                                self.imgvadd.image = #imageLiteral(resourceName: "addimg")
                                self.lbladd.text = "Friends"
                                self.btnadd.isHidden = true
                                self.btnadd.tag = 2
                                self.lbladd.textColor = appcolor
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
    }
    
    // Get Location Name from Latitude and Longitude
    func getprofile()
    {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"user/\(userdetailid)?userId=\(userid)"
        //http://epoultryapi.zederp.net/api/user/35907?userId=35907
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let tempdataDic = responseObject?.value(forKey: "Data") as! NSArray
                         
                           for temp in tempdataDic {
                               // dump(dict)
                               let dict = temp as! NSDictionary
                               if let FirstName = dict.value(forKey: "FirstName") as? String
                               {
                                   self.lblfname.text = FirstName
                               }
                               else
                               {
                                   self.lblfname.text = ""
                               }
                               if let LastName = dict.value(forKey: "LastName") as? String
                               {
                                   self.lbllname.text = LastName
                               }
                               else
                               {
                                   self.lbllname.text = ""
                               }
                               if let address = dict.value(forKey: "address") as? String
                               {
                                   self.lbladdress.text = address
                               }
                               else
                               {
                                   self.lbladdress.text = ""
                               }
                               if let City = dict.value(forKey: "City") as? String
                               {
                                   self.lblcity.text = City
                               }
                               else
                               {
                                   self.lblcity.text = ""
                               }
                               if let Province = dict.value(forKey: "Province") as? String
                               {
                                   self.lblstate.text = Province
                               }
                               else
                               {
                                   self.lblstate.text = ""
                               }
                               //
                               if let Country = dict.value(forKey: "Country") as? String
                               {
                                   self.lblcountry.text = Country
                               }
                               else
                               {
                                   self.lblcountry.text = ""
                               }
                               if let profile_img = dict.value(forKey: "profile_img") as? String
                               {
                                   self.imgname = profile_img
                                   let urlprofile = URL(string: userimagepath+profile_img)
                                   self.imgv.kf.setImage(with: urlprofile)
                               }
                               
                               
                               if self.request == "0"
                               {
                                   self.imgvadd.image = #imageLiteral(resourceName: "addgray")
                                   self.lbladd.text = "Add Friend"
                                   self.btnadd.tag = 0
                                   self.lbladd.textColor = appgraycolor
                               }
                               else if self.request == "1"
                               {
                                   self.imgvadd.image = #imageLiteral(resourceName: "pending")
                                   self.lbladd.text = "Pending Request"
                                   self.btnadd.tag = 1
                                   self.lbladd.textColor = apppendingcolor
                                   
                               }
                               else if self.request == "2"
                               {
                                   self.imgvadd.image = #imageLiteral(resourceName: "addimg")
                                   self.lbladd.text = "Friends"
                                   self.btnadd.isHidden = true
                                   self.btnadd.tag = 2
                                   self.lbladd.textColor = appcolor
                               }
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

    // Marks: - UN Friends
    func ConfirmRequest(accept : String, reject : String, cancel : String)
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
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UserFriendRequestAcceptReject xmlns='http://threepin.org/'><username>\(username)</username><userId>\(userid)</userId><friendId>\(userdetailid)</friendId><accepted>\(accept)</accepted><rejected>\(reject)</rejected><cancel>\(cancel)</cancel></UserFriendRequestAcceptReject></soap:Body></soap:Envelope>"
        
        
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
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UserFriendRequestAcceptRejectResponse")! as Any) as AnyObject).object(forKey:"UserFriendRequestAcceptRejectResult")   ?? NSDictionary()
                
                
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Failed.", viewController: self)
                    }
                    else
                    {
                        self.imgvadd.image = #imageLiteral(resourceName: "addgray")
                        self.lbladd.text = "Add Friend"
                        self.btnadd.tag = 0
                        self.lbladd.textColor = appgraycolor
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
//        
//        self.andicator.startAnimating()
//        
//        DispatchQueue.main.async {
//            manager.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation, responseObject : Any) -> Void in
//                
//                
//                self.andicator.stopAnimating()
//                var dictionaryData = NSDictionary()
//                
//                do
//                {
//                    dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! Data)) as NSDictionary
//                    
//                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UserFriendRequestAcceptRejectResponse")! as Any) as AnyObject).object(forKey:"UserFriendRequestAcceptRejectResult")   ?? NSDictionary()
//                    
//                    
//                    
//                    if (mainDict as AnyObject).count > 0{
//                        
//                        let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//                        
//                        let text = mainD.value(forKey: "text") as! NSString
//                        // text = text.replacingOccurrences(of: "[", with: "") as NSString
//                        // text = text.replacingOccurrences(of: "]", with: "") as NSString
//                        
//                        if text == "0"
//                        {
//                            obj.showAlert(title: "Alert!", message: "Failed.", viewController: self)
//                        }
//                        else
//                        {
//                            self.imgvadd.image = #imageLiteral(resourceName: "addgray")
//                            self.lbladd.text = "Add Friend"
//                            self.btnadd.tag = 0
//                            self.lbladd.textColor = appgraycolor
//                        }
//                    }
//                    else{
//                        
//                        obj.showAlert(title: "Alert", message: "try again", viewController: self)
//                        
//                    }
//                    
//                }
//                catch
//                {
//                    print("Your Dictionary value nil")
//                }
//                
//                print(dictionaryData)
//                
//                
//            }, failure: { (operation : AFHTTPRequestOperation, error :Error) -> Void in
//                
//                print(error, terminator: "")
//                self.andicator.stopAnimating()
//                obj.showAlert(title: "Alert!", message: error.localizedDescription, viewController: self)
//            })
//            
//            manager.start()
//        }
        
        
    }

    //MARK:- Send Friend Request
    func SendRequest()
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
       
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UserFriendRequest xmlns='http://threepin.org/'><username>\(username)</username><userId>\(userid)</userId><friendId>\(userdetailid)</friendId></UserFriendRequest></soap:Body></soap:Envelope>"
        
        
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
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UserFriendRequestResponse")! as Any) as AnyObject).object(forKey:"UserFriendRequestResult")   ?? NSDictionary()
                
                
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Failed.", viewController: self)
                    }
                    else
                    {
                        self.imgvadd.image = #imageLiteral(resourceName: "pending")
                        self.lbladd.text = "Pending Request"
                        self.btnadd.tag = 1
                        self.lbladd.textColor = apppendingcolor
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
//        self.andicator.startAnimating()
//        
//        DispatchQueue.main.async {
//            manager.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation, responseObject : Any) -> Void in
//                
//                
//                self.andicator.stopAnimating()
//                var dictionaryData = NSDictionary()
//                
//                do
//                {
//                    dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! Data)) as NSDictionary
//                    
//                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UserFriendRequestResponse")! as Any) as AnyObject).object(forKey:"UserFriendRequestResult")   ?? NSDictionary()
//                    
//                    
//                    
//                    if (mainDict as AnyObject).count > 0{
//                        
//                        let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//                        
//                        let text = mainD.value(forKey: "text") as! NSString
//                        // text = text.replacingOccurrences(of: "[", with: "") as NSString
//                        // text = text.replacingOccurrences(of: "]", with: "") as NSString
//                        
//                        if text == "0"
//                        {
//                            obj.showAlert(title: "Alert!", message: "Failed.", viewController: self)
//                        }
//                        else
//                        {
//                            self.imgvadd.image = #imageLiteral(resourceName: "pending")
//                            self.lbladd.text = "Pending Request"
//                            self.btnadd.tag = 1
//                            self.lbladd.textColor = apppendingcolor
//                        }
//                    }
//                    else{
//                        
//                        obj.showAlert(title: "Alert", message: "try again", viewController: self)
//                        
//                    }
//                    
//                }
//                catch
//                {
//                    print("Your Dictionary value nil")
//                }
//                
//                print(dictionaryData)
//                
//                
//            }, failure: { (operation : AFHTTPRequestOperation, error :Error) -> Void in
//                
//                print(error, terminator: "")
//                self.andicator.stopAnimating()
//                obj.showAlert(title: "Alert!", message: error.localizedDescription, viewController: self)
//            })
//            
//            manager.start()
//        }
    }
}
