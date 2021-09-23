//
//  Friend.swift
//  AMPL
//
//  Created by Paragon Marketing on 05/07/2017.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import Kingfisher

class Friend: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    ///////////////////////////////////////////////////////
    var pulltorefresh = String()
    var width = Int()
    var height = Int()
    //MARK: - Friend Array
    var arrcityF = [String]()
    var arrisonlineF = [String]()
    var arrissponsoreduserF = [String]()
    var arrnameF = [String]()
    var arrrequeststatusF = [String]()
    var arridF = [String]()
    var arrmobileF = [String]()
    var arrprofileimgF = [String]()
    var arrusernameF = [String]()
    
    
    //MARK: - Request Array
    var arrcityR = [String]()
    var arrisonlineR = [String]()
    var arrissponsoreduserR = [String]()
    var arrnameR = [String]()
    var arrrequeststatusR = [String]()
    var arridR = [String]()
    var arrmobileR = [String]()
    var arrprofileimgR = [String]()
    var arrusernameR = [String]()
    
    
    ///////////////////////////////////////////////////////
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var btnfriend: UIButton!
    @IBOutlet weak var btnrequest: UIButton!
    @IBOutlet weak var tablev: UITableView!
    
    @IBOutlet weak var btnaddfriend: UIButton!
    @IBAction func btnaddfriend(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! Search
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        
        
        
    
    
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        width = Int(self.btnfriend.frame.width)
        height = Int(self.btnfriend.frame.height)
        
        
        // MARK : - UIRefresh controll in table View
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(pulltorefreshfun), for: UIControl.Event.valueChanged)
        tablev.addSubview(refreshControl) // not required when using UITableViewController
        
        //MARK: - Button Add Round
        btnaddfriend.layer.cornerRadius = btnaddfriend.frame.width / 2
        
        //Mark: - Initial Flag of Button Friend
        btnfriend.tag = 1
        
        self.pulltorefresh = "0"
        //Mark:- Services Call for fetching data
        DispatchQueue.main.async {
            //MARK:- replace these to apis from soup to rest the will uncomment
            //self.GetFriend()
            //self.GetRequest()
        }
    }
    
    //Marks: - Pull to refresh
    @objc func pulltorefreshfun()
    {
        pulltorefresh = "1"
        //Mark:- Services Call for fetching data
        DispatchQueue.main.async {
            self.GetFriend()
            self.GetRequest()
        }
    }
    
    //MARKS:- fununfriend
    @objc func fununfriend(sender : UIButton)
    {
        let tag = sender.tag
        
        let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
        
       
            alertController.addAction(UIAlertAction(title: "Are you sure to unfriend", style: UIAlertAction.Style.default)
            { action -> Void in
                // Put your code here
                self.UnFriend(tag: tag)
                
            })
        
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // Marks: - Button option
    @objc func optionbtn(sender: UIButton)
    {
        let tag = sender.tag
        let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
    
        if arrrequeststatusR[tag] == "1"
        {
            alertController.addAction(UIAlertAction(title: "Cancel Request", style: UIAlertAction.Style.default)
            { action -> Void in
                // Put your code here
                self.ConfirmRequest(tag: tag, accept: "0", reject: "0", cancel: "1")
                
            })        }
        else if arrrequeststatusR[tag] == "0"
        {
            alertController.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default)
            { action -> Void in
                // Put your code here
                self.ConfirmRequest(tag: tag, accept: "1", reject: "0", cancel: "0")
                
            })
            alertController.addAction(UIAlertAction(title: "Reject", style: UIAlertAction.Style.default)
            { action -> Void in
                // Put your code here
                self.ConfirmRequest(tag: tag, accept: "0", reject: "1", cancel: "0")
                
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    ////////////////////////MARK: - Buttons
    //MARK: - Friend
    @IBAction func btnfriend(_ sender: Any) {
        btnaddfriend.isHidden = false
        btnrequest.tag = 0
        btnfriend.tag = 1
        tablev.reloadData()
        
        
        btnfriend.frame = CGRect(x: Int(self.btnfriend.frame.origin.x), y: Int(self.btnfriend.frame.origin.y), width: Int(btnfriend.frame.size.width), height: height)
        btnrequest.frame = CGRect(x: Int(self.btnrequest.frame.origin.x), y: Int(self.btnrequest.frame.origin.y), width: Int(btnrequest.frame.size.width), height: Int(height+2))
    }
    //MARK: - Friend Request
    @IBAction func btnrequest(_ sender: Any) {
        btnaddfriend.isHidden = true
        btnrequest.tag = 1
        btnfriend.tag = 0
        tablev.reloadData()
        btnfriend.frame = CGRect(x: Int(self.btnfriend.frame.origin.x), y: Int(self.btnfriend.frame.origin.y), width: Int(btnfriend.frame.size.width), height: height+2)
        btnrequest.frame = CGRect(x: Int(self.btnrequest.frame.origin.x), y: Int(self.btnrequest.frame.origin.y), width: Int(btnrequest.frame.size.width), height: Int(height))
    }
    
    
    
    ///////////////////////
    //MARK: - TableView Delegates and Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btnfriend.tag == 1
        {
            return arridF.count
        }
        else
        {
            return arridR.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if btnfriend.tag == 1
        {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendCell
            
            cell.btnunfriend.layer.cornerRadius = 9
            
            //Kingfisher Image upload
            let urlprofile = URL(string: imagepath+arrprofileimgF[indexPath.row])
            cell.imgv.kf.setImage(with: urlprofile)
            
            
            //MARK:- Data to labels
            cell.lblname.text! = arrnameF[indexPath.row]
            cell.lblfrom.text! = "From: "+arrcityF[indexPath.row]
            
            //UNFriend Button
            cell.btnunfriend.tag = indexPath.row
            cell.btnunfriend.addTarget(self, action: #selector(fununfriend), for: .touchUpInside)
            return cell

        }
        else
        {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "FriendRequestCell") as! FriendRequestCell
            
            //Kingfisher Image upload
            let urlprofile = URL(string: imagepath+arrprofileimgR[indexPath.row])
            cell.imgv.kf.setImage(with: urlprofile)
            
            //MARK:- Check on images
            if arrrequeststatusR[indexPath.row] == "1"
            {
                cell.imgvadd.image = #imageLiteral(resourceName: "pending")
                cell.lblreq.textColor = apppendingcolor
                cell.lblreq.text = "Pending Request"
            }
            else if arrrequeststatusR[indexPath.row] == "0"
            {
                cell.imgvadd.image = #imageLiteral(resourceName: "addimg")
                cell.lblreq.textColor = appcolor
                cell.lblreq.text = "Confirm Request"
            }
            //MARK:- Data to labels
            cell.lblname.text! = arrnameR[indexPath.row]
            cell.lblfrom.text! = "From: "+arrcityR[indexPath.row]
            
            //Button Option
            cell.btnadd.tag = indexPath.row
            cell.btnadd.addTarget(self, action: #selector(optionbtn), for: .touchUpInside)

            
            return cell

            
        }
        
        
    }
    
        //MARK: - TableView Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return  68.0
    }
    
    
    //MARK: - Webservices
    
    // Marks: - Get All Friends
    func GetFriend()
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
        
       
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetUserFriends xmlns='http://threepin.org/'><userId>\(userid)</userId><accepted>1</accepted></GetUserFriends></soap:Body></soap:Envelope>"
        
        
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
        
        if pulltorefresh != "1"
        {
            self.view.addSubview(andicator)
            andicator.startAnimating()
        }
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
            if self.pulltorefresh != "1"
            {
                self.andicator.stopAnimating()
                self.andicator.removeFromSuperview()
            }
            self.pulltorefresh = "0"
            
            refreshControl.endRefreshing()
           
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetUserFriendsResponse")! as Any) as AnyObject).object(forKey:"GetUserFriendsResult")   ?? NSDictionary()
                
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
                        
                        //MARK: - Friend Array
                        self.arrcityF = [String]()
                        self.arrisonlineF = [String]()
                        self.arrissponsoreduserF = [String]()
                        self.arrnameF = [String]()
                        self.arrrequeststatusF = [String]()
                        self.arridF = [String]()
                        self.arrmobileF = [String]()
                        self.arrprofileimgF = [String]()
                        self.arrusernameF = [String]()
                        
                        DispatchQueue.main.async {
                            for dict in json {
                                //dump(dict)
                                
                                
                                if let City = dict.value(forKey: "City") as? String
                                {
                                    self.arrcityF.append(City)
                                }
                                else
                                {
                                    self.arrcityF.append("")
                                }
                                if let IsOnline = dict.value(forKey: "IsOnline") as? Int
                                {
                                    self.arrisonlineF.append(String(IsOnline))
                                }
                                else
                                {
                                    self.arrisonlineF.append("")
                                }
                                if let IsSponsoredUser = dict.value(forKey: "IsSponsoredUser") as? Int
                                {
                                    self.arrissponsoreduserF.append(String(IsSponsoredUser))
                                }
                                else
                                {
                                    self.arrissponsoreduserF.append("")
                                }
                                if let Name = dict.value(forKey: "Name") as? String
                                {
                                    self.arrnameF.append(String(Name))
                                }
                                else
                                {
                                    self.arrnameF.append("")
                                }
                                if let RequestStatus = dict.value(forKey: "RequestStatus") as? Int
                                {
                                    self.arrrequeststatusF.append(String(RequestStatus))
                                }
                                else
                                {
                                    self.arrrequeststatusF.append("")
                                }
                                if let idd = dict.value(forKey: "id") as? Int
                                {
                                    self.arridF.append(String(idd))
                                }
                                else
                                {
                                    self.arridF.append("")
                                }
                                if let mobile = dict.value(forKey: "mobile") as? Int
                                {
                                    self.arrmobileF.append(String(mobile))
                                }
                                else
                                {
                                    self.arrmobileF.append("")
                                }
                                
                                if let profile_img = dict.value(forKey: "profile_img") as? String
                                {
                                    self.arrprofileimgF.append(String(profile_img))
                                }
                                else
                                {
                                    self.arrprofileimgF.append("")
                                }
                                
                                if let username = dict.value(forKey: "username") as? String
                                {
                                    self.arrusernameF.append(String(username))
                                }
                                else
                                {
                                    self.arrusernameF.append("")
                                }
                                
                                
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
                self.pulltorefresh = "0"
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        task.resume()
    }
    
    // Marks: - Get All Posts
    func GetRequest()
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
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetUserFriends xmlns='http://threepin.org/'><userId>\(userid)</userId><accepted>0</accepted></GetUserFriends></soap:Body></soap:Envelope>"
        
        
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
        
        if pulltorefresh != "1"
        {
            //self.view.addSubview(andicator)
            //andicator.startAnimating()
        }
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
            if self.pulltorefresh != "1"
            {
                //self.andicator.stopAnimating()
                //self.view.addSubview(self.andicator)
            }
            
            self.pulltorefresh = "0"
            refreshControl.endRefreshing()
            
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetUserFriendsResponse")! as Any) as AnyObject).object(forKey:"GetUserFriendsResult")   ?? NSDictionary()
                
                
                
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
                        
                        self.arrcityR = [String]()
                        self.arrisonlineR = [String]()
                        self.arrissponsoreduserR = [String]()
                        self.arrnameR = [String]()
                        self.arrrequeststatusR = [String]()
                        self.arridR = [String]()
                        self.arrmobileR = [String]()
                        self.arrprofileimgR = [String]()
                        self.arrusernameR = [String]()
                        
                        DispatchQueue.main.async {
                            for dict in json {
                                // dump(dict)
                                if let City = dict.value(forKey: "City") as? String
                                {
                                    self.arrcityR.append(City)
                                }
                                else
                                {
                                    self.arrcityR.append("")
                                }
                                if let IsOnline = dict.value(forKey: "IsOnline") as? Int
                                {
                                    self.arrisonlineR.append(String(IsOnline))
                                }
                                else
                                {
                                    self.arrisonlineR.append("")
                                }
                                if let IsSponsoredUser = dict.value(forKey: "IsSponsoredUser") as? Int
                                {
                                    self.arrissponsoreduserR.append(String(IsSponsoredUser))
                                }
                                else
                                {
                                    self.arrissponsoreduserR.append("")
                                }
                                if let Name = dict.value(forKey: "Name") as? String
                                {
                                    self.arrnameR.append(String(Name))
                                }
                                else
                                {
                                    self.arrnameR.append("")
                                }
                                if let RequestStatus = dict.value(forKey: "RequestStatus") as? Int
                                {
                                    self.arrrequeststatusR.append(String(RequestStatus))
                                }
                                else
                                {
                                    self.arrrequeststatusR.append("")
                                }
                                if let idd = dict.value(forKey: "id") as? Int
                                {
                                    self.arridR.append(String(idd))
                                }
                                else
                                {
                                    self.arridR.append("")
                                }
                                if let mobile = dict.value(forKey: "mobile") as? Int
                                {
                                    self.arrmobileR.append(String(mobile))
                                }
                                else
                                {
                                    self.arrmobileR.append("")
                                }
                                
                                
                                if let profile_img = dict.value(forKey: "profile_img") as? String
                                {
                                    self.arrprofileimgR.append(String(profile_img))
                                }
                                else
                                {
                                    self.arrprofileimgR.append("")
                                }
                                
                                if let username = dict.value(forKey: "username") as? String
                                {
                                    self.arrusernameR.append(String(username))
                                }
                                else
                                {
                                    self.arrusernameR.append("")
                                }
                            }
                            if self.pulltorefresh != "1"
                            {
                                self.tablev.reloadData()
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
                self.pulltorefresh = "0"
                
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
        
    }
    
    // Marks: - UN Friends
    func UnFriend(tag : Int)
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
        
        let friendid = arridF[tag]
        let username = arrusernameF[tag]
        
       
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UserFriendRemove xmlns='http://threepin.org/'><username>\(username)</username><userId>\(userid)</userId><friendId>\(friendid)</friendId></UserFriendRemove></soap:Body></soap:Envelope>"
        
        
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
        
        if pulltorefresh != "1"
        {
          obj.startandicator(viewController: self)
        }
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
            self.pulltorefresh = "0"
            DispatchQueue.global(qos: .background).async
            {
                    obj.stopandicator(viewController: self)
            }
            refreshControl.endRefreshing()
           
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UserFriendRemoveResponse")! as Any) as AnyObject).object(forKey:"UserFriendRemoveResult")   ?? NSDictionary()
                
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
                        //MARK: - Friend Array
                        self.arrcityF.remove(at: tag)
                        self.arrisonlineF.remove(at: tag)
                        self.arrissponsoreduserF.remove(at: tag)
                        self.arrnameF.remove(at: tag)
                        self.arrrequeststatusF.remove(at: tag)
                        self.arridF.remove(at: tag)
                        self.arrmobileF.remove(at: tag)
                        self.arrprofileimgF.remove(at: tag)
                        self.arrusernameF.remove(at: tag)
                        DispatchQueue.main.async {
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
                self.pulltorefresh = "0"
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }
    // Marks: - UN Friends
    func ConfirmRequest(tag : Int, accept : String, reject : String, cancel : String)
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
        
        let friendid = arridR[tag]
        let username = arrusernameR[tag]
     
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UserFriendRequestAcceptReject xmlns='http://threepin.org/'><username>\(username)</username><userId>\(userid)</userId><friendId>\(friendid)</friendId><accepted>\(accept)</accepted><rejected>\(reject)</rejected><cancel>\(cancel)</cancel></UserFriendRequestAcceptReject></soap:Body></soap:Envelope>"
        
        
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
        
        if pulltorefresh != "1"
        {
            andicator.startAnimating()
        }
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Body: \(strData)")
            
            self.pulltorefresh = "0"
            DispatchQueue.global(qos: .background).async
                {
                    
            }
            refreshControl.endRefreshing()
            self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

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
                        //MARK: - Friend Array
                        self.arrcityR.remove(at: tag)
                        self.arrisonlineR.remove(at: tag)
                        self.arrissponsoreduserR.remove(at: tag)
                        self.arrnameR.remove(at: tag)
                        self.arrrequeststatusR.remove(at: tag)
                        self.arridR.remove(at: tag)
                        self.arrmobileR.remove(at: tag)
                        self.arrprofileimgR.remove(at: tag)
                        self.arrusernameR.remove(at: tag)
                        
                        DispatchQueue.main.async {
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
                self.pulltorefresh = "0"
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }

    
    //MARK:- Send Friend Request
    func SendRequest(tag : Int)
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
        
        let friendid = arridR[tag]
        let username = arrusernameR[tag]
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UserFriendRequest xmlns='http://threepin.org/'><username>\(username)</username><userId>\(userid)</userId><friendId>\(friendid)</friendId></UserFriendRequest></soap:Body></soap:Envelope>"
        
        
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
        
        if pulltorefresh != "1"
        {
            andicator.startAnimating()
        }
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Body: \(strData)")
            
            self.pulltorefresh = "0"
            DispatchQueue.global(qos: .background).async
                {
                    
            }
            refreshControl.endRefreshing()
            self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetUserFriendsResponse")! as Any) as AnyObject).object(forKey:"GetUserFriendsResult")   ?? NSDictionary()
                
                
                
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
                        
                        //MARK: - Friend Array
                        self.arrcityF = [String]()
                        self.arrisonlineF = [String]()
                        self.arrissponsoreduserF = [String]()
                        self.arrnameF = [String]()
                        self.arrrequeststatusF = [String]()
                        self.arridF = [String]()
                        self.arrmobileF = [String]()
                        self.arrprofileimgF = [String]()
                        self.arrusernameF = [String]()
                        
                        
                        for dict in json {
                            //dump(dict)
                            
                            
                            if let City = dict.value(forKey: "City") as? String
                            {
                                self.arrcityF.append(City)
                            }
                            else
                            {
                                self.arrcityF.append("")
                            }
                            if let IsOnline = dict.value(forKey: "IsOnline") as? Int
                            {
                                self.arrisonlineF.append(String(IsOnline))
                            }
                            else
                            {
                                self.arrisonlineF.append("")
                            }
                            if let IsSponsoredUser = dict.value(forKey: "IsSponsoredUser") as? Int
                            {
                                self.arrissponsoreduserF.append(String(IsSponsoredUser))
                            }
                            else
                            {
                                self.arrissponsoreduserF.append("")
                            }
                            if let Name = dict.value(forKey: "Name") as? String
                            {
                                self.arrnameF.append(String(Name))
                            }
                            else
                            {
                                self.arrnameF.append("")
                            }
                            if let RequestStatus = dict.value(forKey: "RequestStatus") as? Int
                            {
                                self.arrrequeststatusF.append(String(RequestStatus))
                            }
                            else
                            {
                                self.arrrequeststatusF.append("")
                            }
                            if let idd = dict.value(forKey: "id") as? String
                            {
                                self.arridF.append(String(idd))
                            }
                            else
                            {
                                self.arridF.append("")
                            }
                            if let mobile = dict.value(forKey: "mobile") as? Int
                            {
                                self.arrmobileF.append(String(mobile))
                            }
                            else
                            {
                                self.arrmobileF.append("")
                            }
                            
                            
                            if let profile_img = dict.value(forKey: "profile_img") as? String
                            {
                                self.arrprofileimgF.append(String(profile_img))
                            }
                            else
                            {
                                self.arrprofileimgF.append("")
                            }
                            
                            if let username = dict.value(forKey: "username") as? String
                            {
                                self.arrusernameF.append(String(username))
                            }
                            else
                            {
                                self.arrusernameF.append("")
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
                self.pulltorefresh = "0"
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
   }
    
    
    
    
    
    // Get Location Name from Latitude and Longitude
    
}

