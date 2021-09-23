//
//  Users.swift
//  ZedChat
//
//  Created by MacBook Pro on 26/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire
import ContactsUI
import Contacts


class Users: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CNContactViewControllerDelegate {
    
    let arrcolor = [[appclrContact10, appclrContact11, appclrContact12],[appclrContact21, appclrContact22, appclrContact23],[appclrContact31, appclrContact32, appclrContact33],[appclrContact41, appclrContact42, appclrContact43],[appclrContact51, appclrContact52, appclrContact53],[appclrContact6, appclrContact6, appclrContact6]]
    
    var arruid = [String]()
    var arrusername = [String]()
    var arruserphone = [String]()
    var arruserstatus = [Any]()
    var arremail = [Any]()
    var arrfcmid = [Any]()
    var arrpic = [String]()
    var arrlastonline = [Any]()
    var arrSelectedNumber = NSMutableArray()
    
    var selectedMessageVideoData = Data()
    var selectedMessageImage = UIImage()
    var selectedMessageType = 0
    var selectedMessageText = ""
    var selectedFileName = ""
    var selecteFileExtension = ""
    
    var isCallScreen = false
    @IBOutlet weak var txtsearch: UITextField!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var tablev: UITableView!
    
    @IBOutlet weak var btnchat: UIButton!
    @IBAction func btnchat(_ sender: Any) {
        self.btnchat.isUserInteractionEnabled = false
        self.btnchat.backgroundColor = .lightGray
        self.andicator.startAnimating()
        if self.selectedMessageType == IMAGE || self.selectedMessageType == DOCUMENT{
            //MARK:- PICTURE Message
            self.uploadMedia(type: selectedMessageType) { url in
                guard let url = url else { return }
                self.objecturl = url
                self.sendSingleUserMessage()
            }
        }
        else if self.selectedMessageType == VIDEO{
            //MARK:- VIDEO Message
            self.uploadMedia(type: VIDEOIMAGE) { url in
                guard let url = url else { return }
                self.videoimageurl = url
                self.audioVideoData = self.selectedMessageVideoData
                self.uploadMedia(type: VIDEO) { url in
                    guard let url = url else { return }
                    self.objecturl = url
                    self.sendSingleUserMessage()
                }
            }
        }
        else{
            //MARK:- TEXT Message
            sendSingleUserMessage()
        }
    }
    
    //MARK:- Send Single User Message
    func sendSingleUserMessage() {
        let tempFromUid = USERUID
        for (countindex,index) in arrSelectedNumber.enumerated(){
            let tempReceiverId = arrGuserUid[index as! Int] as! String
            retreivePrivateChatGroupId(tempFromUid: tempFromUid, tempReceiverId: tempReceiverId, completion: {
                response in
                var isBack = false
                
                if self.arrSelectedNumber.count - 1 == countindex{
                    isBack = true
                }
                self.shareMessage(index: index as! Int, isBack: isBack, tempFromId: tempFromUid, tempReceiverId: tempReceiverId, tempGroupId: response!)
            })
        }
    }
    
    func shareMessage(index: Int, isBack: Bool, tempFromId: String, tempReceiverId: String, tempGroupId: String){
        self.andicator.startAnimating()
        if self.selectedMessageType != TEXT {
            self.sendMediaMsg(msgtype: self.selectedMessageType, messageTextt: self.selectedMessageText, tempfromuid: tempFromId, temptouid: tempReceiverId, tempgroupType: PRIVATECHAT, tempgroupId: tempGroupId, isBack: isBack)
        }
        else if self.selectedMessageType == TEXT {
            self.sendMessage(msgtype: self.selectedMessageType, messageTextt: self.selectedMessageText, tempfromuid: tempFromId, temptouid: tempReceiverId, tempgroupType: PRIVATECHAT, tempgroupId: tempGroupId, isBack: isBack)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        if arrGnumber.count == 0 || arrGusername.count == 0
        {
            andicator.startAnimating()
            //funRectifyUser()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchUserData"), object: nil)
        }
        else
        {
            //self.funSortData()
        }
    }
    override func viewDidLoad() {
        self.title = "Share to..."
        self.btnchat.backgroundColor = .lightGray
        btnchat.isUserInteractionEnabled = false
        obj.putImgInButtonWithOutLabel(button: btnchat, imgname: "send")
         DispatchQueue.main.async {
             obj.setbuttonHeighWidth4Pad(button: self.btnchat, viewcontroller: self)
             DispatchQueue.main.async {
                 self.btnchat.layer.cornerRadius = self.btnchat.frame.size.height / 2
             }
         }
        // search textfield func.
        
        funSearchSetting()
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "ShareChatCell", bundle: nil), forCellReuseIdentifier: "ShareChatCell")
        self.tablev.register(UINib(nibName: "CallMessageCell", bundle: nil), forCellReuseIdentifier: "CallMessageCell")
        self.tablev.register(UINib(nibName: "CreateGroupTitleCell", bundle: nil), forCellReuseIdentifier: "CreateGroupTitleCell")
        
