//
//  Chats.swift
//  sChat
//
//  Created by MacBook Pro on 13/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseDatabase
import Kingfisher
import Contacts
import CoreData
import Alamofire

class Chats: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, InboxMsgCellDelegate, OutGoingMsgCellDelegate {
    
    var longPressGesture = UILongPressGestureRecognizer()
    var arrSelectedDeletIndex = [Int]()
    
    var refreshControl = UIRefreshControl()
    
    var tableviewframe = CGFloat()
    var ifScreenOpenOtherUserId = String()
    var arrShowNamesInCell = [String]()
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
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "Contacts") as! Contacts
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
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
        self.lblsearching.isHidden = true
        var index = indexPath.row
        if isFiltered == true {
            index = arrSearchIndex[indexPath.row] as! Int
        }
        var statutype = Int()
        if let status = arrMsgStatus[index] as? String {
            statutype = Int(status)!
        }
        else if let status = arrMsgStatus[index] as? Int {
            statutype = status
        }
        var type = Int()
        if let temptype = arrMsgType[index] as? String {
            type = Int(temptype)!
        }
        else if let temptype = arrMsgType[index] as? Int {
            type = temptype
        }
        var unseencount = Int()
        if let tempunseen = arrMsgUnSeenCount[index] as? String {
            unseencount = Int(tempunseen)!
        }
        else if let tempunseen = arrMsgUnSeenCount[index] as? Int {
            unseencount = tempunseen
        }
        var showprofilephoto = ""
        if let tempprofilephoto = arrMsgShowProfilePhoto[index] as? String {
            showprofilephoto = tempprofilephoto
        }
        
        let grouptype = arrMsgGroupType[index] as! String
        let timestring = obj.convertTimespamIntoTime(timestring: "\(arrMsgTime[index] as! Int)")
        let fromuid = arrMsgFomUid[index] as! String
        
        var contactUserName = String()
        
        if grouptype == PRIVATECHAT {
            //MARK:- Get Name of cuntact
            contactUserName = obj.getContactNameFromNumber(contactNumber:"\(arrUserPhoneNumber[index])")
        }
        else{
            contactUserName = arrMsgUserName[index] as! String
        }
        
        //MARK:- If Message Delete
        if statutype == MESSAGE_DELETED
        {
            //MARK:- Self Messages
            let cell = tablev.dequeueReusableCell(withIdentifier: "InboxPhotoCell") as! InboxMsgCell
            //MARK:- Assign Manual Delegate
            cell.cellConfigration(row: index, delegate: self)
            cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic), for: .touchUpInside)
            cell.imgvtype.image = UIImage(named: "deletedmsg")
            //cell.lbltitle.text = (arrMsgUserName[index] as! String)
            
            cell.lbltitle.text = contactUserName
            if arrShowNamesInCell.count < index{
                arrShowNamesInCell.append(contactUserName)
            }
            else if arrShowNamesInCell.count == index{
                arrShowNamesInCell.append(contactUserName)
            }
            else{
                arrShowNamesInCell[index] = contactUserName
            }
            cell.lblcount.isHidden = true
            if arrMsgTyping[index] as? Int == TYPING{
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING {
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else{
                cell.lbltextmsg.textColor = .lightGray
                if arrMsgFomUid[index] as! String == USERUID {
                    cell.lbltextmsg.text = "You deleted this message"
                }
                else
                {
                    cell.lbltextmsg.text = "User deleted this message"
                }
            }
            return cell
        }
        if type == GROUP_INFO_MESSAGE || type == CREATE_GROUP || type == LEFT_GROUP || type == REMOVE_MEMBER || type == ADD_MEMBER || type == GROUP_ADMIN
        {
            return inCommingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto, username: contactUserName)
        }
        else if type == TEXT
        {
            if fromuid == USERUID && grouptype == PRIVATECHAT {
                return outGoingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto, username: contactUserName)
            }
            else
            {
                return inCommingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto, username: contactUserName)
            }
        }
        else {
            
            if fromuid == USERUID && grouptype == PRIVATECHAT {
                return outGoingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto, username: contactUserName)
            }
            else
            {
                return inCommingCell(index: index, type: type, statutype: statutype, timestring: timestring, grouptype: grouptype, unseencount: unseencount, showprofilephoto: showprofilephoto, username: contactUserName)
            }
        }
    }
    
    func outGoingCell(index: Int, type: Int, statutype: Int, timestring: String, grouptype: String, unseencount: Int, showprofilephoto: String, username: String) -> UITableViewCell
    {
        if arrShowNamesInCell.count < index{
            arrShowNamesInCell.append(username)
        }
        else if arrShowNamesInCell.count == index{
            arrShowNamesInCell.append(username)
        }
        else{
            arrShowNamesInCell[index] = username
        }
        if type == TEXT || type == GROUP_INFO_MESSAGE || type == CREATE_GROUP || type == REMOVE_MEMBER {
            //MARK:- Self Messages
            let cell = tablev.dequeueReusableCell(withIdentifier: "OutGoingMsgCell") as! OutGoingMsgCell
            //MARK:- Assign Manual Delegate
            cell.cellConfigration(row: index, delegate: self)
            //cell.lbltitle.text = (arrMsgUserName[index] as! String)
            
            cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic), for: .touchUpInside)
            cell.lbltitle.text = username
            cell.lbltime.text = timestring
            
            if showprofilephoto == "Nobody"
            {
                if grouptype == "Public Group"
                {
                    cell.imgvprofile.image = UIImage(named: "groupicon")
                }
                else
                {
                    cell.imgvprofile.image = UIImage(named: "user")
                }
            }
            else if let imgurl = arrMsgProfilePic[index] as? String
            {
                if imgurl != ""
                {
                    loadimage(imgv: cell.imgvprofile, imgurl: USER_IMAGE_PATH + imgurl)
                }
                else
                {
                    cell.imgvprofile.image = UIImage(named: "user")
                }
                
                //cell.imgvprofile.kf.setImage(with: URL(string: imgurl))
            }
            else
            {
                cell.imgvprofile.image = UIImage(named: "user")
            }
            
            //MARK:- Message Status Set
            self.setMessageStatusForCell(msgStatus: statutype, imageview: cell.imgvstatus)
            obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            
            if arrMsgTyping[index] as? Int == TYPING
            {
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING
            {
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else
            {
                cell.lbltextmsg.text = arrMsgLast[index] as? String
                if type == TEXT {
                    cell.lbltextmsg.textColor = .darkGray
                }
                else{
                    cell.lbltextmsg.textColor = .black
                }
            }
            return cell
        }
        else{
            //MARK:- Self Messages
            let cell = tablev.dequeueReusableCell(withIdentifier: "OutGoingPhotoMsgCell") as! OutGoingMsgCell
            //MARK:- Assign Manual Delegate
            cell.cellConfigration(row: index, delegate: self)
            cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic), for: .touchUpInside)
            //cell.lbltitle.text = (arrMsgUserName[index] as! String)
            cell.lbltitle.text = username
            cell.lbltime.text = timestring
            if showprofilephoto == "Nobody"
            {
                if grouptype == "Public Group"
                {
                    cell.imgvprofile.image = UIImage(named: "groupicon")
                }
                else
                {
                    cell.imgvprofile.image = UIImage(named: "user")
                }
            }
            else if let imgurl = arrMsgProfilePic[index] as? String
            {
                if imgurl != ""
                {
                    loadimage(imgv: cell.imgvprofile, imgurl: USER_IMAGE_PATH + imgurl)
                }
                else
                {
                    cell.imgvprofile.image = UIImage(named: "user")
                }
                //cell.imgvprofile.kf.setImage(with: URL(string: imgurl))
            }
            else
            {
                cell.imgvprofile.image = UIImage(named: "user")
            }
            //MARK:- Message Status Set
            self.setMessageStatusForCell(msgStatus: statutype, imageview: cell.imgvstatus)
            obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            
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
            if arrMsgTyping[index] as? Int == TYPING
            {
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING
            {
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else
            {
                cell.lbltextmsg.textColor = UIColor.lightGray
            }
            return cell
        }
    }
    
    func inCommingCell(index: Int, type: Int, statutype: Int, timestring: String, grouptype: String, unseencount: Int, showprofilephoto: String, username: String) -> UITableViewCell
    {
        if arrShowNamesInCell.count < index{
            arrShowNamesInCell.append(username)
        }
        else if arrShowNamesInCell.count == index{
            arrShowNamesInCell.append(username)
        }
        else{
            arrShowNamesInCell[index] = username
        }
        if type == TEXT || type == GROUP_INFO_MESSAGE || type == CREATE_GROUP || type == LEFT_GROUP || type == REMOVE_MEMBER || type == ADD_MEMBER || type == GROUP_ADMIN
        {
            let cell = tablev.dequeueReusableCell(withIdentifier: "InboxMsgCell") as! InboxMsgCell
            cell.cellConfigration(row: index, delegate: self)
            cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic), for: .touchUpInside)
            if unseencount != 0
            {
                cell.lblcount.text = "\(unseencount)"
                cell.lblcount.isHidden = false
                obj.setLabelCircle(label: cell.lblcount, viewcontroller: self)
            }
            else
            {
                cell.lblcount.isHidden = true
            }
            //cell.lbltitle.text = (arrMsgUserName[index] as! String)
            cell.lbltitle.text = username
            cell.lbltime.text = timestring
            if showprofilephoto == "Nobody"
            {
                if grouptype == "Public Group"
                {
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
                        if grouptype == "Public Group"
                        {
                            path = GROUP_IMAGE_PATH
                        }
                        loadimage(imgv: cell.imgvprofile, imgurl: path + imgurl)
                    }
                    else if grouptype == "Public Group"
                    {
                        obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
                        cell.imgvprofile.layer.borderColor = UIColor.lightGray.cgColor
                        
                        cell.imgvprofile.image = UIImage(named: "groupicon")
                    }
                    else
                    {
                        cell.imgvprofile.image = UIImage(named: "user")
                    }
                    
                    //cell.imgvprofile.kf.setImage(with: URL(string: imgurl))
                }
            }
            
            obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            if arrMsgTyping[index] as? Int == TYPING
            {
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING
            {
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else
            {
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
                        else {
                            let tempname = obj.getContactNameFromNumber(contactNumber: "\(tempphone)")
                            tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: tempname)
                        }
                        if tempphone2 == defaults.value(forKey: "phoneno") as? String{
                            tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone2, with: "You")
                        }
                        else {
                            let tempname = obj.getContactNameFromNumber(contactNumber: "\(tempphone2)")
                            tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone2, with: tempname)
                        }
                    }
                    else{
                        if type == CREATE_GROUP {
                            let strArray = tempTextMsg.components(separatedBy: " ")
                            tempphone = strArray[0].components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                        }
                        else {
                            tempphone = tempTextMsg.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                        }
                        
                        if tempphone == defaults.value(forKey: "phoneno") as! String{
                            tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: "You")
                        }
                        else {
                            let tempname = obj.getContactNameFromNumber(contactNumber: "\(tempphone)")
                            tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: tempname)
                        }
                    }
                    
                    
