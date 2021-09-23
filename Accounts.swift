//
//  Privacy.swift
//  ZedChat
//
//  Created by MacBook Pro on 24/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import DropDown
import CoreData

class Accounts: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckBoxDelegate {
    
    //MARK:- Check Box Delegate Made byself Custom Delegate
    func didSelectCheckBox(indexPath: IndexPath) {
        let selectedValue = dataSource[indexPath.row]
        var columnKey = ""
        var columnValue = ""
        if selectTitle == "mobileData"{
            columnKey = "mobile_data"
            arrMobileData.append(selectedValue)
            funDataArrayEmptyCheck()
            columnValue = MOBILE_DATA
        }
        else if selectTitle == "wifiData"{
            columnKey = "wifi_data"
            arrWifi.append(selectedValue)
            funDataArrayEmptyCheck()
            columnValue = WIFI_DATA
        }
        else if selectTitle == "roaming"{
            columnKey = "roaming_data"
            arrRoming.append(selectedValue)
            funDataArrayEmptyCheck()
            columnValue = ROAMING_DATA
        }
        
        updateRecord(value: columnValue, key: columnKey, completion: {
            success in
            self.tablev.reloadData()
            if success == true {
                print("Record update \(String(describing: success))")
            }
        })
    }
    //MARK:- Check Box Custom Delegates
    func didUnSelectCheckBox(indexPath: IndexPath) {
        let selectedValue = dataSource[indexPath.row]
        var columnKey = ""
        var columnValue = ""
        if selectTitle == "mobileData"{
            columnKey = "mobile_data"
            let index = arrMobileData.firstIndex(of: selectedValue)
            if index != nil{
                arrMobileData.remove(at: index!)
                funDataArrayEmptyCheck()
            }
            else{
                MOBILE_DATA = ""
            }
            columnValue = MOBILE_DATA
        }
        else if selectTitle == "wifiData"{
            columnKey = "wifi_data"
            let index = arrWifi.firstIndex(of: selectedValue)
            if index != nil{
                arrWifi.remove(at: index!)
                funDataArrayEmptyCheck()
            }else{
                WIFI_DATA = ""
            }
            columnValue = WIFI_DATA
        }
        else if selectTitle == "roaming"{
            columnKey = "roaming_data"
            let index = arrRoming.firstIndex(of: selectedValue)
            if index != nil{
                arrRoming.remove(at: index!)
                funDataArrayEmptyCheck()
            }
            else{
                ROAMING_DATA = ""
            }
            columnValue = ROAMING_DATA
        }
        updateRecord(value: columnValue, key: columnKey, completion: {
            success in
            self.tablev.reloadData()
            if success == true {
                print("Record update \(String(describing: success))")
                self.tablev.reloadData()
            }
        })
    }
    
    
    var selectTitle = String()
    var screen = ""
    //MAARK:- Dropdown
    let dropDown = DropDown()
    var arrWifi = [String]()
    var arrMobileData = [String]()
    var arrRoming = [String]()
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var tablev: UITableView!
    let arrChatHeader = ["", "Chat Settings", "Media visibility"]
    let arrChatTitleSectionOne = ["App Language"]
    let arrChatTitleSectionTwo = ["Enter is Send", "Font Size: ", "Wallpaper", "Chat backup", "Chat history"]
    let arrChatTitleSectionThree =  ["Show media in gallery"]
    
    let arrChatDescSectionOne = ["Phone's language"]
    let arrChatDescSectionTwo = ["Enter key will add a new line", "Font size for chat screen", "", "", ""]
    let arrChatDescSectionThree = ["Show newly downloaded media in your phone's gallery"]
    
    let arrHelpTitle = ["FAQ", "Contact Us", "App Info", "Privacy Policy", "Terms & Conditions"]
    let arrKeySectionOne = ["Last Seen", "Profile Photo", "See About"]
    
    let arrheaders = ["Who can see my personal info", "Messaging", ""]
    let arrSectionOne = ["Last Seen", "Profile Photo", "About", "if you dont't want to share your Last Seen, you won't be able to see other people's Last Seen"]
    
