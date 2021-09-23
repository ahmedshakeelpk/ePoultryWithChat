//
//  PublicFunctions.swift
//  SE
//
//  Created by Apple on 13/12/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts



//MARK:- Unlimited text to label
   public func labelunlimitedtext(label :UILabel){
       label.lineBreakMode = .byWordWrapping
       label.numberOfLines = 9
   }

    public func putRightButtoninTextField(btn: UIButton ,txtfield: UITextField, imgname: String, x: Int, width:Int, height:Int){
        let y = CGFloat(txtfield.frame.size.height / 2) - CGFloat(height / 2)
        //MARK: - Add image in text field Right SIDE
        let rightimgv = UIView()
        rightimgv.frame = CGRect(x:0, y:0, width:50, height:txtfield.frame.size.height)
        txtfield.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: x, y: Int(y), width: width, height: height))
        let image = UIImage(named: imgname)
        imageView.image = image
        rightimgv.addSubview(imageView)
        txtfield.rightView = rightimgv
        
        //MARK: - Add button in text field Right SIDE
        btn.frame = rightimgv.frame
        rightimgv.addSubview(btn)
    }

//MARK:- set View Circle
public func setViewCircle(view: UIView, viewcontroller: UIViewController)
{
    setViewHeighWidth4Pad(view: view, viewcontroller: viewcontroller)
    DispatchQueue.main.async {
        view.layer.cornerRadius = view.frame.size.height / 2
        view.clipsToBounds = true
    }
}

//MARK:- set heigh image 4 ipad
public func setImageHeighWidth4Pad(image: UIImageView, viewcontroller :UIViewController)
{
    let imageCenterPoint = image.center
    image.frame.size.width = image.frame.size.height
    //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
    //image.contentMode = .scaleAspectFill
    image.clipsToBounds = true
    image.center = imageCenterPoint
}
//MARK:- set heigh image 4 ipad
public func setViewHeighWidth4Pad(view: UIView, viewcontroller :UIViewController)
{
    let imageCenterPoint = view.center
    view.frame.size.width = view.frame.size.height
    //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
    //image.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    view.center = imageCenterPoint
}
//MARK:- set image Circle
public func setimageCircle(image: UIImageView, viewcontroller: UIViewController)
{
    setImageHeighWidth4Pad(image: image, viewcontroller: viewcontroller)
    DispatchQueue.main.async {
        image.layer.cornerRadius = image.frame.size.height / 2
        image.clipsToBounds = true
        
        let imagecenterpoint = image.center
        image.frame.size.width = image.frame.size.height
        //image.frame.origin.x = (viewcontroller.view.frame.midX - (image.frame.width / 2))
        //image.contentMode = .scaleAspectFill
        image.center = imagecenterpoint
    }
}
public func setCellImage(imgv: UIImageView, index: Int){
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
public func findIndex(value searchValue: String, in array: [String], completion: @escaping (_ userindex: Int?) -> Void) {
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
public func setViewShade(view: UIView)
{
    //view.layer.cornerRadius = 8
    view.layer.borderWidth = 1
    view.layer.borderColor = appclr.cgColor
    
    //MARK:- Shade a view
    view.layer.shadowOpacity = 0.5
    view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    view.layer.shadowRadius = 3.0
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.masksToBounds = false
}
public func setTextFieldShade(textfield: UITextField)
{
    //view.layer.cornerRadius = 8
    textfield.layer.borderWidth = 1
    textfield.layer.borderColor = AppTextFieldBorderColor.cgColor
    
    //MARK:- Shade a view
    textfield.layer.shadowOpacity = 0.5
    textfield.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    textfield.layer.shadowRadius = 3.0
    textfield.layer.shadowColor = UIColor.black.cgColor
    textfield.layer.masksToBounds = false
}
public func showAlert(title: String, message: String, viewController: UIViewController)
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default)
    { (action) in
        
    }
    alert.addAction(ok)
    DispatchQueue.main.async {
        viewController.present(alert, animated: true)
    }
}
 //MARK:- PassPhone number and get contact name
public func getContactNameFromNumber(contactNumber: String) -> String {
    var contactName = String()
    let contactStore = CNContactStore()
    let t = CNPhoneNumber.init(stringValue: contactNumber)
    
    var predicate = CNContact.predicateForContacts(withIdentifiers: [contactNumber])
    if #available(iOS 11.0, *) {
        predicate = CNContact.predicateForContacts(matching: t)
    } else {
        // Fallback on earlier versions
    }
    var contacts = [CNContact]()
    var message: String!
    
    do {
        contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: CONTACTKEY)
        
        if contacts.count == 0 {
            message = "No contacts were found matching the given name."
        }
    }
    catch {
        message = "Unable to fetch contacts."
    }
    //print(message)
    if contacts.count > 0{
        print(contacts[0])
        let tempcontact = contacts[0]
        
        if let fullname = tempcontact.value(forKey: "fullName") as Any as? String
        {
            contactName = fullname
        }
        else{
            contactName =  (tempcontact.phoneNumbers.first?.value.stringValue)!
        }
    }
    if contactName == ""{
        contactName = contactNumber
    }
    return contactName
}