//                    let tempphone = tempTextMsg.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
//                    if tempphone == defaults.value(forKey: "phoneno") as! String{
//                        tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: "You")
//                    }
//                    else{
//                        let tempname = obj.getContactNameFromNumber(contactNumber: "\(tempphone)")
//                        tempTextMsg = tempTextMsg.replacingOccurrences(of: tempphone, with: tempname)
//                    }
                    cell.lbltextmsg.text = tempTextMsg
                }
            }
            
            return cell
        }
        else {
            let cell = tablev.dequeueReusableCell(withIdentifier: "InboxPhotoCell") as! InboxMsgCell
            //MARK:- Assign Manual Delegate
            cell.cellConfigration(row: index, delegate: self)
            cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic), for: .touchUpInside)
            //cell.lbltitle.text = (arrMsgUserName[index] as! String)
            cell.lbltitle.text = username
            cell.lbltime.text = timestring
            if showprofilephoto == "Nobody"
            {
                if grouptype == "Public Group"
                {
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
                        if grouptype == "Public Group"
                        {
                            path = GROUP_IMAGE_PATH
                        }
                        loadimage(imgv: cell.imgvprofile, imgurl: path + imgurl)
                    }
                    else if grouptype == "Public Group"
                    {
                        obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
                        cell.imgvprofile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgvprofile.image = UIImage(named: "groupicon")
                    }
                    else
                    {
                        cell.imgvprofile.image = UIImage(named: "user")
                    }
                    
                    //cell.imgvprofile.kf.setImage(with: URL(string: imgurl))
                }
            }
            
            cell.imgvtype.image = UIImage(named: "locimg")
            obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
            if unseencount != 0
            {
                cell.lblcount.text = "\(unseencount)"
                cell.lblcount.isHidden = false
                obj.setLabelCircle(label: cell.lblcount, viewcontroller: self)
            }
            else
            {
                cell.lblcount.isHidden = true
            }
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
            if arrMsgTyping[index] as? Int == TYPING
            {
                cell.lbltextmsg.text = "Typing ..."
                cell.lbltextmsg.textColor = appclr
            }
            else if arrMsgTyping[index] as? Int == RECORDING
            {
                cell.lbltextmsg.text = "Recording ..."
                cell.lbltextmsg.textColor = appclr
            }
            else
            {
                cell.lbltextmsg.textColor = UIColor.lightGray
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
            funDeleteSelectedValue(grouptype: arrMsgGroupType[index] as! String, key: USERUID, groupid: arrMsgGroupId[index] as! String, index: index)
        }
    }
    
    
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
        var imagestring = arrMsgProfilePic[index] as! String
        let imagename = imagestring
        var userName = "\(arrUserPhoneNumber[index])"
        
        if arrMsgGroupType[index] as! String == "Public Group"
        {
            userName = "\(arrMsgUserName[index])"
            if imagestring != ""
            {
                imagestring = GROUP_IMAGE_PATH + imagestring
            }
            ifScreenOpenOtherUserId = ""
        }
        else
        {
            userName = obj.getContactNameFromNumber(contactNumber: "\(arrUserPhoneNumber[index])")
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "taponuser"), object: ["touid": ifScreenOpenOtherUserId, "fromuid": USERUID,
                                                                                                   "useridserver": arrUserUserId[index],
                                                                                                   "userprofilepic":imagestring,
                                                                                                   "imagename": imagename,
                                                                                                   "username": userName,
                                                                                                   "groupid": arrMsgGroupId[index],
                                                                                                   "otherUserPhone_Number":arrUserPhoneNumber[index],
                                                                                                   "grouptype" : arrMsgGroupType[index],
                                                                                                   "unSeenCount" : arrMsgUnSeenCount[index]])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD
        {
            return 150
        }
        return 75
    }
    
    func loadimage(imgv: UIImageView, imgurl : String)
    {
        DispatchQueue.main.async {
            imgv.kf.setImage(with: URL(string: imgurl))
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
        // removeValue()
        
        
//        let scoresRef = Database.database().reference(withPath: "Users")
//        scoresRef.keepSynced(true)
        self.lblsearching.textColor = appclr
        // retreiveMessages()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "chat"])
    }
    override func viewDidDisappear(_ animated: Bool) {
        //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "chat"])
    }
    //MARK:- REmove any value
    func removeValue() {
        ChatDB.child("-LeAQIbL0OLM_OJ6jg2_").removeValue(completionBlock: { error, snapshot in
            print(snapshot)
        })
    }
    //MARK:- Show Profile Pic Function
    func didTapOnRow(row: NSInteger) {
        print(row)
    }
    @objc func funShowProfilePic(sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        
        let index = sender.tag
        var type = Int()
        if let temptype = arrMsgType[index] as? String
        {
            type = Int(temptype)!
        }
        else if let temptype = arrMsgType[index] as? Int
        {
            type = temptype
        }
        let grouptype = arrMsgGroupType[index] as! String
        let fromuid = arrMsgFomUid[index] as! String
        if type == TEXT
        {
            if fromuid == USERUID && grouptype == PRIVATECHAT {
                //Directly get the cell from button or any sender of cell in table view
                guard let cell = sender.superview?.superview as? OutGoingMsgCell else {
                    return // or fatalError() or whatever
                }
                if cell.imgvprofile.image != nil{
                    vc.profilepic = cell.imgvprofile.image!
                }
                else{
                    vc.profilepic = UIImage(named: "user")!
                }
                vc.name = cell.lbltitle.text ?? ""
            }
            else
            {
                guard let cell = sender.superview?.superview as? InboxMsgCell else {
                    return // or fatalError() or whatever
                }
                if cell.imgvprofile.image != nil{
                    vc.profilepic = cell.imgvprofile.image!
                }
                else{
                    vc.profilepic = UIImage(named: "user")!
                }
                vc.name = cell.lbltitle.text ?? ""
            }
        }
        else {
            
            if fromuid == USERUID && grouptype == PRIVATECHAT {
                //MARK:- Self Messages
                guard let cell = sender.superview?.superview as? OutGoingMsgCell else {
                    return // or fatalError() or whatever
                }
                if cell.imgvprofile.image != nil{
                    vc.profilepic = cell.imgvprofile.image!
                }
                else{
                    vc.profilepic = UIImage(named: "user")!
                }
                vc.name = cell.lbltitle.text ?? ""
            }
            else
            {
                guard let cell = sender.superview?.superview as? InboxMsgCell else {
                    return // or fatalError() or whatever
                }
                if cell.imgvprofile.image != nil{
                    vc.profilepic = cell.imgvprofile.image!
                }
                else{
                    vc.profilepic = UIImage(named: "user")!
                }
                vc.name = cell.lbltitle.text ?? ""
            }
        }
        vc.videoimagename = "Picture"
        vc.videoimagetag = PROFILEPIC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        
    }
    
    func funDeleteValue(grouptype: String, key: String, groupid: String)
    {
        if grouptype == "Public Group"
        {
            GroupsDB.child(groupid).removeValue(completionBlock: { error, snapshot in
                if error != nil
                {
                    obj.showToast(message: "Not Delete", viewcontroller: self)
                }
                else
                {
                    obj.showToast(message: "Value Delete", viewcontroller: self)
                }
            })
        }
        else if grouptype == PRIVATECHAT
        {
            ChatDB.child(key).child(groupid).removeValue(completionBlock: { error, snapshot in
                
                if error != nil
                {
                    obj.showToast(message: "Not Delete", viewcontroller: self)
                    
                }
                else
                {
                    obj.showToast(message: "Value Delete", viewcontroller: self)
                }
            })
        }
    }
    
    func funDeleteSelectedValue(grouptype: String, key: String, groupid: String, index: Int)
    {
        if grouptype == "Public Group"{
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
                                if tempArrGroupParticipant.contains(USERUID){
                                    obj.showAlert(title: "Public Group!", message: "Please exist from group, then you can able to delete chat", viewController: self)
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
                obj.showToast(message: "Not Delete try again", viewcontroller: self)
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
    
    // MARK: Methods to Open, Store and Fetch data
    func openDatabse(dicdata: NSDictionary, key: String)
    {
        // setEntity(dicdata: dicdata)
        
        return
        let entityChat = NSEntityDescription.entity(forEntityName: "Chat", in: context)
        
        let newChat = NSManagedObject(entity: entityChat!, insertInto: context)
        
        saveData(ChatDBObj:newChat, dicdata: dicdata, key: key)
    }
    func saveData(ChatDBObj:NSManagedObject, dicdata: NSDictionary, key: String)
    {
        return
        let dicAllKeys = dicdata.allKeys
        ChatDBObj.setValue(key, forKey: "groupid")
        
        //        if let temp = dicdata.value(forKey: "createdAt") as? Int{
        //            ChatDBObj.setValue(temp, forKey: "createdAt")
        //        }
        //        else if let temp = dicdata.value(forKey: "createdAt") as? String{
        //            ChatDBObj.setValue(Int(temp), forKey: "createdAt")
        //        }
        ChatDBObj.setValue(dicdata.value(forKey: "groupType") as! String, forKey: "groupType")
        ChatDBObj.setValue(dicdata.value(forKey: "lastMessage"), forKey: "lastMessage")
        ChatDBObj.setValue(dicdata.value(forKey: "lastMessageId"), forKey: "lastMessageId")
        ChatDBObj.setValue(dicdata.value(forKey: "lastMessageStatus"), forKey: "lastMessageStatus")
        ChatDBObj.setValue(dicdata.value(forKey: "lastMessageTime"), forKey: "lastMessageTime")
        ChatDBObj.setValue(dicdata.value(forKey: "lastMessageType"), forKey: "lastMessageType")
        ChatDBObj.setValue(dicdata.value(forKey: "lastMessageUserId"), forKey: "lastMessageUserId")
        if let temp = dicdata.value(forKey: "messageStatus") as? Int{
            ChatDBObj.setValue(temp, forKey: "messageStatus")
        }
        else if let temp = dicdata.value(forKey: "messageStatus") as? String{
            ChatDBObj.setValue(Int(temp), forKey: "messageStatus")
        }
        ChatDBObj.setValue(dicdata.value(forKey: "otherUserId"), forKey: "otherUserId")
        ChatDBObj.setValue(dicdata.value(forKey: "seen"), forKey: "seen")
        ChatDBObj.setValue(dicdata.value(forKey: "Source"), forKey: "Source")
        
        ChatDBObj.setValue(dicdata.value(forKey: "typing"), forKey: "typing")
        if let temp = dicdata.value(forKey: "unSeenCount") as? Int{
            ChatDBObj.setValue(temp, forKey: "unSeenCount")
        }
        else if let temp = dicdata.value(forKey: "unSeenCount") as? String{
            ChatDBObj.setValue(Int(temp), forKey: "unSeenCount")
        }
        
        ChatDBObj.setValue(dicdata.value(forKey: "userPhoneNumber"), forKey: "userPhoneNumber")
        
        
        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }
        
        //fetchData(entityName: "Chat")
    }
    
    func fetchData(entityName:String)
    {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count == 0{
                self.retreiveMessages()
                return
            }
            //let dataArray = result as NSArray
            // let dataArray2nd = dataArray
            for data in result as! [NSManagedObject] {
                let groupid = data.value(forKey: "groupid") as! String
                //let age = data.value(forKey: "age") as! String
                // print("User Name is : "+groupid+" and Age is : "+age)
                
                let keys = Array(data.entity.attributesByName.keys)
                let dict = data.dictionaryWithValues(forKeys: keys)
                self.funInsertMessageInArrays(datadic: dict as NSDictionary, key: groupid)
            }
            self.sortArrays()
            DispatchQueue.main.async{
                self.tablev.reloadData {
                    
                }
            }
        } catch {
            print("Fetching data Failed")
        }
    }
    
    override func viewDidLoad() {
        USERUID = defaults.value(forKey: "uid") as! String
        funSearchSetting()
        self.retreiveMessages()
        
        //MARK:- Notification when tap on some user
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(searchshowhide), name: NSNotification.Name(rawValue: "searchshowhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchhide), name: NSNotification.Name(rawValue: "searchhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchshowhide), name: NSNotification.Name(rawValue: "clearchat"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funTableSelectUnselectWithNotification), name: NSNotification.Name(rawValue: "funTableSelectUnselect"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(btncancelSearch(sender:)), name: NSNotification.Name(rawValue: "btncancelSearch"), object: nil)
        funInitializationOfDashboardPC()
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            self.refresh(sender: self.refreshControl)
        }
        ///////
        lblsearching.textColor = appclr
        btnchat.backgroundColor = appclr
        btnchat.isUserInteractionEnabled = false
        self.lblsearching.isHidden = true
        self.andicator.stopAnimating()
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "InboxMsgCell", bundle: nil), forCellReuseIdentifier: "InboxMsgCell")
        self.tablev.register(UINib(nibName: "InboxPhotoCell", bundle: nil), forCellReuseIdentifier: "InboxPhotoCell")
        self.tablev.register(UINib(nibName: "OutGoingMsgCell", bundle: nil), forCellReuseIdentifier: "OutGoingMsgCell")
        self.tablev.register(UINib(nibName: "OutGoingPhotoMsgCell", bundle: nil), forCellReuseIdentifier: "OutGoingPhotoMsgCell")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "chat"])
        //MARK:- Add Long Gesture
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.allowableMovement = 15 // 15 points
        longPressGesture.delegate = self
        self.tablev.addGestureRecognizer(longPressGesture)
        
        
        
        obj.putImgInButtonWithOutLabel(button: btnchat, imgname: "chaticon")
       
        DispatchQueue.main.async {
            obj.setbuttonHeighWidth4Pad(button: self.btnchat, viewcontroller: self)
            DispatchQueue.main.async {
                self.btnchat.layer.cornerRadius = self.btnchat.frame.size.height / 2
            }
        }
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tablev.addSubview(refreshControl) // not required when using UITableViewController
    }
    //MARK:- Long Press Gesture
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizer.State.ended {
            return
        }
        else if sender.state == UIGestureRecognizer.State.began
        {
            let p = sender.location(in: self.tablev)
            let indexPath = self.tablev.indexPathForRow(at: p)
            funTableSelectUnselect()
        }else {
            print("Could not find index path")
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
        //            if fromuid == myuid && grouptype == PRIVATECHAT
        //            {
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
        //            if fromuid == myuid && grouptype == PRIVATECHAT
        //            {
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
    
    //MARK:- New Message Receive when the user is not in Inbox Screen
    func retreiveNewUserMessages(){
        ChatDB.child(USERUID).observe(.childAdded) { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                if snapShot.count > 0
                {
                    if self.arrMsgGroupId.contains(snapshot.key) != true
                    {
                        //MARK:- If new Child Added
                        let datadic = (snapshot.value as! NSDictionary)
                        //MARK:- Insert User New Message on Top of Array
                        if datadic.count > 10
                        {
                            
                        }
                        else
                        {
                            return
                        }
                        if datadic.value(forKey: "otherUserId") as? String == ""
                        {
                            //return
                        }
                        self.funInsertMessageOnTop(datadic: datadic, key: snapshot.key)
                        //MARK:- Get index when recevie new message after changing in array
                        let indexofchild = self.arrMsgGroupId.index(of: snapshot.key)
                        //MARK:- Message Delivery Status Update When App Receive New Message
                        if (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String == PRIVATECHAT
                        {
                            self.funMessageStatusUpdateRunTime(indexofchild: indexofchild)
                            //if self.arrMsgOtherUid.count > self.arrUserPhoneNumber.count
                            // {
                            //MARK:- Add only one user in array
                            let uidd = datadic.value(forKey: "otherUserId") as! String
                            print(uidd as Any)
                            UserDB.child(uidd).keepSynced(true)
                            UserDB.child(uidd).observeSingleEvent(of: .value, with: { (subsnapshot) in
                                print(subsnapshot)
                                if subsnapshot.childrenCount > 0
                                {
                                    self.arrMsgProfilePic.insert((subsnapshot
                                        .value as! NSDictionary)
                                        .value(forKey: "UserLink") as! String, at: 0)
                                    self.arrMsgUserName.insert((subsnapshot
                                        .value as! NSDictionary)
                                        .value(forKey: "UserName") as! String, at: 0)
                                    self.arrUserPhoneNumber.insert((subsnapshot
                                        .value as! NSDictionary)
                                        .value(forKey: "UserPhoneNumber") as! String, at: 0)
                                    
                                    self.arrUserUserId.insert((subsnapshot
                                        .value as! NSDictionary)
                                        .value(forKey: "user_id") as! String, at: 0)
                                    
                                    let allkeys = (subsnapshot.value as! NSDictionary).allKeys as NSArray
                                    
                                    if allkeys.contains("LastSeen"){
                                        if let tempLastSeen = (subsnapshot
                                            .value as! NSDictionary)
                                            .value(forKey: "LastSeen") as? String
                                        {
                                            self.arrMsgShowLastSeen.insert(tempLastSeen, at: 0)
                                        }
                                        else
                                        {
                                            self.arrMsgShowLastSeen.insert("", at: 0)
                                        }
                                    }
                                    else{
                                        self.arrMsgShowLastSeen.insert("", at: 0)
                                    }
                                    
                                    if allkeys.contains("ProfilePhoto"){
                                        if let tempProfilePhoto = (subsnapshot
                                            .value as! NSDictionary)
                                            .value(forKey: "ProfilePhoto") as? String
                                        {
                                            self.arrMsgShowProfilePhoto.insert(tempProfilePhoto, at: 0)
                                        }
                                        else
                                        {
                                            self.arrMsgShowProfilePhoto.insert("", at: 0)
                                        }
                                    }
                                    else{
                                        self.arrMsgShowProfilePhoto.insert("", at: 0)
                                    }
                                    if allkeys.contains("SeeAbout"){
                                        if let tempSeeAbout = (subsnapshot.value as! NSDictionary).value(forKey: "SeeAbout") as? String
                                        {
                                            self.arrMsgShowSeeAbout.insert(tempSeeAbout, at: 0)
                                        }
                                        else
                                        {
                                            self.arrMsgShowSeeAbout.insert("", at: 0)
                                        }
                                    }
                                    else{
                                        self.arrMsgShowSeeAbout.insert("", at: 0)
                                    }
                                }
                                DispatchQueue.main.async{
                                    self.tablev.beginUpdates()
                                    self.tablev.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                    self.tablev.endUpdates()
                                }
                                
                                
                                //  self.tablev.reloadData()
                            })
                            //}//End of IF Check
                        }
                        else if (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String == "Public Group"
                        {
                            let tempgroupid = snapshot.key
                            
                            GroupsDB.child(tempgroupid)
                                .observeSingleEvent(of: .value, with: { (snapshot) in
                                print(snapshot)
                                if snapshot.childrenCount > 0
                                {
                                    self.arrMsgProfilePic.insert((snapshot
                                        .value as! NSDictionary)
                                        .value(forKey: "groupImage") as! String, at: 0)
                                    self.arrMsgUserName.insert((snapshot
                                        .value as! NSDictionary)
                                        .value(forKey: "groupName") as! String, at: 0)
                                    self.arrUserPhoneNumber.insert("", at: 0)
                                    self.arrUserUserId.insert("" , at: 0)
                                    
                                    self.arrMsgShowLastSeen.insert("" , at: 0)
                                    self.arrMsgShowProfilePhoto.insert("" , at: 0)
                                    self.arrMsgShowSeeAbout.insert("" , at: 0)
                                    
                                    self.tablev.beginUpdates()
                                    self.tablev.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                    self.tablev.endUpdates()
                                }
                            })
                        }//End of Else IF Check
                    }
                }
            }
        }
    }
    //MARK:- Insert User Message on Top
    func funInsertMessageOnTop(datadic: NSDictionary, key: String)
    {
        
        self.arrMsgGroupId.insert(key, at: 0)
        let allkeys = datadic.allKeys as NSArray
        self.arrMsgFomUid.insert(datadic.value(forKey: "lastMessageUserId") as Any, at: 0)
        if datadic.value(forKey: "groupType") as? String == "Public Group"
        {
            self.arrMsgOtherUid.insert("", at: 0)
        }
        else{
            self.arrMsgOtherUid.insert(datadic.value(forKey: "otherUserId") as Any, at: 0)
        }
        self.arrMsgLast.insert(datadic.value(forKey: "lastMessage") as Any, at: 0)
        self.arrMsgStatus.insert(datadic.value(forKey: "lastMessageStatus") as Any, at: 0)
        self.arrMsgType.insert(datadic.value(forKey: "lastMessageType") as Any, at: 0)
        self.arrMsgTime.insert(datadic.value(forKey: "lastMessageTime") as Any, at: 0)
        self.arrMsgSeen.insert(datadic.value(forKey: "seen") as Any, at: 0)
        // self.arrMsgNumber.insert(datadic.value(forKey: "userPhoneNumber") as Any, at: 0)
        self.arrMsgTyping.insert(datadic.value(forKey: "typing") as Any, at: 0)
        self.arrMsgGroupType.insert(datadic.value(forKey: "groupType") as Any, at: 0)
        self.arrMsgLastMsgId.insert(datadic.value(forKey: "lastMessageId") as Any, at: 0)
        self.arrMsgUnSeenCount.insert(datadic.value(forKey: "unSeenCount") as Any, at: 0)
        //        self.arrMsgShowLastSeen.insert(datadic.value(forKey: "LastSeen") as Any, at: 0)
        //        self.arrMsgShowProfilePhoto.insert(datadic.value(forKey: "ProfilePhoto") as Any, at: 0)
        //        self.arrMsgShowSeeAbout.insert(datadic.value(forKey: "SeeAbout") as Any, at: 0)
        
        if allkeys.contains("userPhoneNumber"){
            self.arrMsgNumber.insert(datadic.value(forKey: "userPhoneNumber") as Any, at: 0)
        }
        else{
            self.arrMsgNumber.insert("", at: 0)
        }
        if allkeys.contains("LastSeen"){
            self.arrMsgShowLastSeen.insert(datadic.value(forKey: "LastSeen") as Any, at: 0)
        }
        else{
            self.arrMsgShowLastSeen.insert("", at: 0)
        }
        if allkeys.contains("ProfilePhoto"){
            self.arrMsgShowProfilePhoto.insert(datadic.value(forKey: "ProfilePhoto") as Any, at: 0)
        }
        else{
            self.arrMsgShowProfilePhoto.insert("", at: 0)
        }
        if allkeys.contains("SeeAbout"){
            self.arrMsgShowSeeAbout.insert(datadic.value(forKey: "SeeAbout") as Any, at: 0)
        }
        else{
            self.arrMsgShowSeeAbout.insert("", at: 0)
        }
    }
    
    //MARK:- Insert User Message on Top
    func funInsertMessageInArrays(datadic: NSDictionary, key: String)
    {
        if datadic.value(forKey: "otherUserId") as? String == ""
        {
            if datadic.value(forKey: "groupType") as? String == "Public Group"
            {
                
            }
            else
            {
                funDeleteFromChat(groupid: key)
                return
            }
        }
        //        if ((datadic.value(forKey: "createdAt") as? Int) != nil){
        //
        //        }
        //        else{
        //            funDeleteFromChat(groupid: key)
        //            return
        //        }
        if ((datadic.value(forKey: "groupType") as? String) != nil){
            
        }
        else{
            funDeleteFromChat(groupid: key)
            return
        }
        //        if ((datadic.value(forKey: "userPhoneNumber") as? String) != nil){
        //
        //        }
        //        else{
        //            if datadic.value(forKey: "groupType") as! String == PRIVATECHAT {
        //                funDeleteFromChat(groupid: key)
        //                return
        //            }
        //        }
        print(datadic)
        let tempdata = datadic.allKeys as NSArray
        self.arrMsgGroupId.add(key)
        self.arrMsgFomUid.add(datadic.value(forKey: "lastMessageUserId") as Any)
        if datadic.value(forKey: "groupType") as? String == "Public Group"
        {
            self.arrMsgOtherUid.add("")
        }
        else{
            self.arrMsgOtherUid.add(datadic.value(forKey: "otherUserId") as Any)
        }
        
        self.arrMsgLast.add(datadic.value(forKey: "lastMessage") as Any)
        self.arrMsgStatus.add(datadic.value(forKey: "lastMessageStatus") as Any)
        self.arrMsgType.add(datadic.value(forKey: "lastMessageType") as Any)
        self.arrMsgTime.add(datadic.value(forKey: "lastMessageTime") as Any)
        self.arrMsgSeen.add(datadic.value(forKey: "seen") as Any)
        // self.arrMsgNumber.add(datadic.value(forKey: "userPhoneNumber") as Any)
        self.arrMsgTyping.add(datadic.value(forKey: "typing") as Any)
        self.arrMsgGroupType.add(datadic.value(forKey: "groupType") as Any)
        self.arrMsgLastMsgId.add(datadic.value(forKey: "lastMessageId") as Any)
        self.arrMsgUnSeenCount.add(datadic.value(forKey: "unSeenCount") as Any)
        let allkeys = datadic.allKeys as NSArray
        if allkeys.contains("userPhoneNumber"){
            self.arrMsgNumber.insert(datadic.value(forKey: "userPhoneNumber") as Any, at: 0)
        }
        else{
            self.arrMsgNumber.insert("", at: 0)
        }
        self.arrMsgProfilePic.add("")
        self.arrUserPhoneNumber.add("")
        self.arrMsgUserName.add("")
        self.arrUserUserId.add("")
        //MARK:- For saving data
        self.openDatabse(dicdata: datadic, key: key)
//        self.arrMsgShowLastSeen.add(datadic.value(forKey: "LastSeen") as Any)
//        self.arrMsgShowProfilePhoto.add(datadic.value(forKey: "ProfilePhoto") as Any)
//        self.arrMsgShowSeeAbout.add(datadic.value(forKey: "SeeAbout") as Any)
        
        if tempdata.contains("LastSeen"){
            self.arrMsgShowLastSeen.insert(datadic.value(forKey: "LastSeen") as Any, at: 0)
        }
        else{
            self.arrMsgShowLastSeen.insert("", at: 0)
        }
        if tempdata.contains("ProfilePhoto"){
            self.arrMsgShowProfilePhoto.insert(datadic.value(forKey: "ProfilePhoto") as Any, at: 0)
        }
        else{
            self.arrMsgShowProfilePhoto.insert("", at: 0)
        }
        if tempdata.contains("SeeAbout"){
            self.arrMsgShowSeeAbout.insert(datadic.value(forKey: "SeeAbout") as Any, at: 0)
        }
        else{
            self.arrMsgShowSeeAbout.insert("", at: 0)
        }
    }
    func sortArrays()
    {
        //MARK:- this is for checking thr Null in Chat
        var arrDeleteCount = [Int]()
        for (index, object) in self.arrMsgTime.enumerated() {
            if object is NSNull {
                print("Hey, it's null!")
                funDeleteFromChat(groupid: arrMsgGroupId[index] as! String)
                arrDeleteCount.append(index)
            }else if object is String {
                print("Hey, it's Empty!")
                funDeleteFromChat(groupid: arrMsgGroupId[index] as! String)
                arrDeleteCount.append(index)
            }
            else {
                print("It's not null, it's \(object)")
            }
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
            
            if error != nil {
                print("Not Delete")
                //obj.showToast(message: "Not Delete", viewcontroller: self)
            }
            else {
                print("Value Delete")
                //obj.showToast(message: "Value Delete", viewcontroller: self)
            }
        })
    }
    //MARK:- Retreive Messages from db and add observer When This screen run first time
    
    @objc func retreiveMessages(){
        //MARK:- If Child Added Means if new user messaged you then this will call!
         ChatDB.child(USERUID)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                self.retreiveNewUserMessages()
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
                                            self.funInsertMessageInArrays(datadic:
                                                tempdatadic.value as! NSDictionary,
                                                key: tempdatadic.key as! String)
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
                        image1Attachment.bounds = CGRect(x: 0, y: -8, width: 25, height: 25)
                        // wrap the attachment in its own attributed string so we can append it
                        let image1String = NSAttributedString(attachment: image1Attachment)

                        // add the NSTextAttachment wrapper to our full string, then add some more text.
                        fullString.append(image1String)
                        fullString.append(NSAttributedString(string: EMPTY_CHAT_INBOX_END))
                        // draw the result in a label
                        self.lblsearching.attributedText = fullString
                        self.lblsearching.center.x = self.view.center.x
                        
                        self.andicator.stopAnimating()
                        DispatchQueue.main.async {
                            self.funTypingNewMessageUserValueChange()
                        }
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
        if self.arrMsgGroupId.count > self.arrUserPhoneNumber.count || self.isViewLoaded == true
        {
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
                              let tempdic = NSMutableDictionary()
                              if let temp = (subsnapshot.value as! NSDictionary).value(forKey: "\(objUserDBM.phoneNumber)") as? String {
                                  if indexofuid > self.arrUserPhoneNumber.count - 1
                                  {
                                      self.arrUserPhoneNumber.add("")
                                  }
                                  self.arrUserPhoneNumber[indexofuid] = temp
                                  tempdic.setValue(temp, forKey: "\(objChatDBM.userName)")
                              }
                              else {
                                  self.arrUserPhoneNumber[indexofuid] = ""
                                  tempdic.setValue("", forKey: "\(objChatDBM.userName)")
                              }
                              if let temp = (subsnapshot.value as! NSDictionary).value(forKey: "\(objUserDBM.profilePhoto)") as? String {
                                  if indexofuid > self.arrMsgProfilePic.count - 1
                                        {
                                            self.arrMsgProfilePic.add("")
                                        }
                                        self.arrMsgProfilePic[indexofuid] = temp
                                        tempdic.setValue(temp, forKey: "\(objUserDBM.profilePhoto)")
                                    }
                                    else {
                                        self.arrMsgProfilePic[indexofuid] = ""
                                        tempdic.setValue("", forKey: "\(objUserDBM.profilePhoto)")
                                    }
                                    
                                    if let temp = (subsnapshot.value as! NSDictionary).value(forKey: "\(objUserDBM.userName)") as? String {
                                        if indexofuid > self.arrMsgUserName.count - 1
                                        {
                                            self.arrMsgUserName.add("")
                                        }
                                        self.arrMsgUserName[indexofuid] = temp
                                        tempdic.setValue(temp, forKey: "\(objUserDBM.userName)")
                                    }
                                    else {
                                        self.arrMsgUserName[indexofuid] = ""
                                        tempdic.setValue("", forKey: "\(objUserDBM.userName)")
                                    }
                                    
                                    let tempUser_id = (subsnapshot.value as! NSDictionary).value(forKey: "\(objUserDBM.userId)") as! String
                                    self.arrUserUserId.add(tempUser_id)
                                    tempdic.setValue(tempUser_id, forKey: "\(objUserDBM.userId)")
                                    
                                    let tempLastSeen = (subsnapshot.value as! NSDictionary).value(forKey: "LastSeen") as Any
                                    self.arrMsgShowLastSeen.add(tempLastSeen)
                                    tempdic.setValue(tempLastSeen, forKey: "lastSeen")
                                    
                                    let tempProfilePhoto = (subsnapshot.value as! NSDictionary).value(forKey: "\(objUserDBM.profilePhoto)") as Any
                                    self.arrMsgShowProfilePhoto.add(tempProfilePhoto)
                                    tempdic.setValue(tempProfilePhoto, forKey: "profilePhoto")
                                    
                                    let tempSeeAbout = (subsnapshot.value as! NSDictionary).value(forKey: "SeeAbout") as Any
                                    self.arrMsgShowSeeAbout.add(tempSeeAbout)
                                    tempdic.setValue(tempSeeAbout, forKey: "seeAbout")
                                    self.funRegisterUserObserver(uidd: subsnapshot.key)
                                }
                                else {
                                    let tempgroupid =  self.arrMsgGroupId[index] as! String
                                    
                                    self.funDeleteValue(grouptype: "private", key: uidd as! String, groupid: tempgroupid)
                                  
                                    self.funDeleteValue(grouptype: "private", key: USERUID, groupid: tempgroupid)
                                }
                                if self.arrMsgOtherUid.count - 1 == index {
                                    self.funDeliveryStatusUpdate()
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
                                    let tempdic = NSMutableDictionary()
                                    
                                    self.arrUserPhoneNumber.add("")
                                    self.arrUserUserId.add("")
                                    self.arrMsgShowLastSeen.add("")
                                    self.arrMsgShowProfilePhoto.add("")
                                    self.arrMsgShowSeeAbout.add("")
                                    
                                    tempdic.setValue("", forKey: "\(objUserDBM.userName)")
                                    tempdic.setValue("", forKey: "\(objUserDBM.userId)")
                                    tempdic.setValue("", forKey: "\(objUserDBM.lastSeen)")
                                    tempdic.setValue("", forKey: "\(objUserDBM.profilePhotoPrivacy)")
                                    tempdic.setValue("", forKey: "\(objUserDBM.seeAbout)")
                                    
                                    let temparr = (subsnapshot.value as! NSDictionary).allKeys as NSArray
                                    if (temparr.contains("\(objGroupsDBM.groupImage)")) {
                                        if let temp = (subsnapshot.value as! NSDictionary).value(forKey: "\(objGroupsDBM.groupImage)") as? String {
                                            if indexofuid > self.arrMsgProfilePic.count - 1
                                            {
                                                self.arrMsgProfilePic.add("")
                                            }
                                            self.arrMsgProfilePic[indexofuid] = temp
                                            tempdic.setValue(temp, forKey: "\(objGroupsDBM.groupImage)")
                                        }
                                        else {
                                            self.arrMsgProfilePic[indexofuid] = ""
                                            tempdic.setValue("", forKey: "\(objGroupsDBM.groupImage)")
                                        }
                                    }
                                    else {
                                        self.arrMsgProfilePic[indexofuid] = ""
                                    }
                                    if let temp = (subsnapshot.value as! NSDictionary).value(forKey: "\(objGroupsDBM.groupName)") as? String {
                                        if indexofuid > self.arrMsgUserName.count - 1
                                        {
                                            self.arrMsgUserName.add("")
                                        }
                                        self.arrMsgUserName[indexofuid] = temp
                                        tempdic.setValue(temp, forKey: "\(objGroupsDBM.groupName)")
                                    }
                                    else {
                                        self.arrMsgUserName[indexofuid] = ""
                                        tempdic.setValue("", forKey: "\(objGroupsDBM.groupImage)")
                                    }
                                }
                                else {
                                    self.funDeleteValue(grouptype: "public", key: tempgroupid, groupid: tempgroupid)
                                }
                                if self.arrMsgOtherUid.count - 1 == index {
                                    self.funDeliveryStatusUpdate()
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
    
    func funDeliveryStatusUpdate(){
        //MARK:- Message Delivery Status Update When App Run This Screen  First Time
        DispatchQueue.main.async {
            self.funMessageStatusUpdateWhenAppRun()
            DispatchQueue.main.async {
                self.funTypingNewMessageUserValueChange()
            }
        }//End of loop
    }
    //MARK:- Other User Typing Status and New Message Receive
    func funTypingNewMessageUserValueChange() {
        ChatDB.child(USERUID).observe(.childChanged) { (snapshot) in
            //print(snapshot)
            let groupid = (snapshot.key)
            //MARK:- Update value in Chat DB when other user send us a message
            if self.arrMsgGroupId.contains(groupid) == true
            {
                let indexofchild = self.arrMsgGroupId.index(of: groupid)
                let indexPath = IndexPath(row: indexofchild, section: 0)
                if self.arrMsgLastMsgId[indexofchild] as! String != (snapshot.value as! NSDictionary).value(forKey: "lastMessageId") as! String {
                    //MARK:- Receive New Message
                    //MARK:- Check
                    let tempdatadic = snapshot.value as! NSDictionary
                    //MARK:- If Typing Recording or Delivery Status Changes This will Call
                    self.arrMsgFomUid[indexofchild] = tempdatadic.value(forKey: "lastMessageUserId") as! String
                    
                    if tempdatadic.value(forKey: "groupType") as? String == "Public Group" {
                        //MARK:- Public Group
                        self.arrMsgOtherUid[indexofchild] = ""
                    }
                    else {
                        //MARK:- Private Chat
                        self.arrMsgOtherUid[indexofchild] = tempdatadic.value(forKey: "otherUserId") as! String
                    }
                    self.arrMsgLast[indexofchild] = tempdatadic.value(forKey: "lastMessage") as! String
                    self.arrMsgStatus[indexofchild] = tempdatadic.value(forKey: "lastMessageStatus") as Any
                    self.arrMsgType[indexofchild] = tempdatadic.value(forKey: "lastMessageType") as Any
                    self.arrMsgTime[indexofchild] = tempdatadic.value(forKey: "lastMessageTime") as Any
                    self.arrMsgSeen[indexofchild] = tempdatadic.value(forKey: "seen") as Any
                    self.arrMsgNumber[indexofchild] = tempdatadic.value(forKey: "userPhoneNumber") as Any
                    self.arrMsgTyping[indexofchild] = tempdatadic.value(forKey: "typing") as Any
                    self.arrMsgGroupType[indexofchild] = tempdatadic.value(forKey: "groupType") as! String
                    self.arrMsgLastMsgId[indexofchild] = tempdatadic.value(forKey: "lastMessageId") as! String
                    self.arrMsgUnSeenCount[indexofchild] = tempdatadic.value(forKey: "unSeenCount") as Any
                    
                    self.arrMsgShowLastSeen[indexofchild] = tempdatadic.value(forKey: "LastSeen") as Any
                    self.arrMsgShowProfilePhoto[indexofchild] = tempdatadic.value(forKey: "ProfilePhoto") as Any
                    self.arrMsgShowSeeAbout[indexofchild] = tempdatadic.value(forKey: "SeeAbout") as Any
                    
                    //MARK:- Insert new row in table view
                    self.tablev.reloadRows(at: [indexPath], with: .none)
                    //MARK:- Message Delivery Status Update When App Receive New Message
                    if (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String == PRIVATECHAT
                    {
                        self.funMessageStatusUpdateRunTime(indexofchild: indexofchild)
                    }
                    
                    //MARK:- Need to delete row and show in top
                    let profilepic = self.arrMsgProfilePic[indexofchild]
                    let username = self.arrMsgUserName[indexofchild]
                    let usernumber = self.arrUserPhoneNumber[indexofchild]
                    let useriddd = self.arrUserUserId[indexofchild]
                    
                    self.funRemoveindex(index: indexofchild)
                    
                    self.funInsertMessageOnTop(datadic: snapshot.value as! NSDictionary, key: snapshot.key)
                    let lastmsg = (snapshot.value as! NSDictionary).value(forKey: "lastMessage") as! String
                    let grouptype = (snapshot.value as! NSDictionary).value(forKey: "groupType") as! String
                    if lastmsg == "Group icon has been update" || lastmsg == "Group name has been update" || lastmsg == "Group have been update" || lastmsg == "You have been update this group" && grouptype == "Public Group"
                    {
                        
                        GroupsDB.child(snapshot.key)
                            .observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.childrenCount > 0
                            {
                                self.arrMsgProfilePic.insert((snapshot.value as! NSDictionary).value(forKey: "groupImage") as! String, at: 0)
                                self.arrMsgUserName.insert((snapshot.value as! NSDictionary).value(forKey: "groupName") as! String, at: 0)
                                
                                self.arrUserPhoneNumber.insert("", at: 0)
                                self.arrUserUserId.insert("", at: 0)
                                self.arrMsgShowLastSeen.insert("", at: 0)
                                self.arrMsgShowProfilePhoto.insert("", at: 0)
                                self.arrMsgShowSeeAbout.insert("", at: 0)
                                
                                // Move the corresponding row in the table view to reflect this change
                                self.tablev.moveRow(at: indexPath, to: NSIndexPath(row: 0, section: 0) as IndexPath)
                                self.tablev.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                                DispatchQueue.main.async {
                                    
                                }
                            }
                        })
                    }
                    else
                    {
                        self.arrMsgProfilePic.insert(profilepic, at: 0)
                        self.arrMsgUserName.insert(username, at: 0)
                        self.arrUserPhoneNumber.insert(usernumber, at: 0)
                        self.arrUserUserId.insert(useriddd, at: 0)
                        
                        // Move the corresponding row in the table view to reflect this change
                        self.tablev.moveRow(at: indexPath, to: NSIndexPath(row: 0, section: 0) as IndexPath)
                    }
                }
                else
                {
                    //MARK:- Check
                    let tempdatadic = snapshot.value as! NSDictionary
                    //MARK:- If Typing Recording or Delivery Status Changes This will Call
                    self.arrMsgFomUid[indexofchild] = tempdatadic.value(forKey: "lastMessageUserId") as! String
                    if tempdatadic.value(forKey: "groupType") as? String == "Public Group"{
                        //MARK:- Public Group
                        self.arrMsgOtherUid[indexofchild] = ""
                    }
                    else{
                        //MARK:- Private Chat
                        self.arrMsgOtherUid[indexofchild] = tempdatadic.value(forKey: "otherUserId") as! String
                    }
                    self.arrMsgLast[indexofchild] = tempdatadic.value(forKey: "lastMessage") as! String
                    self.arrMsgStatus[indexofchild] = tempdatadic.value(forKey: "lastMessageStatus") as Any
                    self.arrMsgType[indexofchild] = tempdatadic.value(forKey: "lastMessageType") as Any
                    self.arrMsgTime[indexofchild] = tempdatadic.value(forKey: "lastMessageTime") as Any
                    self.arrMsgSeen[indexofchild] = tempdatadic.value(forKey: "seen") as Any
                    self.arrMsgNumber[indexofchild] = tempdatadic.value(forKey: "userPhoneNumber") as Any
                    self.arrMsgTyping[indexofchild] = tempdatadic.value(forKey: "typing") as Any
                    self.arrMsgGroupType[indexofchild] = tempdatadic.value(forKey: "groupType") as! String
                    self.arrMsgLastMsgId[indexofchild] = tempdatadic.value(forKey: "lastMessageId") as! String
                    self.arrMsgUnSeenCount[indexofchild] = tempdatadic.value(forKey: "unSeenCount") as Any
                    self.arrMsgShowLastSeen[indexofchild] = tempdatadic.value(forKey: "LastSeen") as Any
                    self.arrMsgShowProfilePhoto[indexofchild] = tempdatadic.value(forKey: "ProfilePhoto") as Any
                    self.arrMsgShowSeeAbout[indexofchild] = tempdatadic.value(forKey: "SeeAbout") as Any
                    //MARK:-
                    DispatchQueue.main.async {
                        
                    }
                    self.tablev.reloadRows(at: [indexPath], with: .none)
                    // self.tablev.reloadData()
                }
            }
        }
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
    //MARK:- Message Delivery Status Update When App Receive New Message
    func funMessageStatusUpdateRunTime(indexofchild: Int)
    {
        //MARK:- Last Message Delivery Status Update against send messages from other user
        if self.arrMsgOtherUid.count > 0
        {
            let groupid = self.arrMsgGroupId[indexofchild] as! String
            let otheruid = self.arrMsgOtherUid[indexofchild] as! String
            let lastmsgid = self.arrMsgLastMsgId[indexofchild] as! String
            
            var tempMsgStatus = Int()
            //MARK:- Check
            if defaults.value(forKey: "is_chatscreen") as? String == "1" && self.ifScreenOpenOtherUserId == otheruid
            {
                
                ChatDB.child(USERUID).child(groupid)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                        if snapShot.count > 0{
                            ChatDB.child(USERUID).child(groupid)
                                .updateChildValues(["unSeenCount":0])
                        }
                    }
                })
            }
            else
            {
                tempMsgStatus = DELIVERED
            }
            tempMsgStatus = DELIVERED
            if otheruid != ""
            {
                ChatDB.child(otheruid).child(groupid)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                        if snapShot.count > 0{
                            
                            if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "lastMessageStatus") as? Int
                            {
                                if lastmessagestatus != SEEN && lastmessagestatus != DELIVERED
                                {
                                    let tempdic = snapshot.value as! NSMutableDictionary
                                    //print(tempdic)
                                    //print(tempdic)
                                    tempdic.setValue(tempMsgStatus, forKey: "lastMessageStatus")
                                    let tempkeyarray = tempdic.allKeys as NSArray
                                    if tempkeyarray.contains("source")
                                    {
                                        tempdic.setValue("IOS", forKey: "Source")
                                    }
                                    else
                                    {
                                        tempdic.setValue("IOS", forKey: "Source")
                                    }
                                    ChatDB.child(otheruid).child(groupid).updateChildValues(tempdic as! [AnyHashable : Any])
                                }
                            }
                        }
                    }
                })
                MessagesDB.child(groupid)
                    .child(otheruid).child(lastmsgid)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                        if snapShot.count > 0
                        {
                            if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "messageStatus") as? Int
                            {
                                if lastmessagestatus != tempMsgStatus
                                {
                                    //MARK:- Check
                                    if defaults.value(forKey: "is_chatscreen") as? String == "1" && self.ifScreenOpenOtherUserId == otheruid
                                    {
                                        
                                    }
                                    else
                                    {
                                        let tempdic = snapshot.value as! NSMutableDictionary
                                        //print(tempdic)
                                        tempdic.setValue(tempMsgStatus, forKey: "messageStatus")
                                        //print(tempdic)
                                        let tempkeyarray = tempdic.allKeys as NSArray
                                        if tempkeyarray.contains("source")
                                        {
                                            tempdic.setValue("IOS", forKey: "Source")
                                        }
                                        else
                                        {
                                            tempdic.setValue("IOS", forKey: "Source")
                                        }
                                        MessagesDB.child(groupid)
                                            .child(otheruid)
                                            .child(lastmsgid)
                                            .updateChildValues(tempdic as! [AnyHashable : Any])
                                    }
                                }
                            }
                            else if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "messageStatus") as? String
                            {
                                if lastmessagestatus != "\(tempMsgStatus)"
                                {
                                    //MARK:- Check
                                    if defaults.value(forKey: "is_chatscreen") as? String == "1" && self.ifScreenOpenOtherUserId == otheruid
                                    {
                                        
                                    }
                                    else
                                    {
                                        MessagesDB.child(groupid)
                                            .child(otheruid)
                                            .child(lastmsgid)
                                            .observeSingleEvent(of: .value, with: { (snapshot) in
                                            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                                                if snapShot.count > 0
                                                {
                                                    let tempdic = snapshot.value as! NSMutableDictionary
                                                    //print(tempdic)
                                                    tempdic.setValue(DELIVERED, forKey: "messageStatus")
                                                    let tempkeyarray = tempdic.allKeys as NSArray
                                                    if tempkeyarray.contains("source")
                                                    {
                                                        tempdic.setValue("IOS", forKey: "Source")
                                                    }
                                                    else
                                                    {
                                                        tempdic.setValue("IOS", forKey: "Source")
                                                    }
                                                    //print(tempdic)
                                                    
                                                    MessagesDB.child(groupid).child(otheruid).child(lastmsgid).updateChildValues(tempdic as! [AnyHashable : Any])
                                                }
                                                
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    //MARK:- Message Delivery Status Update When App This Screen Run First Time
    func funMessageStatusUpdateWhenAppRun()
    {
        //MARK:- Last Message Delivery Status Update against send messages from other user
        if arrMsgOtherUid.count > 0
        {
            for (index, otheruid) in self.arrMsgOtherUid.enumerated() {
                let grouptype = self.arrMsgGroupType[index] as! String
                if grouptype == PRIVATECHAT {
                    let groupid = self.arrMsgGroupId[index] as! String
                    let lastmsgid = self.arrMsgLastMsgId[index] as! String
                    let lastmsgstatus = self.arrMsgStatus[index] as! Int
                    print("GROUP ID: \(groupid)")
                    print("USER ID: \(otheruid)")
                    print("Index No: \(index)")
                    print("Last Message ID: \(lastmsgid)")
                    print("Last Message Status: \(lastmsgstatus)")
                    if lastmsgid == ""{
                        return
                    }
                    ChatDB.child(otheruid as! String).child(groupid).observeSingleEvent(of: .value, with: {(snapshot) in
                    
                        if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                            if snapShot.count > 0{
                                if lastmsgstatus != SEEN && lastmsgstatus != DELIVERED && lastmsgstatus != MESSAGE_DELETED
                                {
                                    let tempdic = snapshot.value as! NSMutableDictionary
                                    //print(tempdic)
                                    tempdic.setValue(DELIVERED, forKey: "lastMessageStatus")
                                    let tempkeyarray = tempdic.allKeys as NSArray
                                    if tempkeyarray.contains("source")
                                    {
                                        tempdic.setValue("IOS", forKey: "Source")
                                    }
                                    else
                                    {
                                        tempdic.setValue("IOS", forKey: "Source")
                                    }
                                    //print(tempdic)
                                    ChatDB.child(otheruid as! String).child(groupid).updateChildValues(tempdic as! [AnyHashable : Any])
                                }
                            }
                        }
                    })//End of  ChatDB.child(otheruid).child(groupid).observe
                    MessagesDB.child(groupid)
                    .child(otheruid as! String)
                    .child(lastmsgid)
                        .observeSingleEvent(of: .value, with:{ (snapshot) in
                        if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                            if snapShot.count > 0{
                                let tempdic = snapshot.value as! NSMutableDictionary
                                //print(tempdic)
                                tempdic.setValue(DELIVERED, forKey: "messageStatus")
                                let tempkeyarray = tempdic.allKeys as NSArray
                                if tempkeyarray.contains("source")
                                {
                                    tempdic.setValue("IOS", forKey: "Source")
                                }
                                else
                                {
                                    tempdic.setValue("IOS", forKey: "Source")
                                }
                                //print(tempdic)
                                if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "messageStatus") as? Int
                                {
                                    
                                    if lastmessagestatus != SEEN && lastmessagestatus != DELIVERED && lastmsgstatus != MESSAGE_DELETED
                                    {
                                        print (tempdic)
                                        MessagesDB.child(groupid).child(otheruid as! String).child(lastmsgid).updateChildValues(
                                            tempdic as! [AnyHashable : Any])
                                    }
                                }
                                else if let lastmessagestatus = (snapshot.value as! NSDictionary).value(forKey: "messageStatus") as? String
                                {
                                    if lastmessagestatus != "\(SEEN)" && lastmessagestatus != "\(DELIVERED)"
                                    {
                                        MessagesDB.child(groupid).child(otheruid as! String).child(lastmsgid).updateChildValues(tempdic as! [AnyHashable : Any])
                                    }
                                }
                                
                            }
                        }
                    })
                }
            }//End of Loop
        }//End of If
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
                
                var type = Int()
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
                
                if let temp = (subsnapshot.value as! NSDictionary).value(forKey: "UserLink") as? String
                {
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
                    if let temp = tempdic.value(forKey: "UserPhoneNumber") as? String
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
                    
                    if let temp = tempdic.value(forKey: "UserName") as? String
                    {
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
                    
                    let tempUser_id = tempdic.value(forKey: "user_id") as! String
                    self.arrUserUserId.add(tempUser_id)
                    if let temp = (subsnapshot.value as! NSDictionary).value(forKey: "LastSeen") as? String
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
                    if let temp = tempdic.value(forKey: "ProfilePhoto") as? String
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
                    if let temp = tempdic.value(forKey: "SeeAbout") as? String
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
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: txtsearch, imgname: "cross", x: 20, width: 15, height: 15)
        btncancelSearch.addTarget(self, action: #selector(btncancelSearch(sender:)), for: .touchUpInside)
        
        obj.setTextFieldShade(textfield: txtsearch)
        
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
            for (index, temp) in arrShowNamesInCell.enumerated()
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchhide"), object: nil)
        searchhide()
    }
    
    @objc func searchhide()
    {
        if UIApplication.shared.isKeyboardPresented {
            if txtsearch == nil{
                return
            }
            txtsearch.resignFirstResponder()
        }
        isFiltered = false
        tablev.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if UIApplication.shared.isKeyboardPresented {
            txtsearch.resignFirstResponder()
        }
        return true
    }
    
    //MARK:- Dashboard PC Functions
    func funInitializationOfDashboardPC(){
        NotificationCenter.default.addObserver(self, selector: #selector(funChatScreen), name: NSNotification.Name(rawValue: "taponuser"), object: nil)
    }
    @objc func funChatScreen(notification: Notification)
    {
        let datadic = notification.object as! NSDictionary
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "Messagingg") as! Messagingg
            vc.fromuid = datadic.value(forKey: "fromuid") as! String
            vc.touid = datadic.value(forKey: "touid") as! String
            vc.username = datadic.value(forKey: "username") as! String
            vc.userprofilepic = datadic.value(forKey: "userprofilepic") as! String
            vc.groupId = datadic.value(forKey: "groupid") as! String
            vc.groupType = datadic.value(forKey: "grouptype") as! String
            vc.imagename = datadic.value(forKey: "imagename") as! String
            vc.otherUserPhone_Number = datadic.value(forKey: "otherUserPhone_Number") as! String
            if let temp = datadic.value(forKey: "unSeenCount") as? String{
                vc.unSeenCount = temp
            }
            else if (datadic.value(forKey: "unSeenCount") as? Int) != nil{
                vc.unSeenCount = "1"
            }
              
            if let temp = datadic.value(forKey: "useridserver") as? String
            {
                vc.useridserver = temp
            }
            else if let temp = datadic.value(forKey: "useridserver") as? Int
            {
                vc.useridserver = "\(temp)"
            }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - IndicatorInfoProvider for page controller like android
extension Chats: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Chats")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Chats")
        return itemInfo
    }
}
extension NSMutableArray {
    func remove(at indexes: [Int]) {
        var lastIndex: Int? = nil
        for index in indexes.sorted(by: >) {
            guard lastIndex != index else {
                continue
            }
            remove(at: [index])
            lastIndex = index
        }
    }
}

