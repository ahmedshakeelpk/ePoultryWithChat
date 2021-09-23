////
////  GroupInfo.swift
////  AMPL
////
////  Created by Paragon Marketing on 19/07/2017.
////  Copyright © 2017 sameer. All rights reserved.
////
//
import UIKit

class GroupInfo: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate,UIScrollViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate  {
   
    

    //MARK:- For Image Picker
    var imagePicker: UIImagePickerController!
    var popover = UIViewController()

    //////////
    var isedit = String()
    var isadmin = String()
    var type = String()
    //////////////////
    var groupid = String()
    var groupname = String()
    var groupimage = String()
    
    ///////////////////////////////////
    var arrcity = [String]()
    var arrgroupid = [String]()
    var arrisadmin = [String]()
    var arrisonline = [String]()
    var arrisuninstall = [String]()
    var arrlastseen = [String]()
    var arrlogout = [String]()
    var arrmemberid = [String]()
    var arrname = [String]()
    var arrgcmid = [String]()
    var arrid = [String]()
    var arrmob = [String]()
    var arrprofileimg = [String]()
    var arrusername = [String]()
    var arrversion = [String]()
//    
    ///////////////////////////////////
    @IBOutlet weak var headerv: UIView!
    @IBOutlet weak var imgvhead: UIImageView!
    @IBOutlet weak var lblnamehead: UILabel!
    @IBOutlet weak var lblcreatedbyhead: UILabel!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var btnexit: UIButton!
    
