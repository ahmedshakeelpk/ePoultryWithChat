//
//  Search.swift
//  AMPL
//
//  Created by sameer on 10/07/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher


class Search: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {

    var type = String()
    //MARK:- Person Arrays
    var arrcity = [String]()
    var arrfriendstatus = [String]()
    var arrname = [String]()
    var arrreq = [String]()
    var arrdesignation = [String]()
    var arrid = [String]()
    var arrproimg = [String]()
    var arrusername = [String]()
    
    //MARK:- Group Arrays
    var arrcreatedby = [String]()
    var arrcreatedtime = [String]()
    var arrgroupid = [String]()
    var arrgrouptitle = [String]()
    var arrtotal = [String]()
    var arruserstatus = [String]()
    
    //MARK:- Post Arrays
    var arrcreatedon = [String]()
    var arrstatus = [String]()
    var arrstatusid = [String]()
    //////////////////////////////////////
    @IBOutlet weak var lblnorecord: UILabel!

    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var txtsearch: UITextField!
    @IBOutlet weak var btnperson: UIButton!
    
    @IBOutlet weak var btngroup: UIButton!
    
    @IBOutlet weak var btnpost: UIButton!
    
    @IBOutlet weak var btnsearch: UIButton!
   
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // txtsearch.text = "Riaz Ahmed"
        btnperson.tag = 1
        type = "PERSON"
        
        tablev.rowHeight = 128
        tablev.estimatedRowHeight = UITableView.automaticDimension
        
