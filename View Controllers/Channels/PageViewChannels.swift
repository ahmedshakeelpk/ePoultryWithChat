//
//  PageViewChannels.swift
//  ePoltry
//
//  Created by MacBook Pro on 22/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import Alamofire

var tempIsAdmin = ""
var isChannelSuperAdminID = ""
class PageViewChannels: UIViewController, UITableViewDataSource, UITableViewDelegate, PageViewChannelCellDelegates, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIDocumentPickerDelegate, TagFilterDelegate, UIScrollViewDelegate {
    func search(searchTag: String, dateStr: String, dateStrFrom: String, dateStrTo: String, searchTitle: String) {
        print(searchTag)
        NEWsChannelFromDate = dateStrFrom
        NEWsChannelToDate = dateStrTo
        NEWsChannelSEARCHTitle = searchTitle
        NEWsChannelSEARCHTags = searchTag
        NEWsChannelEventDate = dateStr
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: nil)
    }
    
    func tableViewTag(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    var isLive = false
    var isLiveLink = ""
    var isLiveTitle = ""
    var numberOfFollowers = ""
    var MyFollowing = 0
    var ChannelMembers = ""
    var isAdminForChannel = false
    var profileImage = ""
    var coverImage = ""
    var channeldesc = ""
    var arrTags = NSArray()
    
    @IBOutlet weak var btnGoLive: UIButton!
    @IBAction func btnGoLive(_ sender: Any) {
        if self.isLive && isChannelSuperAdminID == USERID && btnGoLive.titleLabel!.text == "Watch Live!" {
            funConfirmationPopup()
        }
        else if btnGoLive.titleLabel!.text == "Watch Live!" {
            self.funWatchLive()
        }
        else if btnGoLive.titleLabel!.text == "Go Live!" { 
            let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "GoLive") as! GoLive
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var vheader: UIView!
    var pagecontrollheight = CGFloat()
    
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var imgvCoverCamera: UIImageView!
    @IBOutlet weak var imgvProfileCamera: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    
    @IBOutlet weak var btnUpdateCoverImage: UIButton!
    @IBAction func btnUpdateCoverImage(_ sender: Any) {
        btnUpdateCoverImage.tag = 1
        btnUpdateChannelProfileImage.tag = 0
        self.showActionSheet(sender: sender)
    }
    
    @IBOutlet weak var btnUpdateChannelProfileImage: UIButton!
    @IBAction func btnUpdateChannelProfileImage(_ sender: Any) {
        btnUpdateCoverImage.tag = 0
        btnUpdateChannelProfileImage.tag = 1
        self.showActionSheet(sender: sender)
    }
    
    @IBOutlet weak var btnShowCoverImage: UIButton!
    @IBAction func btnShowCoverImage(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        var tempUrl: String?
        vc.videoimagetag = IMAGE
        vc.videoimagename = coverImage
        tempUrl = imagepath+coverImage
        if coverImage == ""{
            vc.videoimagename = profileImage
            tempUrl = imagepath+profileImage
        }
        obj.funForceDownloadPlayShow(urlString: tempUrl!, isProgressBarShow: true, viewController: self, completion: {
            url in
            
            if url == ""{
                vc.profilepic = UIImage(named: "tempimg")!
            }
            else{
                vc.strurl = url!
            }
            //MARK:- Reload image row after download
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    @IBOutlet weak var btn1: UIButton!
    @IBAction func btn1(_ sender: Any) {
        if arrProfileImage.count == 0{
            return
        }
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        var tempUrl: String?
        vc.videoimagetag = IMAGE
        vc.videoimagename = profileImage
        tempUrl = "\(userimagepath)\(self.arrProfileImage[0] as? String ?? "")"
        obj.funForceDownloadPlayShow(urlString: tempUrl!, isProgressBarShow: true, viewController: self, completion: {
            url in
            
            if url == ""{
                vc.profilepic = UIImage(named: "tempimg")!
            }
            else{
                vc.strurl = url!
            }
            //MARK:- Reload image row after download
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    @IBOutlet weak var btn2: UIButton!
    @IBAction func btn2(_ sender: Any) {
        if arrProfileImage.count < 1{
            return
        }
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        var tempUrl: String?
        vc.videoimagetag = IMAGE
        vc.videoimagename = profileImage
        tempUrl = "\(userimagepath)\(self.arrProfileImage[1] as? String ?? "")"
        obj.funForceDownloadPlayShow(urlString: tempUrl!, isProgressBarShow: true, viewController: self, completion: {
            url in
            
            if url == ""{
                vc.profilepic = UIImage(named: "tempimg")!
            }
            else{
                vc.strurl = url!
            }
            //MARK:- Reload image row after download
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    @IBOutlet weak var btn3: UIButton!
    @IBAction func btn3(_ sender: Any) {
        if arrProfileImage.count < 2{
            return
        }
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        var tempUrl: String?
        vc.videoimagetag = IMAGE
        vc.videoimagename = profileImage
        tempUrl = "\(userimagepath)\(self.arrProfileImage[2] as? String ?? "")"
        obj.funForceDownloadPlayShow(urlString: tempUrl!, isProgressBarShow: true, viewController: self, completion: {
            url in
            
            if url == ""{
                vc.profilepic = UIImage(named: "tempimg")!
            }
            else{
                vc.strurl = url!
            }
            //MARK:- Reload image row after download
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
        
    @IBOutlet weak var btnShowProfileImage: UIButton!
    @IBAction func btnShowProfileImage(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        var tempUrl: String?
        vc.videoimagetag = IMAGE
        vc.videoimagename = profileImage
        tempUrl = imagepath+profileImage
        obj.funForceDownloadPlayShow(urlString: tempUrl!, isProgressBarShow: true, viewController: self, completion: {
            url in
            
            if url == ""{
                vc.profilepic = UIImage(named: "tempimg")!
            }
            else{
                vc.strurl = url!
            }
            //MARK:- Reload image row after download
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    @IBOutlet weak var btnfollow: UIButton!
    @IBAction func btnfollow(_ sender: Any) {
        if self.MyFollowing == 0{
            funFollow()
        }
        else{
            funUnFollow()
        }
    }
    
    @IBOutlet weak var imgv1: UIImageView!
    @IBOutlet weak var imgv2: UIImageView!
    @IBOutlet weak var imgv3: UIImageView!
    
    @IBOutlet weak var lbl2nddesc: UILabel!
    
    @IBOutlet weak var btntagFilter: UIButton!
    @IBAction func btntagFilter(_ sender: Any) {
        
    }
    
    @objc func funTagFilter(){
        TagFilter.showTagPopup(arrSource: arrTags as NSArray, viewController: self)
    }
    
    @IBOutlet weak var btnaddpost: UIButton!
    @IBAction func btnaddpost(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddnewPost") as! AddnewPost
        vc.newsvideostag = "public"
        vc.type = "News"
        vc.posttype = "news"
        vc.statusid = NEWsChannelID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        btnGoLive.isHidden = true
        headerContentHeight = self.vheader.frame.height
        NEWsChannelisAdmin = false
        tablev.tableHeaderView = vheader
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "PageViewChannelCell", bundle: nil), forCellReuseIdentifier: "PageViewChannelCell")
        
        self.title = "Channel"
        
        
        obj.setImageHeighWidth4Pad(image: imgvprofile, viewcontroller: self)
        obj.setImageHeighWidth4Pad(image: imgv1, viewcontroller: self)
        obj.setImageHeighWidth4Pad(image: imgv2, viewcontroller: self)
        obj.setImageHeighWidth4Pad(image: imgv3, viewcontroller: self)
        
        obj.setimageCircle(image: imgvprofile, viewcontroller: self)
        obj.setimageCircle(image: imgv1, viewcontroller: self)
        obj.setimageCircle(image: imgv2, viewcontroller: self)
        obj.setimageCircle(image: imgv3, viewcontroller: self)
        borderForImage(imgv: imgvprofile)
        borderForImage(imgv: imgv1)
        borderForImage(imgv: imgv2)
        borderForImage(imgv: imgv3)
        btnfollow.layer.cornerRadius = 4
        
        setLocalData()
        self.GetChannelMembers()
        self.GetChannelDetails()
        self.GetChannelTags()
        // Back Button with image
        let backBtn = UIBarButtonItem(image: UIImage.init(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // Marks: - Right Search button
        let searchTag:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(funTagFilter))
        self.navigationItem.setRightBarButtonItems([searchTag], animated: true)
        
        // MARK : - Remove Notification
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateCommunity), name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didScrollCustom), name: NSNotification.Name(rawValue: "scrollviewScroll"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(funisAdmin), name: NSNotification.Name(rawValue: "isAdmin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funisLiveNotification), name: NSNotification.Name(rawValue: "funisLiveNotification"), object: nil)
        
        btnaddpost.layer.cornerRadius = btnaddpost.frame.width / 2
        btnaddpost.isHidden = true
        super.viewDidLoad()
    }
    
    func setLocalData() {
        DispatchQueue.main.async {
            self.imgvprofile.image = NEWsHeaderimage
            self.lblname.text = NEWsChannelName
            self.imgv1.image = NEWsHeaderimage
            self.imgv2.image = NEWsHeaderimage
            self.imgv3.image = NEWsHeaderimage
            
            obj.set3LinesTitle(topline: NEWsChannelName, middleline: NEWsChannelDescription, bottomline: "No followers", label: self.lblname)
        }
    }

    // variable to save the last position visited, default to zero
    private var lastContentOffset: CGFloat = 0
    let screenHeight = UIScreen.main.bounds.height
    var headerContentHeight = CGFloat()
    var tempTableView = UITableView()
    var tempColV: UICollectionView?
    @objc func didScrollCustom(notification: Notification) {
        var yOffset = CGFloat()
        let tempdata = notification.object as! NSDictionary
        if let temp = tempdata.value(forKey: "tablev") as? UITableView {
            self.tablev.isScrollEnabled = true
            tempTableView = temp
            yOffset = tempTableView.contentOffset.y
        }
        else if let temp = tempdata.value(forKey: "colv") as? UICollectionView {
            //tablev.isScrollEnabled = false
            tempColV = temp
            yOffset = temp.contentOffset.y
        }
//        print("LAST OFFSET: \(lastContentOffset)")
//        print("Current OFFSET: \(yOffset)")
        if yOffset >= headerContentHeight - 20 {
            print("move up")
            self.tablev.isScrollEnabled = false
            return
        }
        else {
            print("move down")
            self.tablev.isScrollEnabled = true
        }
        if (tempdata.value(forKey: "tablev") as? UITableView) != nil{
            tablev.contentOffset.y = tempTableView.contentOffset.y
        }
        else if (tempdata.value(forKey: "colv") as? UICollectionView) != nil{
            tablev.contentOffset.y = tempColV!.contentOffset.y
        }
        // update the new position acquired
        self.lastContentOffset = yOffset
    }
    
    @objc func funisAdmin() {
        btnaddpost.isHidden = false
    }
    //Marks: - Handle Notification
    @objc func handleUpdateCommunity() {
        setLocalData()
        self.GetChannelMembers()
        self.GetChannelDetails()
        self.GetChannelTags()
    }
    //Marks: - Handle Notification
    @objc func funEdit(sender: UIButton) {
        let vc = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "AddNewChannel") as! AddNewChannel
        vc.isEdit = true
        if (imgvprofile!.image != nil) {
            vc.channelimage = imgvprofile.image!
        }
        else {
            vc.channelimage = UIImage(named: "groupimg")!
        }
        vc.channeltitle = NEWsChannelName
        vc.channeldesc = NEWsChannelDescription
        vc.channelid = NEWsChannelID
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func borderForImage(imgv: UIImageView){
        imgv.layer.borderColor = appclr.cgColor
        imgv.layer.borderWidth = 0.8
    }
    
    @objc func funback()
    {
        NEWsChannelSEARCHTags = "All"
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "PageViewChannelCell") as! PageViewChannelCell
        cell.pageViewChannelCellDelegate = self
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellheight = self.view.frame.height - 20
        //let tempheight = cellheight * 15 / 100
        //cellheight = cellheight - tempheight
        return cellheight
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return vheader.frame.height
//    }
//
    func addThisViewControllerAsChild(pcvc: ChannelsPC) {
        self.addChild(pcvc)
    }
    
    var arrChannelId = [Any]()
    var arrUserId = [Any]()
    var arrCity = [Any]()
    var arrIsActive = [Any]()
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
    
    func GetChannelMembers() {
        let url = BASEURL+"channelmembers/\(NEWsChannelID)"
       //let url = DataContainer.baseUrl()+"channels/\("35907")"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
              
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                let dataarr = (datadic.value(forKey: "data") as! NSArray)
                                if dataarr.count == 0 { }
                                else if dataarr.count == 0 { }
                                else {
                                    
                                    self.arrChannelId = dataarr.value(forKey: "ChannelId") as! [Any]
                                    self.arrCity = dataarr.value(forKey: "City") as! [Any]
                                    self.arrIsActive = dataarr.value(forKey: "IsActive") as! [Any]
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
                                    
                                    
                                    let tempUsersIds = self.arrUserId as! [Int]
                                    if let tempindex = tempUsersIds.firstIndex(of: Int(defaults.value(forKey: "userid") as! String)!){
                                        tempIsAdmin = self.arrRole[tempindex] as! String
                                    }
                                    //MARK:- Edit option for admin user
                                    if tempIsAdmin == "Admin" || defaults.value(forKey: "isadmin") as? String == "1"{
                                        self.GetChannelDetails()
                                        //MARK:- Admin User
                                        self.isAdminForChannel = true
                                        self.btnUpdateCoverImage.isHidden = false
                                        self.imgvCoverCamera.isHidden = false
                                        self.btnUpdateChannelProfileImage.isHidden = false
                                        self.imgvProfileCamera.isHidden = false
                                        // Edit Button with title
                                        let editBtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.funEdit))
                                        // Marks: - Right Search button
                                        let searchTag:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(self.funTagFilter))
                                        self.navigationItem.setRightBarButtonItems([editBtn, searchTag], animated: true)
                                        
                                        NEWsChannelisAdmin = true
                                        DispatchQueue.main.async {
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isAdmin"), object: nil)
                                        }
                                        
                                    }
                                    else {
                                        //MARK:- Normal User
                                        self.btnUpdateCoverImage.isHidden = true
                                        self.imgvCoverCamera.isHidden = true
                                        self.btnUpdateChannelProfileImage.isHidden = true
                                        self.imgvProfileCamera.isHidden = true
                                    }

                                    let tempnamearray = self.arrName as! [String]
                                    self.ChannelMembers = tempnamearray.joined(separator: ", ")
                                    self.lbl2nddesc.text = self.ChannelMembers
                                    
                                    if self.arrProfileImage.count > 0{
                                        //MARK:- Image 1
                                        let tempimg1 = "\(userimagepath)\(self.arrProfileImage[0] as? String ?? "")"
                                        self.imgv1.kf.setImage(with: URL(string: tempimg1)) { result in
                                            switch result {
                                            case .success(let value):
                                                print("Image: \(value.image). Got from: \(value.cacheType)")
                                                self.imgv1.image = value.image
                                            case .failure(let error):
                                                print("Error: \(error)")
                                                self.imgv1.image = UIImage(named: "user")
                                            }
                                        }
                                    }
                                    
                                    if self.arrProfileImage.count > 1 {
                                        //MARK:- Image 2
                                        let tempimg12 = "\(userimagepath)\(self.arrProfileImage[1] as? String ?? "")"
                                        self.imgv2.kf.setImage(with: URL(string: tempimg12)) { result in
                                            switch result {
                                            case .success(let value):
                                                print("Image: \(value.image). Got from: \(value.cacheType)")
                                                self.imgv2.image = value.image
                                            case .failure(let error):
                                                print("Error: \(error)")
                                                self.imgv2.image = UIImage(named: "user")
                                            }
                                        }
                                    }
                                    
                                    if self.arrProfileImage.count > 2{
                                        //MARK:- Image 3 j
                                        let tempimg3 = "\(userimagepath)\(self.arrProfileImage[2] as? String ?? "")"
                                        self.imgv3.kf.setImage(with: URL(string: tempimg3)) { result in
                                            switch result {
                                            case .success(let value):
                                                print("Image: \(value.image). Got from: \(value.cacheType)")
                                                self.imgv3.image = value.image
                                            case .failure(let error):
                                                print("Error: \(error)")
                                                self.imgv3.image = UIImage(named: "user")
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        obj.showAlert(title: "Error", message: "error!", viewController: self)
                    }
                }
        })
    }
    func GetChannelTags() {
        let url = BASEURL+"tag/\(NEWsChannelID)/channel"
       //let url = DataContainer.baseUrl()+"channels/\("35907")"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
              
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                var temptagstring = (datadic.value(forKey: "data") as! String)
                                temptagstring = temptagstring.replacingOccurrences(of: " ", with: "")
                                let tagarray = temptagstring.split(separator: ",")
                                if tagarray.count > 0{
                                    self.arrTags = tagarray as NSArray
                                }
                            }
                            else {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        obj.showAlert(title: "Error", message: "error!", viewController: self)
                    }
                }
        })
    }
    func GetChannelDetails() {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"channel/\(NEWsChannelID)/userId/\(userid)"
       //let url = DataContainer.baseUrl()+"channels/\("35907")"
        
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
              
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            var datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                let tempdataArray = responseObject?.value(forKey: "data") as! NSArray
                                datadic = tempdataArray[0] as! NSDictionary
                                self.numberOfFollowers = "\(responseObject?.value(forKey: "NoOfFollowings") as! Int)"
                                self.MyFollowing = responseObject?.value(forKey: "MyFollowing") as! Int
                                if self.MyFollowing == 1{
                                    self.btnfollow.setTitle("Unfollow", for: .normal)
                                    self.btnfollow.backgroundColor = .lightGray
                                }
                                else{
                                    self.btnfollow.setTitle("Follow", for: .normal)
                                    self.btnfollow.backgroundColor = appclr
                                }
                                let coverimg = datadic.value(forKey: "ImagePath") as? String ?? ""
                                self.isLive = datadic.value(forKey: "IsLive") as? Bool ?? false
                                self.isLiveLink = datadic.value(forKey: "LiveLink") as? String ?? ""
                                self.isLiveTitle = datadic.value(forKey: "LiveTitle") as? String ?? ""
                                if let temp = datadic.value(forKey: "UserId") as? Int {
                                    isChannelSuperAdminID = "\(temp)"
                                }
                                
                                if self.isLive && isChannelSuperAdminID == USERID {
                                    self.btnGoLive.isHidden = false
                                    self.btnGoLive.setTitle("Watch Live!", for: .normal)
                                    print("Live")
                                }
                                else if isChannelSuperAdminID == USERID {
                                    print("Go Live for Admin")
                                    self.btnGoLive.isHidden = false
                                    self.btnGoLive.setTitle("Go Live!", for: .normal)
                                }
                                else if self.isLive {
                                    self.btnGoLive.isHidden = false
                                    self.btnGoLive.setTitle("Watch Live!", for: .normal)
                                    print("Live")
                                }
                                else {
                                    self.btnGoLive.isHidden = true
                                }
                                let profileimg = datadic.value(forKey: "thumbnail") as? String ?? ""
                                
                                self.coverImage = coverimg
                                self.profileImage = profileimg
                                self.imgvprofile.image = NEWsHeaderimage
                                self.imgvprofile.kf.setImage(with: URL(string: imagepath+profileimg)) { result in
                                    switch result {
                                    case .success(let value):
                                        print("Image: \(value.image). Got from: \(value.cacheType)")
                                        self.imgvprofile.image = value.image
                                    case .failure(let error):
                                        print("Error: \(error)")
                                        //self.imgvprofile = NEWsHeaderimage
                                    }
                                }
                                self.imgv.kf.setImage(with: URL(string: imagepath+coverimg)) { result in
                                    switch result {
                                    case .success(let value):
                                        print("Image: \(value.image). Got from: \(value.cacheType)")
                                        self.imgv.image = value.image
                                    case .failure(let error):
                                        print("Error: \(error)")
                                        self.imgv.image = NEWsHeaderimage
                                    }
                                }
                                
                                obj.set3LinesTitle(topline: NEWsChannelName, middleline: NEWsChannelDescription, bottomline: "\(self.numberOfFollowers) followers", label: self.lblname)
                            }
                            else {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        obj.showAlert(title: "Error", message: "error!", viewController: self)
                    }
                }
        })
    }
    
    // Marks: - Like
    func funFollow() {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"/channelmember"
        let parameters : Parameters =
            ["ChannelId": NEWsChannelID,
             "UserId": userid,
             "IsActive": 1,
             "Role": "user",]
        
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                if self.MyFollowing == 0{
                                    self.MyFollowing = 1
                                    self.btnfollow.setTitle("Unfollow", for: .normal)
                                    self.btnfollow.backgroundColor = .lightGray
                                }
                                else {
                                    self.MyFollowing = 0
                                    self.btnfollow.setTitle("Follow", for: .normal)
                                    self.btnfollow.backgroundColor = appclr
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetAllchannels"), object: nil)
                            }
                            else {
                                 obj.showAlert(title: "Alert", message: "try again", viewController: self)
                            }
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    // Marks: - Like
    func funUnFollow() {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"/channelmember/\(NEWsChannelID)"

        let parameters : Parameters =
            ["ChannelId": NEWsChannelID,
             "UserId": userid,
             "IsActive": 1,
             "Role": "user",]
        
        andicator.startAnimating()
        obj.webServicePut(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                if self.MyFollowing == 0{
                                    self.MyFollowing = 1
                                    self.btnfollow.setTitle("Unfollow", for: .normal)
                                    self.btnfollow.backgroundColor = .lightGray
                                }
                                else{
                                    self.MyFollowing = 0
                                    self.btnfollow.setTitle("Follow", for: .normal)
                                    self.btnfollow.backgroundColor = appclr
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetAllchannels"), object: nil)
                            }
                            else {
                                 obj.showAlert(title: "Alert", message: "try again", viewController: self)
                            }
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    
    //Open Action Sheet for Camera and Gallery
    //MARK:- Upload image or video Image Picker
    var imagePicker: UIImagePickerController!
    func showActionSheet(sender: Any) {
        var title = String()
        title = "Choose Image"
        let alert:UIAlertController=UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.OpenCamera()
        }
        let gallaryAction = UIAlertAction(title: "Photo Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.OpenGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        // Add the actions
        imagePicker?.delegate = self
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        self.present(alert, animated: true, completion: nil)
        //        //  - See more at:      http://www.theappguruz    .com/blog/user-interaction-camera-using-uiimagepickercontroller-swift#    sthash.WnJ7r5sU.dpuf
        //
    }

    func OpenCamera() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func OpenGallary() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    ////image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageData: NSData = image.jpegData(compressionQuality: 0.4)! as NSData
            
            if self.btnUpdateChannelProfileImage.tag == 1 {
                self.imgvprofile.image = image
            }
            else if self.btnUpdateCoverImage.tag == 1 {
                self.imgv.image = image
            }
            uploadMediaProfilePicture(type: "IMAGE", object: imageData, completion: { filename in
                guard let filename = filename else { return }
                // print(filename)
                if self.btnUpdateChannelProfileImage.tag == 1 {
                    self.imgvprofile.image = image
                    self.funUpdateChannelBanner(imagename: filename, button: self.btnUpdateChannelProfileImage)
                }
                else if self.btnUpdateCoverImage.tag == 1 {
                    self.imgv.image = image
                    self.funUpdateChannelBanner(imagename: filename, button: self.btnUpdateCoverImage)
                }
            })
        }
        else {
            obj.showAlert(title: "Alert!", message: "Your selected video format is not correct",      viewController: self)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil);
    }

    // Marks: - Like
    func funUpdateChannelBanner(imagename: String, button: UIButton) {
        //For Channel Profile image
        var updatetype = ""
        var messagealert = ""
        if button == btnUpdateChannelProfileImage{
            //For Channel Profile Image
            updatetype = "Thumbnail"
            messagealert = "Your channel profile photo updated"
        }
        else if button ==  btnUpdateCoverImage{
            //For Channel Cover Image
            updatetype = "ImagePath"
            messagealert = "Your channel cover photo updated"
        }
                
        let url = BASEURL+"channel/\(NEWsChannelID)/banner"
        let parameters : Parameters =
            [updatetype: imagename]

        andicator.startAnimating()
        obj.webServicePut(url: url, parameters: parameters, completionHandler:{ responseObject, error in

                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetAllchannels"), object: nil)
                                obj.showAlert(title: "Success!", message: messagealert, viewController: self)
                            }
                            else {
                                obj.showAlert(title: "Alert", message: "try again", viewController: self)
                            }
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController:    self)
                        }
                    }
                    else {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }

    //MARK:- Upload image or file to Firebase Storage
    func uploadMedia(type: String, object: NSData, completion: @escaping (_ url: String?) -> Void) {
        let uploadData = object
        var imgdata = Data()
        let timespam = Date().currentTimeMillis()!
        var url = ""
        var imagefilename = ""
        var parameters : Parameters = ["":""]
        if type == "IMAGE" {
            imgdata = uploadData as Data
            imagefilename = "\("\(String(describing: timespam))").png"
            parameters = ["filename":imagefilename]
            url = BASEURL + "Upload/Post?filename=\(imagefilename)"
        }
        andicator.startAnimating()
        obj.webServiceWithPictureAudio(url: url, parameters: parameters, imagefilename: imagefilename,    audiofilename:"" , videofilename: "", imageData: imgdata, audioData: Data(), videoData: Data(), viewController: self,       completionHandler:{

            responseObject, error in
            self.andicator.stopAnimating()
            if error == nil {
                completion(imagefilename)
            }
            else {
                completion("error")
            }
        })
    }
    
    //MARK:- Upload image or file to Firebase Storage
    func uploadMediaProfilePicture(type: String, object: NSData, completion: @escaping (_ url: String?) -> Void) {
        let uploadData = object
        var imgdata = Data()
        let timespam = Date().currentTimeMillis()!
        var imagefilename = ""
        var parameters : Parameters = ["":""]
        if type == "IMAGE" {
            imgdata = uploadData as Data
            imagefilename = "\("\(String(describing: timespam))").png"
            parameters = ["filename":imagefilename]
        }
        andicator.startAnimating()
        obj.webServiceWithProfilePicture(url: imagepathPost, parameters: parameters, imagefilename: imagefilename,    audiofilename:"" , videofilename: "", imageData: imgdata, audioData: Data(), videoData: Data(), viewController: self,       completionHandler:{

            responseObject, error in
            self.andicator.stopAnimating()
            if error == nil || error == "success"{
                completion(imagefilename)
            }
            else {
                completion("error")
            }
        })
    }
    
    func funConfirmationPopup(){
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Watch Live!", message: "", preferredStyle: .alert)
        let stopLive = UIAlertAction(title: "Stop Live!", style: .default)
        { (action) in
            self.funStopLive()
        }
        let watchLive = UIAlertAction(title: "Watch Live!", style: .default)
        { (action) in
            self.funWatchLive()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        { (action) in }
        alert.addAction(stopLive)
        alert.addAction(watchLive)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func funStopLive() {
        let url = BASEURL+"channel/\(NEWsChannelID)/Live"
        let parameters : Parameters =
        ["UserId": USERID,
         "LiveTitle": "",
         "IsLive":false,
         "LiveOnDate":"",
         "LiveOnTime":"",
         "ScheduleForLater":false]
        andicator.startAnimating()
        obj.webServicePutUpdateUser(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
              if error == nil && responseObject != nil {
                if (responseObject!.value(forKey: "data") as? Int) != nil {
                    self.btnGoLive.setTitle("Go Live!", for: .normal)
                    obj.showAlert(title: "Alert!", message: "Live Stopped", viewController: self)
                }
                else {
                    obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                }
            }
            else {
                if error == nil {
                    obj.showAlert(title: "Error!", message: ("error?.description"), viewController: self)
                    return
                }
                obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
            }
        })
    }
    
    
    //Marks: - Video Play button
    @objc func funWatchLive() {
        
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Events") as! Events
        vc.isLiveLink = isLiveLink
        vc.isLiveTitle = isLiveTitle
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
//        vc.videoimagetag = VIDEO
//        vc.videoimagename = ""
//        vc.profilepic = UIImage(named: "tempimg")!
//        vc.strurl = isLiveLink
//        DispatchQueue.main.async {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    @objc func funisLiveNotification() {
        self.btnGoLive.setTitle("Watch Live!", for: .normal)
        GetChannelDetails()
    }
}