public func convertTimespamIntoTime(timestring: String) -> String
{
    let currentDateTimeToMiliSec = NSDate(timeIntervalSince1970: Double(Date().currentTimeMillis()!) / 1000)
    
    let date = NSDate(timeIntervalSince1970: Double(timestring)! / 1000)
    let formatter = DateFormatter()
    formatter.timeZone = (NSTimeZone(name: "\(TimeZone.current.identifier)")! as TimeZone)
    
    formatter.dateFormat = "YYYY-MM-dd"
    //formatter.dateFormat = "ddmmYY"
    let currentdate = formatter.date(from: formatter.string(from: currentDateTimeToMiliSec as Date))
    let msgdate = formatter.date(from: formatter.string(from: date as Date))
    
    if currentdate == msgdate
    {
        formatter.dateFormat = "hh:mm a"
        return "" + formatter.string(from: date as Date)
    }
    else
    {
        formatter.dateFormat = "d/MM/yy hh:mm a"
        return formatter.string(from: date as Date)
    }
}

public func SendPushNotification(toToken: String, title: String, body: String, data: [String: Any])
{
    let sender = PushNotificationSender()
    sender.sendPushNotification(to: toToken, title: title, body: body, data: data)
}

//MARK:- Device to device Push Notification
class PushNotificationSender {
    func
        sendPushNotification(to token: String, title: String, body: String, data: [String: Any]) {
        let url = NSURL(string: FBASE_SEND_NOTIFICATION_URL)!
        
        
        var tempdataAndroid = data
        var paramString = [String : Any]()
        var tempisAndroid = Bool()
        let tempdic = data as NSDictionary
        if (tempdic.allKeys as NSArray).contains("isAndroidUser") {
            tempisAndroid = (tempdic.value(forKey: "isAndroidUser") as? Bool)!
            if tempisAndroid == true{
                //For Android
                tempdataAndroid.removeValue(forKey: "title")
                tempdataAndroid.removeValue(forKey: "body")
                tempdataAndroid.removeValue(forKey: "isAndroidUser")
                paramString = [
                    "to" : token,
                    "priority": "high",
                    "data" : tempdataAndroid,
                    "sound": "default"
                   // "notification": tempdataAndroid
                ]
            }else{
                tempdataAndroid.removeValue(forKey: "isAndroidUser")
                //For IOS
                paramString = [
                    "to" : token,
                    // "title":title,
                    // "body":body,
                    "priority": "high",
                    "data" : data,
                    "notification": data,
                    //"aps": dd,
                    //"payload": dd,
                    "sound": "default"
                    // "mutable_content": true,
                    //  "content_available": true
                ]
            }
        }
        else{
            if isAndroidUser == true{
                //For Android
                tempdataAndroid.removeValue(forKey: "title")
                tempdataAndroid.removeValue(forKey: "body")
                paramString = [
                    "to" : token,
                    "priority": "high",
                    "data" : tempdataAndroid,
                    "sound": "default"
                   // "notification": tempdataAndroid
                ]
            }else{
                //For IOS
                paramString = [
                    "to" : token,
                    // "title":title,
                    // "body":body,
                    "priority": "high",
                    "data" : data,
                    "notification": data,
                    //"aps": dd,
                    //"payload": dd,
                    "sound": "default"
                    // "mutable_content": true,
                    //  "content_available": true
                ]
            }
        }
        
        
        //        let dd = [
        //            "title":title,
        //            "body":body,
        //            "alert": "Hello!",
        //            "sound": "default",
        //            "mutable_content": true,
        //            //"content_available": true,
        //            "badge": 0,
        //            "data": [
        //                    "attachment-url": "https://ibb.co/BccHsMR"
        //            ]] as [String : Any]
        
        //        let paramString: [String : Any] = ["to" : token,
        //                                           "title":title,
        //                                           "body":body,
        //                                           "priority": "high",
        //                                           "data" : data,
        //                                           // "notification": data,
        //            "aps": dd,
        //            "payload": dd,
        //            "sound": "incomming.mp3",
        //            // "content_available": true//,
        //            "mutable_content": true
        //        ]
        
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(FIREBASE_SERVERKEY)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}