    ///////////////////MARK:- Popup view
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
        type = "Private"
        btnprivate.setImage(#imageLiteral(resourceName: "btnclicks"), for: .normal)
        btnpublic.setImage(#imageLiteral(resourceName: "btnunclicks"), for: .normal)
    }
    @IBAction func btnpublic(_ sender: Any) {
        btnprivate.tag = 0
        btnpublic.tag = 1
        type = "Public"
        btnpublic.setImage(#imageLiteral(resourceName: "btnclicks"), for: .normal)
        btnprivate.setImage(#imageLiteral(resourceName: "btnunclicks"), for: .normal)
    }
    @IBAction func btncancel(_ sender: Any) {
       
        popv.isHidden = true
        txttitle.text = ""
    }
    @IBAction func btnok(_ sender: Any) {
       
            if txttitle.text! != ""
            {
                UpdateGroupIcon(memberid: "", tag: 0)
                DispatchQueue.global(qos: .background).async {
                }
               
            }
            else
            {
                obj.showAlert(title: "Alert", message: "Group title is missing.", viewController: self)
            }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        button.center = (self.navigationController?.navigationBar.center)!
        button.titleLabel?.text = "Yello"
        
        button.sendSubviewToBack((self.navigationController?.navigationBar)!)
        
        
        
        
        //MARK:- Initial Assign values
        btnpublic.tag = 1
        if let temp = defaults.value(forKey: "isadmin") as? String
        {
            isadmin = temp
        }
        else
        {
            isadmin = ""
        }
        
        type = "Public"
        //
        imgvhead.layer.cornerRadius = imgvhead.frame.width / 2
        
        lblnamehead.textColor = appcolor
        lblnamehead.text = groupname
        lblcreatedbyhead.text = "Created by"
        
        //Kingfisher Image upload
        let urlprofile = URL(string: imagepath+groupimage)
        imgvhead.kf.setImage(with: urlprofile)
        GetMembersInfo()
        
        
    }
    
    //MARK:- Right button
    func rightbutton()
    {
        // Marks: - Right button multiple
        let btnadd:UIBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "addimg"), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.funaddfriend))
        let btnedit:UIBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "edit"), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.funeditfriend))
            DispatchQueue.main.async {
              
                self.navigationItem.setRightBarButtonItems([btnadd, btnedit], animated: true)
            }
    

    }
    
    //MARK:- Button Exit groupimage
    @IBAction func btnexit(_ sender: Any) {
       
        let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
        
        
        alertController.addAction(UIAlertAction(title: "Are you sure to leave the group.", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
             let tempuserid = defaults.value(forKey: "userid") as? String
            
            self.RemoveFromGroup(userid: tempuserid!, other: "0", tag: 0)
            
        })
        
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Option Function of alertview
    func funoption(sender : Int)
    {
        
        let tag = (sender - 1)
        
        let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
        
        
        alertController.addAction(UIAlertAction(title: "View Profile.", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            
            
        })
        alertController.addAction(UIAlertAction(title: "Make group admin.", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            self.AddAsAdmin(memberid: self.arrid[tag], tag: tag)
            
        })
        alertController.addAction(UIAlertAction(title: "Remove this member.", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
           
            let tempuserid = self.arrid[tag]
            self.RemoveFromGroup(userid: tempuserid, other: "1", tag: tag)
            
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
   
    
    //MARK:- Add Friend
    @objc func funaddfriend()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewGroup") as! NewGroup
        //vc.memberid = arrgroupid[]
        vc.isaddmember = "1"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- Remove Friend
    @objc func funeditfriend()
    {
        isedit = "1"
        popv.isHidden = false
        
    }
    
    //MARK:- Textfield delegates
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // Marks: - Uitextfields delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.view.endEditing(true)
        
        return true
    }

    // Marks: - Table view datasource and delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrid.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "GroupInfoNotCell") as! GroupInfoNotCell
            cell.lblparticpant.text = String(arrid.count)
            return cell
        }
        else
        {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "GroupInfoCell") as! GroupInfoCell
            
            let tag = indexPath.row - 1
            
            cell.lblname.text = arrname[tag]
            cell.lblfrom.text = arrcity[tag]
            
            let userid = defaults.value(forKey: "userid") as? String
            if arrid[tag] == userid
            {
                cell.lblname.text = "YOU"
            }
            else
            {
                
            }
            if arrversion[tag] != appver
            {
                cell.lblversion.text = "Old Version"
                cell.lblname.textColor = .red
                cell.lblseen.text = "last seen \(arrlastseen[tag])"
            }
            else
            {
                cell.lblseen.text = ""
                cell.lblversion.text = ""
                cell.lblname.textColor = .black
            }
            if arrisadmin[tag]  == "1"
            {
                cell.lbladmin.text = "~ ADMIN"
                
                if arrid[tag] == defaults.value(forKey: "userid") as! String
                {
                    self.rightbutton()
                }
            }
            else
            {
                cell.lbladmin.text = ""
            }
            
            
            //Kingfisher Image upload
            let urlprofile = URL(string: imagepath+arrprofileimg[tag])
            cell.imgvprof.kf.setImage(with: urlprofile)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isadmin == "1"
        {
           self.funoption(sender: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 0
        {
            return 70
        }
        else
        {
            return 86
        }
    }
    
    
    // Marks: - Get All Posts
    func GetMembersInfo()
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
        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMembersInfo xmlns='http://threepin.org/'><groupId>\(groupid)</groupId></GetMembersInfo></soap:Body></soap:Envelope>"
        
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
        
        
        let session = URLSession.shared
        
//        if pulltorefresh != "1"
//        {
            obj.startandicator(viewController: self)
        
       // }
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
//            if self.pulltorefresh != "1"
//            {
                DispatchQueue.main.async {
                    obj.stopandicator(viewController: self)
                }
            
           // }
            
          //  self.pulltorefresh = "0"
            
            refreshControl.endRefreshing()
            var dictionaryData = NSDictionary()
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetMembersInfoResponse")! as Any) as AnyObject).object(forKey:"GetMembersInfoResult")   ?? NSDictionary()
                
                self.arrcity = [String]()
                self.arrgroupid = [String]()
                self.arrisadmin = [String]()
                self.arrisonline = [String]()
                self.arrisuninstall = [String]()
                self.arrlastseen = [String]()
                self.arrlogout = [String]()
                self.arrmemberid = [String]()
                self.arrname = [String]()
                self.arrgcmid = [String]()
                self.arrid = [String]()
                self.arrmob = [String]()
                self.arrprofileimg = [String]()
                self.arrusername = [String]()
                self.arrversion = [String]()

                
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
                        
                        DispatchQueue.main.async {
                            
                            for dict in json {
                                // dump(dict)
                                
//
                                if let City = dict.value(forKey: "City") as? String
                                {
                                    self.arrcity.append(City)
                                }
                                else
                                {
                                    self.arrcity.append("")
                                }
                                
                                if let GroupId = dict.value(forKey: "GroupId") as? Int
                                {
                                    self.arrgroupid.append(String(GroupId))
                                }
                                else
                                {
                                    self.arrgroupid.append("")
                                }

                                if let IsAdmin = dict.value(forKey: "IsAdmin") as? Bool
                                {
                                    if IsAdmin == true
                                    {
                                        self.arrisadmin.append(String("1"))
                                    }
                                    else
                                    {
                                        self.arrisadmin.append("")
                                    }
                                    
                                }
                                else
                                {
                                    self.arrisadmin.append("")
                                }
                                
                                if let IsOnline = dict.value(forKey: "IsOnline") as? Int
                                {
                                    self.arrisonline.append(String(IsOnline))
                                }
                                else
                                {
                                    self.arrisonline.append("")
                                }
                               
                                if let IsUnistall = dict.value(forKey: "IsUnistall") as? String
                                {
                                    self.arrisuninstall.append(String(IsUnistall))
                                }
                                else
                                {
                                    self.arrisuninstall.append("")
                                }
                                
//                                if let LastSeen = dict.value(forKey: "LastSeen") as? String
//                                {
//                                   self.arrlastseen.append(LastSeen)
//                                }
//                                else
//                                {
//                                    self.arrlastseen.append("")
//                                }
                                
                                if let Logout = dict.value(forKey: "Logout") as? Int
                                {
                                    self.arrlogout.append(String(Logout))
                                }
                                else
                                {
                                    self.arrlogout.append("")
                                }

                                
                                if let MemberId = dict.value(forKey: "MemberId") as? Int
                                {
                                    self.arrmemberid.append(String(MemberId))
                                }
                                else
                                {
                                    self.arrmemberid.append("")
                                }
                                
                                if let Name = dict.value(forKey: "Name") as? String
                                {
                                    self.arrname.append(String(Name))
                                }
                                else
                                {
                                    self.arrname.append("")
                                }

                                if let idd = dict.value(forKey: "id") as? Int
                                {
                                    self.arrid.append(String(idd))
                                }
                                else
                                {
                                    self.arrid.append("")
                                }
                                
                                if let mobile = dict.value(forKey: "mobile") as? String
                                {
                                    self.arrmob.append(String(mobile))
                                }
                                else
                                {
                                    self.arrmob.append("")
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
                                
                                if let version = dict.value(forKey: "version") as? String
                                {
                                    self.arrversion.append(String(version))
                                }
                                else
                                {
                                    self.arrversion.append("")
                                }

                                
                                if let LastSeen = dict.value(forKey: "LastSeen") as? String
                                {
                                    
                                    let prefix = "/Date("
                                    let suffix = ")/"
                                    let scanner = Scanner(string: LastSeen)
                                    
                                    // Check prefix:
                                    if scanner.scanString(prefix, into: nil) {
                                        
                                        // Read milliseconds part:
                                        var milliseconds : Int64 = 0
                                        if scanner.scanInt64(&milliseconds) {
                                            // Milliseconds to seconds:
                                            var timeStamp = TimeInterval(milliseconds)/1000.0
                                            
                                            // Read optional timezone part:
                                            var timeZoneOffset : Int = 0
                                            if scanner.scanInt(&timeZoneOffset) {
                                                let hours = timeZoneOffset / 100
                                                let minutes = timeZoneOffset % 100
                                                // Adjust timestamp according to timezone:
                                                timeStamp += TimeInterval(3600 * hours + 60 * minutes)
                                            }
                                            
                                            // Check suffix:
                                            if scanner.scanString(suffix, into: nil) {
                                                // Success! Create NSDate and return.
                                                //self(timeIntervalSince1970: timeStamp)
                                                let date = NSDate(timeIntervalSince1970: timeStamp)
                                                
                                                
                                                //print(agotime)
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                                                dateFormatter.locale = NSLocale.current
                                                dateFormatter.dateFormat = "dd-MMM-yyyy" //Specify your format that you want
                                                let strDate = dateFormatter.string(from: date as Date)
                                               // let ddate = dateFormatter.date(from: strDate)
                                                
                                              //  let agotime =  self.timeAgoSinceDate(date: ddate! as NSDate, numericDates: true)
                                                //print(agotime)
                                                self.arrlastseen.append(strDate)
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    self.arrlastseen.append("")
                                }
                                
                           
//                                // self.arrcity.append(tempcity)
//                                // self.arrisactivecon.append(tempcityid)
//                                if self.lastindex == self.arrstatusid.last!
//                                {
//
//                                }
//                                else
//                                {
//                                    self.lastindex = self.arrstatusid.last!
//                                    DispatchQueue.main.async {
//                                        self.tablev.reloadData()
//
//                                    }
//                                }
                                
                            }
                            DispatchQueue.main.async {
                                
            
                                
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
                               //self.pulltorefresh = "0"
                
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
  }
    
    // Marks: - Get All Posts
    func RemoveFromGroup(userid : String, other: String, tag: Int)
    {
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><LeaveGroup xmlns='http://threepin.org/'><groupId>\(groupid)</groupId><userId>\(userid)</userId></LeaveGroup></soap:Body></soap:Envelope>"
        
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
        
        
        let session = URLSession.shared
        
        //        if pulltorefresh != "1"
        //        {
        obj.startandicator(viewController: self)
        
        // }
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
            //            if self.pulltorefresh != "1"
            //            {
            DispatchQueue.main.async {
                obj.stopandicator(viewController: self)
            }
            
            // }
            
            //  self.pulltorefresh = "0"
            
            refreshControl.endRefreshing()
            var dictionaryData = NSDictionary()
            
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "LeaveGroupResponse")! as Any) as AnyObject).object(forKey:"LeaveGroupResult")   ?? NSDictionary()
                
                
                
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
                        if other == "0"
                        {
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "leavegroup"), object: nil)
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.arrcity.remove(at: tag)
                                self.arrgroupid.remove(at: tag)
                                self.arrisadmin.remove(at: tag)
                                self.arrisonline.remove(at: tag)
                                self.arrisuninstall.remove(at: tag)
                                self.arrlastseen.remove(at: tag)
                                self.arrlogout.remove(at: tag)
                                self.arrmemberid.remove(at: tag)
                                self.arrname.remove(at: tag)
                                //self.arrgcmid.remove(at: tag)
                                self.arrid.remove(at: tag)
                                self.arrmob.remove(at: tag)
                                self.arrprofileimg.remove(at: tag)
                                self.arrusername.remove(at: tag)
                                self.arrversion.remove(at: tag)
                                DispatchQueue.main.async {
                                    self.tablev.reloadData()
                                }
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
                //self.pulltorefresh = "0"
                
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }
    
    // Marks: - Get All Posts
    func AddAsAdmin(memberid : String, tag: Int)
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

        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><MakeNewGroupAdmin xmlns='http://threepin.org/'><memberId>\(memberid)</memberId><groupId>\(groupid)</groupId><userId>\(userid)</userId></MakeNewGroupAdmin></soap:Body></soap:Envelope>"
        
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
        
        
        let session = URLSession.shared
        
        //        if pulltorefresh != "1"
        //        {
        obj.startandicator(viewController: self)
        
        // }
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
            //            if self.pulltorefresh != "1"
            //            {
            DispatchQueue.main.async {
                obj.stopandicator(viewController: self)
            }
            
            // }
            
            //  self.pulltorefresh = "0"
            
            refreshControl.endRefreshing()
            var dictionaryData = NSDictionary()
            
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "MakeNewGroupAdminResponse")! as Any) as AnyObject).object(forKey:"MakeNewGroupAdminResult")   ?? NSDictionary()
                
                
                
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
                        self.arrisadmin[tag] = "1"
                        let indexPath = IndexPath(item: tag+1, section: 0)
                        DispatchQueue.main.async {
                            
                            self.tablev.reloadRows(at: [indexPath], with: .none)
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
                //self.pulltorefresh = "0"
                
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }
    
    
    
    // Marks: - Update Group Icon
    func UpdateGroupIcon(memberid : String, tag: Int)
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
        
        let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
       
        let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
        let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
        
     // MUTABLE REQUEST
        DispatchQueue.main.async {
            let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateGroupIcon xmlns='http://threepin.org/'><groupId>\(self.groupid)</groupId><userId>\(userid)</userId><title>\(self.txttitle.text!)</title><fileName>\(String(timespam)+".jpg")</fileName><img>\(imageStr)</img><type>\("Public")</type></UpdateGroupIcon></soap:Body></soap:Envelope>"
            
            
            
            
            let soapLenth = String(soapMessage.count)
            let theUrlString = "http://websrv.zederp.net/Apml/GroupService.asmx"
            let theURL = URL(string: theUrlString)
            let mutableR = NSMutableURLRequest(url: theURL!)
            
            mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
            mutableR.httpMethod = "POST"
            mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
            
            
            let session = URLSession.shared
         
            obj.startandicator(viewController: self)
            
            let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
                
                //            if self.pulltorefresh != "1"
                //            {
                DispatchQueue.main.async {
                    obj.stopandicator(viewController: self)
                }
                
                // }
                
                //  self.pulltorefresh = "0"
                
                refreshControl.endRefreshing()
                var dictionaryData = NSDictionary()
                
                
                do
                {
                    //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateGroupIconResponse")! as Any) as AnyObject).object(forKey:"UpdateGroupIconResult")   ?? NSDictionary()
                    
                    
                    
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
                    //self.pulltorefresh = "0"
                    
                    obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                }
            })
            
            task.resume()
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
    
    /// what app will do when user choose & complete the selection image :
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        /// chcek if you can return edited image that user choose it if user already edit it(crop it), return it as image
        if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'
            self.imgv.image = editedImage
            
            /// else if you could't find the edited image that means user select original image same is it without editing .
        } else if let orginalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'.
            self.imgv.image = orginalImage
        }
        else { print ("error") }
        
        /// if the request successfully done just dismiss
        picker.dismiss(animated: true, completion: nil)
        
    }