    let arrDataNdStorageSection = ["Media auto-download", "Call Settings"]
    let arrDataNdStorageTitle = ["Voice messages are always auto-downloaded for the best communication experience", "When using mobile data", "When connected on Wi-Fi", "When roaming"]
    let arrDataNdStorageTitleCalling = ["Low data usage"]
    let arrDataNdStorageDescriptionCalling = ["Reduce the data used in a call"]
    
    var arrSelectionSectionOne = NSMutableArray()
    
    let arrSectionTwoTitle = ["Blocked Contacts: "]
    let arrSectionTwoDesc = ["List of contacts that you have blocked"]
    
    let arrSectionThreeTitle = ["Read Receipts", "Send SMS Notification", "If you turn off read receipts, you won't be able to see read receipts from other people. Read receipts are always send for group chats."]
    let dataSource = ["Photo", "Audio", "Video", "Document"]
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD
        {
            if screen == "Chats"{
                if indexPath.section == 2
                {
                    return UITableView.automaticDimension
                }
                else
                {
                    return 110
                }
            }
            else if screen == "Data & Storage"{
                if indexPath.section == 0
                {
                    return UITableView.automaticDimension
                }
                else {
                    return 110
                }
            }
            if indexPath.section == 0
            {
                if indexPath.row == 3
                {
                    return UITableView.automaticDimension
                }
                else
                {
                    if indexPath.row == 1
                    {
                        return 110
                    }
                    return 100
                }
            }
            else if indexPath.section == 1
            {
                return 110
            }
            else if indexPath.section == 2
            {
                if indexPath.row == 2
                {
                    return UITableView.automaticDimension
                }
                else
                {
                    return 100
                }
            }
            else
            {
                return 0
            }
        }
        else
        {
            if screen == "Chats"
            {
                if indexPath.section == 2
                {
                    return UITableView.automaticDimension
                }
                else
                {
                    return 55
                }
            }
            else if screen == "Data & Storage"{
                
                if indexPath.section == 0 && indexPath.row == 0{
                    return UITableView.automaticDimension
                }
                return 55
            }
            if indexPath.section == 0
            {
                if indexPath.row == 3
                {
                    return UITableView.automaticDimension
                }
                else
                {
                    if indexPath.row == 1
                    {
                        return 55
                    }
                    return 50
                }
            }
            else if indexPath.section == 1
            {
                return 55
            }
            else if indexPath.section == 2
            {
                if indexPath.row == 2
                {
                    return UITableView.automaticDimension
                }
                else
                {
                    return 50
                }
            }
            else
            {
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if screen == "Chats"
        {
            if section == 0
            {
                return 0
            }
            return 40
        }
        else if screen == "Data & Storage"{
            return 40
        }
        if screen == "Help"
        {
            return 0
        }
        let tempheader = arrheaders[section]
        if tempheader == ""
        {
            return 0
        }
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if screen == "Chats"
        {
            return arrChatHeader[section]
        }
        if screen == "Help"
        {
            return ""
        }
        else if screen == "Data & Storage"{
            return arrDataNdStorageSection[section]
        }
        return arrheaders[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if screen == "Chats"{
            return arrChatHeader.count
        }
        if screen == "Help"{
            return 1
        }
        else if screen == "Data & Storage"{
            return arrDataNdStorageSection.count
        }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screen == "Data & Storage"{
            if section == 0{
                return arrDataNdStorageTitle.count
            }else if section == 1{
                return arrDataNdStorageTitleCalling.count
            }
            return 0
        }
        else if screen == "Chats"
        {
            if section == 0 || section == 2
            {
                return 1
            }
            else if section == 1
            {
                return 5
            }
            return 0
        }
        else if screen == "Help"
        {
            return arrHelpTitle.count
        }else{
            if section == 0
            {
                return arrSectionOne.count
            }
            else if section == 1
            {
                return arrSectionTwoTitle.count
            }
            else if section == 2
            {
                return arrSectionThreeTitle.count
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if screen == "Data & Storage"{
            if indexPath.section == 0{
                if indexPath.row == 0{
                    let cell = tablev.dequeueReusableCell(withIdentifier: "MultilineCell") as! MultilineCell
                    cell.lbltitle.lineBreakMode = .byWordWrapping
                    cell.lbltitle.numberOfLines = 0
                    cell.lbltitle.text = arrDataNdStorageTitle[indexPath.row]
                    cell.lbltitle.sizeToFit()
                    return cell
                }
                else{
                    let cell = tablev.dequeueReusableCell(withIdentifier: "ChatCheckCell") as! ChatCheckCell
                    
                    cell.lbltitle.text = arrDataNdStorageTitle[indexPath.row]
                    if indexPath.row == 1{
                        if arrMobileData.count == 0{
                            cell.lbldesc.text = "No media"
                        }else if arrMobileData.count == 4{
                            cell.lbldesc.text = "All media"
                        }
                        else{
                            cell.lbldesc.text = MOBILE_DATA
                        }
                    }
                    else if indexPath.row == 2{
                        if arrWifi.count == 0{
                            cell.lbldesc.text = "No media"
                        }
                        else if arrWifi.count == 4{
                            cell.lbldesc.text = "All media"
                        }
                        else{
                            cell.lbldesc.text = WIFI_DATA
                        }
                    }
                    else if indexPath.row == 3{
                        if arrRoming.count == 0{
                            cell.lbldesc.text = "No media"
                        }else if arrRoming.count == 4{
                            cell.lbldesc.text = "All media"
                        }
                        else{
                            cell.lbldesc.text = ROAMING_DATA
                        }
                    }
                    cell.imgv.isHidden = true
                    return cell
                }
            }else if indexPath.section == 1{
                let cell = tablev.dequeueReusableCell(withIdentifier: "ChatCheckCell") as! ChatCheckCell
                
                cell.lbltitle.text = arrDataNdStorageTitleCalling[indexPath.row]
                cell.lbldesc.text = arrDataNdStorageDescriptionCalling[indexPath.row]
                cell.imgv.frame.origin.x = cell.imgv.frame.origin.x - 5
                
                if LOW_DATAUSAGE == true{
                    cell.imgv.image = UIImage(named: "check")
                }
                else{
                    cell.imgv.image = UIImage(named: "uncheck")
                }
                return cell
            }
            return tablev.dequeueReusableCell(withIdentifier: "ChatCheckCell") as! ChatCheckCell
        }
        else if screen == "Chats"
        {
            if indexPath.section == 0
            {
                let cell = tablev.dequeueReusableCell(withIdentifier: "ChatCheckCell") as! ChatCheckCell
                cell.lbltitle.text = arrChatTitleSectionOne[indexPath.row]
                cell.lbldesc.text = arrChatDescSectionOne[indexPath.row]
                cell.imgv.isHidden = true
                return cell
            }
            else if indexPath.section == 1
            {
                if indexPath.row == 0 || indexPath.row == 1
                {
                    let cell = tablev.dequeueReusableCell(withIdentifier: "ChatCheckCell") as! ChatCheckCell
                    if indexPath.row == 1
                    {
                        cell.lbltitle.text = arrChatTitleSectionTwo[indexPath.row] + fontSize
                    }else{
                        cell.lbltitle.text = arrChatTitleSectionTwo[indexPath.row]
                    }
                    
                    cell.lbldesc.text = arrChatDescSectionTwo[indexPath.row]
                    cell.imgv.image = UIImage(named: "check")
                    if indexPath.row == 1
                    {
                        cell.imgv.isHidden = true
                    }
                    return cell
                }
                else
                {
                    let cell = tablev.dequeueReusableCell(withIdentifier: "CheckUnCheckCell") as! CheckUnCheckCell
                    cell.lbltitle.text = arrChatTitleSectionTwo[indexPath.row]
                    cell.imgvcheck.isHidden = true
                    return cell
                }
            }
            else
            {
                let cell = tablev.dequeueReusableCell(withIdentifier: "ChatCheckCell") as! ChatCheckCell
                cell.lbldesc.numberOfLines = 0
                cell.lbldesc.lineBreakMode = .byWordWrapping
                cell.lbltitle.text = arrChatTitleSectionThree[indexPath.row]
                
                cell.lbldesc.text = arrChatDescSectionThree[indexPath.row]
                cell.lbldesc.sizeToFit()
                cell.imgv.image = UIImage(named: "check")
                return cell
            }
        }
        else if screen == "Help"
        {
            if indexPath.row == 1
            {
                let cell = tablev.dequeueReusableCell(withIdentifier: "MessageBlockCell") as! MessageBlockCell
                cell.lbltitle.text = arrHelpTitle[indexPath.row]
                cell.lbldesc.text = "Questions? Need help?"
                return cell
            }
            let cell = tablev.dequeueReusableCell(withIdentifier: "CheckUnCheckCell") as! CheckUnCheckCell
            cell.lbltitle.text = arrHelpTitle[indexPath.row]
            cell.imgvcheck.isHidden = true
            return cell
        }

        let celltemp = tablev.dequeueReusableCell(withIdentifier: "PersonalInfoCell") as! PersonalInfoCell
        if indexPath.section == 0
        {
            if indexPath.row == 3
            {
                let cell = tablev.dequeueReusableCell(withIdentifier: "MultilineCell") as! MultilineCell
                cell.lbltitle.lineBreakMode = .byWordWrapping
                cell.lbltitle.numberOfLines = 0
                cell.lbltitle.text = arrSectionOne[indexPath.row]
                cell.lbltitle.sizeToFit()
                return cell
            }
            else
            {
                let cell = tablev.dequeueReusableCell(withIdentifier: "PersonalInfoCell") as! PersonalInfoCell
                cell.lbltitle.text = arrSectionOne[indexPath.row]
                if arrSelectionSectionOne.count > 0
                {
                    cell.lblselection.text = (arrSelectionSectionOne[indexPath.row] as! String)
                }
                else
                {
                    cell.lblselection.text = ""
                }
                return cell
            }
        }
        else if indexPath.section == 1
        {
            let cell = tablev.dequeueReusableCell(withIdentifier: "MessageBlockCell") as! MessageBlockCell
            cell.lbltitle.text = arrSectionTwoTitle[indexPath.row]
            cell.lbldesc.text = arrSectionTwoDesc[indexPath.row]
            return cell
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 2
            {
                let cell = tablev.dequeueReusableCell(withIdentifier: "MultilineCell") as! MultilineCell
                cell.lbltitle.lineBreakMode = .byWordWrapping
                cell.lbltitle.numberOfLines = 0
                cell.lbltitle.text = arrSectionThreeTitle[indexPath.row]
                cell.lbltitle.sizeToFit()
                return cell
            }
            else
            {
                let cell = tablev.dequeueReusableCell(withIdentifier: "CheckUnCheckCell") as! CheckUnCheckCell
                let temptitle = arrSectionThreeTitle[indexPath.row]
                
                cell.lbltitle.text = temptitle
                
                if temptitle == "Read Receipts"{
                    if READ_RECEIPT == true{
                        cell.imgvcheck.image = UIImage(named: "check")
                    }
                    else{
                        cell.imgvcheck.image = UIImage(named: "uncheck")
                    }
                }
                return cell
            }
        }
        return celltemp
    }
    
    var dataarray = ["Everyone", "Nobody"]
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if screen == "Chats"
        {
            if indexPath.section == 1 && indexPath.row == 0 || indexPath.section == 2
            {
                //MARK:- Change Check in row in table view
                self.tablev.beginUpdates()
                let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
                let cell = self.tablev.cellForRow(at: indexPath) as! ChatCheckCell
                
                if cell.imgv.accessibilityIdentifier ==  "uncheck"
                {
                    cell.imgv.image = UIImage(named: "check")
                }
                else
                {
                    cell.imgv.image = UIImage(named: "uncheck")
                }
                self.tablev.endUpdates()
            }
            else if indexPath.section == 1
            {
                let temptitle = arrChatTitleSectionTwo[indexPath.row]
                if temptitle == "Font Size: "
                {
                    dataarray = ["Small", "Medium", "Large"]
                    dropDown.dataSource = dataarray
                    dropDown.direction = .bottom
                    dropDown.width = 100
                    //let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
                    let cell = self.tablev.cellForRow(at: indexPath) as! ChatCheckCell
                    self.dropDown.anchorView = cell.lbltitle
                    dropDown.show()
                    
                    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        print("Selected item: \(item) at index: \(index)")
                        self.dropDown.hide()
                        //MARK:-
                        //MARK:- Change Check in row in table view
                        self.tablev.beginUpdates()
                        
                        switch self.dataarray[index] {
                        case "Small":
                            cell.lbltitle.text = self.arrChatTitleSectionTwo[indexPath.row] + "Small"
                            defaults.setValue(10.0, forKey: "fontsize")
                           
                            //self.funChageStatus(key: self.arrKeySectionOne[indexPath.row], value: "Everyone")
                            break
                        case "Medium":
                            cell.lbltitle.text = self.arrChatTitleSectionTwo[indexPath.row] + "Medium"
                            defaults.setValue(15.0, forKey: "fontsize")
                          //  self.funChageStatus(key: self.arrKeySectionOne[indexPath.row], value: "Nobody")
                            break
                        case "Large":
                            cell.lbltitle.text = self.arrChatTitleSectionTwo[indexPath.row] + "Large"
                            defaults.setValue(20.0, forKey: "fontsize")
                            break
                        default:
                            print("no match")
                            break
                        }
                        self.tablev.endUpdates()
                    }
                }
            }
            return
        }
        else if screen == "Data & Storage"{
            if indexPath.section == 0{
                if indexPath.row == 0{
                    return
                }
                let title = arrDataNdStorageTitle[indexPath.row]
                arrWifi = WIFI_DATA.components(separatedBy: ",")
                arrMobileData = MOBILE_DATA.components(separatedBy: ",")
                arrRoming = ROAMING_DATA.components(separatedBy: ",")
                var dataArray = [String]()
                if title == "When using mobile data"{
                    selectTitle = "mobileData"
                    dataArray = arrMobileData
                }
                else if title == "When connected on Wi-Fi"{
                    selectTitle = "wifiData"
                    dataArray = arrWifi
                }
                else if title == "When roaming"{
                    selectTitle = "roaming"
                    dataArray = arrRoming
                }
                if dataArray.contains("All media"){
                     dataArray = dataSource
                }
                else if dataArray.contains("No media"){
                    dataArray = [String]()
                }
                objG.showCheckBox(dataSource: dataSource, dataSourceSelectedCheck: dataArray, viewController: self)
                
            }
            else{
                //MARK:- Change Check in row in table view
                var value = Bool()
                self.tablev.beginUpdates()
                let cell = self.tablev.cellForRow(at: indexPath) as! ChatCheckCell
                if cell.imgv.accessibilityIdentifier ==  "uncheck"
                {
                    cell.imgv.image = UIImage(named: "check")
                    value = true
                }
                else
                {
                    cell.imgv.image = UIImage(named: "uncheck")
                    value = false
                }
                LOW_DATAUSAGE = value
                self.tablev.endUpdates()
                updateRecord(value: value, key: "low_datausage", completion: { success in
                    if success == true {
                        print("Record update \(String(describing: success))")
                    }
                })
            }
            return
        }
        else if screen == "Help"
        {
            let title = arrHelpTitle[indexPath.row]
            if title == "FAQ"
            {
                
            }
            else if title == "Contact US"
            {
                
            }
            else if title == "App Info"
            {
                let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "AppInfo") as! AppInfo
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if title == "Privacy Policy" || title == "Terms & Conditions"
            {
                let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "WebView") as! WebView
                if title == "Privacy Policy"
                {
                    vc.strtitle = "Privacy Policy"
                    vc.link = "http://zedchat.net/Privacy_Policy.html"
                }
                else if title == "Terms & Conditions"
                {
                    vc.strtitle = "Terms & Conditions"
                    vc.link = "http://zedchat.net/Terms_Of_Use.html"
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        if indexPath.section == 0
        {
            if indexPath.row == 3
            {
                return
            }
            
            dropDown.dataSource = dataarray
            dropDown.direction = .bottom
            dropDown.width = 100
            let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            let cell = self.tablev.cellForRow(at: indexPath) as! PersonalInfoCell
            self.dropDown.anchorView = cell.lblselection
            dropDown.show()
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.dropDown.hide()
                //MARK:-
                //MARK:- Change Check in row in table view
                self.tablev.beginUpdates()
                
                switch self.dataarray[index] {
                case "Everyone":
                    cell.lblselection.text = "Everyone"
                    self.funChageStatus(key: self.arrKeySectionOne[indexPath.row], value: "Everyone")
                    break
                case "Nobody":
                    cell.lblselection.text = "Nobody"
                    self.funChageStatus(key: self.arrKeySectionOne[indexPath.row], value: "Nobody")
                    break
                default:
                    print("no match")
                    break
                }
                self.tablev.endUpdates()
            }
        }
        else if indexPath.section == 1
        {
            
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 2
            {
                return
            }
            //MARK:- Change Check in row in table view
            self.tablev.beginUpdates()
            let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            let cell = self.tablev.cellForRow(at: indexPath) as! CheckUnCheckCell
            var value = Bool()
            if cell.imgvcheck.accessibilityIdentifier == "uncheck"
            {
                cell.imgvcheck.image = UIImage(named: "check")
                value = true
            }
            else
            {
                cell.imgvcheck.image = UIImage(named: "uncheck")
                value = false
            }
            updateRecord(value: value, key: "read_receipts", completion: {
                success in
                
                if success == true {
                    READ_RECEIPT = value
                    print("Record update \(String(describing: success))")
                }
            })
            self.tablev.endUpdates()
        }
    }

    var fontSize = "Medium"
    override func viewWillAppear(_ animated: Bool) {
        if screen == "Chats"
        {
            if let tempsize = defaults.value(forKey: "fontsize") as? CGFloat
            {
                if tempsize == 10.0
                {
                    fontSize = "Small"
                }
                else if tempsize == 15.0
                {
                    fontSize = "Medium"
                }
                else if tempsize == 20.0
                {
                    fontSize = "Large"
                }
            }
            else
            {
               fontSize = "Medium"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = screen
        getUserProfile()
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        if screen == "Help"
        {
            
        }
        else if screen == "Privacy"
        {
            
        }
        else if screen == "Data & Storage"{
            funDataArray()
        }
        self.tablev.register(UINib(nibName: "PersonalInfoCell", bundle: nil), forCellReuseIdentifier: "PersonalInfoCell")
        self.tablev.register(UINib(nibName: "MultilineCell", bundle: nil), forCellReuseIdentifier: "MultilineCell")
        self.tablev.register(UINib(nibName: "ChatCheckCell", bundle: nil), forCellReuseIdentifier: "ChatCheckCell")
        self.tablev.register(UINib(nibName: "CheckUnCheckCell", bundle: nil), forCellReuseIdentifier: "CheckUnCheckCell")
        self.tablev.register(UINib(nibName: "MessageBlockCell", bundle: nil), forCellReuseIdentifier: "MessageBlockCell")
        
        self.tablev.tableFooterView = UIView()
        //LOW_DATAUSAGE = true
//        self.updateRecord(value: LOW_DATAUSAGE, key: "low_datausage"){ success in
//
//            }
    }
    func funDataArray(){
        arrWifi = WIFI_DATA.components(separatedBy: ",")
        arrMobileData = MOBILE_DATA.components(separatedBy: ",")
        arrRoming = ROAMING_DATA.components(separatedBy: ",")
        
        if arrWifi.count == 1{
            if arrWifi[0] == ""{
                arrWifi = [String]()
            }
        }
        if arrMobileData.count == 1{
            if arrMobileData[0] == ""{
                arrMobileData = [String]()
            }
        }
        if arrRoming.count == 1{
            if arrRoming[0] == ""{
                arrRoming = [String]()
            }
        }
    }
    
    func funDataArrayEmptyCheck(){
        var arrDeleteIndex = [Int]()
        var count = 0
        for temp in arrWifi{
            if temp == ""
            {
                arrDeleteIndex.append(count)
            }
            count = count + 1
        }
        
        for tempindex in arrDeleteIndex{
            arrWifi.remove(at: tempindex)
        }
        
        count = 0
        arrDeleteIndex = [Int]()
        for temp in arrMobileData{
            if temp == ""
            {
                arrDeleteIndex.append(count)
            }
            count = count + 1
        }
        
        for tempindex in arrDeleteIndex{
            arrMobileData.remove(at: tempindex)
        }
        
        count = 0
        arrDeleteIndex = [Int]()
        for temp in arrRoming{
            if temp == ""
            {
                arrDeleteIndex.append(count)
            }
            count = count + 1
        }
        for tempindex in arrDeleteIndex{
            arrRoming.remove(at: tempindex)
        }
        
        
        WIFI_DATA = arrWifi.joined(separator: ",")
        MOBILE_DATA = arrMobileData.joined(separator: ",")
        ROAMING_DATA = arrRoming.joined(separator: ",")
        
        if arrWifi.count == 1{
            if arrWifi[0] == ""{
                arrWifi = [String]()
            }
        }
        if arrMobileData.count == 1{
            if arrMobileData[0] == ""{
                arrMobileData = [String]()
            }
        }
        if arrRoming.count == 1{
            if arrRoming[0] == ""{
                arrRoming = [String]()
            }
        }
    }
    
    @objc func funback()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func funChageStatus(key: String, value: String)
    {
        andicator.startAnimating()
        ///// Save user Info
        UserDB.child(USERUID).updateChildValues([key : value]
            //,
//            "UserPhoneNumber"    : self.phonenumber,
//            "UserStatus"     : "\(self.txtstatus.text!)" as String,
//            "fcmId"       : fcmtoken,
//            // "myImageURL" : url,
//            "UserLink": imagename,
//            "onLine" : timespam,
//            "onLineUpdatedAt" : timespam,
//            "email" : "",
//            "user_id": "\(self.user_id)"]
            
            as [String :Any],withCompletionBlock: {
                error, ref in
                UserDB.child(USERUID).removeAllObservers()
                self.andicator.stopAnimating()
                if error == nil
                {
                    ///// Save user Location
                    
                }
                else
                {
                    obj.showAlert(title: "Error", message: error.debugDescription, viewController: self)
                }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- Run Time Message Delivery Status
    @objc func getUserProfile()
    {
        andicator.startAnimating()
        UserDB.child(USERUID)
            .observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot)
            self.andicator.stopAnimating()
            if snapshot.childrenCount > 0
            {
                let dicdata = (snapshot.value as! NSDictionary)
                if let temp = dicdata.value(forKey: "LastSeen") as? String
                {
                    if temp == "Nobody"
                    {
                        self.arrSelectionSectionOne.add(temp)
                    }
                    else
                    {
                        self.arrSelectionSectionOne.add("Every One")
                    }
                }
                else
                {
                    self.arrSelectionSectionOne.add("Every One")
                }
                if let temp = dicdata.value(forKey: "ProfilePhoto") as? String
                {
                    if temp == "Nobody"
                    {
                        self.arrSelectionSectionOne.add(temp)
                    }
                    else
                    {
                        self.arrSelectionSectionOne.add("Every One")
                    }
                }
                else
                {
                    self.arrSelectionSectionOne.add("Every One")
                }
                if let temp = dicdata.value(forKey: "SeeAbout") as? String
                {
                    if temp == "Nobody"
                    {
                        self.arrSelectionSectionOne.add(temp)
                    }
                    else
                    {
                        self.arrSelectionSectionOne.add("Every One")
                    }
                }
                else
                {
                    self.arrSelectionSectionOne.add("Every One")
                }
               // self.arrSelectionSectionOne.add("")
                self.tablev.reloadData {
                    
                }
            }
        })
    }
    
    //MARK:- Local Core Data Database
    // MARK: Methods to Open, Store and Fetch data
    func updateRecord(value: Any, key: String, completion: @escaping (_ success: Bool?) -> Void) {
        //Key = column
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Setting")
        //request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0{
                for data in result as! [NSManagedObject] {
                    data.setValue(value, forKey: key)

                    do {
                        try context!.save()
                        completion(true)
                    } catch _ {
                        print("Something went wrong.")
                        completion(false)
                    }
                }
            }
            //let dataArray = result as NSArray
            // let dataArray2nd = dataArray
            
        } catch {
            print("Fetching data Failed")
            completion(false)
        }
    }
    
}
