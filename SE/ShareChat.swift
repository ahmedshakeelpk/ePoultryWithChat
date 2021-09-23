//
//  ShareChat.swift
//  ePoltry
//
//  Created by Apple on 27/11/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import Contacts
import CoreData
import Alamofire

class ShareChat: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, InboxMsgCellDelegate, OutGoingMsgCellDelegate {
    
    var selectedMessageVideoData = Data()
    var selectedMessageImage = UIImage()
    var selectedMessageType = 0
    var selectedMessageText = ""
    var selectedFileName = ""

    var uid = defaults.value(forKey: "uid") as? String
    
    var longPressGesture = UILongPressGestureRecognizer()
    var arrSelectedDeletIndex = [Int]()
    
    var refreshControl = UIRefreshControl()
    
    var tableviewframe = CGFloat()
    var ifScreenOpenOtherUserId = String()
    
    var arrMsgUnSeenCount = NSMutableArray()
    var arrMsgFomUid = NSMutableArray()
    var arrMsgOtherUid = NSMutableArray()
    var arrMsgLast = NSMutableArray()
    var arrMsgStatus = NSMutableArray()
    var arrMsgType = NSMutableArray()
    var arrMsgTime = NSMutableArray()
    var arrMsgProfilePic = NSMutableArray()
    var arrMsgPicThumb = NSMutableArray()
    var arrMsgLat = NSMutableArray()
    var arrMsgLong = NSMutableArray()
    var arrMsgSeen = NSMutableArray()
    var arrMsgNumber = NSMutableArray()
    var arrMsgUserName = NSMutableArray()
    var arrUserPhoneNumber = NSMutableArray()
    var arrMsgTyping = NSMutableArray()
    var arrMsgGroupType = NSMutableArray()
    var arrMsgLastMsgId = NSMutableArray()
    var arrMsgGroupId = NSMutableArray()
    var arrUserUserId = NSMutableArray()
    //MARK:- Privacy Arrays
    var arrMsgShowLastSeen = NSMutableArray()
    var arrMsgShowProfilePhoto = NSMutableArray()
    var arrMsgShowSeeAbout = NSMutableArray()
    
    @IBOutlet weak var lblsearching: UILabel!
    @IBOutlet weak var txtsearch: UITextField!
    @IBOutlet weak var btnchat: UIButton!
    @IBAction func btnchat(_ sender: Any) {
        self.btnchat.isUserInteractionEnabled = false
        self.btnchat.backgroundColor = .lightGray
        self.andicator.startAnimating()
        
        let tempAutoCreatedId = MessagesDB.childByAutoId().key!
        if self.selectedMessageType == IMAGE || self.selectedMessageType == DOCUMENT{
            //MARK:- PICTURE/DOCUMENT Message
            self.uploadMedia(type: selectedMessageType) { url in
                guard let url = url else { return }
                self.objecturl = url
                
                for (countIndex, index) in self.arrSelectedNumber.enumerated(){
                    if self.arrMsgGroupType[index as! Int] as! String == PUBLICGROUP {
                        self.sendMessageInGroup(countIndex: countIndex, index: index as! Int, tempAutoCreatedId: tempAutoCreatedId)
                    }
                    else{
                        if countIndex == self.arrSelectedNumber.count - 1{
                            self.shareMessage(index: index as! Int, isBack: true)
                        }
                        else{
                            self.shareMessage(index: index as! Int, isBack: false)
                        }
                    }
                }
            }
        }
        else{
            //MARK:- TEXT Message
            self.btnchat.isUserInteractionEnabled = false
            self.btnchat.backgroundColor = .lightGray
            for (countIndex, index) in arrSelectedNumber.enumerated(){
                if self.arrMsgGroupType[index as! Int] as! String == PUBLICGROUP {
                    self.sendMessageInGroup(countIndex: countIndex, index: index as! Int, tempAutoCreatedId: tempAutoCreatedId)
                }
                else{
                    sendSingleUserMessage(countIndex: countIndex, index: index as! Int, tempAutoCreatedId: tempAutoCreatedId)
                }
            }
        }
    }
    
    //MARK:- Send Message in Group
    func sendMessageInGroup(countIndex: Int, index: Int, tempAutoCreatedId: String){
        self.fetchGroupParticipent(tempgroupId: self.arrMsgGroupId[index] as! String, completion: {
            response in
            
            if response == "1"{
                for (indexParticipant, receiverid) in self.arrGroupParticipatUid.enumerated() {
                    let temp = self.arrGroupParticipatDeviceSource.object(at: indexParticipant) as! String
                    var tempDevice = false
                    var tempisBack = false
                    if temp == "ios" || temp == "IOS"{
                        isAndroidUser = false
                    }
                    else if temp == "Android" || temp == "android"{
                        isAndroidUser = true
                        tempDevice = true
                    }
                    
                    let tempFromUid = defaults.value(forKey: "uid") as! String
                    let tempGroupId = self.arrMsgGroupId[index] as! String
                    let tempGroupType = self.arrMsgGroupType[index] as! String
                    let tempReceiverToken = self.arrGroupParticipatUserFBToken[indexParticipant] as! String
                    //MARK:- if last participat and last selected index for go back to previous screen
                    if indexParticipant == self.arrGroupParticipatUid.count - 1 && countIndex  == self.arrSelectedNumber.count - 1 {
                        tempisBack = true
                    }
                    //MARK:- Send message in group
                    self.funSendMsgInGroup(tempMsgType: self.selectedMessageType, messageTextt: self.selectedMessageText, tempfromuid: tempFromUid, temptouid: receiverid as! String, tempgroupType: tempGroupType, tempgroupId: tempGroupId, isBack: tempisBack, tempreceiverId: receiverid as! String, receiverToken: tempReceiverToken, isAndroidUserTemp: tempDevice, tempautocreatedid: tempAutoCreatedId)
                }
            }
        })
    }
    //MARK:- Send Single User Message
    func sendSingleUserMessage(countIndex: Int, index: Int, tempAutoCreatedId: String){
        if countIndex == arrSelectedNumber.count - 1{
            shareMessage(index: index, isBack: true)
        }
        else{
            shareMessage(index: index, isBack: false)
        }
    }
    
    @IBOutlet weak var bgchat: UIView!
    
    let arrtype = ["text","location", "photo", "voice", "text","voice", "photo", "location"]
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var tablev: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered == true
        {
            return arrSearchIndex.count
        }
        else
        {
            return arrMsgUserName.count
        }
    }
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            print("Deleted")
    //            self.tablev.deleteRows(at: [indexPath], with: .automatic)
    //        }
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = indexPath.row
        if isFiltered == true
        {
            index = arrSearchIndex[indexPath.row] as! Int
        }