        // Back Button with image
        let backBtn = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // fetchAllUsers()
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUserDataRefresh), name: NSNotification.Name(rawValue: "fetchUserDataRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startAndicator), name: NSNotification.Name(rawValue: "startAndicator"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopAndicator), name: NSNotification.Name(rawValue: "stopAndicator"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endRefresh), name: NSNotification.Name(rawValue: "endRefresh"), object: nil)
        if arrGusername.count != 0
        {
            self.tablev.reloadData()
        }
        
        super.viewDidLoad()
    }
    @objc func funback()
    {
        navigationController?.popViewController(animated: true)
    }
    @objc func endRefresh(notification: Notification)
    {
        self.tablev.reloadData {
            self.andicator.stopAnimating()
            self.change()
        }
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
    @objc func fetchUserDataRefresh()
    {
        tablev.reloadData {
            self.andicator.stopAnimating()
            self.tablev.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 1
        }
        else if section == 1
        {
            if isFiltered == true
            {
                return arrSearchIndex.count
            }
            else
            {
                return arrGnumber_AppUser.count
            }
        }
        else {
            return 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tablev.dequeueReusableCell(withIdentifier: "CreateGroupTitleCell", for: indexPath) as! CreateGroupTitleCell
            cell.lbltitle.text = "Create Contact"
            cell.imgv.image = UIImage(named: "createcontact")
            obj.setImageHeighWidth4Pad(image: cell.imgv, viewcontroller: self)
            obj.setViewCircle(view: cell.imgvbg, viewcontroller: self)
            
            return cell
        }
        else if indexPath.section == 1
        {
            var index = indexPath.row
            if isFiltered == true
            {
                index = arrSearchIndex[indexPath.row] as! Int
            }
            if isCallScreen == true{
                //MARK:- If user come from Call screen
                let cell = tablev.dequeueReusableCell(withIdentifier: "CallMessageCell") as! CallMessageCell
                cell.lblname.text = "\(arrGfullname_AppUser[index])"
                // cell.lblname.text = "\(arrfname[indexPath.row]) \(arrlname[indexPath.row])"
                cell.lbldesc.text = arrGnumber_AppUser[index]
                //MARK:- Show Profile Image Setting
                cell.btnprofilepic.tag = index
                cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic(sender:)), for: .touchUpInside)
                //MARK:- Audio Call Setting
                cell.btnaudio.tag = index
                cell.btnaudio.addTarget(self, action: #selector(funAudioCall(sender:)), for: .touchUpInside)
                //MARK:- Video Call Setting
                cell.btnvideo.tag = index
                cell.btnvideo.addTarget(self, action: #selector(funVideoCall(sender:)), for: .touchUpInside)
                funCellSetting(index: index, button: UIButton(), imgv: cell.imgvprofile, view: cell.imgvbgprofile)
                return cell
            }
            else{
                //MARK:- If user come from Chat screen
                let cell = tablev.dequeueReusableCell(withIdentifier: "ShareChatCell") as! ShareChatCell
                cell.lbltime.isHidden = true
                cell.lbltitle.text = "\(arrGfullname_AppUser[index])"
                // cell.lblname.text = "\(arrfname[indexPath.row]) \(arrlname[indexPath.row])"
                cell.lbltextmsg.text = arrGnumber_AppUser[index]
                cell.btnprofilepic.tag = index
                cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic(sender:)), for: .touchUpInside)
               // funCellSetting(index: index, button: cell.btninvite, imgv: cell.imgv, view: cell.imgvbg)
                if arrSelectedNumber.contains(index) == true
                {
                    cell.imgvcheck.image = UIImage(named: "check")
                }
                else
                {
                    cell.imgvcheck.image = UIImage(named: "btnunclick")
                }
                
                return cell
            }
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
        else if indexPath.section == 1
        {
            var index = indexPath.row
           // funOpenChatScreen(indexRow: index, indexPath: indexPath)
            if isFiltered == true
            {
                index = arrSearchIndex[indexPath.row] as! Int
            }
            selectUser(index: index)
                
                //            let userindex = find(value: searchToSearch, in: itemsArray)
                //            if userindex != nil
                //            {
                //                if let userid = arruserid[userindex!] as? Int
                //                {
                //                    funChatScreen(userid: "\(userid)", userindex: userindex!, indexrow: index)
                //                }
                //            }
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
    
    func selectUser(index: Int){
        if tablev.isEditing == true
        {
            //funTableSelectUnselect(indexPath: indexPath)
            return
        }
        self.tablev.beginUpdates()
        let indexPath = IndexPath(row: index, section: 1)
        let cell = self.tablev.cellForRow(at: indexPath) as! ShareChatCell
        
        if arrSelectedNumber.contains(index) == true
        {
            let tempindex = arrSelectedNumber.index(of: index)
            arrSelectedNumber.removeObject(at: tempindex)
            cell.imgvcheck.image = UIImage(named: "btnunclick")
        }
        else
        {
            if arrSelectedNumber.count > 4{
                obj.showToast(message: "Selection limit is 5", viewcontroller: self)
                return
            }
            arrSelectedNumber.add(index)
            cell.imgvcheck.image = UIImage(named: "check")
        }
        self.tablev.endUpdates()
        
        if arrSelectedNumber.count > 0{
            self.btnchat.backgroundColor = appclr
            btnchat.isUserInteractionEnabled = true
        }
        else{
            self.btnchat.backgroundColor = .lightGray
            btnchat.isUserInteractionEnabled = false
        }
    }
    //MARK:- Function for open chat screen
    func funOpenChatScreen(indexRow: Int, indexPath: IndexPath){
        var index = indexRow
        if isFiltered == true
        {
            index = arrSearchIndex[index] as! Int
        }
        
        if arrGuserid.count > 1
        {
            var tempphone = arrGnumber_AppUser[index]
            tempphone = tempphone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            
            if tempphone.first == "0" || tempphone.first == "+"
            {
                tempphone.removeFirst()
            }
            if tempphone.first == "0"
            {
                tempphone.removeFirst()
            }
            var tempusername = ""
            if isCallScreen{
                guard let cell = tablev.cellForRow(at: indexPath) as? CallMessageCell else {
                    return // or fatalError() or whatever
                }
                tempusername = cell.lblname.text!
            }
            else{
                guard let cell = tablev.cellForRow(at: indexPath) as? ContactsCell else {
                    return // or fatalError() or whatever
                }
                tempusername = cell.lblname.text!
            }
            
            let itemsArray = arrGuserphone as! [String]
            let searchToSearch = tempphone
            self.find(value: searchToSearch, in: itemsArray) { userindex in
                guard let userindex = userindex else { return }
                self.view.endEditing(true)
                if let userid = arrGuserid[userindex] as? Int
                {
                    DispatchQueue.main.async {
                        self.funChatScreen(userid: "\(userid)", userindex: userindex, indexrow: index, name: tempusername)
                    }
                }
                else if let userid = arrGuserid[userindex] as? String
                {
                    DispatchQueue.main.async {
                        self.funChatScreen(userid: "\(userid)", userindex: userindex, indexrow: index, name: tempusername)
                    }
                }
            }
        }
    }
    
    //MARK:- Cell Setting
    func funCellSetting(index: Int, button: UIButton, imgv: UIImageView, view: UIView)
    {
        button.tag = index
        button.addTarget(self, action: #selector(funinvite(sender:)), for: .touchUpInside)
        
        var tempphone = arrGnumber_AppUser[index]
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
        
        let filteredStrings = itemsArray.filter({(item: String) -> Bool in
            
            let stringMatch = item.lowercased().range(of: searchToSearch.lowercased())
            return stringMatch != nil ? true : false
        })
       // print(filteredStrings)
        
        setImageandView(imgv: imgv, view: view)
        
        if (filteredStrings as NSArray).count > 0
        {
            button.isHidden = true
            setCellImage(imgv: imgv, index: index)
           // setImageinCell(index: index, imgv: imgv, imgvbg: view)
        }
        else
        {
            button.layer.cornerRadius = 3
            button.isHidden = false
            
            if (((arrGpic_AppUser[index] as AnyObject) as? String) != nil && ((arrGpic_AppUser[index] as AnyObject) as? String) != "-1.jpg")
            {
                imgv.image = UIImage(named: "user")
                //MARK:- Gladient apply
                //                let number = Int.random(in: 0 ..< 6)
                //                let arrclr = arrcolor[number]
                //                imgv.setImageWith((arrGpic[index] as! String), color: .clear , circular: true)
                //                applyGradient(colours: arrclr, view: view)
            }
            else
            {
                imgv.image = arrGpic_AppUser[index] as? UIImage
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
                var temp = 0
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
                                self.andicator.stopAnimating()
                                if snapshot.childrenCount > 0
                                {
                                    
                                    if temp == 0
                                    {
                                        temp = 1
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
    func funChatScreen(userid: String, userindex: Int, indexrow: Int, name: String)
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
        
        //let tempusername = obj.getContactNameFromNumber(contactNumber:"\(arrGnumber_AppUser[userindex])")
        NotificationCenter.default.post(name:
            NSNotification.Name(rawValue: "taponuser"),
                                        object: ["touid": arrGuserUid[userindex],
                                                 "fromuid": USERUID,
                                                 "useridserver": arrGuserid[userindex],
                                                 "userprofilepic":imagestring,
                                                 "imagename": imagename,
                                                 "username":  name,
                                                 "groupid": "",
                                                 "otherUserPhone_Number": arrGuserphone[userindex],
                                                 "grouptype": PRIVATECHAT])
        
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
//                                                                 "username":  arrGusername[userindex],
//                                                                 "groupid": "",
//                                                                 "otherUserPhone_Number": otherUserPhone_Number,
//                                                                 "grouptype": PRIVATECHAT])
//                    }
//                }
//                else if snapshot.childrenCount == 0
//                {
//
//                }
//            })
    }
    
    @objc func funShowProfilePic(sender: UIButton){
        //let index = sender.tag
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        if isCallScreen{
            guard let cell = sender.superview?.superview as? CallMessageCell else {
                return // or fatalError() or whatever
            }
            if cell.imgvprofile.image != nil{
                vc.profilepic = cell.imgvprofile.image!
            }
            else{
                vc.profilepic = UIImage(named: "user")!
            }
            vc.videoimagename = "Picture"
            vc.videoimagetag = PROFILEPIC
        }else{
            guard let cell = sender.superview?.superview as? ContactsCell else {
                return // or fatalError() or whatever
            }
            if cell.imgv.image != nil{
                vc.profilepic = cell.imgv.image!
            }
            else{
                vc.profilepic = UIImage(named: "user")!
            }
            vc.videoimagename = "Picture"
            vc.videoimagetag = PROFILEPIC
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func funAudioCall(sender: UIButton){
        var index = sender.tag
        if isFiltered == true
        {
            index = arrSearchIndex[index] as! Int
        }
        var tempphone = arrGnumber_AppUser[index]
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
            //MARK:- Call a user
            let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AnswerCall") as! AnswerCall
            
            self.view.endEditing(true)
            isOutGoing = 1
            isAudio = 1
            call_ReceiverFBToken = arrGuserFBToken[userindex] as! String
            
            if let userid = arrGuserid[userindex] as? Int
            {
                callUser_Receiver_id = arrGuserphone[userindex] as! String + "_" + "\(userid)"
                call_ReceiverUser_id = "\(userid)"
            }
            else if let userid = arrGuserid[userindex] as? String
            {
               callUser_Receiver_id = arrGuserphone[userindex] as! String + "_" + "\(userid)"
                call_ReceiverUser_id = "\(userid)"
            }
            
            guard let cell = sender.superview?.superview as? CallMessageCell else {
                return // or fatalError() or whatever
            }
            call_ReceiverImage = UIImage(named: "user")!
            if cell.imgvprofile.image != nil{
                call_ReceiverImage = cell.imgvprofile.image!
            }
            callGroup_Id = ""
            callUser_FBID_Receiver = arrGuserUid[userindex] as! String
            callUser_FBID = USERUID
            callUser_image_Sender = arrGuserpic[userindex] as! String
            callUser_Name = cell.lblname.text!
            callUser_PhoneNumber_Receiver = arrGuserphone[userindex] as! String
            callUser_PhoneNumber = defaults.value(forKey: "phoneno") as! String
            vc.isCallScreen = true
            //callUser_image_Sender = userprofilepic
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func funVideoCall(sender: UIButton){
        var index = sender.tag
        if isFiltered == true
        {
            index = arrSearchIndex[index] as! Int
        }
        var tempphone = arrGnumber_AppUser[index]
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
            //MARK:- Call a user
            let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AnswerCall") as! AnswerCall
            
            self.view.endEditing(true)
            isOutGoing = 1
            isAudio = 0
            call_ReceiverFBToken = arrGuserFBToken[userindex] as! String
            
            if let userid = arrGuserid[userindex] as? Int
            {
                callUser_Receiver_id = arrGuserphone[userindex] as! String + "_" + "\(userid)"
                call_ReceiverUser_id = "\(userid)"
            }
            else if let userid = arrGuserid[userindex] as? String
            {
                callUser_Receiver_id = arrGuserphone[userindex] as! String + "_" + "\(userid)"
                call_ReceiverUser_id = "\(userid)"
            }
            
            guard let cell = sender.superview?.superview as? CallMessageCell else {
                return // or fatalError() or whatever
            }
            call_ReceiverImage = UIImage(named: "user")!
            if cell.imgvprofile.image != nil{
                call_ReceiverImage = cell.imgvprofile.image!
            }
            callGroup_Id = ""
            callUser_FBID_Receiver = arrGuserUid[userindex] as! String
            callUser_FBID = USERUID
            callUser_image_Sender = arrGuserpic[userindex] as! String
            callUser_Name = cell.lblname.text!
            callUser_PhoneNumber_Receiver = arrGuserphone[userindex] as! String
            callUser_PhoneNumber = defaults.value(forKey: "phoneno") as! String
            vc.isCallScreen = true
            //callUser_image_Sender = userprofilepic
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
    
    @objc func funinvite(sender: UILabel){
        //print(sender.tag)
        let alert = UIAlertController(title: "Choose Share Option!", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Message?", style: .default, handler: { _ in
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
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func funShare(sender: UILabel){
        //Set the default sharing message.
        //Set the link to share.
        let objectsToShare = [SHAREMESSAGE ,SHARELINKANDROID, SHARELINKIOS]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            activityVC.popoverPresentationController?.sourceView = sender
            activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            activityVC.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func funShareViaMessage(sender: UILabel){
        var index = sender.tag
        if isFiltered == true
        {
            index = arrSearchIndex[index] as! Int
        }
        
        let sms: String = "sms:+\(arrGnumber[index])&body=\(SHAREMESSAGE+SHARELINKANDROID+SHARELINKIOS)"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    //Fetch All User Dta handle in these delegates
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return arruserphone.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //        let cell = tablev.dequeueReusableCell(withIdentifier: "ContactsCell") as! ContactsCell
    //        cell.lblname.text = "\(arrusername[indexPath.row])"
    //        cell.lblnumber.text = arruserphone[indexPath.row]
    //        //We donot need the invite button becuse thease are varified users
    //        cell.btninvite.isHidden = true
    //        cell.btninvite.layer.cornerRadius = 3
    //        setImageandView(imgv: cell.imgv, view: cell.imgvbg)
    //        if (((arrpic[indexPath.row] as AnyObject) as? String) == nil || ((arrpic[indexPath.row] as AnyObject) as? String) == "")
    //        {
    //            let number = Int.random(in: 0 ..< 6)
    //            let arrclr = arrcolor[number]
    //            cell.imgv.setImageWith((arrusername[indexPath.row]), color: .clear , circular: true)
    //            applyGradient(colours: arrclr, view: cell.imgvbg)
    //        }
    //        else
    //        {
    //            cell.imgv.kf.setImage(with: URL(string: USER_IMAGE_PATH + arrpic[indexPath.row]))
    //        }
    //        return cell
    //    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Messagingg") as! Messagingg
    //        vc.fromuid = USERUID
    //        vc.touid = arruid[indexPath.row]
    //        vc.username = arrusername[indexPath.row]
    //        vc.userprofilepic = arrpic[indexPath.row]
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD
        {
            return 150
        }
        return 75
    }
    
    //Apply Gradient color on UIIView Background
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
    func setView(imgv: UIImageView, view: UIView, section: Int, row: Int)
    {
        DispatchQueue.main.async {
            obj.setImageHeighWidth4Pad(image: imgv, viewcontroller: self)
            obj.setViewCircle(view: view, viewcontroller: self)
            DispatchQueue.main.async {
                if section == 0
                {
                    imgv.image = UIImage(named: "creategroup")
                }
                if section == 2
                {
                    if row == 0
                    {
                        imgv.image = UIImage(named: "shareandroid")
                    }
                    else if  row == 1
                    {
                        imgv.image = UIImage(named: "helpwhite")
                    }
                }
            }
        }
    }
    // MARK: - Fetch all chat users from server
    func fetchAllUsers()   {
        andicator.startAnimating()
        refFireBase.child("Users").queryOrderedByKey().observe(.value) { (snapshot) in
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                
                print(snapShot)
                let datadic = snapShot as NSArray
                self.arruid = [String]()
                self.arruid = datadic.value(forKey: "key") as! [String]
                
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    self.arrusername = [String]()
                    self.arruserphone = [String]()
                    self.arruserstatus = [String]()
                    //self.arremail = [Any]()
                    self.arrfcmid = [Any]()
                    self.arrpic = [String]()
                    self.arrlastonline = [Int]()
                    
                    for snap in snapShot{
                        if let data = snap.value as? [String:AnyObject]{
                            self.arrusername.append((data as AnyObject).value(forKey: "UserName") as! String)
                            self.arruserphone.append((data as AnyObject).value(forKey: "UserPhoneNumber") as! String)
                            //self.arremail.append((data as AnyObject).value(forKey: "email") as! [Any])
                            self.arrfcmid.append((data as AnyObject).value(forKey: "fcmId") as Any)
                            self.arrpic.append((data as AnyObject).value(forKey: "UserLink") as! String)
                            self.arrlastonline.append((data as AnyObject).value(forKey: "onLineUpdatedAt") as Any)
                            self.arruserstatus.append((data as AnyObject).value(forKey: "UserStaus") as Any)
                        }
                    }
                    if self.arruid.count > 0
                    {
                        let indexofuser =  self.arruid.firstIndex(of: USERUID)
                        self.arruid.remove(at: indexofuser!)
                        self.arrusername.remove(at: indexofuser!)
                        self.arruserphone.remove(at: indexofuser!)
                        self.arruserstatus.remove(at: indexofuser!)
                        //self.arremail.remove(at: indexofuser!)
                        self.arrfcmid.remove(at: indexofuser!)
                        self.arrpic.remove(at: indexofuser!)
                        self.arrlastonline.remove(at: indexofuser!)
                    }
                }
                
                self.andicator.stopAnimating()
                self.tablev.reloadData()
            }
            self.andicator.stopAnimating()
        }
    }
    
    ////////////
    //MARK:- Search Section
    var isFiltered = Bool()
    var arrSearchIndex = NSMutableArray()
    
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
//        txtsearch.layer.borderColor = UIColor.lightGray.cgColor
//        txtsearch.layer.borderWidth = 1
        txtsearch.delegate = self
        txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
    }
    @objc func change()
    {
        let length = txtsearch.text
        if length?.count == 0
        {
            isFiltered = false
            //searchBar.responds(to: Selector(resignFirstResponder()))
            //txtsearch.resignFirstResponder()
            arrSearchIndex = NSMutableArray()
            tablev.reloadData()
        }
        else
        {
            isFiltered = true
            arrSearchIndex = NSMutableArray()
            for (index, temp) in arrGfullname_AppUser.enumerated()
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
            for (index, temp) in arrGnumber_AppUser.enumerated()
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
        self.title = APPBUILDNAME
        txtsearch.resignFirstResponder()
        txtsearch.isHidden = true
        isFiltered = false
        tablev.reloadData()
    }
    
    //MARK:- Text field Delegates
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtsearch.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tablev.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0); //values
    }
    
    //MARK:- Contact Add View Picker Delegates
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contactrefresh"), object: ["isPull":"1"])
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        // user name
        //MARK:- tagViewContacts = 1 means you want to just view the contacts
        //MARK:- tagViewContacts = 0 means you want to share the contacts

    }
    func retreivePrivateChatGroupId(tempFromUid: String, tempReceiverId: String, completion: @escaping (_ key: String?) -> Void) {
            //Firebase Fetch Query
            //MARK:- How to get a single valuee by key and again in this node get another single value
            
            PrivateChatDB.child(tempFromUid)
                .child(tempReceiverId)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    if snapshot.childrenCount > 0
                    {
                        //MARK:- Group Id already Exist
                        print(snapshot)
                        
                        if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                            for snap in snapShot{
                                if let gid = snap.value as? String{
                                    completion(gid)
    //                                if self.groupId == ""
    //                                {
    //                                    self.groupId = gid
    //
    //                                }
                                }
                                break
                            }
                        }
                    }
                    else{
                        //MARK:- Create New Group Id
                        self.createNewPrivateChatGroupId(tempFromUid: tempFromUid, tempReceiverId: tempReceiverId, completion: {
                            response in
                            completion(response)
                        })
                    }
                })
        }
        
        func createNewPrivateChatGroupId(tempFromUid: String, tempReceiverId: String,completion: @escaping (_ key: String?) -> Void) {
            //MARK:- Add new group
            let timespam = Date().currentTimeMillis()!
            let dicGroup = [
                "groupCreatedAt" : timespam,
                "groupCreatedBy" : timespam,
                "groupDescription" : "",
                "groupImage" : "",
                "groupName" : "\(tempFromUid),\(tempReceiverId)",
                "groupType" : PRIVATECHAT,
                "groupUpdated" : timespam,
                "source":"IOS"] as [String : Any]
            
            GroupsDB.childByAutoId()
                .setValue(dicGroup ,withCompletionBlock: {
                    error, snapshot in
                    print(snapshot)
                    let tempGroupId = snapshot.key
                    if error != nil
                    {
                        completion(error?.localizedDescription)
                    }
                    else
                    {
                        //MARK:- From
                        let fromdic =  [tempReceiverId:
                            ["groupId": "\(String(describing: snapshot.key!))"]]
                        
                        let todic =  [tempFromUid:
                            ["groupId": "\(String(describing: snapshot.key!))"]]
                        
                        //MARK:- Add data in Private Chat with Group id
                        PrivateChatDB.child(tempFromUid)
                            .updateChildValues(fromdic,withCompletionBlock: {
                                error, ref in
                                if error != nil
                                {
                                    completion(error?.localizedDescription)
                                }
                                else
                                {
                                    PrivateChatDB.child(tempReceiverId)
                                        .updateChildValues(todic, withCompletionBlock: {
                                            
                                            error, ref in
                                            if error != nil
                                            {
                                                completion(error?.localizedDescription)
                                            }
                                            else
                                            {
                                                completion(tempGroupId)
                                            }
                                        })
                                }})
                    }
                })
        }
    
    
    //Chat Shareing Options
    var selectContactNo = ""
    func sendMessage(msgtype: Int, messageTextt: String, tempfromuid: String, temptouid: String, tempgroupType: String, tempgroupId: String, isBack: Bool)
    {
        var tempmessagetext = messageTextt
        if msgtype == CONTACT
        {
            tempmessagetext = selectContactNo
        }
        //andicator.startAnimating()
        let tempautocreatedid = MessagesDB.childByAutoId().key!
        if tempgroupId.isEmpty == true
        {
    //            funCreateNewChat(msgType: msgtype, completion: {
    //                response in
    //
    //            })
                return
        }
        else
        {
            let timespam = Date().currentTimeMillis()!
                //print(timespam)
            MessagesDB.child(tempgroupId)
                .child(tempfromuid).child(tempautocreatedid)
                .setValue([
                    "from":"\(tempfromuid)",
                    "message":tempmessagetext,
                    "messageStatus":NOT_DELIVERED,
                    "messageType":msgtype,
                    "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                    "timestamp": timespam,
                    "source":"IOS"])
            MessagesDB.child(tempgroupId).child(temptouid).child(tempautocreatedid).setValue([
                    "from":"\(tempfromuid)",
                    "message":tempmessagetext,
                    "messageStatus":NOT_DELIVERED,
                    "messageType":msgtype,
                    "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                    "timestamp": timespam,
                    "source":"IOS"] as [String : Any], withCompletionBlock: {
                        error, ref in
                        if isBack{
                            self.andicator.stopAnimating()
                        }
                        
                        if error == nil
                        {
                            // self.isdeliver(messageStatus: SENT)
                            //MARK:- Uncomment the upper line for testing the unSeenCount
                            //obj.showToast(message: "Message send successfully.", viewcontroller: self)
                            
                            let parameters :Parameters = [
                                "title":"1 new message",
                                "body":tempmessagetext,
                                "sound":"default",
                                //"groupId":self.groupId,
                                "groupType":tempgroupType,
                                "messageId":ref.key!,
                                "action":"newMessage",
                                "messageType":msgtype,
                                "firebaseId":tempfromuid,
                                //"to":self.touid,
                                "groupFireBaseId":tempgroupId,
                                "froma":defaults.value(forKey: "phoneno") as! String,
                                "profilePic":defaults.value(forKey: "userimage") as? String ?? "",
                                "message":tempmessagetext,
                                "mutable_content": true] as [String: AnyObject]
                            DispatchQueue.main.async{
                              //  obj.SendPushNotification(toToken: self.receivertokenLocalClass, title: "1 new message", body: tempmessagetext, data: parameters )
                            }
                        }
                })
                
                self.createChat(tempautocreatedid: tempautocreatedid, tempmessagetext: tempmessagetext, tempgroupid: tempgroupId, temptouid: temptouid, tempfromuid: tempfromuid, msgtype: msgtype, key: tempgroupId, ifupdate: "1", completion: {
                    response in
                       self.andicator.stopAnimating()
                    if response == "success"
                    {
                        if isBack{
                            self.funback()
                        }
                    }
                    else
                    {
                        //MARK:- From
                        obj.showToast(message: response!, viewcontroller: self)
                    }
                })
            }
        }
    
    var audioDuration = Double()
    func sendMediaMsg(msgtype: Int, messageTextt: String, tempfromuid: String, temptouid: String, tempgroupType: String, tempgroupId: String, isBack: Bool)
        {
            //andicator.startAnimating()
            let tempautocreatedid = MessagesDB.childByAutoId().key!
            let timespam = Date().currentTimeMillis()!
            var dicfromto = [String : Any]()
            
            if msgtype == IMAGE{
                dicfromto = [
                "from":"\(tempfromuid)",
                "imageThumb":self.objecturl,
                "message": messageTextt,
                "messageImagePath":self.objecturl,
                "messageStatus":NOT_DELIVERED,
                "messageType":msgtype,
                "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                "timestamp": timespam,
                "source":"IOS"]
            }
            else if msgtype == VIDEO{
                let tempmilisecond = String(Int(self.audioDuration*1000))
                dicfromto = [
                "from":"\(tempfromuid)",
                "message":String(tempmilisecond),
                "imageThumb":self.videoimageurl,
                "messageImagePath":self.videoimageurl,
                "messageVideoPath":self.objecturl,
                "messageStatus":NOT_DELIVERED,
                "messageType":msgtype,
                "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                "timestamp": timespam,
                "source":"IOS"]
            }
            else if msgtype == DOCUMENT{
                dicfromto = [
                "from":"\(tempfromuid)",
                "message":selectedFileName,
                //"messageAudioFile":self.objecturl,
                "messageImagePath":self.objecturl,
                "messageStatus":NOT_DELIVERED,
                "messageType":msgtype,
                "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                "timestamp": timespam,
                "source":"IOS"]
            }
            MessagesDB.child(tempgroupId).child(tempfromuid)
                .child(tempautocreatedid)
                .setValue(dicfromto
                as [String :Any],withCompletionBlock: {
                    error, ref in
                    if isBack{
                        self.andicator.stopAnimating()
                    }
                    if error != nil
                    {
                        obj.showToast(message: (error?.localizedDescription)!, viewcontroller: self)
                    }
                    else
                    {
                        let parameters :Parameters = [
                            "title":"1 new message",
                            "body":"Image Received",
                            "sound":"default",
                            //"groupId":self.groupId,
                            "groupType":tempgroupType,
                            "messageId":ref.key!,
                            "action":"newMessage",
                            "messageType":IMAGE,
                            "firebaseId":tempfromuid,
                            //"to":self.touid,
                            "groupFireBaseId":tempgroupId,
                            "froma":defaults.value(forKey: "phoneno") as! String,
                            "profilePic":defaults.value(forKey: "userimage") as? String ?? "",
                            "message":messageTextt,
                            "mutable_content": true]
                        
                        //obj.SendPushNotification(toToken: self.receivertokenLocalClass, title: "1 new message", body: self.messagetext, data: parameters )
                        MessagesDB.child(tempgroupId).child(temptouid).child(tempautocreatedid).setValue(dicfromto)
                        //obj.showToast(message: "Picture send successfully.", viewcontroller: self)
                        
                        if isBack{
                            self.funback()
                        }
                    }
            })
            
            //MARK:- Groupid already exist just send message
            self.createChat(tempautocreatedid: tempautocreatedid, tempmessagetext: selectedMessageText, tempgroupid: tempgroupId, temptouid: temptouid, tempfromuid: tempfromuid, msgtype: msgtype, key: tempgroupId, ifupdate: "1", completion: {
                    response in
                    self.andicator.stopAnimating()
                    if response == "success"
                    {
                        //MAARK:- Need to improve this
                        
                    }
                    else
                    {
                        //MARK:- From
                        obj.showToast(message: response!, viewcontroller: self)
                    }
                })
        }
        
        func createChat(tempautocreatedid: String, tempmessagetext: String, tempgroupid: String, temptouid: String, tempfromuid: String, msgtype: Int,key: String,ifupdate: String, completion: @escaping (_ key: String?) -> Void) {
            
            let timespam = Date().currentTimeMillis()!
            funGetMessageCount(tempFromId: tempfromuid, tempGroupId: tempgroupid, receiverid: temptouid, completion: {
                unSeenCount in
                
                let dicGroupFrom = [
                    "createdAt" : timespam,
                    "groupType" : PRIVATECHAT,
                    "lastMessage" : tempmessagetext,
                    "lastMessageId" : tempautocreatedid,
                    "lastMessageStatus" : NOT_DELIVERED,
                    "lastMessageTime" : timespam,
                    "lastMessageType" : msgtype,
                    "lastMessageUserId" : tempfromuid,
                    "messageStatus" : "",
                    "otherUserId" : temptouid,
                    "seen" : false,
                    "typing" : STOP_TYPING_RECORDING,
                    "userPhoneNumber" : defaults.value(forKey: "phoneno") as! String,
                    "unSeenCount":0,
                    "source":"IOS"] as [String : Any]
                let dicGroupTo = [
                    "createdAt" : timespam,
                    "groupType" : PRIVATECHAT,
                    "lastMessage" : tempmessagetext,
                    "lastMessageId" : tempautocreatedid,
                    "lastMessageStatus" : NOT_DELIVERED,
                    "lastMessageTime" : timespam,
                    "lastMessageType" : msgtype,
                    "lastMessageUserId" : tempfromuid,
                    "messageStatus" : "",
                    "otherUserId" : tempfromuid,
                    "seen" : false,
                    "typing" : STOP_TYPING_RECORDING,
                    "userPhoneNumber" : defaults.value(forKey: "phoneno") as! String,
                    "unSeenCount": unSeenCount! as Any,
                    "source":"IOS"] as [String : Any]
                
                ChatDB.child(tempfromuid)
                    .child(key)
                    .updateChildValues(dicGroupFrom, withCompletionBlock: {
                        error, snapshot in
                        if error != nil
                        {
                            completion(error?.localizedDescription)
                        }
                        else
                        {
                            DispatchQueue.main.async{
                                ChatDB.child(temptouid)
                                    .child(key)
                                    .updateChildValues(dicGroupTo)
                                completion("success")
                            }
                        }
                    })
            })
        }
        
    func funGetMessageCount(tempFromId: String, tempGroupId: String, receiverid: String, completion: @escaping (_ unSeenCount: Int?) -> Void) {
        var unSeenCount = 0
        if tempGroupId == ""
        {
            completion(1)
            return
        }
        else if receiverid == tempFromId
        {
            completion(0)
            return
        }
        //ChatDB.keepSynced(true)
        ChatDB.child(receiverid).child(tempGroupId).keepSynced(true)
        ChatDB.child(receiverid).child(tempGroupId)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapShot.count > 0{
                        if let tempunSeenCount = (snapshot.value as! NSDictionary).value(forKey: "unSeenCount") as? Int
                        {
                            unSeenCount = tempunSeenCount
                        }
                        else if let tempunSeenCount = (snapshot.value as! NSDictionary).value(forKey: "unSeenCount") as? String
                        {
                            unSeenCount = Int(tempunSeenCount)!
                        }
                    }
                    unSeenCount = unSeenCount + 1
                    completion(unSeenCount)
                }
            })
    }
    var objecturl = ""
    var videoimageurl = ""
    var audioVideoData: Data!
    var uploadData = Data()
    
    //MARK:- Upload image or file to Firebase Storage
    func uploadMedia(type: Int, completion: @escaping (_ url: String?) -> Void) {
        //andicator.startAnimating()
        // let storageRef = Storage.storage().reference().child("UserPictures")
        let timespam = Date().currentTimeMillis()!
        var filename = ""
        var localFileName = "\(String(describing: timespam))"
        if type == IMAGE
        {
            localFileName = localFileName + ".png"
            filename = "UserMsgPictures/\(localFileName)"
            uploadData = selectedMessageImage.jpegData(compressionQuality: 0.3)!
        }
        else if type == AUDIO
        {
            localFileName = localFileName + "audio.mp4"
            filename = "UserMsgAudio/\("\(localFileName)")"
            uploadData = audioVideoData
        }
        else if type == VIDEOIMAGE
        {
            localFileName = localFileName + ".png"
            filename = "UserVideoThumbPictures/\(localFileName)"
            uploadData = selectedMessageImage.jpegData(compressionQuality: 0.3)!
        }
        else if type == VIDEO
        {
            localFileName = localFileName + "video.mp4"
            filename = "UserMsgVideo/\(localFileName)"
            uploadData = selectedMessageVideoData
        }
        else if type == DOCUMENT
        {
            filename = "UserMsgDocument/\(selectedFileName)"
            uploadData = selectedMessageVideoData
        }
        if (uploadData.count/1024)/1024 > 100{
            //  completion("error")
            obj.showToast(message: "File size cannot be more then 100 MB", viewcontroller: self)
            return
        }
        print(localFileName)
        print(filename)
        
        if uploadData.isEmpty !=  true{
            let uploadTask = refStorageFireBase
                .child(filename)
                .putData(uploadData, metadata: nil) {
                    (snapshot, error) in
                    self.andicator.stopAnimating()
                    if error != nil {
                        print("error")
                        completion("Error Occured in upload picture")
                    } else {
                        print(snapshot as Any)
                        DispatchQueue.main.async{
                            refStorageFireBase.child(filename)
                                .downloadURL { (url, error) in
                                    guard let downloadURL = url else {
                                        completion("Uh-oh, an error occurred! try again.")
                                        return
                                    }
                                    //MARK:- This try cach is use for move local image/audio/video/documents file to Local Directry
                                    
                                    obj.funMoveLocalFileToLocalDirectory(fileName: localFileName, downloadURL: downloadURL, fileData: self.uploadData)
                                    completion("\(downloadURL)")
                            }
                        }
                    }
            }
            
            MEDIAPROGRESS = Float()
            if MEDIAPROGRESS == Float(){
                objG.showProgressBar(viewController: self)
                DispatchQueue.main.async {
                    uploadTask.observe(.progress) { snapshot in
                        print(snapshot.progress!) // NSProgress object
                        MEDIAPROGRESS = Float(snapshot.progress!.fractionCompleted)
                        if snapshot.progress!.fractionCompleted > 0.99{
                            print("Uploading Complete")      // THIS IS WHAT I WANT
                            DispatchQueue.main.async {
                                MEDIAPROGRESS = 1.0
                            }
                        }
                        else{
                            print("Not pausable")    // THIS IS MY PROBLEM
                            if MEDIAPROGRESS == 0.0{
                                
                            }
                        }
                    }
                }
            }
        }
    }
}
