//
//  Community.swift
//  ePoltry
//
//  Created by MacBook Pro on 23/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class Community: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = 65
        if IPAD{
            return CGFloat(height*2)
        }
        return CGFloat(height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrUserId_sectionOne.count
        }
        else{
            return arrUserId.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "CommunityCell") as! CommunityCell
        let index = indexPath.row
        var tempurl = ""
        if indexPath.section == 0 {
            cell.lbltitle.text = arrName_sectionOne[index] as? String ?? ""
            let tempRole = arrRole_sectionOne[index] as? String ?? ""
            if tempRole == "user" || tempRole == "User" {
                cell.lbltype.isHidden = true
            }
            else{
                cell.lbltype.text = arrRole_sectionOne[index] as? String ?? ""
                cell.lbltype.isHidden = false
            }
            tempurl = "\(userimagepath)\(self.arrProfileImage_sectionOne[index] as? String ?? "")"
        }
        else {
            cell.lbltitle.text = arrName[index] as? String ?? ""
            let tempRole = arrRole[index] as? String ?? ""
            if tempRole == "user" || tempRole == "User" {
                cell.lbltype.isHidden = true
            }
            else{
                cell.lbltype.text = arrRole[index] as? String ?? ""
                cell.lbltype.isHidden = false
            }
            tempurl = "\(userimagepath)\(self.arrProfileImage[index] as? String ?? "")"
        }
        obj.setimageCircle(image: cell.imgvprofile, viewcontroller: self)
        obj.setImageHeighWidth4Pad(image: cell.imgvprofile, viewcontroller: self)
        
        cell.imgvprofile.kf.setImage(with: URL(string: tempurl)) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
                cell.imgvprofile.image = value.image
            case .failure(let error):
                print("Error: \(error)")
                cell.imgvprofile.image = UIImage(named: "user")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tempRole = ""
        let index = indexPath.row
        var tempUserId = ""
        var tempIsSuperAdmin = ""
        if indexPath.section == 0 {
            tempRole = arrRole_sectionOne[index] as? String ?? ""
            tempUserId = "\(arrUserId_sectionOne[indexPath.row])"
            tempIsSuperAdmin = "\(arrIsAdmin_sectionOne[indexPath.row])"
        }
        else {
            tempRole = arrRole[index] as? String ?? ""
            tempUserId = "\(arrUserId[indexPath.row])"
            tempIsSuperAdmin = "\(arrIsAdmin[indexPath.row])"
        }
        
        if tempAdmin! && tempUserId != USERID && tempIsSuperAdmin != "1"{
            let alert = UIAlertController(title: "", message: "View Options", preferredStyle: .alert)
            let ViewProfile = UIAlertAction(title: "Profile", style: .default)
            { (action) in
                self.funShowProfile(indexPath: indexPath)
            }
            alert.addAction(ViewProfile)
            
            var MakeRemoveAdmin = UIAlertAction()
            
            if tempRole == "user" || tempRole == "User" {
                MakeRemoveAdmin = UIAlertAction(title: "Make Group Admin", style: .default) {
                    (action) in
                    self.funMakeRemoveAdmin(role: "Admin", indexPath: indexPath)
                }
            }
            else{
                MakeRemoveAdmin = UIAlertAction(title: "Dismiss as Admin", style: .default) {
                    (action) in
                    self.funMakeRemoveAdmin(role: "user", indexPath: indexPath)
                }
            }
            alert.addAction(MakeRemoveAdmin)
            let Cancel = UIAlertAction(title: "Cancel", style: .default)
            { (action) in
                
            }
            alert.addAction(Cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
        else{
            funShowProfile(indexPath: indexPath)
        }
    }
    
    func funShowProfile(indexPath: IndexPath){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileShort") as! ProfileShort
         if indexPath.section == 0 {
            vc.userdetailid = "\(self.arrUserId_sectionOne[indexPath.row])"
            vc.username = "\(self.arrUserName_sectionOne[indexPath.row])"
         }
         else {
            vc.userdetailid = "\(self.arrUserId[indexPath.row])"
            vc.username = "\(self.arrUserName[indexPath.row])"
         }
        // vc.request = arr[indexPath.row]
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var tempAdmin : Bool?
    override func viewDidLoad() {
        if tempIsAdmin == "Admin" || defaults.value(forKey: "isadmin") as? String == "1" {
            tempAdmin = true
        }
        else{
            tempAdmin = false
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "CommunityCell")
        // Comment to receive notification
        // MARK : - Remove Notification
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateCommunity), name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
        GetChannelMembers()
        self.tablev.tableFooterView = UIView()
    }
    
    //Marks: - Handle Notification
    @objc func handleUpdateCommunity()
    {
        GetChannelMembers()
    }
    
    //MARK: - Activity andicator with footer view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tempdic = ["tablev": tablev]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollviewScroll"), object: tempdic)
    }
    
    var arrChannelId = [Any]()
    var arrUserId = [Any]()
    var arrCity = [Any]()
    var arrIsActive = [Any]()
    var arrIsAdmin = [Any]()
    var arrIsOnline = [Any]()
    var arrLastSeen = [Any]()
    var arrMemberId = [Any]()
    var arrName = [Any]()
    var arrRole = [Any]()
    var arrFCMToken = [Any]()
    var arrMobileNo = [Any]()
    var arrProfileImage = [Any]()
    var arrUserName = [Any]()
    var arrVersion = [Any]()
    
    var arrChannelId_sectionOne = [Any]()
    var arrUserId_sectionOne = [Any]()
    var arrCity_sectionOne = [Any]()
    var arrIsActive_sectionOne = [Any]()
    var arrIsAdmin_sectionOne = [Any]()
    var arrIsOnline_sectionOne = [Any]()
    var arrLastSeen_sectionOne = [Any]()
    var arrMemberId_sectionOne = [Any]()
    var arrName_sectionOne = [Any]()
    var arrRole_sectionOne = [Any]()
    var arrFCMToken_sectionOne = [Any]()
    var arrMobileNo_sectionOne = [Any]()
    var arrProfileImage_sectionOne = [Any]()
    var arrUserName_sectionOne = [Any]()
    var arrVersion_sectionOne = [Any]()
    
    func GetChannelMembers() {
        let url = BASEURL+"channelmembers/\(NEWsChannelID)"
       //let url = DataContainer.baseUrl()+"channels/\("35907")"
       // print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
              
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil{
                        if responseObject!.count > 0{
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0{
                                let dataarr = (datadic.value(forKey: "data") as! NSArray)
                                if dataarr.count == 0{
                                    
                                }
                                else if dataarr.count == 0{
                                }
                                else{
                                    
                                    self.arrChannelId_sectionOne = [Any]()
                                    self.arrUserId_sectionOne = [Any]()
                                    self.arrCity_sectionOne = [Any]()
                                    self.arrIsActive_sectionOne = [Any]()
                                    self.arrIsAdmin_sectionOne = [Any]()
                                    self.arrIsOnline_sectionOne = [Any]()
                                    self.arrLastSeen_sectionOne = [Any]()
                                    self.arrMemberId_sectionOne = [Any]()
                                    self.arrName_sectionOne = [Any]()
                                    self.arrRole_sectionOne = [Any]()
                                    self.arrFCMToken_sectionOne = [Any]()
                                    self.arrMobileNo_sectionOne = [Any]()
                                    self.arrProfileImage_sectionOne = [Any]()
                                    self.arrUserName_sectionOne = [Any]()
                                    self.arrVersion_sectionOne = [Any]()
                                    
                                    self.arrChannelId = dataarr.value(forKey: "ChannelId") as! [Any]
                                    self.arrCity = dataarr.value(forKey: "City") as! [Any]
                                    self.arrIsActive = dataarr.value(forKey: "IsActive") as! [Any]
                                    self.arrIsAdmin = dataarr.value(forKey: "IsAdmin") as! [Any]
                                    self.arrIsOnline = dataarr.value(forKey: "IsOnline") as! [Any]
                                    self.arrLastSeen = dataarr.value(forKey: "LastSeen") as! [Any]
                                    self.arrMemberId = dataarr.value(forKey: "MemberId") as! [Any]
                                    self.arrName = dataarr.value(forKey: "Name") as! [Any]
                                    self.arrRole = dataarr.value(forKey: "Role") as! [Any]
                                    self.arrUserId = dataarr.value(forKey: "UserId") as! [Any]
                                    self.arrFCMToken = dataarr.value(forKey: "gcm_id") as! [Any]
                                    self.arrMobileNo = dataarr.value(forKey: "mobile") as! [Any]
                                    self.arrProfileImage = dataarr.value(forKey: "profile_img") as! [Any]
                                    self.arrUserName = dataarr.value(forKey: "username") as! [Any]
                                    self.arrVersion = dataarr.value(forKey: "version") as! [Any]
                                    
                                    var temp = self.arrUserId as NSArray
                                    let tempArray = temp.mutableCopy() as! [Int]
                                    var temp2nd = temp.mutableCopy() as! [Int]
                                    if tempArray.contains(Int(USERID)!){
                                        if let indexof = temp2nd.firstIndex(of: Int(USERID)!){
                                            if self.arrRole[indexof] as! String == "Admin" || self.arrRole[indexof] as! String == "admin"{
                                                self.arrChannelId_sectionOne.append(self.arrChannelId[indexof])
                                                self.arrCity_sectionOne.append(self.arrCity[indexof])
                                                self.arrIsActive_sectionOne.append(self.arrIsActive[indexof])
                                                self.arrIsAdmin_sectionOne.append(self.arrIsAdmin[indexof])
                                                self.arrIsOnline_sectionOne.append(self.arrIsOnline[indexof])
                                                self.arrLastSeen_sectionOne.append(self.arrLastSeen[indexof])
                                                self.arrMemberId_sectionOne.append(self.arrMemberId[indexof])
                                                self.arrName_sectionOne.append(self.arrName[indexof])
                                                self.arrRole_sectionOne.append(self.arrRole[indexof])
                                                self.arrUserId_sectionOne.append(self.arrUserId[indexof])
                                                self.arrFCMToken_sectionOne.append(self.arrFCMToken[indexof])
                                                self.arrMobileNo_sectionOne.append(self.arrMobileNo[indexof])
                                                self.arrProfileImage_sectionOne.append(self.arrProfileImage[indexof])
                                                self.arrUserName_sectionOne.append(self.arrUserName[indexof])
                                                self.arrVersion_sectionOne.append(self.arrVersion[indexof])
                                                
                                                self.arrChannelId.remove(at: indexof)
                                                self.arrCity.remove(at: indexof)
                                                self.arrIsActive.remove(at: indexof)
                                                self.arrIsAdmin.remove(at: indexof)
                                                self.arrIsOnline.remove(at: indexof)
                                                self.arrLastSeen.remove(at: indexof)
                                                self.arrMemberId.remove(at: indexof)
                                                self.arrName.remove(at: indexof)
                                                self.arrRole.remove(at: indexof)
                                                self.arrUserId.remove(at: indexof)
                                                self.arrFCMToken.remove(at: indexof)
                                                self.arrMobileNo.remove(at: indexof)
                                                self.arrProfileImage.remove(at: indexof)
                                                self.arrUserName.remove(at: indexof)
                                                self.arrVersion.remove(at: indexof)
                                            }
//                                            else{
//                                                self.arrChannelId_sectionOne.swapAt(indexof, 0)
//                                                self.arrCity_sectionOne.swapAt(indexof, 0)
//                                                self.arrIsActive_sectionOne.swapAt(indexof, 0)
//                                                self.arrIsAdmin_sectionOne.swapAt(indexof, 0)
//                                                self.arrIsOnline_sectionOne.swapAt(indexof, 0)
//                                                self.arrLastSeen_sectionOne.swapAt(indexof, 0)
//                                                self.arrMemberId_sectionOne.swapAt(indexof, 0)
//                                                self.arrName_sectionOne.swapAt(indexof, 0)
//                                                self.arrRole_sectionOne.swapAt(indexof, 0)
//                                                self.arrUserId_sectionOne.swapAt(indexof, 0)
//                                                self.arrFCMToken_sectionOne.swapAt(indexof, 0)
//                                                self.arrMobileNo_sectionOne.swapAt(indexof, 0)
//                                                self.arrProfileImage_sectionOne.swapAt(indexof, 0)
//                                                self.arrUserName_sectionOne.swapAt(indexof, 0)
//                                                self.arrVersion_sectionOne.swapAt(indexof, 0)
//                                            }
                                        }
                                    }
                                    
                                    temp = self.arrUserId as NSArray
                                    var indexs = [Int]()
                                    let temprolearray = self.arrRole
                                    for (index, element) in temprolearray.enumerated() {
                                        print(index,element)
                                        if (element as! String) == "Admin" || (element as! String) == "admin" {
                                            
                                            self.arrChannelId_sectionOne.append(self.arrChannelId[index])
                                            self.arrCity_sectionOne.append(self.arrCity[index])
                                            self.arrIsActive_sectionOne.append(self.arrIsActive[index])
                                            self.arrIsAdmin_sectionOne.append(self.arrIsAdmin[index])
                                            self.arrIsOnline_sectionOne.append(self.arrIsOnline[index])
                                            self.arrLastSeen_sectionOne.append(self.arrLastSeen[index])
                                            self.arrMemberId_sectionOne.append(self.arrMemberId[index])
                                            self.arrName_sectionOne.append(self.arrName[index])
                                            self.arrRole_sectionOne.append(self.arrRole[index])
                                            self.arrUserId_sectionOne.append(self.arrUserId[index])
                                            self.arrFCMToken_sectionOne.append(self.arrFCMToken[index])
                                            self.arrMobileNo_sectionOne.append(self.arrMobileNo[index])
                                            self.arrProfileImage_sectionOne.append(self.arrProfileImage[index])
                                            self.arrUserName_sectionOne.append(self.arrUserName[index])
                                            self.arrVersion_sectionOne.append(self.arrVersion[index])
                                            
                                            indexs.append(index)
                                        }
                                    }
                                    
                                    for index in indexs{
                                        temp2nd = (self.arrUserId as NSArray) as! [Int]
                                        let indexof = temp2nd.firstIndex(of: temp[index] as! Int)!
                                        self.arrChannelId.remove(at: indexof)
                                        self.arrCity.remove(at: indexof)
                                        self.arrIsActive.remove(at: indexof)
                                        self.arrIsAdmin.remove(at: indexof)
                                        self.arrIsOnline.remove(at: indexof)
                                        self.arrLastSeen.remove(at: indexof)
                                        self.arrMemberId.remove(at: indexof)
                                        self.arrName.remove(at: indexof)
                                        self.arrRole.remove(at: indexof)
                                        self.arrUserId.remove(at: indexof)
                                        self.arrFCMToken.remove(at: indexof)
                                        self.arrMobileNo.remove(at: indexof)
                                        self.arrProfileImage.remove(at: indexof)
                                        self.arrUserName.remove(at: indexof)
                                        self.arrVersion.remove(at: indexof)
                                    }
                                    
                                    self.tablev.reloadData()
                                }
                            }
                            else
                            {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else
                        {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                        obj.showAlert(title: "Error", message: "error!", viewController: self)
                    }
                }
        })
    }
    
    func funMakeRemoveAdmin(role: String, indexPath: IndexPath){
        var tempUserId = ""
        if indexPath.section == 0{
            tempUserId = "\(arrUserId_sectionOne[indexPath.row])"
        }
        else {
            tempUserId = "\(arrUserId[indexPath.row])"
        }
        
        let url = BASEURL+"channelmember/\(NEWsChannelID)"
        let parameters : Parameters =
            ["ChannelId": NEWsChannelID,
             "UserId": tempUserId,
             "IsActive": 1,
             "Role": role]
        andicator.startAnimating()
        obj.webServicePutUpdateUser(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            if error == nil && responseObject != nil{
                
                if responseObject!.count > 0{
                    
                    let datadic = (responseObject! as NSDictionary)
                    if datadic.count > 0{
                        self.GetChannelMembers()
                    }
                    else{
                        
                    }
                }
            }
        })
    }
    
}

// MARK: - IndicatorInfoProvider for page controller like android
extension Community: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "COMMUNITY")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Community")
        return itemInfo
    }
}
