//
//  Functions.swift
//  ZedChat
//
//  Created by MacBook Pro on 31/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import Alamofire
class Functions: NSObject {

    
}

func funLockScreenCheck(viewController: UIViewController){
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let currentdate = formatter.string(from: date)
    
    if let isLock = defaults.value(forKey: "isLock") as? String{
        
        if isLock == "0"{
            
            //MARK:- if Password not set yet
            if let fromdate = defaults.value(forKey: "LockPassDate") as? String
            {
                let result = obj.isPassedMoreThan(days: 3, fromDate: formatter.date(from: fromdate )!, toDate: formatter.date(from: currentdate)!)
                if result == false
                {
                    //MARK:- Check if three days pass this will call
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    let result = formatter.string(from: date)
                    defaults.setValue(result, forKey: "LockPassDate")
                    if let temp = defaults.value(forKey: "DontShowAppLock") as? String{
                        if temp == "1"{
                            return
                        }
                    }
                    funOpenSetPassword(viewController: viewController)
                }
            }
        }
        else if isLock == "1"{
            //MARK:- if Password Set this screen will open for Security code
            funLockScreen(viewController: viewController, isCancelButton: false, type: "lock")
        }
    }else{
        //MARK- If App install and run first time
        defaults.setValue("0", forKey: "isLock")
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        defaults.setValue(result, forKey: "LockPassDate")
        funOpenSetPassword(viewController: viewController)
    }
}

func funOpenSetPassword(viewController: UIViewController){
    let vc = UIStoryboard.init(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "SetPasswrod") as! SetPasswrod
    viewController.present(vc, animated: true, completion: nil)
}

func funEnterNewPasswordScreen(viewController: UIViewController){
    let vc = UIStoryboard.init(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "PasswordScreen") as! PasswordScreen
    vc.passwordtype = "new"
    vc.isConfirmPassword = true
    vc.isCancelButton = true
    viewController.present(vc, animated: true, completion: nil)
}

func funChangeRemoveScreen(viewController: UIViewController){
    let vc = UIStoryboard.init(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "PasswordChangeDelete") as! PasswordChangeDelete
    viewController.navigationController?.pushViewController(vc, animated: true)
}


func funLockScreen(viewController: UIViewController, isCancelButton: Bool, type: String){
    let vc = UIStoryboard.init(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "PasswordScreen") as! PasswordScreen
    vc.passwordtype = type
    vc.isCancelButton = isCancelButton
    if type == "change"{
      //  viewController.navigationController?.pushViewController(vc, animated: true)
    }else{
        
    }
    DispatchQueue.main.async {
        viewController.present(vc, animated: true, completion: nil)
    }
}

func findIndex(value searchValue: String, in array: [String], completion: @escaping (_ userindex: Int?) -> Void) {
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
            for tempnumber in filteredStrings
            {
                if arrGuserphone.contains(tempnumber){
                    let userindex = arrGuserphone.index(of: tempnumber)
                    completion(userindex)
                }
            }
        }
    }
    else
    {
        completion(nil)
    }
}

func setCellImage(imgv: UIImageView, index: Int){
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
    findIndex(value: searchToSearch, in: itemsArray) { userindex in
        guard let userindex = userindex else {
            imgv.image = UIImage(named: "user")
            return
        }
        
        if let temp = arrGuserpic[userindex] as? String
        {
            if temp == ""
            {
                imgv.image = UIImage(named: "user")
            }
            else {
                //Kingfisher Image upload
                let url = URL(string: USER_IMAGE_PATH + temp)
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
        }
    }
}
//MARK:- Profile Update
func funprofileupdate(type: String, text: String, andicator: UIActivityIndicatorView, viewController: UIViewController)
{
    viewController.view.endEditing(true)
    var column = ""
    if type == "name"
    {
        column = "UserName"
    }
    else if type == "status"
    {
        column = "UserStatus"
    }
    andicator.startAnimating()
    UserDB.child(USERUID).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.childrenCount > 0
        {
            let tempdic = snapshot.value as! NSMutableDictionary
            //print(tempdic)
            tempdic.setValue(text, forKey: column)
            UserDB.child(USERUID).updateChildValues(tempdic as! [AnyHashable : Any], withCompletionBlock: {error, ref in
                andicator.stopAnimating()
                objG.removeVerificationPopup()
                if error == nil
                {
                    print("update successfully")
                    
                    if type == "name"
                    {
                        defaults.setValue(text, forKey: "username")
                    }
                    else if type == "status"
                    {
                        defaults.setValue(text, forKey: "userstatus")
                    }
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileupdate"), object: ["value": text, "type": type])
                    }
                }
                else
                {
                    obj.showToast(message: "Error occured in image upload", viewcontroller: viewController)
                }
            })
        }
        else if snapshot.childrenCount == 0
        {
            obj.showToast(message: "Error occured in image upload", viewcontroller: viewController)
        }
    })
}