        //MARK:- Bottom line for the textfield
        obj.txtbottomline(textfield: txtsearch)
        //////////////////////////////////Bottom line end
    }
    
    @IBAction func btnperson(_ sender: Any) {
        tag()
        btnperson.tag = 1
        type = "PERSON"
        
        btnperson.setImage(#imageLiteral(resourceName: "btnclick"), for: .normal)
    }
    @IBAction func btngroup(_ sender: Any) {
        tag()
        btngroup.tag = 1
        type = "GROUP"
        btngroup.setImage(#imageLiteral(resourceName: "btnclick"), for: .normal)
    }
    @IBAction func btnpost(_ sender: Any) {
        tag()
        btnpost.tag = 1
        type = "POST"
        btnpost.setImage(#imageLiteral(resourceName: "btnclick"), for: .normal)
    }
    
    @IBAction func btnsearch(_ sender: Any) {
        if txtsearch.text != ""
        {
            funarrempty()
            tablev.reloadData()
            
            self.view.endEditing(true)
            DispatchQueue.main.async {
                self.search()
            }
        }
    }
    
    func tag()
    {
        btnperson.tag = 0
        btngroup.tag = 0
        btnpost.tag = 0
        
        btnperson.setImage(#imageLiteral(resourceName: "btnunclick"), for: .normal)
        btngroup.setImage(#imageLiteral(resourceName: "btnunclick"), for: .normal)
        btnpost.setImage(#imageLiteral(resourceName: "btnunclick"), for: .normal)
    }
    
    @objc func funadd(sender: UIButton)
    {
        let tag = sender.tag
        if self.arrfriendstatus[tag] == "1"
        {
            let tag = sender.tag
            let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel Request", style: UIAlertAction.Style.default)
            { action -> Void in
                // Put your code here
                self.arrfriendstatus[tag] = "0"
               
                self.ConfirmRequest(tag: tag, accept: "0", reject: "0", cancel: "1")
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
            { action -> Void in
                
            })
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.arrfriendstatus[tag] = "1"
            
            SendRequest(tag: tag)
        }
    }
    
    func funarrempty()
    {
        self.arrcity = [String]()
        self.arrfriendstatus = [String]()
        self.arrname = [String]()
        self.arrreq = [String]()
        self.arrdesignation = [String]()
        self.arrid = [String]()
        self.arrproimg = [String]()
        self.arrusername = [String]()
        
        //MARK:- Group
        self.arrcreatedby = [String]()
        self.arrcreatedtime = [String]()
        self.arrgroupid = [String]()
        self.arrgrouptitle = [String]()
        self.arrtotal = [String]()
        self.arruserstatus = [String]()
        
        //MARK:- Post
        self.arrcreatedon = [String]()
        self.arrstatus = [String]()
        self.arrstatusid = [String]()
    }
    
    //////////////////////////////////////
    // MARK: - Return button delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    /////////////////////////////////////////////////////////////////////
    // Marks: - UISCroll view delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Marks: - Table view datasource and delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.btnperson.tag == 1
        {
            if arrid.count > 0
            {
                lblnorecord.isHidden = true
            }
            else
            {
                lblnorecord.isHidden = false
            }

            return arrid.count
        }
        else if self.btngroup.tag == 1
        {
            if arrgrouptitle.count > 0
            {
                lblnorecord.isHidden = true
            }
            else
            {
                lblnorecord.isHidden = false
            }
            return arrgrouptitle.count
        }
        else if self .btnpost.tag == 1
        {
            if arrstatusid.count > 0
            {
                lblnorecord.isHidden = true
            }
            else
            {
                lblnorecord.isHidden = false
            }
            
            return arrstatusid.count
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! SearchCell
        
        if self.btnperson.tag == 1
        {
            cell.lbltitle.text = arrname[indexPath.row]
            cell.lblfrom.text = "From: \(arrcity[indexPath.row])"
            
            if arrid[indexPath.row] != defaults.value(forKey: "userid") as! String
            {
                if arrfriendstatus[indexPath.row] != "2"
                {
                    cell.btnadd.tag = indexPath.row
                    cell.btnadd.addTarget(self, action: #selector(funadd), for: .touchUpInside)
                }
//                cell.btnadd.isHidden = false
//                cell.lbladd.isHidden = false
//                cell.imgvadd.isHidden = false
            }
            else
            {
                cell.btnadd.tag = indexPath.row
                cell.btnadd.addTarget(self, action: #selector(funadd), for: .touchUpInside)
//                cell.btnadd.isHidden = true
//                cell.lbladd.isHidden = true
//                cell.imgvadd.isHidden = true
            }
            cell.btnadd.isHidden = true
            cell.lbladd.isHidden = true
            cell.imgvadd.isHidden = true
            //Kingfisher Image upload
            let urlprofile = URL(string: userimagepath+arrproimg[indexPath.row])
            cell.imgv.kf.setImage(with: urlprofile) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    cell.imgv.image = value.image
                    
                case .failure(let error):
                    print("Error: \(error)")
                    cell.imgv.image = UIImage(named: "user")
                }
            }
            
            if arrfriendstatus[indexPath.row] == "1"
            {
                cell.imgvadd.image = #imageLiteral(resourceName: "pending")
                cell.lbladd.text = "Pending Request"
                cell.lbladd.textColor = apppendingcolor
            }
            else if arrfriendstatus[indexPath.row] == "0"
            {
                cell.imgvadd.image = #imageLiteral(resourceName: "addgray")
                cell.lbladd.text = "Add Friend"
                cell.lbladd.textColor = appgraycolor
            }
            else if arrfriendstatus[indexPath.row] == "2"
            {
                cell.imgvadd.image = #imageLiteral(resourceName: "addimg")
                cell.lbladd.text = "Friends"
                cell.lbladd.textColor = appcolor
                
            }
        }
        else if self.btngroup.tag == 1
        {
            cell.lbltitle.text = arrgrouptitle[indexPath.row]
            cell.lblfrom.text = "Members Count: \(arrtotal[indexPath.row])"
            //Kingfisher Image upload
            if arrproimg[indexPath.row] == ""
            {
                cell.imgv.image = #imageLiteral(resourceName: "groupimg")
            }
            else
            {
                let urlprofile = URL(string: imagepath+arrproimg[indexPath.row])
                cell.imgv.kf.setImage(with: urlprofile)
            }
            
            cell.btnadd.isHidden = true
            cell.lbladd.isHidden = true
            cell.imgvadd.isHidden = true
        }
        else if self .btnpost.tag == 1
        {
            cell.lbltitle.text = arrstatus[indexPath.row]
            cell.lblfrom.text = arrcreatedon[indexPath.row]
            
            cell.btnadd.isHidden = true
            cell.lbladd.isHidden = true
            cell.imgvadd.isHidden = true
        }
        
        cell.lbltitle.text = cell.lbltitle.text!.replacingOccurrences(of: "_&epoultry&_", with: "\n\n", options: .literal, range: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let role = defaults.value(forKey: "role") as! String
        if btnperson.tag == 1
        {
           if (arrid[indexPath.row]) == (defaults.value(forKey: "userid") as! String)
           {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileAdmin") as! ProfileAdmin
            vc.userdetailid = arrid[indexPath.row]
            vc.username = arrusername[indexPath.row]
            vc.request = arrfriendstatus[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
           }
            else 
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileShort") as! ProfileShort
                vc.userdetailid = arrid[indexPath.row]
                vc.username = arrusername[indexPath.row]
                vc.request = arrfriendstatus[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if btngroup.tag == 1
        {
            
        }
        else if btnpost.tag == 1
        {
            
        }
    }
    
    func search(){
        var temptype = ""
        if type == "PERSON"{
            temptype = "person"
        }
        else if type == "GROUP"{
            temptype = "channel"
        }
        else if type == "POST"{
            temptype = "post"
        }
        let tmepuserid = defaults.value(forKey: "userid") as! String
//        let parameters : Parameters =
//            ["search": txtsearch.text!,
//             "limit":40,
//             "offset":0,
//             "userId":defaults.value(forKey: "userid") as! String]
        
        var url = BASEURL+"search/\(temptype)?search=\(txtsearch.text ?? "")&userId=\(tmepuserid)&limit=\(40)&offset=\(0)"
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       
        print(url)
        
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
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0
                            {
                                do
                                {
                                    self.funarrempty()
                                    if let dataarr = (datadic.value(forKey: "data") as? NSArray)
                                    {
                                        for temp in dataarr {
                                            let dict = temp as! NSDictionary
                                            if self.btnperson.tag == 1
                                            {
                                                if let City = dict.value(forKey: "City") as? String
                                                {
                                                    self.arrcity.append(City)
                                                }
                                                else
                                                {
                                                    self.arrcity.append("")
                                                }
                                                if let FriendStatus = dict.value(forKey: "FriendStatus") as? Int
                                                {
                                                    self.arrfriendstatus.append(String(FriendStatus))
                                                }
                                                else
                                                {
                                                    self.arrfriendstatus.append("")
                                                }
                                                if let Name = dict.value(forKey: "Name") as? String
                                                {
                                                    self.arrname.append(String(Name))
                                                }
                                                else
                                                {
                                                    self.arrname.append("")
                                                }
                                                if let Request = dict.value(forKey: "Request") as? Int
                                                {
                                                    self.arrreq.append(String(Request))
                                                }
                                                else
                                                {
                                                    self.arrreq.append("")
                                                }
                                                if let designation = dict.value(forKey: "designation") as? String
                                                {
                                                    self.arrdesignation.append(String(designation))
                                                }
                                                else
                                                {
                                                    self.arrdesignation.append("")
                                                }
                                        
                                                if let idd = dict.value(forKey: "id") as? Int
                                                {
                                                    self.arrid.append(String(idd))
                                                }
                                                else
                                                {
                                                    self.arrid.append("")
                                                }
                                                if let profile_img = dict.value(forKey: "profile_img") as? String
                                                {
                                                    self.arrproimg.append(String(profile_img))
                                                }
                                                else
                                                {
                                                    self.arrproimg.append("")
                                                }
                                                if let username = dict.value(forKey: "username") as? String
                                                {
                                                    self.arrusername.append(String(username))
                                                }
                                                else
                                                {
                                                    self.arrusername.append("")
                                                }
                                        
                                            }
                                            else if self.btngroup.tag == 1
                                            {
                                                if let CreatedBy = dict.value(forKey: "CreatedBy") as? Int
                                                {
                                                    self.arrcreatedby.append(String(CreatedBy))
                                                }
                                                else
                                                {
                                                    self.arrcreatedby.append("")
                                                }
                                                if let CreatedTime = dict.value(forKey: "CreatedTime") as? String
                                                {
                                                    self.arrcreatedtime.append(String(CreatedTime))
                                                }
                                                else
                                                {
                                                    self.arrcreatedtime.append("")
                                                }
                                                if let GroupId = dict.value(forKey: "GroupId") as? String
                                                {
                                                    self.arrgroupid.append(String(GroupId))
                                                }
                                                else
                                                {
                                                    self.arrgroupid.append("")
                                                }
                                                if let GroupProfilePic = dict.value(forKey: "GroupProfilePic") as? String
                                                {
                                                    self.arrproimg.append(String(GroupProfilePic))
                                                }
                                                else
                                                {
                                                    self.arrproimg.append("")
                                                }
                                                if let GroupTitle = dict.value(forKey: "GroupTitle") as? String
                                                {
                                                    self.arrgrouptitle.append(String(GroupTitle))
                                                }
                                                else
                                                {
                                                    self.arrgrouptitle.append("")
                                                }
                                        
                                                if let Total = dict.value(forKey: "Total") as? Int
                                                {
                                                    self.arrtotal.append(String(Total))
                                                }
                                                else
                                                {
                                                    self.arrtotal.append("")
                                                }
                                                if let userstatus = dict.value(forKey: "userstatus") as? String
                                                {
                                                    self.arruserstatus.append(String(userstatus))
                                                }
                                                else
                                                {
                                                    self.arruserstatus.append("")
                                                }
                                            }
                                            else if self.btnpost.tag == 1
                                            {
                                                if let Status = dict.value(forKey: "Status") as? String
                                                {
                                                    self.arrstatus.append(String(Status))
                                                }
                                                else
                                                {
                                                    self.arrstatus.append("")
                                                }
                                        
                                                if let StatusId = dict.value(forKey: "StatusId") as? Int
                                                {
                                                    self.arrstatusid.append(String(StatusId))
                                                }
                                                else
                                                {
                                                    self.arrstatusid.append("")
                                                }
                                        
                                                if let CreatedOn = dict.value(forKey: "CreatedOn") as? String
                                                {
                                                    var strtime = CreatedOn.replacingOccurrences(of: "T", with: " ")
                                                    let dfmatter = DateFormatter()
                                                    dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                                    dfmatter.locale = Locale(identifier: "en_US_POSIX")
                                                    dfmatter.timeZone = TimeZone.autoupdatingCurrent //Current time zone
                                                    
                                                    strtime = strtime.components(separatedBy: ".")[0]
                                                    print(strtime)
                                                    
                                                    let agotime = obj.timeAgoSinceDate(dfmatter.date(from: strtime)!)
                                                    
                                                    self.arrcreatedon.append(agotime!)
                                                }
                                                else
                                                {
                                                    self.arrcreatedon.append("")
                                                }
                                                DispatchQueue.main.async {
                                                    self.tablev.reloadData()
                                                }
                                            }
                                         else
                                         {
                                             obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                                         }
                                        }
                                    }
                                }
                                catch
                                {
                                    print("Your Dictionary value nil")
                                }
                            }
                            else
                            {
                                obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                            }
                            DispatchQueue.main.async {
                                self.tablev.reloadData()
                            }
                        }
                        else
                        {
                            obj.showAlert(title: "Error", message: "error!", viewController: self)
                        }
                    }
                }//MARK:- Dispatch Queue
        })
    }
//    // Marks: - Get All Posts
//    func searchOld()
//    {
//        var userid = String()
//        if let tempid = defaults.value(forKey: "userid") as? String
//        {
//            userid = tempid
//        }
//        else
//        {
//            userid = ""
//        }
//
//
//        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><PerformSearch xmlns='http://threepin.org/'><search>\(txtsearch.text!)</search><type>\(type)</type><userId>677</userId></PerformSearch></soap:Body></soap:Envelope>"
//
//        let soapLenth = String(soapMessage.count)
//        let theUrlString = "http://websrv.zederp.net/Apml/ProfileService.asmx"
//        let theURL = URL(string: theUrlString)
//        let mutableR = NSMutableURLRequest(url: theURL!)
//
//        // MUTABLE REQUEST
//
//        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
//        mutableR.httpMethod = "POST"
//        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
//
//        let session = URLSession.shared
//
//        andicator.startAnimating()
//
//        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
//            self.andicator.stopAnimating()
//            var dictionaryData = NSDictionary()
//
//            do
//            {
//                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
//                dictionaryData as NSDictionary
//                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "PerformSearchResponse")! as Any) as AnyObject).object(forKey:"PerformSearchResult")   ?? NSDictionary()
//
//                self.funarrempty()
//                if (mainDict as AnyObject).count > 0{
//
//                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//
//                    let text = mainD.value(forKey: "text") as! NSString
//                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
//                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
//
//                    if text == "0"
//                    {
//                        obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
//                    }
//                    else
//                    {
//                        let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
//                        for dict in json {
//                            // dump(dict)
//
//                            //
//                            if self.btnperson.tag == 1
//                            {
//
//                                if let City = dict.value(forKey: "City") as? String
//                                {
//                                    self.arrcity.append(City)
//                                }
//                                else
//                                {
//                                    self.arrcity.append("")
//                                }
//                                if let FriendStatus = dict.value(forKey: "FriendStatus") as? Int
//                                {
//                                    self.arrfriendstatus.append(String(FriendStatus))
//                                }
//                                else
//                                {
//                                    self.arrfriendstatus.append("")
//                                }
//                                if let Name = dict.value(forKey: "Name") as? String
//                                {
//                                    self.arrname.append(String(Name))
//                                }
//                                else
//                                {
//                                    self.arrname.append("")
//                                }
//                                if let Request = dict.value(forKey: "Request") as? Int
//                                {
//                                    self.arrreq.append(String(Request))
//                                }
//                                else
//                                {
//                                    self.arrreq.append("")
//                                }
//                                if let designation = dict.value(forKey: "designation") as? String
//                                {
//                                    self.arrdesignation.append(String(designation))
//                                }
//                                else
//                                {
//                                    self.arrdesignation.append("")
//                                }
//
//                                if let idd = dict.value(forKey: "id") as? Int
//                                {
//                                    self.arrid.append(String(idd))
//                                }
//                                else
//                                {
//                                    self.arrid.append("")
//                                }
//                                if let profile_img = dict.value(forKey: "profile_img") as? String
//                                {
//                                    self.arrproimg.append(String(profile_img))
//                                }
//                                else
//                                {
//                                    self.arrproimg.append("")
//                                }
//                                if let username = dict.value(forKey: "username") as? String
//                                {
//                                    self.arrusername.append(String(username))
//                                }
//                                else
//                                {
//                                    self.arrusername.append("")
//                                }
//
//                            }
//                            else if self.btngroup.tag == 1
//                            {
//                                if let CreatedBy = dict.value(forKey: "CreatedBy") as? Int
//                                {
//                                    self.arrcreatedby.append(String(CreatedBy))
//                                }
//                                else
//                                {
//                                    self.arrcreatedby.append("")
//                                }
//                                if let CreatedTime = dict.value(forKey: "CreatedTime") as? String
//                                {
//                                    self.arrcreatedtime.append(String(CreatedTime))
//                                }
//                                else
//                                {
//                                    self.arrcreatedtime.append("")
//                                }
//                                if let GroupId = dict.value(forKey: "GroupId") as? String
//                                {
//                                    self.arrgroupid.append(String(GroupId))
//                                }
//                                else
//                                {
//                                    self.arrgroupid.append("")
//                                }
//                                if let GroupProfilePic = dict.value(forKey: "GroupProfilePic") as? String
//                                {
//                                    self.arrproimg.append(String(GroupProfilePic))
//                                }
//                                else
//                                {
//                                    self.arrproimg.append("")
//                                }
//                                if let GroupTitle = dict.value(forKey: "GroupTitle") as? String
//                                {
//                                    self.arrgrouptitle.append(String(GroupTitle))
//                                }
//                                else
//                                {
//                                    self.arrgrouptitle.append("")
//                                }
//
//                                if let Total = dict.value(forKey: "Total") as? Int
//                                {
//                                    self.arrtotal.append(String(Total))
//                                }
//                                else
//                                {
//                                    self.arrtotal.append("")
//                                }
//                                if let userstatus = dict.value(forKey: "userstatus") as? String
//                                {
//                                    self.arruserstatus.append(String(userstatus))
//                                }
//                                else
//                                {
//                                    self.arruserstatus.append("")
//                                }
//
//                            }
//                            else if self.btnpost.tag == 1
//                            {
//                                if let Status = dict.value(forKey: "Status") as? String
//                                {
//                                    self.arrstatus.append(String(Status))
//                                }
//                                else
//                                {
//                                    self.arrstatus.append("")
//                                }
//
//                                if let StatusId = dict.value(forKey: "StatusId") as? Int
//                                {
//                                    self.arrstatusid.append(String(StatusId))
//                                }
//                                else
//                                {
//                                    self.arrstatusid.append("")
//                                }
//
//                                if let CreatedOn = dict.value(forKey: "CreatedOn") as? String
//                                {
//
//                                    let prefix = "/Date("
//                                    let suffix = ")/"
//                                    let scanner = Scanner(string: CreatedOn)
//
//                                    // Check prefix:
//                                    if scanner.scanString(prefix, into: nil) {
//
//                                        // Read milliseconds part:
//                                        var milliseconds : Int64 = 0
//                                        if scanner.scanInt64(&milliseconds) {
//                                            // Milliseconds to seconds:
//                                            var timeStamp = TimeInterval(milliseconds)/1000.0
//
//                                            // Read optional timezone part:
//                                            var timeZoneOffset : Int = 0
//                                            if scanner.scanInt(&timeZoneOffset) {
//                                                let hours = timeZoneOffset / 100
//                                                let minutes = timeZoneOffset % 100
//                                                // Adjust timestamp according to timezone:
//                                                timeStamp += TimeInterval(3600 * hours + 60 * minutes)
//                                            }
//
//                                            // Check suffix:
//                                            if scanner.scanString(suffix, into: nil) {
//                                                // Success! Create NSDate and return.
//                                                //self(timeIntervalSince1970: timeStamp)
//                                                let date = NSDate(timeIntervalSince1970: timeStamp)
//
//
//                                                //print(agotime)
//                                                let dateFormatter = DateFormatter()
//                                                dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//                                                dateFormatter.locale = NSLocale.current
//                                                dateFormatter.dateFormat = "dd-MMM-yyyy" //Specify your format that you want
//                                                let strDate = dateFormatter.string(from: date as Date)
//
//                                                self.arrcreatedon.append(strDate)
//                                                // self.arrname.append(ddate)
//                                            }
//                                        }
//                                    }
//                                }
//                                else
//                                {
//                                    // self.arrtime.append("")
//                                }
//                            }
//                            DispatchQueue.main.async {
//                                self.tablev.reloadData()
//                            }
//                        }
//                        DispatchQueue.main.async {
//                            self.tablev.reloadData()
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
//            if error != nil
//            {
//                self.andicator.stopAnimating()
//                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
//            }
//        })
//
//        task.resume()
//    }

    
    
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
        
        let friendid = arrid[tag]
        let username = arrusername[tag]
        
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
                        
                        
                        //MARK:- Person Arrays
                        
                        
                        //                        self.arrcity.remove(at: tag)
                        //                        self.arrfriendstatus.remove(at: tag)
                        //                        self.arrname.remove(at: tag)
                        //                        self.arrreq.remove(at: tag)
                        //                        self.arrdesignation.remove(at: tag)
                        //                        self.arrid.remove(at: tag)
                        //                        self.arrproimg.remove(at: tag)
                        //                        self.arrusername.remove(at: tag)
                        //
                        
                        let indexPath = IndexPath(item: tag, section: 0)
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
//         DispatchQueue.global(qos: .background).async {
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
//                            
//                            
//                            //MARK:- Person Arrays
//                            
//                            
//                            //                        self.arrcity.remove(at: tag)
//                            //                        self.arrfriendstatus.remove(at: tag)
//                            //                        self.arrname.remove(at: tag)
//                            //                        self.arrreq.remove(at: tag)
//                            //                        self.arrdesignation.remove(at: tag)
//                            //                        self.arrid.remove(at: tag)
//                            //                        self.arrproimg.remove(at: tag)
//                            //                        self.arrusername.remove(at: tag)
//                            //
//                            
//                            let indexPath = IndexPath(item: tag, section: 0)
//                            DispatchQueue.main.async {
//                                self.tablev.reloadRows(at: [indexPath], with: .none)
//                            }
//                            
//                            
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
        
        let friendid = arrid[tag]
        let username = arrusername[tag]
        
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
                        let indexPath = IndexPath(item: tag, section: 0)
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
//        DispatchQueue.global(qos: .background).async {
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
//                            let indexPath = IndexPath(item: tag, section: 0)
//                            DispatchQueue.main.async {
//                                self.tablev.reloadRows(at: [indexPath], with: .none)
//                            }
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
