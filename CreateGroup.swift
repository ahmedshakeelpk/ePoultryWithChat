//
//  CreateGroup.swift
//  ZedChat
//
//  Created by MacBook Pro on 15/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Contacts
import XLPagerTabStrip
import UIImageView_Letters
import Alamofire
import FirebaseDatabase

class CreateGroup: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CreateGroupCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CreateGroupColCellDelegate, UICollectionViewDelegateFlowLayout {
   
    var groupId = String()
    var groupName = String()
    var isAddParticipant = false
    var tableviewframe = CGFloat()
    var arrSelectedNumber = NSMutableArray()
    var arrSelectedNumber_temp = NSMutableArray()
    var arrSelectedNumber_AddParticipant = NSMutableArray()
    var arruserphone = NSMutableArray()
    
    var doneBtn = UIBarButtonItem()
    
    @IBOutlet weak var btngroup: UIButton!
    @IBAction func btngroup(_ sender: Any) {
        if arrSelectedNumber.count > 0 {
            let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "GroupCreationConfirm") as! GroupCreationConfirm
            
            vc.arrSelectedNumber = arrSelectedNumber
            vc.arrSelectedNumber_temp = arrSelectedNumber_temp
            if arrSelectedNumber_temp.count > 0{
                let indexof = arruserphone.index(of: USERUniqueID)
                vc.arrSelectedNumber_temp.removeObject(at: indexof)
            }
            vc.groupId = groupId
            vc.groupName = groupName
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            obj.showToast(message: "Please select member", viewcontroller: self)
        }
    }
    @IBOutlet weak var bgvcolv: UIView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var txtsearch: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        if arrGnumber.count == 0 || arrGusername.count == 0 {
            andicator.startAnimating()
            //funRectifyUser()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchUserData"), object: nil)
        }
        else {
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "contacts"])
        self.view.endEditing(true)
        obj.putImgInButtonWithOutLabel2XSmall(button: btngroup, imgname: "arrowNewGroup")
        DispatchQueue.main.async {
            obj.setbuttonHeighWidth4Pad(button: self.btngroup, viewcontroller: self)
            DispatchQueue.main.async {
                self.btngroup.layer.cornerRadius = self.btngroup.frame.size.height / 2
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bgvcolv.isHidden = true
        tablev.frame.origin.y = (txtsearch.frame.maxY)
        tablev.frame.size.height = self.view.frame.size.height - (txtsearch.frame.maxY)
        //MARK:- Navigation Title Multilines
        obj.navigationTwoLineTitle(topline: "New Group", bottomline: "Add Participent", viewcontroller: self)
        tableviewframe = tablev.frame.size.height
        // Do any additional setup after loading the view.
        //TAble view cell
        self.tablev.register(UINib(nibName: "CreateGroupCell", bundle: nil), forCellReuseIdentifier: "CreateGroupCell")
        //Collectionview cell
        self.colv.register(UINib(nibName: "CreateGroupColCell", bundle: nil), forCellWithReuseIdentifier: "CreateGroupColCell")
        // search textfield func
        //MARK:- Notification when tap on some user
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUserDataRefresh), name: NSNotification.Name(rawValue: "fetchUserDataRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funback), name: NSNotification.Name(rawValue: "funback"), object: nil)
        btncancelSearch.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: self.txtsearch, imgname: "searchbar", x: 15, width: 10, height: 10)
        
        obj.setTextFieldShade(textfield: txtsearch)
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: txtsearch, imgname: "cross", x: 20, width: 15, height: 15)
        btncancelSearch.addTarget(self, action: #selector(btncancelSearch(sender:)), for: .touchUpInside)
        funSearchSetting()
        
        obj.setTextFieldShade(textfield: txtsearch)
        
        let backBtn = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        
        if isAddParticipant == true{
            obj.navigationTwoLineTitle(topline: "Group", bottomline: "Add Participent", viewcontroller: self)
            DispatchQueue.main.async {
                self.colv.reloadData()
            }
            doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funDone))
            self.navigationItem.rightBarButtonItem = doneBtn
            btngroup.isHidden = true
        }
        else {
            doneBtn = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funNext))
            self.navigationItem.rightBarButtonItem = doneBtn
            btngroup.isHidden = true
        }
    }
    
    @objc func fetchUserDataRefresh() {
        tablev.reloadData {
            
        }
    }
    @objc func funback() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func funSearch() {
        if txtsearch.isHidden == true {
            self.searchshow()
        }
        else {
            self.searchhide()
        }
    }
    @objc func searchshowhide(notification: Notification) {
        if txtsearch.isHidden == true {
            txtsearch.isHidden = false
            tablev.frame.origin.y = txtsearch.frame.maxY + 8
            tablev.frame.size.height = self.view.frame.size.height
        }
        else {
            self.view.endEditing(true)
            txtsearch.isHidden = true
            tablev.frame.origin.y = 0
            tablev.frame.size.height = self.view.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered == true {
            return arrSearchIndex.count
        }
        else {
            return arrGnumber_AppUser.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "CreateGroupCell") as! CreateGroupCell
        var index = indexPath.row
        if isFiltered == true {
            index = arrSearchIndex[indexPath.row] as! Int
        }
        cell.lblname.text = "\(arrGfullname_AppUser[index])"
        cell.lblnumber.text = arrGnumber_AppUser[index]
        
        funCellSetting(index: index, button: cell.btncheck, imgv: cell.imgv, view: cell.imgvbg, imgvcheck: cell.imgvcheck)
        cell.cellConfigration(row: index, delegate: self)
        
        if isAddParticipant {
            if self.arruserphone.count == 0 && USERUniqueID == self.arruserphone[index] as! String{
            }
            else {
                find2(value:arrGnumber_AppUser[index] , in: self.arruserphone as! [String], completion: { indexx in
                    if indexx != nil {
                        if self.arrSelectedNumber.contains(index) {
                            
                        }
                        else {
                            self.arrSelectedNumber.add(index as Any)
                            if self.arrSelectedNumber_temp.contains(index){
                                
                            }
                            else{
                                self.arrSelectedNumber_temp.add(index as Any)
                            }
                            
                            self.funCellSetting(index: index, button: cell.btncheck, imgv: cell.imgv, view: cell.imgvbg, imgvcheck: cell.imgvcheck)
                            self.colv.reloadData()
                        }
                        cell.isUserInteractionEnabled = false
                    }
                    else {
                        cell.isUserInteractionEnabled = true
                    }
                })
            }
        }
        return cell
        
        //MARK:- Show Profile Image Setting
//        cell.btnprofilepic.tag = index
//        cell.btnprofilepic.addTarget(self, action: #selector(funShowProfilePic(sender:)), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = indexPath.row
        if isFiltered == true {
            index = arrSearchIndex[indexPath.row] as! Int
        }
        didTapOnCheck(row: index)
    }
    
    func find(value searchValue: String, in array: [String], completion: @escaping (_ userindex: Int?) -> Void) {
        
        let itemsArray = array
        let searchToSearch = searchValue
        
        let filteredStrings = itemsArray.filter({(item: String) -> Bool in
            
            let stringMatch = item.lowercased().range(of: searchToSearch.lowercased())
            return stringMatch != nil ? true : false
        })
        
        if filteredStrings.count > 0 {
            andicator.startAnimating()
            if filteredStrings.count == 1 {
                let tempnumber = filteredStrings[0]
                if arrGuserphone.contains(tempnumber){
                    completion(arrGuserphone.index(of: tempnumber))
                }
            }
            else {
                var temp = 0
                for (index, tempnumber) in filteredStrings.enumerated() {
                    if arrGuserphone.contains(tempnumber){
                        let userindex = arrGuserphone.index(of: tempnumber)
                        var useridd = ""
                        if let tempuserid = arrGuserid[userindex] as? Int {
                            useridd = "\(tempuserid)"
                        }
                        else if let tempuserid = arrGuserid[index] as? String {
                            useridd = tempuserid
                        }
                        UserDB.queryOrdered(byChild: "user_id")
                            .queryEqual(toValue: useridd)
                            .observeSingleEvent(of: .value, with: { (snapshot) in
                                print(snapshot)
                                self.andicator.stopAnimating()
                                if snapshot.childrenCount > 0 {
                                    if temp == 0 {
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
    func funChatScreen(userid: String, userindex: Int, indexrow: Int) {
        andicator.startAnimating()
        UserDB.queryOrdered(byChild: "user_id")
            .queryEqual(toValue: userid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                self.andicator.stopAnimating()
                if snapshot.childrenCount > 0 {
                    if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                        var temptouid = ""
                        var imagestring = ""
                        for snap in snapShot {
                            temptouid = snap.key
                            imagestring = (snap.value as! NSDictionary).value(forKey: "UserLink") as! String
                            break
                        }
                        if imagestring != "" {
                            imagestring = USER_IMAGE_PATH + imagestring
                        }
                        
                        NotificationCenter.default.post(name:
                            NSNotification.Name(rawValue: "taponuser"),
                                                        object: ["touid": temptouid,
                                                                 "fromuid": USERUID,
                                                                 "userprofilepic":imagestring,
                                                                 "username": arrGuserphone[userindex],
                                                                 "groupid": "",
                                                                 "grouptype": PRIVATECHAT])
                    }
                }
                else if snapshot.childrenCount == 0 { }
            })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD {
            return 120
        }
        return 65
    }
    
    //MARK:- Cell Setting
    func funCellSetting(index: Int, button: UIButton, imgv: UIImageView, view: UIView, imgvcheck: UIImageView) {
        if arrSelectedNumber.contains(index) {
            imgvcheck.image = UIImage(named: "check")
        }
        else {
            imgvcheck.image = UIImage(named: "uncheck")
        }
        setImageandView(imgv: imgv, view: view)
        setCellImage(imgv: imgv, index: index)
    }
    
    func find2(value searchValue: String, in array: [String], completion: @escaping (_ userindex: Int?) -> Void) {
        
        var tempphone = searchValue
        tempphone = tempphone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if tempphone.first == "0" || tempphone.first == "+" {
            tempphone.removeFirst()
        }
        if tempphone.first == "0" {
            tempphone.removeFirst()
        }
        
        let itemsArray = array
        let searchToSearch = tempphone
        
        let filteredStrings = itemsArray.filter({(item: String) -> Bool in
            
            let stringMatch = item.lowercased().range(of: searchToSearch.lowercased())
            return stringMatch != nil ? true : false
        })
        
        if filteredStrings.count > 0 {
            let tempnumber = filteredStrings[0]
//                if arrGnumberWithoutSpaces.contains(tempnumber){
//                    completion(arrGuserphone.index(of: tempnumber))
//                }
            completion(arrGuserphone.index(of: tempnumber))
        }
        
        completion(nil)
    }
    func applyGradient(colours: [UIColor], view: UIView) {
        DispatchQueue.main.async {
            view.applyGradient(colours: colours)
        }
    }
    func setImageandView(imgv: UIImageView, view: UIView) {
        DispatchQueue.main.async {
            obj.setimageCircle(image: imgv, viewcontroller: self)
            obj.setViewCircle(view: view, viewcontroller: self)
        }
    }

    @objc func funinvite(sender: UIButton) {
        print(sender.tag)
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
    
    //MARK:- Search Section
    var isFiltered = Bool()
    var arrSearchIndex = NSMutableArray()
    
    func funSearchSetting() {
        let searchbtn = UIButton(type: .system)
        searchbtn.setImage(UIImage(named: "searchbar"), for: .normal)
        searchbtn.addTarget(self, action: #selector(self.funSearch), for: .touchUpInside)
        searchbtn.sizeToFit()
        let search = UIBarButtonItem(customView: searchbtn)
        self.navigationItem.rightBarButtonItems = [search]
        // search textfield func
        txtsearch.layer.borderColor = UIColor.black.cgColor
        txtsearch.layer.borderWidth = 1
        txtsearch.delegate = self
        txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
    }
    @objc func change() {
        let length = txtsearch.text
        if length?.count == 0 {
            isFiltered = false
            //searchBar.responds(to: Selector(resignFirstResponder()))
            //txtsearch.resignFirstResponder()
            arrSearchIndex = NSMutableArray()
            tablev.reloadData()
        }
        else {
            isFiltered = true
            arrSearchIndex = NSMutableArray()
            for (index, temp) in arrGfullname_AppUser.enumerated() {
                var name = temp
                if name.isNumeric {
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
            for (index, temp) in arrGnumber_AppUser.enumerated() {
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
            self.searchhide()
    }
    
    @objc func searchhide() {
        if txtsearch == nil{
            return
        }
        txtsearch.text = ""
        self.view.endEditing(true)
        //txtsearch.isHidden = true
        isFiltered = false
        tablev.reloadData()
        return
        if arrSelectedNumber.count > 0 {
            bgvcolv.frame.origin.y = 0
            tablev.frame.origin.y = bgvcolv.frame.maxY
            self.tablev.frame.size.height = self.view.frame.size.height - (self.bgvcolv.frame.maxY)
        }
        else
        {
            tablev.frame.origin.y = 0
            self.tablev.frame.size.height = self.view.frame.size.height
        }
    }
    
    @objc func searchshow()
    {
        txtsearch.isHidden = false
        if arrSelectedNumber.count > 0
        {
            bgvcolv.frame.origin.y = txtsearch.frame.maxY
            tablev.frame.origin.y = bgvcolv.frame.maxY
            self.tablev.frame.size.height = self.view.frame.size.height - (self.bgvcolv.frame.maxY)
        }
        else
        {
            tablev.frame.origin.y = txtsearch.frame.maxY
            self.tablev.frame.size.height = self.view.frame.size.height - txtsearch.frame.maxY
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eview.dismiss()
        self.view.endEditing(true)
        return true
    }
    
    //MARK:- CreateGroupCell Delegates
    func didTapOnCheck(row: NSInteger) {
        //MARK:- Change Check in row in table view
        let index = row
        if isAddParticipant {
            if arrSelectedNumber_temp.contains(index){
                return
            }
        }
        var searchedrow = row
        if isFiltered == true && arrSearchIndex.contains(row) {
            searchedrow = arrSearchIndex.index(of: row)
        }
        if (tablev.numberOfRows(inSection: 0) - 1) < searchedrow {
            
        }
        else {
            self.tablev.beginUpdates()
            let indexPath = IndexPath(row: searchedrow, section: 0)
            let cell = self.tablev.cellForRow(at: indexPath) as! CreateGroupCell
            if arrSelectedNumber.contains(index) == true {
                cell.imgvcheck.image = UIImage(named: "uncheck")
            }
            else {
                cell.imgvcheck.image = UIImage(named: "check")
            }
            self.tablev.endUpdates()
        }
        
        if arrSelectedNumber.contains(index) == true {
            let tempindex = arrSelectedNumber.index(of: index)
            arrSelectedNumber.removeObject(at: tempindex)
            let tempindex_AddParticipant = arrSelectedNumber_AddParticipant.index(of: index)
            arrSelectedNumber_AddParticipant.removeObject(at: tempindex_AddParticipant)
        }
        else {
            if arrSelectedNumber.count > 49{
                obj.showToast(message: "Group limit is 50", viewcontroller: self)
                return
            }
            arrSelectedNumber.add(index)
            arrSelectedNumber_AddParticipant.add(index)
        }
        colv.reloadData()
        if isAddParticipant{
            if arrSelectedNumber_AddParticipant.count == 0 {
                //MARK:- When NO new user selected for New Group
                bgvcolv.isHidden = true
                if txtsearch.isHidden == true {
                    tablev.frame.origin.y = 0
                    tablev.frame.size.height = self.view.frame.size.height
                }
                else {
                    tablev.frame.origin.y = (txtsearch.frame.maxY)
                    tablev.frame.size.height = self.view.frame.size.height - txtsearch.frame.maxY
                }
            }
            else {
                if arrSelectedNumber_AddParticipant.count > 0{
                    //MARK:- When new user selected for New Group
                    bgvcolv.isHidden = false
                    tablev.frame.origin.y = bgvcolv.frame.maxY
                    tablev.frame.size.height = self.view.frame.size.height - (bgvcolv.frame.maxY)
                    funColvScrollToEnd()
                }
            }
        }
        else {
            if arrSelectedNumber.count == 0 {
                //MARK:- When NO new user selected for New Group
                bgvcolv.isHidden = true
                if txtsearch.isHidden == true {
                    tablev.frame.origin.y = 0
                    tablev.frame.size.height = self.view.frame.size.height
                }
                else {
                    tablev.frame.origin.y = (txtsearch.frame.maxY)
                    tablev.frame.size.height = self.view.frame.size.height - txtsearch.frame.maxY
                }
            }
            else if arrSelectedNumber.count > 0 {
                //MARK:- When new user selected for New Group
                bgvcolv.isHidden = false
                tablev.frame.origin.y = bgvcolv.frame.maxY
                tablev.frame.size.height = self.view.frame.size.height - (bgvcolv.frame.maxY)
                funColvScrollToEnd()
            }
        }
    }
    
    //MARK:- Collection view Scroll to End
    func funColvScrollToEnd() {
        let item = self.collectionView(self.colv!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: item, section: 0)
        self.colv?.scrollToItem(at: lastItemIndex as IndexPath, at: .right, animated: false)
    }
    //MARK:- Did select row Collection view
    func didTapOnColvRow(row: NSInteger) {
        
    }
    
    //MARK:- Collection view Delegates
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = 5.0
        let width = (self.colv.frame.size.width / 5) - CGFloat(2 * margin)
        return CGSize(width: width, height: width + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isAddParticipant{
            return arrSelectedNumber_AddParticipant.count
        }
        return arrSelectedNumber.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colv.dequeueReusableCell(withReuseIdentifier: "CreateGroupColCell", for: indexPath) as! CreateGroupColCell
        cell.cellConfigration(viewcontroller: self, delegate: self)
        var tempindex = arrSelectedNumber[indexPath.row] as! Int
        if isAddParticipant{
            tempindex = arrSelectedNumber_AddParticipant[indexPath.row] as! Int
        }
        cell.lbltitle.text = arrGfullname_AppUser[tempindex]
        setCellImage(imgv: cell.imgvuser, index: tempindex)
        
        if isAddParticipant{
            find2(value:arrGnumber_AppUser[tempindex] , in: self.arruserphone as! [String], completion: { indexx in
                if indexx != nil{
                    cell.isUserInteractionEnabled = false
                }
                else{
                    cell.isUserInteractionEnabled = true
                }
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if isAddParticipant{
            didTapOnCheck(row: arrSelectedNumber_AddParticipant[index] as! NSInteger)
        }
        else {
            didTapOnCheck(row: arrSelectedNumber[index] as! NSInteger)
        }
    }//MARK:- End Collection view Delegates
    
    func funAddParticipantInExistingGroup(){
        andicator.startAnimating()
        //MARK:- If admain user
        let temparray = self.arrSelectedNumber
        var isSendMe = false
        for (index, tempNewMember) in arrSelectedNumber.enumerated() {
            //MARK:- in this loop total selected number of member
            let messageautocreatedid = MessagesDB.childByAutoId().key!
            let itemsArray = arrGuserphone as! [String]
            var searchToSearch = "\(arrGnumber_AppUser[tempNewMember as! Int])"
            let tempRole = "participant"
            searchToSearch = searchToSearch.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if searchToSearch.first == "0" || searchToSearch.first == "+" {
                searchToSearch.removeFirst()
            }
            if searchToSearch.first == "0" {
                searchToSearch.removeFirst()
            }
            findIndex(value: searchToSearch, in: itemsArray) { userindex in
                guard let userindex = userindex else { return }
                //MARK:- Send to Own number (Who added the participant)
                let messagetext = "\(USERUniqueID) added '\(arrGuserphone[userindex])'"
                if isSendMe == false{
                    isSendMe = true
                    funSendMessage(msgType: ADD_MEMBER, msgtext: messagetext, groupid: self.groupId, receiverid: USERUID, msgautoid: messageautocreatedid, groupName: self.groupName, completion: {response in
                        if response == "success" { }
                        else { }
                    })
                }
                
                if self.arrSelectedNumber_temp.contains(tempNewMember){
                    //MARK:- Old Participant
                    funSendMessage(msgType: ADD_MEMBER, msgtext: messagetext, groupid: self.groupId, receiverid: arrGuserUid[userindex] as! String, msgautoid: messageautocreatedid, groupName: self.groupName, completion: {response in
                        if response == "success" {
                            
                        }
                        else {
                            
                        }
                    })
                }
                
//                var tempphone = arrGnumber_AppUser[userindex]
//                    tempphone = tempphone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
//                    if tempphone.first == "0" || tempphone.first == "+"
//                    {
//                        tempphone.removeFirst()
//                    }
//                    if tempphone.first == "0"
//                    {
//                        tempphone.removeFirst()
//                    }
//                    let itemsArray = arrGuserphone as! [String]
//                    let searchToSearch = tempphone
//                    findIndex(value: searchToSearch, in: itemsArray) { userindex in
//                        guard let userindex = userindex else {
//                            return
//                        }
//                    }
                //MARK:- Add New users
                self.funAddGroupParticipents(msgtype: ADD_MEMBER, autoGroupId: self.groupId, msgtext: messagetext, role: tempRole, groupName: self.groupName, groupid: self.groupId, userid: arrGuserUid[userindex] as! String, msgautoid: messageautocreatedid, completion: {response in
                    if index >= temparray.count - 1{
                      //  obj.showToast(message: "Paticepants add successfully...!", viewcontroller: self)
                        self.funback()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchGroupParticipant"), object: nil)
                    }
                    if response == "success" { }
                    else { }
                })
            }
            
        }
    }
    func funAddGroupParticipents(msgtype: Int, autoGroupId: String, msgtext: String, role: String, groupName: String, groupid: String, userid: String, msgautoid: String, completion: @escaping (_ response: String?) -> Void) {
        ParticipantsDB.child(autoGroupId).child(userid).updateChildValues(["Role" : role], withCompletionBlock: {
            error, snapshot in
            if error != nil
            {
                completion(error?.localizedDescription)
            }
            else
            {
                funSendMessage(msgType: msgtype, msgtext: msgtext, groupid: groupid, receiverid: userid, msgautoid: msgautoid, groupName: groupName, completion: {response in
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
    @objc func funDone(){
        if isAddParticipant{
            if arrSelectedNumber_AddParticipant.count == 0{
                obj.showToast(message: "Please select user you want to add", viewcontroller: self)
                return
            }
        }else{
            if arrSelectedNumber.count == 0{
                obj.showToast(message: "Please select user you want to add", viewcontroller: self)
                return
            }
        }
        if doneBtn.tag == 1{
            return
        }
        doneBtn.tag = 1
        if isAddParticipant == true{
            andicator.startAnimating()
            funAddParticipantInExistingGroup()
            return
        }
    }
    @objc func funNext(){
        if arrSelectedNumber.count > 0 {
            let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "GroupCreationConfirm") as! GroupCreationConfirm
            vc.arrSelectedNumber = arrSelectedNumber
            vc.arrSelectedNumber_temp = arrSelectedNumber_temp
            if arrSelectedNumber_temp.count > 0{
                let indexof = arruserphone.index(of: USERUniqueID)
                vc.arrSelectedNumber_temp.removeObject(at: indexof)
            }
            vc.groupId = groupId
            vc.groupName = groupName
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            obj.showToast(message: "Please select member", viewcontroller: self)
        }
    }
    
}

// MARK: - IndicatorInfoProvider for page controller like android
extension CreateGroup: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Contacts")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Contacts")
        return itemInfo
    }
}