func  funSendMessage(msgType: Int, msgtext: String, groupid: String, receiverid: String,msgautoid: String, groupName: String, completion: @escaping (_ response: String?) -> Void) {
    
    let timespam = Date().currentTimeMillis()!
    MessagesDB.child(groupid).child(receiverid).child(msgautoid).setValue([
        "from":USERUID,
        "message":msgtext,
        "messageStatus":NOT_DELIVERED,
        "messageType":msgType,
        "phoneNumber":defaults.value(forKey: "phoneno") as! String,
        "timestamp": timespam] as [String : Any], withCompletionBlock: {
            error, ref in
            if error != nil
            {
                // self.isdeliver(messageStatus: SENT)
                //MARK:- Uncomment the upper line for testing the unSeenCount
                completion(error?.localizedDescription)
            }
            else
            {
                if receiverid != USERUID {
                    
                    UserDB.child(receiverid).observeSingleEvent(of: .value, with: { (snapshot) in
                        //UserDB.child(tempiddd as! String).observe(.value, with: { (snapshot) in
                        print(snapshot)
                        if snapshot.childrenCount > 0
                        {
                            let datadic = (snapshot.value as! NSDictionary)
                            var isAndroidUserTemp = Bool()
                            var tempsource = ""
                            let tempallkeys = datadic.allKeys as NSArray
                            let tempreceiverToken = datadic.value(forKey: "fcmId") as! String
                            if tempallkeys.contains("source"){
                                tempsource = datadic.value(forKey: "source") as! String
                            }
                            else if tempallkeys.contains("Source"){
                                tempsource = datadic.value(forKey: "Source") as! String
                            }
                            if tempsource == "ios"{
                                isAndroidUserTemp = false
                            }
                            else{
                                isAndroidUserTemp = true
                            }
                            let parameters :Parameters = [
                                "title":"1 new message",
                                "body":msgtext,
                                "sound":"default",
                                //"groupId":groupid,
                                "groupType":"Public Group",
                                "messageId":msgautoid,
                                "action":"newMessage",
                                "messageType":msgType,
                                "firebaseId":USERUID,
                                //"to":receiverid,
                                "groupFireBaseId":groupid,
                                "froma":defaults.value(forKey: "phoneno") as! String,
                                "profilePic":defaults.value(forKey: "userimage") as? String ?? "",
                                "message":msgtext,
                                "mutable_content": true,
                                "isAndroidUser":isAndroidUserTemp]
                            
                            obj.SendPushNotification(toToken: tempreceiverToken,
                                                        title: "1 new \(msgType) message",
                                                        body: msgtext, data: parameters)
                        }
                    })
                }
                funUpdateChatGroupStatus(msgType: msgType, groupid: groupid, messagetext: msgtext, receiverid: receiverid, msgautoid: msgautoid, completion: {response in
                    
                    if response == "success"
                    {
                        completion("success")
                    }
                    else
                    {
                        completion("error")
                    }
                })
            }
    })
}
//MARK:- Group Chat Update
//func funUpdateChatGroupStatus(msgType: Int, groupid: String, messagetext: String,  receiverid: String, msgautoid: String, completion: @escaping (_ response: String?) -> Void) {
//
//    let timespam = Date().currentTimeMillis()!
//    let dicChatGroup = [
//        "createdAt" : timespam,
//        "groupType" : "Public Group",
//        "lastMessage" : messagetext,
//        "lastMessageId" : msgautoid,
//        "lastMessageStatus" : NOT_DELIVERED,
//        "lastMessageTime" : timespam,
//        "lastMessageType" : msgType,
//        "lastMessageUserId" : USERUID,
//        "messageStatus" : "",
//        "otherUserId" : receiverid,
//        "seen" : false,
//        "typing" : STOP_TYPING_RECORDING,
//        "userPhoneNumber" : defaults.value(forKey: "phoneno") as! String,
//        "unSeenCount": "1"] as [String : Any]
//
//    ChatDB.child(receiverid).child(groupid).updateChildValues(dicChatGroup, withCompletionBlock: {
//        error, snapshot in
//        if error != nil
//        {
//            print("Error occurd chat not update userid: \(receiverid)")
//            completion(error?.localizedDescription)
//        }
//        else
//        {
//            print("Chat updated userid: \(receiverid)")
//            completion("success")
//
//        }
//    })
//}

//MARK:- Group Chat Update
func funUpdateChatGroupStatus(msgType: Int, groupid: String, messagetext: String, receiverid: String, msgautoid: String, completion: @escaping (_ response: String?) -> Void) {
    
    funGetMessageCount(groupid: groupid, receiverid: receiverid, completion: {
        unSeenCount in
        let timespam = Date().currentTimeMillis()!
        let dicChatGroup = [
            "createdAt" : timespam,
            "groupType" : "Public Group",
            "lastMessage" : messagetext,
            "lastMessageId" : msgautoid,
            "lastMessageStatus" : NOT_DELIVERED,
            "lastMessageTime" : timespam,
            "lastMessageType" : msgType,
            "lastMessageUserId" : USERUID,
            "messageStatus" : "",
            //"otherUserId" : receiverid,
            "seen" : false,
            "typing" : STOP_TYPING_RECORDING,
            "userPhoneNumber" : defaults.value(forKey: "phoneno") as! String,
            "unSeenCount": unSeenCount as Any] as [String : Any]
        ChatDB.child(receiverid).child(groupid).updateChildValues(dicChatGroup, withCompletionBlock: {
            error, snapshot in
            if error != nil
            {
                print("Error occurd chat not update userid: \(receiverid)")
                completion(error?.localizedDescription)
            }
            else
            {
                print("Chat updated userid: \(receiverid)")
                completion("success")
                
            }
        })
    })
    
}

func funGetMessageCount(groupid: String, receiverid: String, completion: @escaping (_ unSeenCount: Int?) -> Void) {
    
    var unSeenCount = 0
    if groupid == ""
    {
        completion(1)
        return
    }
    else if receiverid == USERUID {
        completion(0)
        return
    }
    ChatDB.child(receiverid).child(groupid).observeSingleEvent(of: .value, with: { (snapshot) in
        
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