//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
//    {
//        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        imgv.image = image
//
//        if imgv.image != nil
//        {
//
//        }
//
//
//
//
//        //        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        //        {
//        //            let headers: HTTPHeaders = [ "auth-token": "(profile_pic)" ]
//        //            let URL = try! URLRequest(url: ContainerClass.returnBaseURL()+"uploadpic", method: .post, headers: headers)
//        //
//        //            Alamofire.upload(multipartFormData: { multipartFormData in
//        //
//        //                if let imageData = UIImageJPEGRepresentation(image, 1.0)
//        //                {
//        //                    self.activity.startAnimating()
//        //
//        //                    multipartFormData.append(imageData, withName: "profilepic", fileName: "picture.jpeg", mimeType: "image/jpeg")
//        //
//        //                    multipartFormData.append("8".data(using: .utf8)!, withName: "cid")
//        //                }
//        //            }, with: URL, encodingCompletion:
//        //                {
//        //                    encodingResult in
//        //                    switch encodingResult
//        //                    {
//        //                    case .success(let upload, _, _):
//        //                        upload.responseJSON { response in
//        //                            print(response.result.value!)
//        //                            debugPrint("SUCCESS RESPONSE: \(response)")
//        //
//        //                            self.imgViewTop.image = image
//        //                            self.activity.stopAnimating()
//        //                        }
//        //                    case .failure(let encodingError):
//        //                        // hide progressbas here
//        //                        print("ERROR RESPONSE: \(encodingError)")
//        //                    }
//        //            })
//        //        }
//        //        else
//        //        {
//        //            print("Something went wrong")
//        //        }
//
//        picker.dismiss(animated: true, completion: nil)
//
//    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil);
    }
    ///////////////////////////////////////////////////
    
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        obj.stopandicator(viewController: self)
    }

    
    //////////////////// Marks: - Get time in since time ago
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = getCurrentLocalDate()
        
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    //MARK: - getting correct time was error of 4 hours now fix with this func
    func getCurrentLocalDate()-> NSDate {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = TimeZone(abbreviation: "GMT")!
        now = calendar.date(from: nowComponents)!
        return now as NSDate
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