//        var myuid = ""
//        if let temp = defaults.value(forKey: "uid") as? String{
//            myuid = temp
//        }
        var statutype = Int()
        if let status = arrMsgStatus[index] as? String
        {
            statutype = Int(status)!
        }
        else if let status = arrMsgStatus[index] as? Int
        {
            statutype = status
        }
        var type = Int()
        if let temptype = arrMsgType[index] as? String
        {
            type = Int(temptype)!
        }
        else if let temptype = arrMsgType[index] as? Int
        {
            type = temptype
        }
        var unseencount = Int()
        if let tempunseen = arrMsgUnSeenCount[index] as? String
        {
            unseencount = Int(tempunseen)!
        }
        else if let tempunseen = arrMsgUnSeenCount[index] as? Int
        {
            unseencount = tempunseen
        }
        var showprofilephoto = ""
        if let tempprofilephoto = arrMsgShowProfilePhoto[index] as? String
        {
            showprofilephoto = tempprofilephoto
        }
        
        let grouptype = arrMsgGroupType[index] as! String
        let timestring = convertTimespamIntoTime(timestring: "\(arrMsgTime[index] as! Int)")
       // let fromuid = arrMsgFomUid[index] as! String
        
        var contactUserName = String()
        
        if grouptype == PRIVATECHAT {
            //MARK:- Get Name of cuntact
            contactUserName = getContactNameFromNumber(contactNumber:"\(arrUserPhoneNumber[index])")
        }
        else{
            contactUserName = arrMsgUserName[index] as! String
        }
        
        return inCommingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto, username: contactUserName)
    }
    
    func inCommingCell(index: Int, type: Int, statutype: Int, timestring: String, grouptype: String, unseencount: Int, showprofilephoto: String, username: String) -> UITableViewCell {
        if type == TEXT || type == GROUP_INFO_MESSAGE || type == CREATE_GROUP || type == LEFT_GROUP || type == REMOVE_MEMBER || type == ADD_MEMBER || type == GROUP_ADMIN {
            let cell = tablev.dequeueReusableCell(withIdentifier: "ShareChatCell") as! ShareChatCell
            cell.cellConfigration(row: index, delegate: self)
            
            cell.lbltitle.text = username
            cell.lbltime.text = timestring
            if showprofilephoto == "Nobody" {
                if grouptype == PUBLICGROUP {
                    cell.imgvprofile.image = UIImage(named: "groupicon")
                }
                else {
                    cell.imgvprofile.image = UIImage(named: "user")
                }
            }
            else {
                if let imgurl = arrMsgProfilePic[index] as? String {
                    if imgurl != "" {
                        var path = USER_IMAGE_PATH
                        if grouptype == PUBLICGROUP {
                            path = GROUP_IMAGE_PATH
                        }
                        loadimage(imgv: cell.imgvprofile, imgurl: path + imgurl)
                    }
                    else if grouptype == PUBLICGROUP {
                        setimageCircle(image: cell.imgvprofile, viewcontroller: self)
                        cell.imgvprofile.layer.borderColor = UIColor.lightGray.cgColor
                        
                        cell.imgvprofile.image = UIImage(named: "groupicon")
                    }
                    else {
                        cell.imgvprofile.image = UIImage(named: "user")
                    }
                    
                    //cell.imgvprofile.kf.setImage(with: URL(string: imgurl))
                }
            }
            
            setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            
            var tempTextMsg = arrMsgLast[index] as! String
            cell.lbltextmsg.text = tempTextMsg
            if type == TEXT {
                cell.lbltextmsg.textColor = .darkGray
                cell.lbltextmsg.font = UIFont.systemFont(ofSize: cell.lbltextmsg.font.pointSize)
            }
            else if type == GROUP_INFO_MESSAGE {
                cell.lbltextmsg.textColor = .black
                cell.lbltextmsg.font = UIFont.italicSystemFont(ofSize: cell.lbltextmsg.font.pointSize)
            }
            else if type == CREATE_GROUP || type == LEFT_GROUP || type == REMOVE_MEMBER || type == ADD_MEMBER || type == GROUP_ADMIN{
                cell.lbltextmsg.font = UIFont.italicSystemFont(ofSize: cell.lbltextmsg.font.pointSize)
                cell.lbltextmsg.textColor = .black
                var tempphone = ""
                var tempphone2 = ""
                
                if type == ADD_MEMBER || type == REMOVE_MEMBER{
                    let strArray = tempTextMsg.components(separatedBy: " ")
                    tempphone = strArray[0].components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                    if strArray.count > 2{
                        tempphone2 = strArray[2].components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                    }
                    
                    if tempphone == defaults.value(forKey: "phoneno") as? String{
                        tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: "You")
                    }
                    else{
                        let tempname = getContactNameFromNumber(contactNumber: "\(tempphone)")
                        tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: tempname)
                    }
                    if tempphone2 == defaults.value(forKey: "phoneno") as? String{
                        tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone2, with: "You")
                    }
                    else{
                        let tempname = getContactNameFromNumber(contactNumber: "\(tempphone2)")
                        tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone2, with: tempname)
                    }
                }
                else{
                    if type == CREATE_GROUP{
                        let strArray = tempTextMsg.components(separatedBy: " ")
                        tempphone = strArray[0].components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                    }
                    else{
                        tempphone = tempTextMsg.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                    }
                    
                    if tempphone == defaults.value(forKey: "phoneno") as! String{
                        tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: "You")
                    }
                    else{
                        let tempname = getContactNameFromNumber(contactNumber: "\(tempphone)")
                        tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: tempname)
                    }
                }
                cell.lbltextmsg.text = tempTextMsg
            }
            
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
        else
        {
            let cell = tablev.dequeueReusableCell(withIdentifier: "ShareChatMediaCell") as! ShareChatCell
            //MARK:- Assign Manual Delegate
            cell.cellConfigration(row: index, delegate: self)
            //cell.lbltitle.text = (arrMsgUserName[index] as! String)
            cell.lbltitle.text = username
            cell.lbltime.text = timestring
            if showprofilephoto == "Nobody"
            {
                if grouptype == PUBLICGROUP {
                    cell.imgvprofile.image = UIImage(named: "groupicon")
                }
                else
                {
                    cell.imgvprofile.image = UIImage(named: "user")
                }
            }
            else
            {
                if let imgurl = arrMsgProfilePic[index] as? String
                {
                    if imgurl != ""
                    {
                        var path = USER_IMAGE_PATH
                        if grouptype == PUBLICGROUP {
                            path = GROUP_IMAGE_PATH
                        }
                        loadimage(imgv: cell.imgvprofile, imgurl: path + imgurl)
                    }
                    else if grouptype == PUBLICGROUP {
                        setimageCircle(image: cell.imgvprofile, viewcontroller: self)
                        cell.imgvprofile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgvprofile.image = UIImage(named: "groupicon")
                    }
                    else
                    {
                        cell.imgvprofile.image = UIImage(named: "user")
                    }
                }
            }
            
            cell.imgvtype.image = UIImage(named: "locimg")
            setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            
            switch type {
            case LOCATION:
                cell.imgvtype.image = UIImage(named: "locimg")
                cell.lbltextmsg.text = "Location"
                break
            case IMAGE:
                cell.imgvtype.image = UIImage(named: "photoimg")
                cell.lbltextmsg.text = "Photo"
                break
            case AUDIO:
                cell.imgvtype.image = UIImage(named: "voiceimg")
                cell.lbltextmsg.text = "Audio"
                break
            case VIDEO:
                cell.imgvtype.image = UIImage(named: "videoimg")
                cell.lbltextmsg.text = "Video"
                break
            case CONTACT:
                cell.imgvtype.image = UIImage(named: "contactno")
                cell.lbltextmsg.text = "Contact Card"
                break
            case DOCUMENT:
                cell.imgvtype.image = UIImage(named: "document")
                cell.lbltextmsg.text = "Document"
                break
            default:
                break
            }
            cell.lbltextmsg.textColor = UIColor.lightGray
            
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var index: Int = indexPath.row
        if isFiltered == true
        {
            index = arrSearchIndex[index] as! Int
        }
        if (editingStyle == .delete) {
            funDeleteSelectedValue(grouptype: arrMsgGroupType[index] as! String, key: defaults.value(forKey: "uid") as! String, groupid: arrMsgGroupId[index] as! String, index: index)
        }
    }
    var arrSelectedNumber = NSMutableArray()
    var selectedButtonIndex = 0
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //        if selectedButtonIndex == indexPath.row
        //        {
        //            return .delete
        //        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // return
        var index = indexPath.row
        if tablev.isEditing == true
        {
            //funTableSelectUnselect(indexPath: indexPath)
            return
        }
        if isFiltered == true
        {
            index = arrSearchIndex[indexPath.row] as! Int
        }
        
        self.tablev.beginUpdates()
        let indexPath = IndexPath(row: index, section: 0)
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
                showToast(message: "Selection limit is 5", viewcontroller: self)
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
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD
        {
            return 150
        }
        return 75
    }
    
    func shareMessage(index: Int, isBack: Bool){
        var imagestring = arrMsgProfilePic[index] as! String
        let imagename = imagestring
        var userName = "\(arrUserPhoneNumber[index])"
        
        if arrMsgGroupType[index] as! String == PUBLICGROUP {
            userName = "\(arrMsgUserName[index])"
            if imagestring != ""
            {
                imagestring = GROUP_IMAGE_PATH + imagestring
            }
            ifScreenOpenOtherUserId = ""
        }
        else
        {
            userName = getContactNameFromNumber(contactNumber: "\(arrUserPhoneNumber[index])")
            if imagestring != ""
            {
                imagestring = USER_IMAGE_PATH + imagestring
            }
            if let tempprofilephoto = arrMsgShowProfilePhoto[index] as? String
            {
                if tempprofilephoto == "Nobody"
                {
                    imagestring = ""
                }
            }
            ifScreenOpenOtherUserId = arrMsgOtherUid[index] as! String
        }
        
        let datadic = ["touid": ifScreenOpenOtherUserId,
                       "fromuid": defaults.value(forKey: "uid") as! String,
                       "useridserver": arrUserUserId[index],
                       "userprofilepic":imagestring,
                       "imagename": imagename,
                       "username": userName,
                       "groupid": arrMsgGroupId[index],
                       "otherUserPhone_Number":arrUserPhoneNumber[index],
                       "grouptype" : arrMsgGroupType[index],
                       "unSeenCount" : arrMsgUnSeenCount[index]] as NSDictionary
        
        let tempfromuid = datadic.value(forKey: "fromuid") as! String
        let temptouid = datadic.value(forKey: "touid") as! String
        let tempgroupId = datadic.value(forKey: "groupid") as! String
        let tempgroupType = datadic.value(forKey: "grouptype") as! String
//        let tempusername = datadic.value(forKey: "username") as! String
//        let tempuserprofilepic = datadic.value(forKey: "userprofilepic") as! String
//        let tempimagename = datadic.value(forKey: "imagename") as! String
//        let tempotherUserPhone_Number = datadic.value(forKey: "otherUserPhone_Number") as! String
        DispatchQueue.main.async {
            self.andicator.startAnimating()
            if self.selectedMessageType != TEXT {
                self.sendMediaMsg(msgtype: self.selectedMessageType, messageTextt: self.selectedMessageText, tempfromuid: tempfromuid, temptouid: temptouid, tempgroupType: tempgroupType, tempgroupId: tempgroupId, isBack: isBack)
                
            }
            else if self.selectedMessageType == TEXT {
                self.sendMessage(msgtype: self.selectedMessageType, messageTextt: self.selectedMessageText, tempfromuid: tempfromuid, temptouid: temptouid, tempgroupType: tempgroupType, tempgroupId: tempgroupId, isBack: isBack)
            }
        }

        DispatchQueue.main.async {
        //            if let temp = datadic.value(forKey: "useridserver") as? String
        //            {
        //                vc.useridserver = temp
        //            }
        //            else if let temp = datadic.value(forKey: "useridserver") as? Int
        //            {
        //                vc.useridserver = "\(temp)"
        //            }
        }
    }
    func loadimage(imgv: UIImageView, imgurl : String)
    {
        DispatchQueue.main.async {
            //Kingfisher Image upload
            imgv.kf.setImage(with: URL(string: imgurl)) { result in
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
    
    func setMessageStatusForCell(msgStatus: Int, imageview: UIImageView)
    {
        if msgStatus == NOT_DELIVERED
        {
            imageview.image = UIImage(named: "msgsent")
           // imageview.image = UIImage(named: "msgnotsent")
        }
        else if msgStatus == SENT
        {
            imageview.image = UIImage(named: "msgsent")
        }
        else if msgStatus == DELIVERED
        {
            imageview.image = UIImage(named: "msgdeliver")
        }
        else if msgStatus == SEEN
        {
            imageview.image = UIImage(named: "msgseen")
        }
        else if msgStatus == MESSAGE_DELETED
        {
            imageview.image = UIImage(named: "deletedmsg")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
      
//        let scoresRef = Database.database().reference(withPath: "Users")
//        scoresRef.keepSynced(true)
        uid = defaults.value(forKey: "uid") as? String ?? ""
        // retreiveMessages()
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "chat"])
    }
    //MARK:- REmove any value
    func removeValue()
    {
        ChatDB.child("-LeAQIbL0OLM_OJ6jg2_").removeValue(completionBlock: { error, snapshot in
            print(snapshot)
        })
    }
    //MARK:- Show Profile Pic Function
    func didTapOnRow(row: NSInteger) {
        print(row)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        
    }
    
    func funDeleteValue(grouptype: String, key: String, groupid: String)
    {
        if grouptype == PUBLICGROUP {
            GroupsDB.child(groupid).removeValue(completionBlock: { error, snapshot in
                if error != nil
                {
                    showToast(message: "Not Delete", viewcontroller: self)
                }
                else
                {
                    showToast(message: "Value Delete", viewcontroller: self)
                }
            })
        }
        else if grouptype == PRIVATECHAT {
            ChatDB.child(key).child(groupid).removeValue(completionBlock: { error, snapshot in
                
                if error != nil
                {
                    showToast(message: "Not Delete", viewcontroller: self)
                    
                }
                else
                {
                    showToast(message: "Value Delete", viewcontroller: self)
                }
            })
        }
    }
    
    func funDeleteSelectedValue(grouptype: String, key: String, groupid: String, index: Int)
    {
        if grouptype == PUBLICGROUP {
            //MARK:- Public chat need to be remove self from group then can be delete
            ParticipantsDB.child(groupid)
                .queryOrderedByKey().observeSingleEvent(of: .value, with:{ (snapshot) in
                    if snapshot.childrenCount == 0{
                        self.removeNow(grouptype: grouptype, key: key, groupid: groupid, index: index)
                    }
                    else{
                        if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                            
                            if snapShot.count > 0
                            {
                                let datadic = (snapshot.value as! NSDictionary)
                                let tempArrGroupParticipant = datadic.allKeys as NSArray
                                //print(self.arrGroupParticipant)
                                //print(self.arrGroupUserRole)
                                if tempArrGroupParticipant
                                    .contains(defaults.value(forKey: "uid") as! String) {
                                    showAlert(title: PUBLICGROUP, message: "Please exist from group, then you can able to delete chat", viewController: self)
                                }else{
                                    
                                    self.removeNow(grouptype: grouptype, key: key, groupid: groupid, index: index)
                                }
                            }
                        }
                    }
            })
        }else{
            //MARK:- Private chat can be directly delete
            self.removeNow(grouptype: grouptype, key: key, groupid: groupid, index: index)
        }
        
    }
    
    func removeNow(grouptype: String, key: String, groupid: String, index: Int){
        ChatDB.child(key).child(groupid).removeValue(completionBlock: { error, snapshot in
            if error != nil
            {
                showToast(message: "Not Delete try again", viewcontroller: self)
            }
            else
            {
                MessagesDB.child(groupid).child(key).removeValue()
                //obj.showToast(message: "Value Delete", viewcontroller: self)
                self.funRemoveindex(index: index)
                // self.tablev.reloadData()
                
                
                let indexPath = NSIndexPath(row: index, section: 0)
                DispatchQueue.main.async {
                    self.tablev.deleteRows(at: [indexPath as IndexPath], with: .fade)
                }
            }
        })
    }
    
    func setEntity(dicdata: NSDictionary){
        
        //let keyid = (dicdata as AnyObject).key as String
        
        let dicAllKeys = dicdata.allKeys
        
        let model = NSManagedObjectModel()
        // Create the entity
        let entity = NSEntityDescription()
        entity.name = "Chat"
        entity.managedObjectClassName = "Chat"
        // Create the attributes
        var properties = Array<NSAttributeDescription>()
        var count = 0
        for keys in dicAllKeys{
            if count == 0{
                count = 1
                let contentTypeAttribute = NSAttributeDescription()
                contentTypeAttribute.name = "groupid"
                contentTypeAttribute.attributeType = .stringAttributeType
                contentTypeAttribute.isOptional = true
                properties.append(contentTypeAttribute)
                
            }else{
                
                let contentTypeAttribute = NSAttributeDescription()
                contentTypeAttribute.name = keys as! String
                contentTypeAttribute.attributeType = .stringAttributeType
                contentTypeAttribute.isOptional = true
                properties.append(contentTypeAttribute)
            }
        }
        // Add attributes to entity
        entity.properties = properties
        // Add entity to model
        model.entities = [entity]
        
        //        let cont = appDelegate.persistentContainer.managedObjectModel = model
        //
        //        NSpre
    }
    
    override func viewDidLoad() {
        let backBtn = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
            
        self.title = "Share to..."
        self.btnchat.backgroundColor = .lightGray
        btnchat.isUserInteractionEnabled = false
        putImgInButtonWithOutLabel(button: btnchat, imgname: "send")
         DispatchQueue.main.async {
            setbuttonHeighWidth4Pad(button: self.btnchat, viewcontroller: self)
             DispatchQueue.main.async {
                 self.btnchat.layer.cornerRadius = self.btnchat.frame.size.height / 2
             }
         }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            self.refresh(sender: self.refreshControl)
        }
        //MARK:- if want to delte some values
        //        funDeleteValue(grouptype: "public")
        //funDeleteValue(grouptype: "private")
        // return
        //
        //Core Data for conecting with Core Data DB
        
        
        // deleteData(entityName: "Chat")
        
        ///////
        
        self.andicator.stopAnimating()
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "ShareChatCell", bundle: nil), forCellReuseIdentifier: "ShareChatCell")
        self.tablev.register(UINib(nibName: "InboxMsgCell", bundle: nil), forCellReuseIdentifier: "InboxMsgCell")
        self.tablev.register(UINib(nibName: "ShareChatMediaCell", bundle: nil), forCellReuseIdentifier: "ShareChatMediaCell")
        
        self.retreiveMessages()
        //fetchAllUsers()
       
        ////NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "chat"])
        
        
        //MARK:- Notification when tap on some user
        NotificationCenter.default.removeObserver(self)
        funInitializationOfDashboardPC()
        NotificationCenter.default.addObserver(self, selector: #selector(searchshowhide), name: NSNotification.Name(rawValue: "searchshowhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchhide), name: NSNotification.Name(rawValue: "searchhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchshowhide), name: NSNotification.Name(rawValue: "clearchat"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funTableSelectUnselectWithNotification), name: NSNotification.Name(rawValue: "funTableSelectUnselect"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(btncancelSearch(sender:)), name: NSNotification.Name(rawValue: "btncancelSearch"), object: nil)
        
        funSearchSetting()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tablev.addSubview(refreshControl) // not required when using UITableViewController
        
        super.viewDidLoad()
        
    }
    @objc func funback()
    {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func funTableSelectUnselectWithNotification()
    {
        tablev.allowsMultipleSelection = true
        if tablev.isEditing == true
        {
            tablev.setEditing(false, animated: false)
        }
        else
        {
            tablev.setEditing(true, animated: true)
        }
        tablev.reloadData()
    }
    @objc func funTableSelectUnselect()
    {
        //        let index = indexPath
        //
        //        let indexRow = indexPath.row
        //        // do stuff with your cell, for example print the indexPath
        //        print("longpressed Tag: \(indexRow)")
        //
        //        var selectunselect = 0
        //        if arrSelectedDeletIndex.contains(indexRow) == true
        //        {
        //            let indexofcell = arrSelectedDeletIndex.firstIndex(of:index.row)
        //            arrSelectedDeletIndex.remove(at: indexofcell!)
        //            selectunselect = 1
        //        }else{
        //            arrSelectedDeletIndex.append(indexRow)
        //        }
        //        let fromuid = arrMsgFomUid[indexRow] as! String
        //        var type = Int()
        //        if let temptype = arrMsgType[indexRow] as? String
        //        {
        //            type = Int(temptype)!
        //        }
        //        else if let temptype = arrMsgType[indexRow] as? Int
        //        {
        //            type = temptype
        //        }
        //let myuid = defaults.value(forKey: "uid") as! String
        //let grouptype = arrMsgGroupType[indexRow] as! String
        tablev.allowsMultipleSelection = true
        if tablev.isEditing == true
        {
            tablev.setEditing(false, animated: false)
        }
        else
        {
            tablev.setEditing(true, animated: true)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "edittableview"), object: nil)
        tablev.reloadData()
        
        //        if type == TEXT
        //        {
        //            if fromuid == myuid && grouptype == PRIVATECHAT {
        //                let cell = tablev.dequeueReusableCell(withIdentifier: "OutGoingMsgCell", for: indexPath) as! OutGoingMsgCell
        //                tablev.beginUpdates()
        ////                tableView(tablev, canEditRowAt: indexPath)
        //                tablev.allowsMultipleSelection = false
        //
        //                selectedButtonIndex = indexRow
        //
        //
        //
        //
        //                //cell.setEditing(true, animated: true)
        //
        //
        //                tablev.setEditing(true, animated: true)
        //                //cell.setEditing(true, animated: true)
        //              //  tableView(tablev, editingStyleForRowAt: indexPath)
        //                //tableView(tablev, numberOfRowsInSection: indexRow)
        //
        //
        //                //tablev.reloadData()
        //               // tablev.beginUpdates()
        //                //OUTGoing Cell
        //                if selectunselect == 1
        //                {
        //                    cell.vselection.isHidden = true
        //                }else{
        //                    cell.vselection.isHidden = false
        //                }
        //                tablev.endUpdates()
        //               // tablev.reloadRows(at: [indexPath], with: .top)
        //            }
        //            else
        //            {
        //                let cell = tablev.dequeueReusableCell(withIdentifier: "InboxMsgCell") as! InboxMsgCell
        //                tablev.beginUpdates()
        //                //Incoming Cell
        //                if selectunselect == 1
        //                {
        //                    cell.vselection.isHidden = true
        //                }else{
        //                    cell.vselection.isHidden = false
        //                }
        //                tablev.endUpdates()
        //            }
        //        }
        //        else {
        //
        //            if fromuid == myuid && grouptype == PRIVATECHAT {
        //                tablev.beginUpdates()
        //                //OUTGoing Cell
        //                let cell = tablev.dequeueReusableCell(withIdentifier: "OutGoingPhotoMsgCell") as! OutGoingMsgCell
        //                if selectunselect == 1
        //                {
        //                    cell.vselection.isHidden = true
        //                }else{
        //                    cell.vselection.isHidden = false
        //                }
        //                tablev.endUpdates()
        //            }
        //            else
        //            {
        //                tablev.beginUpdates()
        //                //Incoming Cell
        //                let cell = tablev.dequeueReusableCell(withIdentifier: "InboxPhotoCell") as! InboxMsgCell
        //                if selectunselect == 1
        //                {
        //                    cell.vselection.isHidden = true
        //                }else{
        //                    cell.vselection.isHidden = false
        //                }
        //                tablev.endUpdates()
        //            }
        //        }
        
        //this fun need to remove
    }
    
    func funDeleteSelectedMessages(isClear: Int, isDeletedFromEveryOne: Int)
    {
        //        if isClear == 1
        //        {
        //            if arrMsgId.count == 0
        //            {
        //                return
        //            }
        //        }
        //        andicator.startAnimating()
        //        var tempcount = 0
        //        var arrIndexes = arrSelectedDeletIndex
        //        temparrMsgId = arrMsgId
        //        if isClear == 1
        //        {
        //            arrIndexes += 0...arrMsgId.count - 1
        //        }
        //
        //        arrSelectedDeletIndex = arrIndexes
        //        for i in arrIndexes
        //        {
        //            deleteMessages(index: i, isClear: isClear, isDeleteFromEveryOne: isDeletedFromEveryOne, completion: {response in
        //                print(response as Any)
        //                tempcount = tempcount + 1
        //                if tempcount ==  arrIndexes.count
        //                {
        //                    if isClear == 1
        //                    {
        //                        //MARK:- Clear All chat
        //                        self.arrMsgFomid = NSMutableArray()
        //                        self.arrMsg = NSMutableArray()
        //                        self.arrMsgType = NSMutableArray()
        //                        self.arrMsgTime = NSMutableArray()
        //                        self.arrMsgPicThumb = NSMutableArray()
        //                        self.arrMsgPic = NSMutableArray()
        //                        self.arrMsgVideo = NSMutableArray()
        //                        self.arrMsgLat = NSMutableArray()
        //                        self.arrMsgLong = NSMutableArray()
        //                        //self.arrMsgAddress = NSMutableArray()
        //                        self.arrMsgId = NSMutableArray()
        //                        self.arrMsgStatus = NSMutableArray()
        //                    }
        //                    self.unSelectionMessages()
        //                    self.arrSelectedDeletIndex = [Int]()
        //                    DispatchQueue.main.async{
        //                        DispatchQueue.main.async{
        //                            self.tablev.reloadData()
        //                        }
        //                        self.andicator.stopAnimating()
        //                    }
        //                }
        //            })
        //        }
    }
    
    @objc func refresh(sender:AnyObject) {
        //retreiveMessages()
        self.tablev.reloadData()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            print("Fire timer \(timer)")
            self.tablev.reloadData()
            self.refreshControl.endRefreshing()
        }
        // Code to refresh table view
        
    }
    @objc func searchshowhide(notification: Notification)
    {
        let textfield = notification.object as! NSDictionary
        let  temptxtsearch = textfield.value(forKey: "textfield") as! UITextField
        temptxtsearch.delegate = self
        temptxtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
        txtsearch = temptxtsearch
        //        if txtsearch.isHidden == true
        //        {
        //            txtsearch.isHidden = false
        //            tablev.frame.origin.y = txtsearch.frame.maxY
        //           // tablev.frame.size.height = self.view.frame.size.height - (6 + txtsearch.frame.size.height)
        //        }
        //        else
        //        {
        //            self.view.endEditing(true)
        //            txtsearch.isHidden = true
        //            tablev.frame.origin.y = 0
        //           // tablev.frame.size.height = self.view.frame.size.height - 6
        //
        //            self.navigationItem.titleView = txtsearch;
        //        }
    }
    
    //MARK:- Insert User Message on Top
    func funInsertMessageOnTop(datadic: NSDictionary, key: String) {
        self.arrMsgGroupId.insert(key, at: 0)
        let allkeys = datadic.allKeys as NSArray
        self.arrMsgFomUid.insert(datadic.value(forKey: "\(objChatDBM.lastMessageUserId)") as Any, at: 0)
        if datadic.value(forKey: "\(objChatDBM.groupType)") as? String == PUBLICGROUP {
            self.arrMsgOtherUid.insert("", at: 0)
        }
        else{
            self.arrMsgOtherUid.insert(datadic.value(forKey: "\(objChatDBM.otherUserId)") as Any, at: 0)
        }
        self.arrMsgLast.insert(datadic.value(forKey: "\(objChatDBM.lastMessage)") as Any, at: 0)
        self.arrMsgStatus.insert(datadic.value(forKey: "\(objChatDBM.lastMessageStatus)") as Any, at: 0)
        self.arrMsgType.insert(datadic.value(forKey: "\(objChatDBM.lastMessageType)") as Any, at: 0)
        self.arrMsgTime.insert(datadic.value(forKey: "\(objChatDBM.lastMessageTime)") as Any, at: 0)
        self.arrMsgSeen.insert(datadic.value(forKey: "\(objChatDBM.seen)") as Any, at: 0)
        // self.arrMsgNumber.insert(datadic.value(forKey: "userPhoneNumber") as Any, at: 0)
        self.arrMsgTyping.insert(datadic.value(forKey: "\(objChatDBM.typing)") as Any, at: 0)
        self.arrMsgGroupType.insert(datadic.value(forKey: "\(objChatDBM.groupType)") as Any, at: 0)
        self.arrMsgLastMsgId.insert(datadic.value(forKey: "\(objChatDBM.lastMessageId)") as Any, at: 0)
        self.arrMsgUnSeenCount.insert(datadic.value(forKey: "\(objChatDBM.unSeenCount)") as Any, at: 0)
        //        self.arrMsgShowLastSeen.insert(datadic.value(forKey: "LastSeen") as Any, at: 0)
        //        self.arrMsgShowProfilePhoto.insert(datadic.value(forKey: "ProfilePhoto") as Any, at: 0)
        //        self.arrMsgShowSeeAbout.insert(datadic.value(forKey: "SeeAbout") as Any, at: 0)
        
        if allkeys.contains("\(objChatDBM.userName)"){
            self.arrMsgNumber.insert(datadic.value(forKey: "\(objChatDBM.userName)") as Any, at: 0)
        }
        else{
            self.arrMsgNumber.insert("", at: 0)
        }
        if allkeys.contains("\(objChatDBM.lastMessageType)"){
            self.arrMsgShowLastSeen.insert(datadic.value(forKey: "\(objUserDBM.lastSeen)") as Any, at: 0)
        }
        else{
            self.arrMsgShowLastSeen.insert("", at: 0)
        }
        if allkeys.contains("\(objUserDBM.profilePhotoPrivacy)"){
            self.arrMsgShowProfilePhoto.insert(datadic.value(forKey: "\(objUserDBM.profilePhotoPrivacy)") as Any, at: 0)
        }
        else{
            self.arrMsgShowProfilePhoto.insert("", at: 0)
        }
        if allkeys.contains("\(objUserDBM.seeAbout)"){
            self.arrMsgShowSeeAbout.insert(datadic.value(forKey: "\(objUserDBM.seeAbout)") as Any, at: 0)
        }
        else{
            self.arrMsgShowSeeAbout.insert("", at: 0)
        }
    }
    
    //MARK:- Insert User Message on Top
    func funInsertMessageInArrays(datadic: NSDictionary, key: String) {
        if datadic.value(forKey: "\(objChatDBM.otherUserId)") as? String == ""
        {
            if datadic.value(forKey: "\(objChatDBM.groupType)") as? String == PUBLICGROUP {
                
            }
            else
            {
                funDeleteFromChat(groupid: key)
                return
            }
        }
        if ((datadic.value(forKey: "\(objChatDBM.groupType)") as? String) != nil){
            
        }
        else{
            funDeleteFromChat(groupid: key)
            return
        }
        print(datadic)
        let tempdata = datadic.allKeys as NSArray
        self.arrMsgGroupId.add(key)
        self.arrMsgFomUid.add(datadic.value(forKey: "\(objChatDBM.lastMessageUserId)") as Any)
        if datadic.value(forKey: "\(objChatDBM.groupType)") as? String == PUBLICGROUP {
            self.arrMsgOtherUid.add("")
        }
        else{
            self.arrMsgOtherUid.add(datadic.value(forKey: "\(objChatDBM.otherUserId)") as Any)
        }
        
        self.arrMsgLast.add(datadic.value(forKey: "\(objChatDBM.lastMessage)") as Any)
        self.arrMsgStatus.add(datadic.value(forKey: "\(objChatDBM.lastMessageStatus)") as Any)
        self.arrMsgType.add(datadic.value(forKey: "\(objChatDBM.lastMessageType)") as Any)
        self.arrMsgTime.add(datadic.value(forKey: "\(objChatDBM.lastMessageTime)") as Any)
        self.arrMsgSeen.add(datadic.value(forKey: "\(objChatDBM.seen)") as Any)
        // self.arrMsgNumber.add(datadic.value(forKey: "userPhoneNumber") as Any)
        self.arrMsgTyping.add(datadic.value(forKey: "\(objChatDBM.typing)") as Any)
        self.arrMsgGroupType.add(datadic.value(forKey: "\(objChatDBM.groupType)") as Any)
        self.arrMsgLastMsgId.add(datadic.value(forKey: "\(objChatDBM.lastMessageId)") as Any)
        self.arrMsgUnSeenCount.add(datadic.value(forKey: "\(objChatDBM.unSeenCount)") as Any)
        let allkeys = datadic.allKeys as NSArray
        if allkeys.contains("\(objChatDBM.userName)"){
            self.arrMsgNumber.insert(datadic.value(forKey: "\(objChatDBM.userName)") as Any, at: 0)
        }
        else{
            self.arrMsgNumber.insert("", at: 0)
        }
        self.arrMsgProfilePic.add("")
        self.arrUserPhoneNumber.add("")
        self.arrMsgUserName.add("")
        self.arrUserUserId.add("")
        //MARK:- For saving data
        if tempdata.contains("\(objUserDBM.lastSeen)"){
            self.arrMsgShowLastSeen.insert(datadic.value(forKey: "\(objUserDBM.lastSeen)") as Any, at: 0)
        } else{
            self.arrMsgShowLastSeen.insert("", at: 0)
        }
        if tempdata.contains("\(objUserDBM.profilePhotoPrivacy)"){
            self.arrMsgShowProfilePhoto.insert(datadic.value(forKey: "\(objUserDBM.profilePhotoPrivacy)") as Any, at: 0)
        } else{
            self.arrMsgShowProfilePhoto.insert("", at: 0)
        }
        if tempdata.contains("\(objUserDBM.seeAbout)"){
            self.arrMsgShowSeeAbout.insert(datadic.value(forKey: "\(objUserDBM.seeAbout)") as Any, at: 0)
        } else{
            self.arrMsgShowSeeAbout.insert("", at: 0)
        }
    }
    func sortArrays()
    {
        //MARK:- this is for checking thr Null in Chat
        var arrDeleteCount = [Int]()
        var count = 0
        for object in self.arrMsgTime {
            if object is NSNull {
                print("Hey, it's null!")
                funDeleteFromChat(groupid: arrMsgGroupId[count] as! String)
                arrDeleteCount.append(count)
            }else if object is String {
                print("Hey, it's Empty!")
                funDeleteFromChat(groupid: arrMsgGroupId[count] as! String)
                arrDeleteCount.append(count)
            }
            else {
                print("It's not null, it's \(object)")
            }
            count += 1
        }
        //MARK:- This will call if null value found in chat
        if arrDeleteCount.count > 0
        {
            for index in arrDeleteCount {
                funRemoveindex(index: index)
            }
        }
        if arrMsgTime.count > 0{
            
        }
        else{
            return
        }
        let sortedOrder = (self.arrMsgTime as! [Int]).enumerated().sorted(by: {$0.1>$1.1}).map({$0.0})
        
        self.arrMsgGroupId = (sortedOrder.map({self.arrMsgGroupId[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgFomUid = (sortedOrder.map({self.arrMsgFomUid[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgOtherUid = (sortedOrder.map({self.arrMsgOtherUid[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgLast = (sortedOrder.map({self.arrMsgLast[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgStatus = (sortedOrder.map({self.arrMsgStatus[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgType = (sortedOrder.map({self.arrMsgType[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgTime = (sortedOrder.map({self.arrMsgTime[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgSeen = (sortedOrder.map({self.arrMsgSeen[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgNumber = (sortedOrder.map({self.arrMsgNumber[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgTyping = (sortedOrder.map({self.arrMsgTyping[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgGroupType = (sortedOrder.map({self.arrMsgGroupType[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgLastMsgId = (sortedOrder.map({self.arrMsgLastMsgId[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgUnSeenCount = (sortedOrder.map({self.arrMsgUnSeenCount[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgProfilePic = (sortedOrder.map({self.arrMsgProfilePic[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrUserPhoneNumber = (sortedOrder.map({self.arrUserPhoneNumber[$0]}) as NSArray).mutableCopy() as! NSMutableArray
        self.arrMsgUserName = (sortedOrder.map({self.arrMsgUserName[$0]}) as NSArray).mutableCopy() as! NSMutableArray
    }
    
    func funDeleteFromChat(groupid: String)
    {
        ChatDB.child(defaults.value(forKey: "uid") as! String).child(groupid).removeValue(completionBlock: { error, snapshot in
            
            if error != nil
            {
                print("Not Delete")
                //obj.showToast(message: "Not Delete", viewcontroller: self)
            }
            else
            {
                print("Value Delete")
                //obj.showToast(message: "Value Delete", viewcontroller: self)
            }
        })
    }
    //MARK:- Retreive Messages from db and add observer When This screen run first time
    @objc func retreiveMessages(){
        //MARK:- If Child Added Means if new user messaged you then this will call!
        uid = defaults.value(forKey: "uid") as? String
         ChatDB.child(self.uid!)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapShot.count > 0
                    {
                        if snapShot.count > self.arrMsgGroupId.count{
                            
                            if self.arrMsgGroupId.count != 0
                            {
                                
                            }
                            else{
                                //MARK:- Retreive Data if App first time run so Fetch the Complete Data
                                let datadic = (snapshot.value as! NSDictionary)
                                if datadic.count > 0
                                {
                                    for tempdatadic in datadic
                                    {
                                        if tempdatadic.value is NSDictionary{
                                            self.funInsertMessageInArrays(datadic: tempdatadic.value as! NSDictionary, key: tempdatadic.key as! String)
                                        }
                                        else{
                                            self.tablev.reloadData()
                                        }
                                    }
                                    self.sortArrays()
                                    DispatchQueue.main.async {
                                        self.retreiveMessageSetting()
                                    }
                                }
                            }//End Else Check
                        }
                        else{
                            //MARK:- When new user not Added only observer observe the value in DB
                            //MARK:- If user contact not fetch this will call
                            if arrGusername.count == 0
                            {
                                // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchAllContacts"), object: nil)
                            }
                            self.btnchat.isUserInteractionEnabled = true
                            self.lblsearching.isHidden = true
                            self.andicator.stopAnimating()
                            return
                        }
                    }
                    else
                    {
                        self.lblsearching.isHidden = false
                        self.btnchat.isUserInteractionEnabled = true
                        
                        let fullString = NSMutableAttributedString(string: EMPTY_CHAT_INBOX_START)

                        // create our NSTextAttachment
                        let image1Attachment = NSTextAttachment()
                        image1Attachment.image = UIImage(named: "chatEmoji")

                        // wrap the attachment in its own attributed string so we can append it
                        let image1String = NSAttributedString(attachment: image1Attachment)

                        // add the NSTextAttachment wrapper to our full string, then add some more text.
                        fullString.append(image1String)
                        fullString.append(NSAttributedString(string: " at the Chat Screen"))

                        // draw the result in a label
                        self.lblsearching.attributedText = fullString
                        self.lblsearching.center.x = self.view.center.x
                        
                        self.andicator.stopAnimating()
                        //MARK:- If user contact not fetch this will call
                        if arrGusername.count == 0
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchAllContacts"), object: nil)
                        }
                    }
                    //MARK:- This observer is use for if other use is typing or recording or send message then we will change the values of inbox
                }
        })
    }
    
    func retreiveMessageSetting(){
            if self.arrMsgGroupId.count > self.arrUserPhoneNumber.count || self.isViewLoaded == true {
            //Add complete User which retreive 1st time
            let arrDeleteCount = [Int]()
            let tempMsgOtherUid = self.arrMsgOtherUid
            for (index,uidd) in tempMsgOtherUid.enumerated() {
                print(uidd)
                print(index)
                if uidd is NSNull{
                    print("null")
                    print("Count: \(index)")

                    if self.arrMsgGroupType[index] as? String == PRIVATECHAT {
                        self.funDeleteFromChat(groupid: self.arrMsgGroupId[index] as! String)
                        return
                    }
                    else if self.arrMsgGroupType[index] as? String == PUBLICGROUP {

                    }
                }
                
                if self.arrMsgGroupType[index] as? String == PRIVATECHAT {
                    //print("UserID: \(uidd)")
                    UserDB.child(uidd as! String).observeSingleEvent(of: .value, with: { (subsnapshot) in
                        //print(subsnapshot)
                        let indexofuid = self.arrMsgOtherUid
                                .index(of: subsnapshot.key)
                        if subsnapshot.childrenCount == 0 {
                            self.funDeleteFromChat(groupid:self
                                .arrMsgGroupId[indexofuid] as! String)
                            self.funRemoveindex(index: indexofuid)
                            return
                        }
                        //print(subsnapshot)
                        if subsnapshot.childrenCount > 4 {
                            let tempdic = subsnapshot.value as! NSDictionary
                            if let temp = tempdic.value(forKey: "\(objUserDBM.phoneNumber)") as? String {
                                if indexofuid > self.arrUserPhoneNumber.count - 1
                                {
                                    self.arrUserPhoneNumber.add("")
                                }
                                self.arrUserPhoneNumber[indexofuid] = temp
                                //tempdic.setValue(temp, forKey: "\(objChatDBM.userName)")
                            }
                            else {
                                self.arrUserPhoneNumber[indexofuid] = ""
                                tempdic.setValue("", forKey: "\(objChatDBM.userName)")
                            }
                            if let temp = tempdic.value(forKey: "\(objUserDBM.profilePhoto)") as? String {
                                if indexofuid > self.arrMsgProfilePic.count - 1
                                {
                                    self.arrMsgProfilePic.add("")
                                }
                                self.arrMsgProfilePic[indexofuid] = temp
                                //tempdic.setValue(temp, forKey: "\(objUserDBM.profilePhoto)")
                            }
                            else {
                                self.arrMsgProfilePic[indexofuid] = ""
                                //tempdic.setValue("", forKey: "\(objUserDBM.profilePhoto)")
                            }
                            
                            if let temp = tempdic.value(forKey: "\(objUserDBM.userName)") as? String {
                                if indexofuid > self.arrMsgUserName.count - 1 {
                                    self.arrMsgUserName.add("")
                                }
                                self.arrMsgUserName[indexofuid] = temp
                                //tempdic.setValue(temp, forKey: "\(objUserDBM.userName)")
                            }
                            else {
                                self.arrMsgUserName[indexofuid] = ""
                                //tempdic.setValue("", forKey: "\(objUserDBM.userName)")
                            }
                            
                            let tempUser_id = tempdic.value(forKey: "\(objUserDBM.userId)") as! String
                            self.arrUserUserId.add(tempUser_id)
                            //tempdic.setValue(tempUser_id, forKey: "\(objUserDBM.userId)")
                            
                            let tempLastSeen = tempdic.value(forKey: "\(objUserDBM.lastSeen)") as Any
                            self.arrMsgShowLastSeen.add(tempLastSeen)
                            //tempdic.setValue(tempLastSeen, forKey: "lastSeen")
                            
                            let tempProfilePhoto = tempdic.value(forKey: "\(objUserDBM.profilePhoto)") as Any
                            self.arrMsgShowProfilePhoto.add(tempProfilePhoto)
                            //tempdic.setValue(tempProfilePhoto, forKey: "\(objUserDBM.profilePhotoPrivacy)")
                            
                            let tempSeeAbout = tempdic.value(forKey: "\(objUserDBM.seeAbout)") as Any
                            self.arrMsgShowSeeAbout.add(tempSeeAbout)
                            //tempdic.setValue(tempSeeAbout, forKey: "seeAbout")
                            self.funRegisterUserObserver(uidd: subsnapshot.key)
                        }
                        else {
                            let tempgroupid =  self.arrMsgGroupId[index] as! String
                            
                            self.funDeleteValue(grouptype: "private", key: uidd as! String, groupid: tempgroupid)
                            
                            self.funDeleteValue(grouptype: "private", key: USERUID, groupid: tempgroupid)
                        }
                        if self.arrMsgOtherUid.count - 1 == index {
                            DispatchQueue.main.async {
                                self.lblsearching.isHidden = true
                                self.tablev.reloadData {
                                    self.andicator.stopAnimating()
                                    DispatchQueue.main.async {
                                        self.refresh(sender: self.refreshControl)
                                    }
                                }
                            }
                        }
                    })
                }
                else if self.arrMsgGroupType[index] as? String == PUBLICGROUP {
                    let tempgroupid = self.arrMsgGroupId[index] as! String
                    print("GroupID: \(tempgroupid)")
                    
                    GroupsDB.child(tempgroupid).observeSingleEvent(of: .value, with: { (subsnapshot) in
                    print(subsnapshot)
                    let indexofuid = self.arrMsgGroupId.index(of: subsnapshot.key)
                    print(subsnapshot)
                    if subsnapshot.childrenCount > 0 {
                        let tempdic = subsnapshot.value as! NSDictionary
                        
                        self.arrUserPhoneNumber.add("")
                        self.arrUserUserId.add("")
                        self.arrMsgShowLastSeen.add("")
                        self.arrMsgShowProfilePhoto.add("")
                        self.arrMsgShowSeeAbout.add("")
                        
    //                    tempdic.setValue("", forKey: "\(objUserDBM.userName)")
    //                    tempdic.setValue("", forKey: "\(objUserDBM.userId)")
    //                    tempdic.setValue("", forKey: "\(objUserDBM.lastSeen)")
    //                    tempdic.setValue("", forKey: "\(objUserDBM.profilePhotoPrivacy)")
    //                    tempdic.setValue("", forKey: "\(objUserDBM.seeAbout)")
                        
                        let temparr = tempdic.allKeys as NSArray
                        if (temparr.contains("\(objGroupsDBM.groupImage)")) {
                            if let temp = (subsnapshot.value as! NSDictionary).value(forKey: "\(objGroupsDBM.groupImage)") as? String {
                                if indexofuid > self.arrMsgProfilePic.count - 1
                                {
                                    self.arrMsgProfilePic.add("")
                                }
                                self.arrMsgProfilePic[indexofuid] = temp
                                //tempdic.setValue(temp, forKey: "\(objGroupsDBM.groupImage)")
                            }
                            else {
                                self.arrMsgProfilePic[indexofuid] = ""
                                //tempdic.setValue("", forKey: "\(objGroupsDBM.groupImage)")
                            }
                        }
                        else {
                            self.arrMsgProfilePic[indexofuid] = ""
                        }
                        if let temp = tempdic.value(forKey: "\(objGroupsDBM.groupName)") as? String {
                            if indexofuid > self.arrMsgUserName.count - 1
                            {
                                self.arrMsgUserName.add("")
                            }
                            self.arrMsgUserName[indexofuid] = temp
                            //tempdic.setValue(temp, forKey: "\(objGroupsDBM.groupName)")
                        }
                        else {
                            self.arrMsgUserName[indexofuid] = ""
                            //tempdic.setValue("", forKey: "\(objGroupsDBM.groupImage)")
                        }
                    }
                    else {
                        self.funDeleteValue(grouptype: "public", key: tempgroupid, groupid: tempgroupid)
                    }
                    if self.arrMsgOtherUid.count - 1 == index {
                        self.tablev.reloadData()
                        DispatchQueue.main.async {
                            self.tablev.reloadData {
                                DispatchQueue.main.async {
                                    self.tablev.reloadData()
                                    if arrGusername.count == 0
                                    {
                                        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchAllContacts"), object: nil)
                                    }
                                }
                            }
                            self.lblsearching.isHidden = true
                            self.andicator.stopAnimating()
                        }
                    }
                })
            }
                
        }//MARK:- End for loop
        if arrDeleteCount.count > 0 {
            for index in arrDeleteCount {
                self.funRemoveindex(index: index)
            }
        }
            
            //}//MARK:- End of Dispatch Queue
        }//MARK:- End if
        self.btnchat.isUserInteractionEnabled = true
    }
    
    func funRemoveindex(index: Int)
    {
        self.arrMsgFomUid.removeObject(at: index)
        self.arrMsgOtherUid.removeObject(at: index)
        self.arrMsgLast.removeObject(at: index)
        self.arrMsgStatus.removeObject(at: index)
        self.arrMsgType.removeObject(at: index)
        self.arrMsgTime.removeObject(at: index)
        self.arrMsgSeen.removeObject(at: index)
        self.arrMsgNumber.removeObject(at: index)
        self.arrMsgTyping.removeObject(at: index)
        self.arrMsgGroupType.removeObject(at: index)
        self.arrMsgLastMsgId.removeObject(at: index)
        self.arrMsgUnSeenCount.removeObject(at: index)
        self.arrMsgGroupId.removeObject(at: index)
        
        self.arrMsgProfilePic.removeObject(at: index)
        self.arrMsgUserName.removeObject(at: index)
        self.arrUserPhoneNumber.removeObject(at: index)
        self.arrUserUserId.removeObject(at: index)
        
        if self.arrMsgShowLastSeen.count < index{
            self.arrMsgShowLastSeen.add("")
        }
        if self.arrMsgShowProfilePhoto.count < index{
            self.arrMsgShowProfilePhoto.add("")
        }
        if self.arrMsgShowSeeAbout.count < index{
            self.arrMsgShowSeeAbout.add("")
        }
        self.arrMsgShowLastSeen.removeObject(at: index)
        self.arrMsgShowProfilePhoto.removeObject(at: index)
        self.arrMsgShowSeeAbout.removeObject(at: index)
    }
    
    //MARK:- Function for Observe User
    func funRegisterUserObserver(uidd: String){
            UserDB.child(uidd )
                .observe(.value, with: { (subsnapshot) in
                    print(subsnapshot)
                    let index = self.arrMsgOtherUid
                        .index(of: subsnapshot.key)
                    if subsnapshot.childrenCount == 0{
                        self.funDeleteFromChat(groupid: self.arrMsgGroupId[index] as! String)
                        self.funRemoveindex(index: index)
                        return
                    }
                    if self.tablev.rowsCount >= index{
                    }
                    else{
                        return
                    }
                    
                    var type :Int?
                    if let temptype = self.arrMsgType[index] as? String
                    {
                        type = Int(temptype)!
                    }
                    else if let temptype = self.arrMsgType[index] as? Int
                    {
                        type = temptype
                    }
                    let grouptype = self.arrMsgGroupType[index] as! String
                    let fromuid = subsnapshot.key
                    var tempimgurl = ""
                    
                    if let temp = (subsnapshot.value as! NSDictionary).value(forKey: "\(objUserDBM.profilePhoto)") as? String {
                        if index > self.arrMsgProfilePic.count - 1
                        {
                            self.arrMsgProfilePic.add("")
                        }
                        self.arrMsgProfilePic[index] = temp
                        tempimgurl = temp
                    }
                    else
                    {
                        self.arrMsgProfilePic[index] = ""
                    }
                    let indexPath = IndexPath(item: index, section: 0)

                    if fromuid == USERUID && grouptype == PRIVATECHAT {
                        //Directly get the cell from button or any sender of cell in table view
                        guard let cell = self.tablev.cellForRow(at: indexPath) as? OutGoingMsgCell else {
                            return // or fatalError() or whatever
                        }
                        //vc.profilepic = cell.imgvprofile.image!
                        if tempimgurl != ""{
                            let url = URL(string: USER_IMAGE_PATH + tempimgurl)
                            cell.imgvprofile.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                                if (image != nil){
                                    
                                }
                                else {
                                    cell.imgvprofile.image = UIImage(named: "user")!
                                }
                            })
                        }
                    }
                    else
                    {
                        guard let cell = self.tablev.cellForRow(at: indexPath) as? InboxMsgCell else {
                            return // or fatalError() or whatever
                        }
                        if tempimgurl != ""{
                            let url = URL(string: USER_IMAGE_PATH + tempimgurl)
                            cell.imgvprofile.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                                if (image != nil){
                                    
                                }
                                else {
                                    cell.imgvprofile.image = UIImage(named: "user")!
                                }
                            })
                        }
                    }
                    //let cell = self.tablev.cellForRow(at: indexPath) as! MessagingSenderCell
    //                self.tablev.beginUpdates()
    //                if selectunselect == 1
    //                {
    //                    cell.vselection.isHidden = true
    //                }else{
    //                    cell.vselection.isHidden = false
    //                    //cell.contentView.backgroundColor = appclr.withAlphaComponent(0.15)
    //                }
    //                tablev.endUpdates()
                    if subsnapshot.childrenCount > 4
                    {
                        let tempdic = subsnapshot.value as! NSDictionary
                        if let temp = tempdic.value(forKey: "\(objUserDBM.userName)") as? String
                        {
                            if index > self.arrUserPhoneNumber.count - 1
                            {
                                self.arrUserPhoneNumber.add("")
                            }
                            self.arrUserPhoneNumber[index] = temp
                        }
                        else
                        {
                            self.arrUserPhoneNumber[index] = ""
                        }
                        
                        if let temp = tempdic.value(forKey: "\(objUserDBM.userName)") as? String {
                            if index > self.arrMsgUserName.count - 1
                            {
                                self.arrMsgUserName.add("")
                            }
                            self.arrMsgUserName[index] = temp
                        }
                        else
                        {
                            self.arrMsgUserName[index] = ""
                        }
                        
                        let tempUser_id = tempdic.value(forKey: "\(objUserDBM.userId)") as! String
                        self.arrUserUserId.add(tempUser_id)
                        if let temp = tempdic.value(forKey: "\(objUserDBM.lastSeen)") as? String
                        {
                            if index > self.arrMsgShowLastSeen.count - 1
                            {
                                self.arrMsgShowLastSeen.add("")
                            }
                            self.arrMsgShowLastSeen[index] = temp
                        }
                        else{
                            self.arrMsgShowLastSeen[index] = ""
                        }
                        if let temp = tempdic.value(forKey: "\(objUserDBM.profilePhotoPrivacy)") as? String
                        {
                            if index > self.arrMsgShowProfilePhoto.count - 1
                            {
                                self.arrMsgShowProfilePhoto.add("")
                            }
                            self.arrMsgShowProfilePhoto[index] = temp
                        }
                        else{
                            self.arrMsgShowProfilePhoto[index] = ""
                        }
                        if let temp = tempdic.value(forKey: "\(objUserDBM.seeAbout)") as? String
                        {
                            if index > self.arrMsgShowSeeAbout.count - 1
                            {
                                self.arrMsgShowSeeAbout.add("")
                            }
                            self.arrMsgShowSeeAbout[index] = temp
                        }
                        else{
                            self.arrMsgShowSeeAbout[index] = ""
                        }
                    }
                    else
                    {
                        let tempgroupid =  self.arrMsgGroupId[index] as! String
                        self.funDeleteValue(grouptype: "private", key: uidd , groupid: tempgroupid)
                        self.funDeleteValue(grouptype: "private", key: USERUID, groupid: tempgroupid)
                    }
            })
        }
    
    //MARK:- Function table view scroll to bottom
    func scrolltobottom(indexpath: IndexPath)
    {
        if arrMsgOtherUid.count > 0
        {
            self.tablev.scrollToRow(at: indexpath, at: .bottom, animated: true)
        }
    }
    
    //MARK:- Search Section
    var isFiltered = Bool()
    var arrSearchIndex = NSMutableArray()
    
    func funSearchSetting()
    {
        // search textfield func
        let btncancelSearch = UIButton(type: .custom)
        putRightButtoninTextField(btn: btncancelSearch, txtfield: txtsearch, imgname: "cross", x: 20, width: 15, height: 15)
        btncancelSearch.addTarget(self, action: #selector(btncancelSearch(sender:)), for: .touchUpInside)
        
        setTextFieldShade(textfield: txtsearch)
        
        txtsearch.layer.borderColor = UIColor.lightGray.cgColor
        txtsearch.layer.borderWidth = 1
        txtsearch.delegate = self
        txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
    }
    @objc func change()
    {
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
            for (index, temp) in arrMsgUserName.enumerated() {
                var name = temp as! String
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchhide"), object: nil)
        searchhide()
    }
    
    @objc func searchhide()
    {
        isFiltered = false
        tablev.reloadData()
    }
    
    

    //MARK:- Dashboard PC Functions
    func funInitializationOfDashboardPC(){
        NotificationCenter.default.addObserver(self, selector: #selector(funChatScreen), name: NSNotification.Name(rawValue: "shareChatScreen"), object: nil)
    }
    @objc func funChatScreen(notification: Notification)
    {
        
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
         
            MessagesDB.child(tempgroupId)
            .child(tempfromuid).child(tempautocreatedid)
            .setValue([
                "\(objMessageDBM.from)":"\(tempfromuid)",
                "\(objMessageDBM.message)":tempmessagetext,
                "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                "\(objMessageDBM.messageType)":msgtype,
                "\(objMessageDBM.userName)":USERUniqueID,
                "\(objMessageDBM.timeStamp)": timespam,
                "\(objMessageDBM.source)":SOURCECODE])
            MessagesDB.child(tempgroupId).child(temptouid).child(tempautocreatedid).setValue([
                "\(objMessageDBM.from)":"\(tempfromuid)",
                "\(objMessageDBM.message)":tempmessagetext,
                "\(objMessageDBM.messageStatus)":NOT_DELIVERED,
                "\(objMessageDBM.messageType)":msgtype,
                "\(objMessageDBM.userName)":USERUniqueID,
                "\(objMessageDBM.timeStamp)": timespam,
                "\(objMessageDBM.source)":SOURCECODE] as [String : Any], withCompletionBlock: {
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
                    showToast(message: response!, viewcontroller: self)
                }
            })
        }
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
                    showToast(message: (error?.localizedDescription)!, viewcontroller: self)
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
                    
                 //   SendPushNotification(toToken: self.receivertokenLocalClass, title: "1 new message", body: self.messagetext, data: parameters )
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
                    showToast(message: response!, viewcontroller: self)
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
            showToast(message: "File size cannot be more then 100 MB", viewcontroller: self)
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
                                    funMoveLocalFileToLocalDirectory(fileName: localFileName, downloadURL: downloadURL, fileData: self.uploadData)
                                    completion("\(downloadURL)")
                            }
                        }
                    }
            }
            
            MEDIAPROGRESS = Float()
            if MEDIAPROGRESS == Float(){
                showProgressBar(viewController: self)
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
    //MARK:- Public Group Handling
    var arrGroupParticipatUid = NSArray()
    //Groups Messaging Start
    @objc func fetchGroupParticipent(tempgroupId: String, completion: @escaping (_ url: String?) -> Void) {
        ParticipantsDB.child(tempgroupId)
            .queryOrderedByKey()
            .observe(.value) { (snapshot) in
                self.arrGroupParticipatUid = NSArray()
                if snapshot.childrenCount == 0{
                   
                    self.view.endEditing(true)
                    completion("0")
                    return
                }
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    if snapShot.count > 0
                    {
                        let datadic = (snapshot.value as! NSDictionary)
                        self.arrGroupParticipatUid = datadic.allKeys as NSArray
                        self.fetchParticipantUserData(completion: {
                            response in
                            completion(response)
                        })
                        
                    }
                }
        }
    }
    
    //MARK:- Fetch Groups Users Details for profile
    var arrGroupParticipatUserPic = NSMutableArray()
    var arrGroupParticipatUserName = NSMutableArray()
    var arrGroupParticipatUserPhone = NSMutableArray()
    var arrGroupParticipatUserFBid = NSMutableArray()
    
    var arrGroupParticipatDeviceSource = NSMutableArray()
    var arrGroupParticipatUserFBToken = NSMutableArray()
    
    func fetchParticipantUserData(completion: @escaping (_ url: String?) -> Void) {
        DispatchQueue.main.async{
            self.arrGroupParticipatUserPic = NSMutableArray()
            self.arrGroupParticipatUserName = NSMutableArray()
            self.arrGroupParticipatUserPhone = NSMutableArray()
            self.arrGroupParticipatUserFBid = NSMutableArray()

            for (index, tempUid) in self.arrGroupParticipatUid.enumerated(){
                
                UserDB.child(tempUid as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    //UserDB.child(tempiddd as! String).observe(.value, with: { (snapshot) in
                    print(snapshot)
                    self.andicator.stopAnimating()
                    if snapshot.childrenCount > 0
                    {
                        let datadic = (snapshot.value as! NSDictionary)
                        let allkeys = datadic.allKeys as NSArray
                        if self.arrGroupParticipatUserPhone.contains(datadic.value(forKey: "UserPhoneNumber") as Any){
                            return
                        }
                        else{
                            self.arrGroupParticipatUserPic.add(datadic.value(forKey: "UserLink") as Any)
                            self.arrGroupParticipatUserName.add(datadic.value(forKey: "UserName") as Any)
                            self.arrGroupParticipatUserPhone.add(datadic.value(forKey: "UserPhoneNumber") as Any)
                            self.arrGroupParticipatUserFBToken.add(datadic.value(forKey: "fcmId") as Any)
                            self.arrGroupParticipatUserFBid.add(snapshot.key)
                            
                            if allkeys.contains("source"){
                                self.arrGroupParticipatDeviceSource.add((datadic.value(forKey: "source") as Any))
                            }
                            else if allkeys.contains("Source"){
                                self.arrGroupParticipatDeviceSource.add((datadic.value(forKey: "Source") as Any))
                            }
                            else{
                                self.arrGroupParticipatDeviceSource.add("")
                            }
                        }
                        if index == self.arrGroupParticipatUid.count - 1{
                            completion("1")
                        }
                        
                    }
                    else
                    {
                        if index == self.arrGroupParticipatUid.count - 1{
                            completion("0")
                        }
                    }
                })
            }
        }
    }
    
    func funSendMsgInGroup(tempMsgType: Int, messageTextt: String, tempfromuid: String, temptouid: String, tempgroupType: String, tempgroupId: String, isBack: Bool, tempreceiverId: String, receiverToken: String, isAndroidUserTemp: Bool, tempautocreatedid: String)
    {
        var bodymessage = messageTextt
        let timespam = Date().currentTimeMillis()!
        var dicmsg = [String: Any]()
        switch (tempMsgType) {
        case (TEXT):
            dicmsg = [
                "from":"\(tempfromuid)",
                "message":messageTextt,
                "messageStatus":NOT_DELIVERED,
                "messageType":TEXT,
                "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                "timestamp": timespam]
            break
        case (CONTACT):
            bodymessage = "Contact Received"
            dicmsg = [
                "from":"\(tempfromuid)",
                "message":messageTextt,
                "messageStatus":NOT_DELIVERED,
                "messageType":CONTACT,
                "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                "timestamp": timespam]
            break
            
        case (LOCATION):
            bodymessage = "Location Received"
            dicmsg = [
                "from":"\(tempfromuid)",
                "imageThumb":"\("self.currentlat"),\("self.currentlong")",
                "message":messageTextt,
                "messageImagePath":"",
                "messageStatus":NOT_DELIVERED,
                "messageType":LOCATION,
                "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                "timestamp": timespam]
            break
        case (IMAGE):
            bodymessage = "Image Received"
            dicmsg = [
                "from":"\(tempfromuid)",
                "imageThumb":"\(self.objecturl)",
                "message":messageTextt,
                "messageImagePath":self.objecturl,
                "messageStatus":NOT_DELIVERED,
                "messageType":IMAGE,
                "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                "timestamp": timespam]
            break
        case AUDIO:
            bodymessage = "Audio Received"
            dicmsg = [
                "from":"\(tempfromuid)",
                "message":"\("self.audioDuration")",
                "messageImagePath":self.objecturl,
                "messageStatus":NOT_DELIVERED,
                "messageType":AUDIO,
                "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                "timestamp": timespam]
            break
        case VIDEO:
            bodymessage = "Video Received"
            dicmsg = [
                "from":"\(tempfromuid)",
                "message":"\("self.audioDuration")",
                "imageThumb":self.videoimageurl,
                "messageImagePath":self.videoimageurl,
                "messageVideoPath":self.objecturl,
                "messageStatus":NOT_DELIVERED,
                "messageType":VIDEO,
                "phoneNumber":defaults.value(forKey: "phoneno") as! String,
                "timestamp": timespam]
            
            break
       case DOCUMENT:
            bodymessage = "Document Received"
            dicmsg = [
            "from":"\(tempfromuid)",
            "message":self.selectedFileName,
            "messageImagePath":self.objecturl,
            "messageStatus":NOT_DELIVERED,
            "messageType":DOCUMENT,
            "phoneNumber":defaults.value(forKey: "phoneno") as! String,
            "timestamp": timespam]
            break
        default:
            print("dfggf")
        }
        MessagesDB.child(tempgroupId)
        .child(tempreceiverId)
        .child(tempautocreatedid)
        .setValue(dicmsg, withCompletionBlock: {
            error, snapshot in
            print(snapshot)
            
            if error != nil
            {
                showToast(message: (error?.localizedDescription)!, viewcontroller: self)
            }
            else
            {
                
                let parameters :Parameters = ["title":"1 new message",
                                                      "body":bodymessage,
                                                      "sound":"default",
                                                      //"groupId":self.groupId,
                                                      "groupType":tempgroupType,
                                                      "messageId":snapshot.key!,
                                                      "action":"newMessage",
                                                      "messageType":tempMsgType,
                                                      "firebaseId":tempfromuid,
                                                      //"to":receiverid,
                                                      "groupFireBaseId":tempgroupId,
                                                      "froma":defaults.value(forKey: "phoneno") as! String,
                                                      "profilePic":defaults.value(forKey: "userimage") as? String ?? "",
                                                      "message":messageTextt,
                                                      "mutable_content": true,
                                                      "isAndroidUser":isAndroidUserTemp]
                if tempreceiverId != defaults.value(forKey: "uid") as! String{
                    SendPushNotification(toToken: receiverToken, title: "1 new \(tempMsgType) message", body: messageTextt, data: parameters )
                }
                self.funUpdateChatGroupStatusLocal(messageTextt:messageTextt, tempFromId: tempfromuid, tempGroupId: tempgroupId, msgType: tempMsgType, receiverid: tempreceiverId)
                if isBack{
                    self.funback()
                }
            }
        })
    }
    
    //MARK:- Group Chat Update
    func funUpdateChatGroupStatusLocal(messageTextt: String, tempFromId: String, tempGroupId: String,msgType: Int, receiverid: String)
    {
        funGetMessageCount(tempFromId: tempFromId, tempGroupId: tempGroupId, receiverid: receiverid, completion: {
            unSeenCount in
            let timespam = Date().currentTimeMillis()!
            let dicChatGroup = [
                "Source":"ios",
                "createdAt" : timespam,
                "groupType" : PUBLICGROUP,
                "lastMessage" : messageTextt,
                "lastMessageId" : messageTextt,
                "lastMessageStatus" : NOT_DELIVERED,
                "lastMessageTime" : timespam,
                "lastMessageType" : msgType,
                "lastMessageUserId" : tempFromId,
                "messageStatus" : "",
                //"otherUserId" : receiverid,
                "seen" : false,
                "typing" : STOP_TYPING_RECORDING,
                "userPhoneNumber" : defaults.value(forKey: "phoneno") as! String,
                "unSeenCount": unSeenCount as Any] as [String : Any]
            
            ChatDB.child(receiverid).child(tempGroupId).updateChildValues(dicChatGroup, withCompletionBlock: {
                error, snapshot in
                if error != nil
                {
                    print("Error occurd chat not update userid: \(receiverid)")
                }
                else
                {
                    print("Chat updated userid: \(receiverid)")
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
    
    
    
    
}

