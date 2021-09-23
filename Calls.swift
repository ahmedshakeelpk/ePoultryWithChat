//
//  Calls.swift
//  ZedChat
//
//  Created by MacBook Pro on 13/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreData
import Contacts
import FirebaseDatabase


class Calls: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CallCellDelegate {
    
    let timespam = Date().currentTimeMillis()
    var receivertokenLocalClass = String()
    
    var arrCallerNumber = [String]()
    var arrCallerTime = [Int]()
    var arrCallerPic = [String]()
    var arrCallType = [Int]()
    var arrCallerFBID = [String]()
    var arrCallGroupID = [String]()
    var arrCallID = [String]()
    
    func didTapOnRow(row: NSInteger) {
        //print(row)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCallerTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK:- Self Messages
        let cell = tablev.dequeueReusableCell(withIdentifier: "CallCell") as! CallCell
        var index = indexPath.row
        if isFiltered == true
        {
            index = arrSearchIndex[indexPath.row] as! Int
        }
        //MARK:- Assign Manual Delegate
        cell.cellConfigration(row: index, delegate: self)
        //cell.lbltitle.text = (arrMsgUserName[index] as! String)
        
        cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic), for: .touchUpInside)
        cell.btncall.tag = index
        cell.btncall.addTarget(self, action: #selector(funCall), for: .touchUpInside)
        let contactUserName = obj.getContactNameFromNumber(contactNumber:"\(arrCallerNumber[index])")
        let timestring = obj.convertTimespamIntoTime(timestring: "\(arrCallerTime[index])")
        cell.lbltitle.text = contactUserName
        cell.lbltextmsg.text = timestring
        
        cell.lbltime.text = ""
        
        let calltype = arrCallType[index]
        if calltype == MISSED_CALL{
            cell.imgvstatus.image = UIImage.init(named: "misscall")
        }
        else if calltype == MISSED_VIDEO_CALL{
            cell.imgvstatus.image = UIImage.init(named: "misscall")
        }
        else if calltype == AUDIO_CALL{
            cell.imgvstatus.image = UIImage.init(named: "outgoingcall")
        }
        else if calltype == VIDEO_CALL{
            cell.imgvstatus.image = UIImage.init(named: "outgoingcall")
        }
        else if calltype == INCOMING_AUDIO{
            cell.imgvstatus.image = UIImage.init(named: "incommingcall")
        }
        if calltype == INCOMING_VIDEO || calltype == VIDEO_CALL || calltype == MISSED_VIDEO_CALL{
            cell.imgvcallbutton.image = UIImage.init(named: "videocallicon")
        }
        else{
            cell.imgvcallbutton.image = UIImage.init(named: "phoneicon")
        }
        obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
        //Load image from url
        if arrCallerPic[index] != "" && arrCallerPic[index] != "-1.jpg"
        {
            let url = URL(string: USER_IMAGE_PATH + arrCallerPic[index])
            //Kingfisher Image upload
            cell.imgvprofile.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    cell.imgvprofile.image = value.image
                    
                    
                case .failure(let error):
                    print("Error: \(error)")
                    cell.imgvprofile.image = UIImage(named: "user")
                }
            }
            
        }else{
            cell.imgvprofile.image = UIImage.init(named: "user")
        }
        
        cell.imgvcallbutton.image = cell.imgvcallbutton.image?.withRenderingMode(.alwaysTemplate)
        cell.imgvcallbutton.tintColor = appclr
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD
        {
            return 150
        }
        return 75
    }
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var txtsearch: UITextField!
    
    @IBAction func btncall(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Users") as! Users
        vc.isCallScreen = true
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBOutlet weak var btncall: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "calls"]) 
        funRefresh()
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        btncall.backgroundColor = appclr
        obj.putImgInButtonWithOutLabel(button: btncall, imgname: "call+")
        DispatchQueue.main.async {
            obj.setbuttonHeighWidth4Pad(button: self.btncall, viewcontroller: self)
            DispatchQueue.main.async {
                self.btncall.layer.cornerRadius = self.btncall.frame.size.height / 2
            }
        }
        //MARK:- Notification when tap on some user
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(searchshowhide), name: NSNotification.Name(rawValue: "searchshowhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchhide), name: NSNotification.Name(rawValue: "searchhide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funRefresh), name: NSNotification.Name(rawValue: "funRefresh"), object: nil)
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: txtsearch, imgname: "cross", x: 20, width: 15, height: 15)
        btncancelSearch.addTarget(self, action: #selector(btncancelSearch(sender:)), for: .touchUpInside)
        funSearchSetting()
        obj.setTextFieldShade(textfield: txtsearch)
        
        self.tablev.register(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "CallCell")
    }
    
    @objc func funRefresh()
    {
        fetchDataCallRecords(){ success in
            if success == false{
                //self.openDatabse()
                
            }else{
                
            }
            self.tablev.reloadData()
        }
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
        //            tablev.frame.origin.y = txtsearch.frame.maxY + 8
        //            tablev.frame.size.height = self.view.frame.maxY
        //        }
        //        else
        //        {
        //            self.view.endEditing(true)
        //            txtsearch.isHidden = true
        //            tablev.frame.origin.y = 10
        //            tablev.frame.size.height = self.view.frame.maxY
        //        }
    }
    override func didReceiveMemoryWarning() {
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK:- Search Section
    var isFiltered = Bool()
    var arrSearchIndex = NSMutableArray()
    
    func funSearchSetting()
    {
        // search textfield func
        txtsearch.layer.borderColor = UIColor.black.cgColor
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
            for (index, temp) in arrCallerNumber.enumerated() {
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
        // tablev.frame.origin.y = 0
        //  tablev.frame.size.height = self.view.frame.maxY
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if UIApplication.shared.isKeyboardPresented {
            txtsearch.resignFirstResponder()
        }
        return true
    }
    func convertTimespamIntoTime(timestring: String) -> String
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
    /////////////////////////////////////////////////////
    @objc func funShowProfilePic(sender: UIButton){
        
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        guard let cell = sender.superview?.superview as? CallCell else {
            return // or fatalError() or whatever
        }
        if cell.imgvprofile.image != nil{
            vc.profilepic = cell.imgvprofile.image!
        }
        else{
            vc.profilepic = UIImage.init(named: "user")!
        }
        
        vc.name = cell.lbltitle.text ?? ""
        vc.videoimagename = "Picture"
        vc.videoimagetag = PROFILEPIC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Run Time Message Delivery Status
    @objc func funCall(sender: UIButton)
    {
        let index = sender.tag
        let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AnswerCall") as! AnswerCall
        
        isOutGoing = 1
        if arrCallType[index] == MISSED_CALL{
            isAudio = 1
        }
        else if arrCallType[index] == AUDIO_CALL{
            isAudio = 1
        }
        else if arrCallType[index] == INCOMING_AUDIO{
            isAudio = 0
        }
        guard let cell = sender.superview?.superview as? CallCell else {
            return // or fatalError() or whatever
        }
        //        ["identifier": 923455063003, "froma": 923455063003, "firebase_group_id": -LheGjVV0r3v-MdL1gWB, "message": startservices, "phoneNumber": 923438922855, "current_profile": 1563339292674.png, "current_username": 923455063003, "id": 923455063003_2011, "current_fireBase_user_id": 3Pq25A8W1WeO9fNorVTaa8IljJn2, "fireBaseUserId": xjfGR3j1CuOnsN85GNkZuy6JQ4I2, "action": audioservice, "user_profile": 1563339292674.png, "profilePic": 1563339292674.png]
        //
        //        ["phoneNumber": 923455063003, "identifier": 923455063003, "profilePic": 1563339292674.png, "current_profile": 1563339292674.png, "firebase_group_id": -LheGjVV0r3v-MdL1gWB, "message": startservices, "fireBaseUserId": 3Pq25A8W1WeO9fNorVTaa8IljJn2, "action": audioservice, "user_profile": 1563339292674.png, "id": 923455063003_2011, "current_username": 923455063003, "froma": 923455063003, "current_fireBase_user_id": 3Pq25A8W1WeO9fNorVTaa8IljJn2]
        
        let parametersdic = [
            "id":callUser_Receiver_id,
            "identifier":callUser_PhoneNumber,
            "current_profile": defaults.value(forKey: "userimage") as! String,
            "user_profile": callUser_image_Sender,
            "phoneNumber": callUser_PhoneNumber_Receiver,
            "current_username": defaults.value(forKey: "phoneno") as! String,
            "current_fireBase_user_id": callUser_FBID,
            "fireBaseUserId": callUser_FBID_Receiver,
            "firebase_group_id": callGroup_Id,
            "action":"audioservice",
            "froma":callUser_PhoneNumber,
            "profilePic":callUser_image_Sender,
            "message":"startservices",
            ] as [String : AnyObject]
        
        
        callUser_Receiver_id = arrCallID[index]
        callGroup_Id = arrCallGroupID[index]
        callUser_FBID = USERUID
        callUser_PhoneNumber_Receiver = arrCallerNumber[index]
        callUser_Name = arrCallerNumber[index]
        callUser_PhoneNumber = defaults.value(forKey: "phoneno") as! String
        call_ReceiverImage = cell.imgvprofile.image!
        callUser_Picture = arrCallerPic[index]
        callUser_FBID_Receiver = arrCallerFBID[index]
        if let tempname = defaults.value(forKey: "userimage") as? String{
            callUser_image_Sender = tempname
        }
        else{
            callUser_image_Sender = ""
        }
        andicator.startAnimating()
        UserDB.child(callUser_FBID_Receiver).observeSingleEvent(of: .value, with: {
            (snapshot) in
       // })
        //UserDB.child(callUser_FBID_Receiver).observe(.value, with:{
          //  (snapshot) in
            print(snapshot)
            self.andicator.stopAnimating()
            if snapshot.children.allObjects.count > 0
            {
                let datadic = snapshot.value as! NSDictionary
                if let temp = datadic.value(forKey: "fcmId") as? String
                {
                    self.receivertokenLocalClass = temp
                    call_ReceiverFBToken = temp
                }
            }
            vc.isCallScreen = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnCallButtonCallScreen"), object:nil)
        })
        //call_ReceiverUser_id = self.useridserver
        
    }
    
    //Core Data
    //MARK:- Fetch user call data
    func fetchDataCallRecords(completion: @escaping (_ success: Bool?) -> Void) {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CallRecords")
        //request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            self.arrCallerNumber = [String]()
            self.arrCallerTime = [Int]()
            self.arrCallerPic = [String]()
            self.arrCallType = [Int]()
            self.arrCallerFBID = [String]()
            self.arrCallGroupID = [String]()
            self.arrCallID = [String]()
            
            
            let result = try context.fetch(request)
            if result.count == 0{
                completion(false)
                return
            }
            //let dataArray = result as NSArray
            // let dataArray2nd = dataArray
            for data in result as! [NSManagedObject] {
                if let temp = data.value(forKey: "call_date") as? Int{
                    arrCallerTime.append(temp)
                    arrCallerNumber.append(data.value(forKey: "caller_no") as! String)
                    arrCallerPic.append(data.value(forKey: "user_image") as! String)
                    arrCallType.append(data.value(forKey: "call_type") as! Int)
                    arrCallerFBID.append(data.value(forKey: "caller_FBID") as Any as! String)
                    arrCallGroupID.append(data.value(forKey: "group_id") as! String)
                    arrCallID.append(data.value(forKey: "call_id") as! String)
                    
                    //                    newCallRecordObject.setValue(tmep_timestamp, forKey: "call_date")
                    //                    newCallRecordObject.setValue("value", forKey: "call_duration")
                    //                    newCallRecordObject.setValue(call_type, forKey: "call_type")
                    //                    newCallRecordObject.setValue(temp_caller_no, forKey: "caller_no")
                    //                    newCallRecordObject.setValue(temp_user_image, forKey: "user_image")
                    
                    let sortedOrder = (self.arrCallerTime)
                        .enumerated().sorted(by: {$0.1>$1.1})
                        .map({$0.0})
                    
                    self.arrCallerTime = (sortedOrder.map({self.arrCallerTime[$0]}) as NSArray).mutableCopy() as! [Int]
                    self.arrCallerNumber = (sortedOrder.map({self.arrCallerNumber[$0]}) as NSArray).mutableCopy() as! [String]
                    self.arrCallerPic = (sortedOrder.map({self.arrCallerPic[$0]}) as NSArray).mutableCopy() as! [String]
                    self.arrCallType = (sortedOrder.map({self.arrCallType[$0]}) as NSArray).mutableCopy() as! [Int]
                    self.arrCallerFBID = (sortedOrder.map({self.arrCallerFBID[$0]}) as NSArray).mutableCopy() as! [String]
                    self.arrCallGroupID = (sortedOrder.map({self.arrCallGroupID[$0]}) as NSArray).mutableCopy() as! [String]
                    self.arrCallID = (sortedOrder.map({self.arrCallID[$0]}) as NSArray).mutableCopy() as! [String]
                    
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
                else{
                    context.delete(data)
                    try context.save()
                    //                    appDelegate.saveContext()
                    // deleteData(entityName: "Setting")
                    
                    //saveData(newStorageData: data)
                    completion(false)
                }
                //MARK:- Get all key and Values of Cordata fetch Resul
                //let keys = Array(data.entity.attributesByName.keys)
                //let dict = data.dictionaryWithValues(forKeys: keys)
            }
        } catch {
            print("Fetching data Failed")
        }
    }
}


// MARK: - IndicatorInfoProvider for page controller like android
extension Calls: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Calls")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Calls")
        return itemInfo
    }
}
