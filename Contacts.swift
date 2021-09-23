//
//  Contacts.swift
//  ZedChat
//
//  Created by MacBook Pro on 13/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import XLPagerTabStrip
import UIImageView_Letters
import Alamofire
import FirebaseDatabase

var arrGfullname = [String]()
var arrGfname = [String]()
var arrGlname = [String]()
var arrGnumber = [String]()
var arrGnumberWithoutSpaces = NSMutableArray()
var arrGpic = NSMutableArray()

var arrGfullname_AppUser = [String]()
var arrGfname_AppUser = [String]()
var arrGlname_AppUser = [String]()
var arrGnumber_AppUser = [String]()
var arrGuserid_AppUser = [String]()
var arrGnumberWithoutSpaces_AppUser = NSMutableArray()
var arrGpic_AppUser = NSMutableArray()


var arrGRectifyPhone = NSMutableArray()
var arrGuserphone = NSMutableArray()
var arrGuserid = NSMutableArray()
var arrGusername = NSMutableArray()
var arrGuserpic = NSMutableArray()
var arrGuserFBToken = NSMutableArray()
var arrGuserUid = NSMutableArray()

class Contacts: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CNContactViewControllerDelegate {
    var refreshControl = UIRefreshControl()
    var tableviewframe = CGFloat()
    
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var txtsearch: UITextField!
    override func viewWillAppear(_ animated: Bool) {
    //self.funSortData()
    self.tablev.reloadData {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contactrefresh"), object: ["isPull":"1"])
    }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "contacts"])
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        
    }
    
    override func viewDidLoad() {
        
        self.title = "Contacts"
        // Back Button with image
        let backBtn = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        funSearchSetting()
        super.viewDidLoad()
        
        tableviewframe = tablev.frame.size.height
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "ContactsCell", bundle: nil), forCellReuseIdentifier: "ContactsCell")
        self.tablev.register(UINib(nibName: "CallMessageCell", bundle: nil), forCellReuseIdentifier: "CallMessageCell")
        self.tablev.register(UINib(nibName: "CreateGroupTitleCell", bundle: nil), forCellReuseIdentifier: "CreateGroupTitleCell")
        
        // search textfield func
        //MARK:- Notification when tap on some user
        NotificationCenter.default.removeObserver(self)
      //  NotificationCenter.default.addObserver(self, selector: #selector(searchshowhide), name: NSNotification.Name(rawValue: "searchshowhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchhide), name: NSNotification.Name(rawValue: "searchhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactrefresh), name: NSNotification.Name(rawValue: "contactrefreshContacts"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startAndicator), name: NSNotification.Name(rawValue: "startAndicator"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopAndicator), name: NSNotification.Name(rawValue: "stopAndicator"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endRefresh), name: NSNotification.Name(rawValue: "endRefresh"), object: nil)
        
        btncancelSearch.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: self.txtsearch, imgname: "searchbar", x: 15, width: 10, height: 10)
        
        obj.setTextFieldShade(textfield: txtsearch)
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: txtsearch, imgname: "cross", x: 20, width: 15, height: 15)
        btncancelSearch.addTarget(self, action: #selector(btncancelSearch(sender:)), for: .touchUpInside)
        
        obj.setTextFieldShade(textfield: txtsearch)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tablev.addSubview(refreshControl) // not required when using UITableViewController
    }
    func funSearchSetting()
    {
        let btncancelSearch = UIButton(type: .custom)
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: txtsearch, imgname: "crosssmall", x: 20, width: 15, height: 15)
        btncancelSearch.addTarget(self, action: #selector(btncancelSearch(sender:)), for: .touchUpInside)
    
        let searchbtn = UIButton(type: .system)
        searchbtn.setImage(UIImage(named: "searchbar"), for: .normal)
        searchbtn.addTarget(self, action: #selector(self.funSearch), for: .touchUpInside)
        searchbtn.sizeToFit()
        let search = UIBarButtonItem(customView: searchbtn)
    
        self.navigationItem.rightBarButtonItems = [search]
    
    // obj.setTextFieldShade(textfield: txtsearch)
        // search textfield func
    
    
        txtsearch.delegate = self
        txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
        DispatchQueue.main.async {
            self.txtsearch.layer.borderColor = UIColor.clear.cgColor
            self.txtsearch.layer.borderWidth = 0
        }
    }
    @objc func funback()
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func funSearch()
    {
        if txtsearch.isHidden == true
        {
            navigationItem.titleView = txtsearch
            txtsearch.becomeFirstResponder()
            txtsearch.textColor = .white
            txtsearch.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                                                                 
            txtsearch.isHidden = false
         //   tablev.frame.origin.y = txtsearch.frame.maxY
          //  self.tablev.frame.size.height = self.view.frame.size.height - (self.txtsearch.frame.maxY)
        }
        else
        {
            
            searchhide()
           // let navigationBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
         //   tablev.frame.origin.y = navigationBarHeight
          //  self.tablev.frame.size.height = self.view.frame.size.height
        }
        DispatchQueue.main.async {
            
        }
    }
    
    
    @objc func refresh(sender:AnyObject) {
        //retreiveMessages()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contactrefresh"), object: ["isPull":"1"])
        // Code to refresh table view
    }
    
    @objc func endRefresh()
    {
        self.tablev.reloadData {
            self.change()
            self.refreshControl.endRefreshing()
        }
    }
    @objc func startAndicator()
    {
        andicator.startAnimating()
    }
    @objc func stopAndicator()
    {
        tablev.reloadData {
            self.andicator.stopAnimating()
            DispatchQueue.main.async {
                obj.showToast(message: "Contact Refresh.", viewcontroller: self)
            }
        }
    }
    @objc func contactrefresh(notification: Notification)
    {
        self.tablev.reloadData {
            self.andicator.stopAnimating()
            self.change()
        }
    }
    @objc func searchshowhide(notification: Notification)
    {
        let textfield = notification.object as! NSDictionary
        let  temptxtsearch = textfield.value(forKey: "textfield") as! UITextField
        temptxtsearch.delegate = self
        temptxtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
        txtsearch = temptxtsearch
        txtsearch.delegate = self
        //        if txtsearch.isHidden == true
        //        {
        //            txtsearch.isHidden = false
        //            tablev.frame.origin.y = txtsearch.frame.maxY
        //            tablev.frame.size.height = self.view.frame.size.height - (txtsearch.frame.maxY)
        //        }
        //        else
        //        {
        //            self.view.endEditing(true)
        //            txtsearch.isHidden = true
        //            tablev.frame.origin.y = 0
        //            tablev.frame.size.height = self.view.frame.size.height
        //        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 {
            if isFiltered == true
            {
                return arrSearchIndex.count
            }
            else
            {
                return arrGnumber.count
            }
        }
        else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
             let cell = tablev.dequeueReusableCell(withIdentifier: "CreateGroupTitleCell", for: indexPath) as! CreateGroupTitleCell
                       //setView(imgv: cell.imgv, view: cell.imgvbg, section: indexPath.section, row: index)
                       
                       if indexPath.row == 0{
                           cell.lbltitle.text = "Create Group"
                           cell.imgv.image = UIImage(named: "creategroup")
                       }else {
                           cell.lbltitle.text = "Create Contact"
                           cell.imgv.image = UIImage(named: "createcontact")
                       }
                       obj.setImageHeighWidth4Pad(image: cell.imgv, viewcontroller: self)
                       obj.setViewCircle(view: cell.imgvbg, viewcontroller: self)
                       
                       return cell
        }
        else if indexPath.section == 1 {
            let cell = tablev.dequeueReusableCell(withIdentifier: "ContactsCell") as! ContactsCell
            var index = indexPath.row
            if isFiltered == true
            {
                index = arrSearchIndex[index] as! Int
            }
            cell.lblname.text = "\(arrGfullname[index])"
            // cell.lblname.text = "\(arrfname[indexPath.row]) \(arrlname[indexPath.row])"
            cell.lblnumber.text = arrGnumber[index]
            cell.btnprofilepic.tag = index
            cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic(sender:)), for: .touchUpInside)
            funCellSetting(index: index, button: cell.btninvite, imgv: cell.imgv, view: cell.imgvbg)
            
            return cell
        }
        else{
            let cell = tablev.dequeueReusableCell(withIdentifier: "CreateGroupTitleCell", for: indexPath) as! CreateGroupTitleCell
            if indexPath.row == 0
            {
                cell.lbltitle.text = "Invite a friend"
            }
            else if  indexPath.row == 1
            {
                cell.lbltitle.text = "Contact Help"
            }
            if indexPath.row == 0
            {
                cell.imgv.image = UIImage(named: "shareandroid")
            }
            else if  indexPath.row == 1
            {
                cell.imgv.image = UIImage(named: "helpwhite")
            }
            obj.setImageHeighWidth4Pad(image: cell.imgv, viewcontroller: self)
            obj.setViewCircle(view: cell.imgvbg, viewcontroller: self)
            //setView(imgv: cell.imgv, view: cell.imgvbg, section: indexPath.section, row: index)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if indexPath.section == 0
        {
            if indexPath.row == 0{
                let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "CreateGroup") as! CreateGroup
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 1{
                let newContact = CNMutableContact()
                newContact.phoneNumbers.append(CNLabeledValue(label: "home", value: CNPhoneNumber(stringValue: "")))

                let contactVC = CNContactViewController(forUnknownContact: newContact)
                
                contactVC.contactStore = CNContactStore()
                
               // contactVC.hidesBottomBarWhenPushed = true
                contactVC.allowsEditing = false
                contactVC.allowsActions = false
                contactVC.delegate = self
                // 3
                navigationController?.navigationBar.isHidden = false
                navigationController?.navigationBar.tintColor = appclr
                navigationController?.navigationItem.hidesBackButton = false
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(contactVC, animated: true)
                }
            }
        }
        else if indexPath.section == 1
        {
            var index = indexPath.row
            if isFiltered == true
            {
                index = arrSearchIndex[index] as! Int
            }
            
            if arrGuserid.count > 1
            {
                var tempphone = arrGnumber[index]
                tempphone = tempphone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                if tempphone.first == "0" || tempphone.first == "+"
                {
                    tempphone.removeFirst()
                }
                if tempphone.first == "0"
                {
                    tempphone.removeFirst()
                }
                
                let itemsArray = arrGuserphone as! [String]
                let searchToSearch = tempphone
                self.find(value: searchToSearch, in: itemsArray) { userindex in
                    guard let userindex = userindex else { return }
                    if UIApplication.shared.isKeyboardPresented {
                        if self.txtsearch != nil{
                            self.txtsearch.resignFirstResponder()
                        }
                    }
                    
                    
                    if let userid = arrGuserid[userindex] as? Int
                    {
                        DispatchQueue.main.async {
                            self.funChatScreen(userid: "\(userid)", userindex: userindex, indexrow: index)
                        }
                    }
                    else if let userid = arrGuserid[userindex] as? String
                    {
                        DispatchQueue.main.async {
                            self.funChatScreen(userid: "\(userid)", userindex: userindex, indexrow: index)
                        }
                    }
                }
                
                
                //            let userindex = find(value: searchToSearch, in: itemsArray)
                //            if userindex != nil
                //            {
                //                if let userid = arruserid[userindex!] as? Int
                //                {
                //                    funChatScreen(userid: "\(userid)", userindex: userindex!, indexrow: index)
                //                }
                //            }
            }
        }
        else
        {
           if indexPath.section == 2{
                if indexPath.row == 0{
                    let cell = tablev.dequeueReusableCell(withIdentifier: "CreateGroupTitleCell") as! CreateGroupTitleCell
                    funShare(sender: cell.lbltitle)
                }
                else if indexPath.row == 1{
                    let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "WebView") as! WebView
                    vc.strtitle = "Help"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    func setImageinCell(index: Int, imgv: UIImageView, imgvbg: UIView)
    {
        var tempphone = arrGnumber[index]
        tempphone = tempphone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if tempphone.first == "0" || tempphone.first == "+"
        {
            tempphone.removeFirst()
        }
        if tempphone.first == "0"
        {
            tempphone.removeFirst()
        }
        
        let itemsArray = arrGuserphone as! [String]
        let searchToSearch = tempphone
        findIndex(value: searchToSearch, in: itemsArray) { userindex in
            guard let userindex = userindex else {
                let number = Int.random(in: 0 ..< 6)
                let arrclr = arrcolor[number]
                
                imgv.setImageWith(("\(arrGfullname[index])"), color: .clear , circular: true)
                self.applyGradient(colours: arrclr, view: imgvbg)
                return
            }
            
            if let temp = arrGuserpic[userindex] as? String
            {
                if temp == ""
                {
                    imgv.image = UIImage(named: "user")
//                    let number = Int.random(in: 0 ..< 6)
//                    let arrclr = arrcolor[number]
//                    imgv.setImageWith(("\(arrGfullname[index])"), color: .clear , circular: true)
//                    self.applyGradient(colours: arrclr, view: imgvbg)
                }else {
                    let url = URL(string: USER_IMAGE_PATH + "\(arrGuserpic[userindex])")
                    //Kingfisher Image upload
                    imgv.kf.setImage(with: url) { result in
                        switch result {
                        case .success(let value):
                            print("Image: \(value.image). Got from: \(value.cacheType)")
                            imgv.image = value.image
                            
                            
                        case .failure(let error):
                            print("Error: \(error)")
                            imgv.image = UIImage(named: "user")
                        }
                    }
                }
            }
            else
            {
                imgv.image = UIImage(named: "user")
//                let number = Int.random(in: 0 ..< 6)
//                let arrclr = arrcolor[number]
//                imgv.setImageWith(("\(arrGfullname[index])"), color: .clear , circular: true)
//                self.applyGradient(colours: arrclr, view: imgvbg)
            }
        }
    }
    
    func find(value searchValue: String, in array: [String], completion: @escaping (_ userindex: Int?) -> Void) {
        
        let itemsArray = array
        let searchToSearch = searchValue
        
        let filteredStrings = itemsArray.filter({(item: String) -> Bool in
            
            let stringMatch = item.lowercased().range(of: searchToSearch.lowercased())
            return stringMatch != nil ? true : false
        })
        
        if filteredStrings.count > 0
        {
            //andicator.startAnimating()
            if filteredStrings.count == 1
            {
                let tempnumber = filteredStrings[0]
                if arrGuserphone.contains(tempnumber){
                    completion(arrGuserphone.index(of: tempnumber))
                }
            }
            else
            {
                for (index, tempnumber) in filteredStrings.enumerated()
                {
                    if arrGuserphone.contains(tempnumber){
                        let userindex = arrGuserphone.index(of: tempnumber)
                        var useridd = ""
                        if let tempuserid = arrGuserid[userindex] as? Int
                        {
                            useridd = "\(tempuserid)"
                        }
                        else if let tempuserid = arrGuserid[index] as? String
                        {
                            useridd = tempuserid
                        }
                        UserDB.queryOrdered(byChild: "user_id")
                            .queryEqual(toValue: useridd)
                            .observeSingleEvent(of: .value, with: { (snapshot) in
                                print(snapshot)
                                //self.andicator.stopAnimating()
                                if snapshot.childrenCount > 0
                                {
                                    if index == 0
                                    {
                                        completion(userindex)
                                    }
                                }
                            })
                    }
                }
            }
        }
        
        completion(nil)
    }
    func funChatScreen(userid: String, userindex: Int, indexrow: Int)
    {
        var imagestring = ""
        var imagename = arrGuserpic[userindex]
        if imagename is String
        {
            if imagename as! String != "" {
                imagestring = USER_IMAGE_PATH + "\(imagename as! String)"
            }
        }
        else if imagename is NSNull{
            imagestring = ""
            imagename = ""
        }
        let temptouid = arrGuserUid[userindex] as! String
        if temptouid == ""{
            DispatchQueue.main.async{
                obj.showAlert(title: "Alert!", message: "User issue in server", viewController: self)
            }
            return
        }
        let tempdata = ["touid": temptouid,
        "fromuid": USERUID,
        "useridserver": arrGuserid[userindex],
        "userprofilepic":imagestring,
        "imagename": imagename,
        "username":  arrGfullname[indexrow],
        "groupid": "",
        "otherUserPhone_Number": arrGuserphone[userindex],
        "grouptype": PRIVATECHAT]
        print(tempdata)
        NotificationCenter.default.post(name:
            NSNotification.Name(rawValue: "taponuser"),
                                        object: tempdata)
        
        
        //        andicator.startAnimating()
        //        UserDB.queryOrdered(byChild: "user_id")
        //            .queryEqual(toValue: userid)
        //            .observeSingleEvent(of: .value, with: { (snapshot) in
        //                UserDB.child(snapshot.key).removeAllObservers()
        //                self.andicator.stopAnimating()
        //                if snapshot.childrenCount > 0
        //                {
        //                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
        //                        var temptouid = ""
        //                        var imagestring = ""
        //                        var imagename = ""
        //                        var useridserver = ""
        //                        var otherUserPhone_Number = ""
        //
        //                        for snap in snapShot{
        //                            temptouid = snap.key
        //                            imagestring = (snap.value as! NSDictionary).value(forKey: "UserLink") as! String
        //                            imagename = imagestring
        //                            useridserver = (snap.value as! NSDictionary).value(forKey: "user_id") as! String
        //                            otherUserPhone_Number = (snap.value as! NSDictionary).value(forKey: "UserPhoneNumber") as! String
        //                            break
        //                        }
        //
        //                        if imagestring != ""
        //                        {
        //                            imagestring = USER_IMAGE_PATH + imagestring
        //                        }
        //
        //                        NotificationCenter.default.post(name:
        //                            NSNotification.Name(rawValue: "taponuser"),
        //                                                        object: ["touid": temptouid,
        //                                                                 "fromuid": USERUID, "useridserver": useridserver,
        //                                                                 "userprofilepic":imagestring, "imagename": imagename,
        //                                                                 "username":  arrGfullname[indexrow],
        //                                                                 "groupid": "",
        //                                                                 "otherUserPhone_Number": otherUserPhone_Number,
        //                                                        "grouptype": PRIVATECHAT])
        //                    }
        //                }
        //                else if snapshot.childrenCount == 0
        //                {
        //
        //                }
        //            })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD
        {
            return 120
        }
        return 65
    }
    
    //MARK:- Cell Setting
    func funCellSetting(index: Int, button: UIButton, imgv: UIImageView, view: UIView)
    {
        setImageandView(imgv: imgv, view: view)
        if index > arrGnumber_AppUser.count - 1{
            imgv.image = UIImage(named: "user")
            button.layer.cornerRadius = 3
            button.isHidden = false
            button.tag = index
            button.addTarget(self, action: #selector(funinvite(sender:)), for: .touchUpInside)
        }
        else{
            setCellImage(imgv: imgv, index: index)
            button.isHidden = true
        }
        
    }
    func applyGradient(colours: [UIColor], view: UIView)
    {
        DispatchQueue.main.async {
            view.applyGradient(colours: colours)
        }
    }
    func setImageandView(imgv: UIImageView, view: UIView)
    {
        DispatchQueue.main.async {
            obj.setimageCircle(image: imgv, viewcontroller: self)
            obj.setViewCircle(view: view, viewcontroller: self)
        }
    }
    @objc func funinvite(sender: UIButton)
    {
        //print(sender.tag)
        let alert = UIAlertController(title: "Choose Share Option!", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Message", style: .default, handler: { _ in
            self.funShareViaMessage(sender: sender)
        }))
        
        alert.addAction(UIAlertAction(title: "Other", style: .default, handler: { _ in
            self.funShare(sender: sender)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender // as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func funShare(sender: AnyObject){
        //Set the default sharing message.
        //Set the link to share.
        let objectsToShare = [SHAREMESSAGE ,SHARELINKANDROID, SHARELINKIOS]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            activityVC.popoverPresentationController?.sourceView = (sender as! UIView)
            activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            activityVC.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func funShareViaMessage(sender: UIButton){
        var index = sender.tag
        if isFiltered == true
        {
            index = arrSearchIndex[index] as! Int
        }
        
        let sms: String = "sms:+\(arrGnumber[index])&body=\(SHAREMESSAGE+SHARELINKANDROID+SHARELINKIOS)"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    @objc func funShowProfilePic(sender: UIButton){
        //let index = sender.tag
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        guard let cell = sender.superview?.superview as? ContactsCell else {
            return // or fatalError() or whatever
        }
        if cell.imgv.image != nil{
            vc.profilepic = cell.imgv.image!
        }
        else{
            vc.profilepic = UIImage(named: "user")!
        }
        vc.name = cell.lblname.text ?? ""
        vc.videoimagename = "Picture"
        vc.videoimagetag = PROFILEPIC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Search Section
    var isFiltered = Bool()
    var arrSearchIndex = NSMutableArray()
    
    //MARK:- For Dashboard Page Control6-
//    func funSearchSetting()
//    {
//        // search textfield func
//        txtsearch.layer.borderColor = UIColor.black.cgColor
//        txtsearch.layer.borderWidth = 1
//        txtsearch.delegate = self
//        txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
//    }
    @objc func change()
    {
        if txtsearch == nil{
            return
        }
        let length = txtsearch.text
        if length?.count == 0
        {
            isFiltered = false
            arrSearchIndex = NSMutableArray()
            tablev.reloadData()
        }
        else
        {
            isFiltered = true
            arrSearchIndex = NSMutableArray()
            for (index, temp) in arrGfullname.enumerated()
            {
                var name = temp
                if name.isNumeric{
                    print("String contain only Numeric")
                    name = name.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                    name = name.trimmingCharacters(in: .whitespaces)
                    name = name.replacingOccurrences(of: " ", with: "")
                    name = name.replacingOccurrences(of: "+", with: "")
                    name = name.replacingOccurrences(of: "-", with: "")
                    name = name.replacingOccurrences(of: "(", with: "")
                    name = name.replacingOccurrences(of: ")", with: "")
                }
                // MARK:- case InSensitive Search
                if let _ = (name).range(of: "\(txtsearch.text!)", options: .caseInsensitive) {
                    self.arrSearchIndex.add(index)
                }
            }
            
            for (index, temp) in arrGnumber.enumerated()
            {
                var name = temp
                if name.isNumeric{
                    print("String contain only Numeric")
                    name = name.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                    name = name.trimmingCharacters(in: .whitespaces)
                    name = name.replacingOccurrences(of: " ", with: "")
                    name = name.replacingOccurrences(of: "+", with: "")
                    name = name.replacingOccurrences(of: "-", with: "")
                    name = name.replacingOccurrences(of: "(", with: "")
                    name = name.replacingOccurrences(of: ")", with: "")
                }
                // MARK:- case InSensitive Search
                if let _ = (name).range(of: "\(txtsearch.text!)", options: .caseInsensitive) {
                    self.arrSearchIndex.add(index)
                }
            }
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.tablev?.reloadData()
                }
            }
        }
    }
    
    var btncancelSearch = UIButton(type: .custom)
    @IBAction func btncancelSearch(sender: UIButton){
        searchhide()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchhide"), object: nil)
    }
    
    @objc func searchhide()
    {
        if txtsearch == nil{
            return
        }
        txtsearch.text = nil
        navigationItem.titleView = nil
        self.title = "ZedChat"
        txtsearch.resignFirstResponder()
        txtsearch.isHidden = true
        isFiltered = false
        tablev.reloadData()
    }
    //MARK:- Dashboard PC
//    @objc func searchhide()
//    {
//        if UIApplication.shared.isKeyboardPresented {
//            if txtsearch == nil{
//                return
//            }
//            txtsearch.resignFirstResponder()
//        }
//        // txtsearch.isHidden = true
//        isFiltered = false
//        tablev.reloadData()
//        //  tablev.frame.origin.y = 0
//        //  tablev.frame.size.height = self.view.frame.size.height - 6
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if UIApplication.shared.isKeyboardPresented {
            if self.txtsearch != nil{
                self.txtsearch.resignFirstResponder()
            }
        }
        return true
    }
    
    //MARK:- Contact Add View Picker Delegates
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contactrefresh"), object: ["isPull":"1"])
    }
    //MARK:- Contact Picker Delegates
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        // user name
        //MARK:- tagViewContacts = 1 means you want to just view the contacts
        //MARK:- tagViewContacts = 0 means you want to share the contacts

    }
}

// MARK: - IndicatorInfoProvider for page controller like android
extension Contacts: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Contacts")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Contacts")
        return itemInfo
    }
}



