//
//  Post.swift
//  AMPL
//
//  Created by sameer on 02/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import Kingfisher
import CZPicker
import Alamofire
import XLPagerTabStrip

var TwitterLink = ""
var FaceBookLink = ""
var YouTubeLink = ""
class Post: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var refreshc = UIRefreshControl()
    
    
    var pulltorefresh = String()
    //////////////////////////////////////////
    var arrname = [String]()
    var arrdesc = [String]()
    var arrcomment = [String]()
    var arrlike = [String]()
    var arrid = [String]()
    var arrprofileimg = [String]()
    var arrpostimg = [String]()
    var arrisvideo = [String]()
    var arrvideourl = [String]()
    var arrvideoimg = [String]()
    var arrtime = [String]()
    var arrmylike = [String]()
    var arrstatusid = [String]()
    var lastindex = String()
    var commenttag = Int()
    var arrsubTypes = [Any]()
    
    /////// Marks: - For Groups Arrays
    var arrgtitle = [String]()
    var arrgtype = [String]()
    var arrgid = [Any]()
    var arrgimgprofile = [String]()
    var arrgtotalmember = [String]()
    var arrguserstatus = [String]()
    /////////////////////////////////////////
    
    @IBOutlet weak var andicator_colv: UIActivityIndicatorView!
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var btnaddpost: UIButton!
    @IBOutlet weak var andicator2: UIActivityIndicatorView!

    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        updatefcm()
        //self.view.frame.origin.y = (self.navigationController?.navigationBar.frame.maxY)!
        
        let tempheight = (tabBarController?.tabBar.frame.minY)! - (((self.navigationController?.navigationBar.frame.maxY)!))
       // self.view.frame.size.height = tempheight - 500
        
        self.colv.frame.origin.y = (self.navigationController?.navigationBar.frame.maxY)!
        tablev.frame.origin.y = colv.frame.maxY
        self.tablev.frame.size.height = tempheight
         
        btnaddpost.frame.origin.y = (tabBarController?.tabBar.frame.minY)! - (btnaddpost.frame.height + 20)
        
        
        super.viewDidLoad()
        if IPAD{
            
            //self.tablev.frame.size.height = (self.tabBarController?.tabBar.frame.minY)!
        }
        self.colv.register(UINib(nibName: "PostColvCell", bundle: nil), forCellWithReuseIdentifier: "PostColvCell")
        GetSocialLinks()
        DispatchQueue.main.async {
            //MARK : - Activity andicator in footer view
            self.tablev.tableFooterView = self.andicator2
        }
        // MARK : - UIRefresh controll in table View
        refreshc = UIRefreshControl()
        refreshc.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshc.addTarget(self, action: #selector(pulltorefreshfun), for: UIControl.Event.valueChanged)
        tablev.addSubview(refreshc) // not required when using UITableViewController
        
        // MARK : - Remove Notification
        NotificationCenter.default.removeObserver(self)
        // Comment to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationshowComment), name: NSNotification.Name(rawValue: "updatecomment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationshowPost), name: NSNotification.Name(rawValue: "updatepost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationUpdateChannel), name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
        
        if let temp = defaults.value(forKey: "fbRegistration") as? Bool{
            if temp == false{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fbRegistration"), object: nil)
            }
        }
        btnaddpost.layer.cornerRadius = btnaddpost.frame.width / 2
        tablev.rowHeight = 128
        tablev.estimatedRowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
        self.pulltorefresh = "0"
        
        self.GetAllPosts()
        GetUserSponsoredChannels()
        DispatchQueue.global(qos: .background).async {
                self.getallgroups()
        }
        //MARK:- Cell Register
        self.tablev.register(UINib(nibName: "ImgvCell", bundle: nil), forCellReuseIdentifier: "ImgvCell")
        self.tablev.register(UINib(nibName: "LinkCell", bundle: nil), forCellReuseIdentifier: "LinkCell")
        self.tablev.register(UINib(nibName: "DocumentCell", bundle: nil), forCellReuseIdentifier: "DocumentCell")
        self.tablev.register(UINib(nibName: "VideoPostCell", bundle: nil), forCellReuseIdentifier: "cellvideo")
        self.tablev.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    }
    
     //MARK : - Activity andicator in footer view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
           
            // call method to add data to tableView
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hidefooter), userInfo: nil, repeats: false)
        }
    }

    //MARK: - Hide Footer
    @objc func hidefooter()
    {
         tablev.tableFooterView!.isHidden = true
    }
    //Marks: - Profile button
    @objc func profile(sender: UIButton) {
        //let tag = sender.tag
    }
    
    //Marks: - Video Play button
    @objc func playvideo(sender: UIButton) {
     let tag = sender.tag
     let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
     vc.videoimagetag = VIDEO
     vc.videoimagename = arrvideourl[tag]
     
     obj.funForceDownloadPlayShow(urlString: videopath+arrvideourl[tag]+videoPlayEndPath, isProgressBarShow: true, viewController: self, completion: {
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
    //Marks: - Show image button
    @objc func showimage(sender: UIButton) {
        let tag = sender.tag
        if arrsubTypes[tag] as! String == "document"{
            if let url = URL(string: "\(docpath)\(arrpostimg[tag])") {
                UIApplication.shared.open(url)
            }
        }
        else{
            let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
             vc.videoimagetag = IMAGE
             vc.videoimagename = arrpostimg[tag]
             
             obj.funForceDownloadPlayShow(urlString: imagepath+arrpostimg[tag], isProgressBarShow: true, viewController: self, completion: {
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
    }
    
    //Marks: - Like button
    @objc func likefun(sender: UIButton) {
        let tag = sender.tag
        
        if arrmylike[tag] == "0" || arrmylike[tag] == "" {
            self.like(tag: tag)
            var value = Int(self.arrlike[tag])
            if value == nil {
                value = 0
            }
            value = value! + 1
            
            if value! < 0 {
                value = 0
            }
            var strvalue = String()
            strvalue = "\(value!)"
            
            self.arrlike[tag] = strvalue
            
            if self.arrmylike[tag] == "0" {
                self.arrmylike[tag] = "1"
            }
            else {
                self.arrmylike[tag] = "0"
            }
            if value == 0 {
                self.arrmylike[tag] = "0"
            }
        }
        else {
            
            self.unlike(tag: tag)
            var value = Int(self.arrlike[tag])
            if value == nil{
                value = 0
            }
            value = value! - 1
            
            if value! < 0 {
                value = 0
            }
            var strvalue = String()
            strvalue = "\(value!)"
            
            self.arrlike[tag] = strvalue
            
            if self.arrmylike[tag] == "0" {
                self.arrmylike[tag] = "1"
            }
            else {
                self.arrmylike[tag] = "0"
            }
            if value == 0 {
                self.arrmylike[tag] = "0"
            }
        }
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: tag, section: 0)
            self.tablev.reloadRows(at: [indexPath], with: .none)
        }
    }
    //Marks: - Comment button
    @objc func commentfun(sender: UIButton) {
        let tag = sender.tag
        commenttag = tag
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Comments") as! Comments
        vc.type = "Public"
        vc.statusid = arrstatusid[tag]
        vc.totallike = arrlike[tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   // Marks: = Share button
    @objc func sharefun(sender: UIButton) {
        let tag = sender.tag
        let alertController = UIAlertController(title: "Share it!", message: "", preferredStyle:UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Share it to Other", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            
            var desc = self.arrdesc[tag]
            desc = desc + SIGNATURE
            var shareUrl = ""
            UIPasteboard.general.string = desc
            var activityVC = UIActivityViewController(activityItems: [], applicationActivities: nil)
            
            if self.arrsubTypes[tag] as? String == "video"
            {
                //MARK:- Video
                shareUrl = videopath+self.arrvideourl[tag]+videoPlayEndPath+"\n\n"
            }
            else if self.arrsubTypes[tag] as? String == "image"
            {
                //MARK:- Image
                shareUrl = imagepath+self.arrpostimg[tag]+"\n\n"
            }
                
            else if self.arrsubTypes[tag] as? String == "link"{
                //MARK:- Link
            }
            else if self.arrsubTypes[tag] as? String == "document"{
                //MARK:- Document
                shareUrl = docpath+self.arrpostimg[tag]+"\n\n"
            }
            else
            {
                //MARK:- Simple Text

            }
            desc = desc.replacingOccurrences(of: "_&epoultry&_", with: "\n", options: .literal, range: nil)

            activityVC = UIActivityViewController(activityItems: [shareUrl +  desc], applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop,UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]

            self.present(activityVC, animated: true, completion: nil)
            DispatchQueue.main.async
                {
                    // let obj = Movies()
                    // obj.Andicator.stopAnimating()
            }
        })
        alertController.addAction(UIAlertAction(title: "ePoultry Share", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            // Marks: - For the Custome Picker view
            
            selectedrow = tag
            //  arrpickerview = arrcities
            self.view.endEditing(true)
            // Marks: - Custome CZPicker View
            czpicker = CZPickerView(headerTitle: "Select Channel", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
            czpicker.delegate = self
            czpicker.dataSource = self
            
            czpicker.headerBackgroundColor = appclr
            czpicker.needFooterView = false
            czpicker.show()
        })
        alertController.addAction(UIAlertAction(title: "Chat", style: UIAlertAction.Style.default)
        { action -> Void in
            self.shareChat(tag: tag, is_ePoultryContacts: false)
        })
        alertController.addAction(UIAlertAction(title: "ePoultry Contacts", style: UIAlertAction.Style.default)
        { action -> Void in
            self.shareChat(tag: tag, is_ePoultryContacts: true)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func shareChat(tag: Int, is_ePoultryContacts: Bool) {
        
        var desc = self.arrdesc[tag]
        desc = desc.replacingOccurrences(of: "_&epoultry&_", with: "\n")
        var tempselectedMessageType = 0
        var tempselectedMessageImage = UIImage()
        let tempselectedMessageText = desc
        let tempis_ePoultryContacts = is_ePoultryContacts
        if self.arrsubTypes[tag] as? String == "video" {
            //MARK:- Video
            tempselectedMessageType = VIDEO
            let indexPath = IndexPath(item: tag, section: 0)
            guard let cell = self.tablev.cellForRow(at: indexPath) as? VideoPostCell else {
                return // or fatalError() or whatever
            }
            tempselectedMessageImage = cell.imgpost.image!
            let videoUrl = videopath+arrvideourl[tag]+videoPlayEndPath
            let tempFileName = arrvideourl[tag]
            obj.funForceDownloadPlayShow(urlString: videoUrl, isProgressBarShow: true, viewController: self, completion: {
                    url in
                       
                    if url == "" {

                    }
                    else {

                       }
                    //MARK:- Reload image row after download
                       
                let tempVideoData = NSData(contentsOf: URL(string: url!)!)
                self.openShareViewController(tempFileName: tempFileName, tempselectedMessageVideoData: tempVideoData! as Data, is_ePoultryContacts: tempis_ePoultryContacts, tempselectedMessageText: tempselectedMessageText, tempselectedMessageType: tempselectedMessageType, tempselectedMessageImage: tempselectedMessageImage)
            })
            
            return
        }
        else if self.arrsubTypes[tag] as? String == "image"{
            //MARK:- Image
            tempselectedMessageType = IMAGE
            let indexPath = IndexPath(item: tag, section: 0)
            guard let cell = self.tablev.cellForRow(at: indexPath) as? ImgvCell else {
                return // or fatalError() or whatever
            }
            tempselectedMessageImage = cell.imgpost.image!
        }
        else if self.arrsubTypes[tag] as? String == "link"{
            //MARK:- Link
            tempselectedMessageType = TEXT
        }
        else if self.arrsubTypes[tag] as? String == "document"{
            //MARK:- Document
            //shareUrl = docpath+self.arrpostimg[tag]+"\n\n"
            tempselectedMessageType = DOCUMENT
            
            let documentUrl = "\(docpath)\(arrpostimg[tag])"
            let tempFileName = arrpostimg[tag]
            obj.funForceDownloadPlayShow(urlString: documentUrl, isProgressBarShow: true, viewController: self, completion: {
                    url in
                       
                    if url == ""{

                    }
                    else{

                       }

                let tempVideoData = NSData(contentsOf: URL(string: url!)!)
                self.openShareViewController(tempFileName: tempFileName, tempselectedMessageVideoData: tempVideoData! as Data, is_ePoultryContacts: tempis_ePoultryContacts, tempselectedMessageText: tempselectedMessageText, tempselectedMessageType: tempselectedMessageType, tempselectedMessageImage: tempselectedMessageImage)
            })
            return
        }
        else
        {
            //MARK:- Simple Text
            tempselectedMessageType = TEXT
        }
        openShareViewController(tempFileName: "", tempselectedMessageVideoData: Data(), is_ePoultryContacts: tempis_ePoultryContacts, tempselectedMessageText: tempselectedMessageText, tempselectedMessageType: tempselectedMessageType, tempselectedMessageImage: tempselectedMessageImage)
    }
    
    func openShareViewController(tempFileName: String, tempselectedMessageVideoData: Data, is_ePoultryContacts: Bool, tempselectedMessageText: String, tempselectedMessageType: Int, tempselectedMessageImage: UIImage){
        if is_ePoultryContacts{
            //MARK:- Share in Contacts
            let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "Users") as! Users
            vc.selectedMessageText = tempselectedMessageText
            vc.selectedMessageType = tempselectedMessageType
            vc.selectedMessageImage = tempselectedMessageImage
            vc.selectedMessageVideoData = tempselectedMessageVideoData
            vc.selectedFileName = tempFileName
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            //MARK:- Share in Chat Inbox
            let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ShareChat") as! ShareChat
            vc.selectedMessageText = tempselectedMessageText
            vc.selectedMessageType = tempselectedMessageType
            vc.selectedMessageImage = tempselectedMessageImage
            vc.selectedMessageVideoData = tempselectedMessageVideoData
            vc.selectedFileName = tempFileName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //Marks: - Button Add new POST
    @IBAction func btnaddpost(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddnewPost") as! AddnewPost
        vc.newsvideostag = "public"
        vc.type = "Public"
        vc.edit = "0"
        vc.posttype = "status"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Marks: - Button option
    @objc func optionbtn(sender: UIButton) {
        let tag = sender.tag
        let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Edit", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddnewPost") as! AddnewPost
            
            vc.newsvideostag = "public"
            vc.type = "Public"
            vc.edit = "1"
            vc.postTypeNewsORTimeLine = "status"
            vc.statusid = self.arrstatusid[tag]
            if self.arrsubTypes[tag] as? String == "video"
            {
                vc.buttonTag = VIDEO
            }
            else if self.arrsubTypes[tag] as? String == "image"
            {
                vc.buttonTag = IMAGE
            }
            else if self.arrsubTypes[tag] as? String == "link"{
                vc.buttonTag = TEXT
            }
            else if self.arrsubTypes[tag] as? String == "document"{
                vc.buttonTag = DOCUMENT
            }
            if self.arrisvideo[tag] == "1"
            {
                vc.url = self.arrvideourl[tag]
                vc.strvideolbl = "Video uploaded"
            }
            else
            {
                vc.url = self.arrpostimg[tag]
                vc.strvideolbl = ""
            }
            if self.arrdesc[tag] == ""
            {
                vc.strpost = "Write your post here"
            }
            else
            {
                vc.strpost = self.arrdesc[tag]
            }
            self.navigationController?.pushViewController(vc, animated: true)
        })
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            self.delete(tag: tag)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    
// Marks: - Table view datasource and delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrname.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if arrsubTypes[indexPath.row] as? String == "video" {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "cellvideo") as! VideoPostCell
            cell.lbldesc1.text = nil
            let lblwidth = cell.lbldesc1.frame.size.width
            cell.lbldesc1.lineBreakMode = .byWordWrapping
            cell.lbldesc1.numberOfLines = 0
            cell.lbldesc1.textAlignment = .natural
            
            cell.lblname.text = arrname[indexPath.row]
            cell.lblcomments.text = arrcomment[indexPath.row]
            cell.lbllikes.text = arrlike[indexPath.row]
            cell.lbldesc1.text = arrdesc[indexPath.row]
            cell.lbltime.text = arrtime[indexPath.row]
            
            cell.lbldesc1.sizeToFit()
            obj.findLinkInText(label: cell.lbldesc1)
            cell.lbldesc1.frame.size.width = lblwidth
            
            let userid = defaults.value(forKey: "userid") as! String
            let statusid = arrid[indexPath.row]
            // Marks: - Check my post
            if statusid == userid || defaults.value(forKey: "isadmin") as? String == "1" {
                cell.btnoption.isHidden = false
                //Profile Option
                cell.btnoption.tag = indexPath.row
                cell.btnoption.addTarget(self, action: #selector(optionbtn), for: .touchUpInside)
            }
            else {
                cell.btnoption.isHidden = true
            }
            
            // Marks: - Check my like
            if arrmylike[indexPath.row] == "1" {
                cell.imglike.image = #imageLiteral(resourceName: "likeg")
            }
            else {
                cell.imglike.image = #imageLiteral(resourceName: "like")
            }
            
            //Kingfisher Image upload
            let urlprofile = URL(string: userimagepath+arrprofileimg[indexPath.row])
            cell.imgprofile.kf.setImage(with: urlprofile) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    cell.imgprofile.image = value.image
                    
                case .failure(let error):
                    print("Error: \(error)")
                    cell.imgprofile.image = UIImage(named: "user")
                }
            }
            //Video image
            //Kingfisher Image upload
            let urlpost = URL(string:  imagepath+arrvideoimg[indexPath.row])
            cell.imgpost.kf.setImage(with: urlpost)
            
            //Profile button
            cell.btnprofile.tag = indexPath.row
            cell.btnprofile.addTarget(self, action: #selector(profile), for: .touchUpInside)
            
            //Play Video button
            cell.btnplayvideo.tag = indexPath.row
            cell.btnplayvideo.addTarget(self, action: #selector(playvideo), for: .touchUpInside)
            
            // Like Button
            cell.btnlike.tag = indexPath.row
            cell.btnlike.addTarget(self, action: #selector(likefun), for: .touchUpInside)

            // Comment Button
            cell.btncomment.tag = indexPath.row
            cell.btncomment.addTarget(self, action: #selector(commentfun), for: .touchUpInside)
            
            // Share Button
            cell.btnshare.tag = indexPath.row
            cell.btnshare.addTarget(self, action: #selector(sharefun), for: .touchUpInside)

            return cell
        }
        else if arrsubTypes[indexPath.row] as? String == "image" {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "ImgvCell") as! ImgvCell
            //let lblwidth = cell.lbldesc1.frame.size.width
            cell.lbldesc1.text = nil
            cell.lbldesc1.lineBreakMode = .byWordWrapping
            cell.lbldesc1.numberOfLines = 0
            cell.lbldesc1.textAlignment = .natural
            
            
            
            cell.lblname.text = arrname[indexPath.row]
            cell.lblcomments.text = arrcomment[indexPath.row]
            cell.lbllikes.text = arrlike[indexPath.row]
            //
            
            cell.lbltime.text = arrtime[indexPath.row]
            
            let stringToDecode = arrdesc[indexPath.row]
            let newStr = String(utf8String: stringToDecode.cString(using: .utf8)!)
            cell.lbldesc1.text = newStr
            cell.lbldesc1.sizeToFit()
            //            let locale =  NSLocale.accessibilityLabel()
            //            let lang = locale.languageCode
            //            let direction = NSLocale.characterDirection(forLanguage:lang!)
            //
                        
            //            let attribute = view.semanticContentAttribute
            //            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            //            if layoutDirection == .rightToLeft {
            //                cell.lbldesc1.textAlignment = .left
            //            }
            //            else
            //            {
            //                cell.lbldesc1.textAlignment = .right
            //            }
                        
            //            let locale = NSLocale.autoupdatingCurrent
            //            let lang = locale.languageCode
            //            let direction = NSLocale.characterDirection(forLanguage:lang!)
                        
                        
                        
            let userid = defaults.value(forKey: "userid") as! String
            let statusid = arrid[indexPath.row]
            // Marks: - Check my post
            if statusid == userid || defaults.value(forKey: "isadmin") as? String == "1" {
                cell.btnoption.isHidden = false
                
                //Profile Option
                cell.btnoption.tag = indexPath.row
                cell.btnoption.addTarget(self, action: #selector(optionbtn), for: .touchUpInside)
            }
            else {
                cell.btnoption.isHidden = true
            }
            // Marks: - Check my like
            if arrmylike[indexPath.row] == "1" {
                cell.imglike.image = #imageLiteral(resourceName: "likeg")
            }
            else {
                cell.imglike.image = #imageLiteral(resourceName: "like")
            }
            
            //Kingfisher Image upload
            let urlprofile = URL(string: userimagepath+arrprofileimg[indexPath.row])
            cell.imgprofile.kf.setImage(with: urlprofile) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    cell.imgprofile.image = value.image
                    
                    
                case .failure(let error):
                    print("Error: \(error)")
                    cell.imgprofile.image = UIImage(named: "user")
                }
            }
            //Kingfisher Image Post
            let urlpost = URL(string:  imagepath+arrpostimg[indexPath.row])
            cell.imgpost.kf.setImage(with: urlpost) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    cell.imgpost.image = value.image
                    self.setcustomimage(cell: cell, imgvv: cell.imgpost)
                    
                case .failure(let error):
                    print("Error: \(error)")
                    cell.imgpost.image = UIImage(named: "applogoicon")
                }
            }
            //Profile button
            cell.btnprofile.tag = indexPath.row
            cell.btnprofile.addTarget(self, action: #selector(profile), for: .touchUpInside)
            
            //Show image button
            cell.btnshowimage.tag = indexPath.row
            cell.btnshowimage.addTarget(self, action: #selector(showimage), for: .touchUpInside)
            
            // Like Button
            cell.btnlike.tag = indexPath.row
            cell.btnlike.addTarget(self, action: #selector(likefun), for: .touchUpInside)
            
            // Comment Button
            cell.btncomment.tag = indexPath.row
            cell.btncomment.addTarget(self, action: #selector(commentfun), for: .touchUpInside)
            
            // Share Button
            cell.btnshare.tag = indexPath.row
            cell.btnshare.addTarget(self, action: #selector(sharefun), for: .touchUpInside)
            
            return cell
        }
        else if arrsubTypes[indexPath.row] as? String == "link" {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "LinkCell") as! LinkCell
            //let lblwidth = cell.lbldesc1.frame.size.width
                cell.lbldesc1.text = nil
                cell.lbldesc1.numberOfLines = 0
                cell.lbldesc1.lineBreakMode = .byWordWrapping
                cell.lbldesc1.textAlignment = .natural
                cell.lblname.text = arrname[indexPath.row]
                cell.lblcomments.text = arrcomment[indexPath.row]
                cell.lbllikes.text = arrlike[indexPath.row]
                //
                
                cell.lbltime.text = arrtime[indexPath.row]
                let tempstr = arrdesc[indexPath.row]
                let tempstrarray = tempstr.components(separatedBy: "_&epoultry&_")
                var teampdesc1 = ""
                if tempstrarray.count == 0{
                    teampdesc1 = "\(tempstrarray[0])"
                }
                else if tempstrarray.count > 3{
                    teampdesc1 = "\(tempstrarray[0])\n\(tempstrarray[1])\n\n\(tempstrarray[2])\n\n\(tempstrarray[3])"
                }
                else if tempstrarray.count > 2{
                    teampdesc1 = "\(tempstrarray[0])\n\(tempstrarray[1])\n\n\(tempstrarray[2])"
                }
                else if tempstrarray.count > 1{
                    teampdesc1 = "\(tempstrarray[0])\n\n\(tempstrarray[1])"
                }
                let stringToDecode = teampdesc1
                let newStr = String(utf8String: stringToDecode.cString(using: .utf8)!)
                cell.lbldesc1.text = newStr
                cell.lbldesc1.sizeToFit()
            
                obj.findLinkInText(label: cell.lbldesc1)
            //            let locale =  NSLocale.accessibilityLabel()
            //            let lang = locale.languageCode
            //            let direction = NSLocale.characterDirection(forLanguage:lang!)
            //
                
            //            let attribute = view.semanticContentAttribute
            //            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            //            if layoutDirection == .rightToLeft {
            //                cell.lbldesc1.textAlignment = .left
            //            }
            //            else
            //            {
            //                cell.lbldesc1.textAlignment = .right
            //            }
                
            //            let locale = NSLocale.autoupdatingCurrent
            //            let lang = locale.languageCode
            //            let direction = NSLocale.characterDirection(forLanguage:lang!)
                let userid = defaults.value(forKey: "userid") as! String
                let statusid = arrid[indexPath.row]
                // Marks: - Check my post
                if statusid == userid || defaults.value(forKey: "isadmin") as? String == "1"
                {
                    cell.btnoption.isHidden = false
                    
                    //Profile Option
                    cell.btnoption.tag = indexPath.row
                    cell.btnoption.addTarget(self, action: #selector(optionbtn), for: .touchUpInside)
                }
                else
                {
                    cell.btnoption.isHidden = true
                }
                // Marks: - Check my like
                if arrmylike[indexPath.row] == "1" {
                    cell.imglike.image = #imageLiteral(resourceName: "likeg")
                }
                else {
                    cell.imglike.image = #imageLiteral(resourceName: "like")
                }
                
                //Kingfisher Image upload
                let urlprofile = URL(string: userimagepath+arrprofileimg[indexPath.row])
                cell.imgprofile.kf.setImage(with: urlprofile) { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                        cell.imgprofile.image = value.image
                    case .failure(let error):
                        print("Error: \(error)")
                        cell.imgprofile.image = UIImage(named: "user")
                    }
                }
                //Kingfisher Image Post
                let urlpost = URL(string:  imagepath+arrpostimg[indexPath.row])
                cell.imgpost.kf.setImage(with: urlpost) { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                        cell.imgpost.image = value.image
                        //cell.setCustomImage(image: value.image)
                    case .failure(let error):
                        print("Error: \(error)")
                        cell.imgpost.image = UIImage(named: "applogoicon")
                    }
                }
                //Profile button
                cell.btnprofile.tag = indexPath.row
                cell.btnprofile.addTarget(self, action: #selector(profile), for: .touchUpInside)
                
                //Show image button
                cell.btnshowimage.tag = indexPath.row
                cell.btnshowimage.addTarget(self, action: #selector(showimage), for: .touchUpInside)
                
                // Like Button
                cell.btnlike.tag = indexPath.row
                cell.btnlike.addTarget(self, action: #selector(likefun), for: .touchUpInside)
                
                // Comment Button
                cell.btncomment.tag = indexPath.row
                cell.btncomment.addTarget(self, action: #selector(commentfun), for: .touchUpInside)
                
                // Share Button
                cell.btnshare.tag = indexPath.row
                cell.btnshare.addTarget(self, action: #selector(sharefun), for: .touchUpInside)
                
                return cell
        }
        else if arrsubTypes[indexPath.row] as? String == "document" {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "DocumentCell") as! DocumentCell
            //let lblwidth = cell.lbldesc1.frame.size.width
            cell.lbldesc1.text = nil
            cell.lbldesc1.numberOfLines = 0
            cell.lbldesc1.lineBreakMode = .byWordWrapping
            cell.lbldesc1.textAlignment = .natural
            cell.lblname.text = arrname[indexPath.row]
            cell.lblcomments.text = arrcomment[indexPath.row]
            cell.lbllikes.text = arrlike[indexPath.row]
            
            cell.lbltime.text = arrtime[indexPath.row]
            let tempdesc = arrdesc[indexPath.row]
            if tempdesc != ""{
                cell.lbldesc1.text = arrpostimg[indexPath.row] + "\n\n\(tempdesc)"
            }
            else{
                cell.lbldesc1.text = arrpostimg[indexPath.row]
            }
            cell.lbldesc1.sizeToFit()
            
            let userid = defaults.value(forKey: "userid") as! String
            let statusid = arrid[indexPath.row]
            // Marks: - Check my post
            if statusid == userid || defaults.value(forKey: "isadmin") as? String == "1"
            {
                cell.btnoption.isHidden = false
                //Profile Option
                cell.btnoption.tag = indexPath.row
                cell.btnoption.addTarget(self, action: #selector(optionbtn), for: .touchUpInside)
            }
            else
            {
                cell.btnoption.isHidden = true
            }
            // Marks: - Check my like
            if arrmylike[indexPath.row] == "1"
            {
                cell.imglike.image = #imageLiteral(resourceName: "likeg")
            }
            else
            {
                cell.imglike.image = #imageLiteral(resourceName: "like")
            }
            
            //Kingfisher Image upload
            let urlprofile = URL(string: userimagepath+arrprofileimg[indexPath.row])
            cell.imgprofile.kf.setImage(with: urlprofile) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    cell.imgprofile.image = value.image
                case .failure(let error):
                    print("Error: \(error)")
                    cell.imgprofile.image = UIImage(named: "user")
                }
            }
            //Kingfisher Image Post
            let urlpost = URL(string:  docpath+arrpostimg[indexPath.row])
            
            cell.imgpost.image = UIImage(named: "document")
            //Profile button
            cell.btnprofile.tag = indexPath.row
            cell.btnprofile.addTarget(self, action: #selector(profile), for: .touchUpInside)
            
            //Show image button
            cell.btnshowimage.tag = indexPath.row
            cell.btnshowimage.addTarget(self, action: #selector(showimage), for: .touchUpInside)
            
            // Like Button
            cell.btnlike.tag = indexPath.row
            cell.btnlike.addTarget(self, action: #selector(likefun), for: .touchUpInside)
            
            // Comment Button
            cell.btncomment.tag = indexPath.row
            cell.btncomment.addTarget(self, action: #selector(commentfun), for: .touchUpInside)
            
            // Share Button
            cell.btnshare.tag = indexPath.row
            cell.btnshare.addTarget(self, action: #selector(sharefun), for: .touchUpInside)
            
            return cell
        }
        else {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            cell.lbldesc1.text = nil
            let lblwidth = cell.lbldesc1.frame.size.width
            
            cell.lbldesc1.lineBreakMode = .byWordWrapping
            cell.lbldesc1.numberOfLines = 0
            cell.lbldesc1.textAlignment = .natural
            
            cell.lblname.text = arrname[indexPath.row]
            cell.lblcomments.text = arrcomment[indexPath.row]
            cell.lbllikes.text = arrlike[indexPath.row]
            cell.lbltime.text = arrtime[indexPath.row]
            
            let stringToDecode = arrdesc[indexPath.row]
            let newStr = String(utf8String: stringToDecode.cString(using: .utf8)!)
            cell.lbldesc1.text = newStr
            
            cell.lbldesc1.sizeToFit()
            cell.lbldesc1.frame.size.width = lblwidth
            
            let statusid = arrid[indexPath.row]
            // Marks: - Check my post
            if statusid == USERID || defaults.value(forKey: "isadmin") as? String == "1" {
                cell.btnoption.isHidden = false
                
                //Profile Option
                cell.btnoption.tag = indexPath.row
                cell.btnoption.addTarget(self, action: #selector(optionbtn), for: .touchUpInside)
            }
            else {
                cell.btnoption.isHidden = true
            }
            // Marks: - Check my like
            if arrmylike[indexPath.row] == "1" {
                cell.imglike.image = #imageLiteral(resourceName: "likeg")
            }
            else {
                cell.imglike.image = #imageLiteral(resourceName: "like")
            }
            //Kingfisher Image upload
            let urlprofile = URL(string: userimagepath+arrprofileimg[indexPath.row])
            cell.imgprofile.kf.setImage(with: urlprofile) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    cell.imgprofile.image = value.image
                case .failure(let error):
                    print("Error: \(error)")
                    cell.imgprofile.image = UIImage(named: "user")
                }
            }
            
            //Profile button
            cell.btnprofile.tag = indexPath.row
            cell.btnprofile.addTarget(self, action: #selector(profile), for: .touchUpInside)
            
            // Like Button
            cell.btnlike.tag = indexPath.row
            cell.btnlike.addTarget(self, action: #selector(likefun), for: .touchUpInside)
            
            // Comment Button
            cell.btncomment.tag = indexPath.row
            cell.btncomment.addTarget(self, action: #selector(commentfun), for: .touchUpInside)
            
            // Share Button
            cell.btnshare.tag = indexPath.row
            cell.btnshare.addTarget(self, action: #selector(sharefun), for: .touchUpInside)
            
            return cell
        }
    }
    
    func setcustomimage(cell: ImgvCell, imgvv: UIImageView){
        cell.setCustomImage(image: imgvv.image!)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    //Show Last Cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row+1 == arrstatusid.count {
            let laststatusid = arrstatusid.last
            if laststatusid == lastindex {
                
            }
            else {
                
            }
            self.GetMorePosts()
            print("came to last row")
        }
    }
    
    
    // Get Location Name from Latitude and Longitude
    func GetAllPosts() {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"status?userId=\(userid)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                if self.pulltorefresh == "1" {
                    self.pulltorefresh = "0"
                    self.refreshc.endRefreshing()
                }
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                self.manageUserData(mainDict: datadic)
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
                        if error == nil {
                            obj.showAlert(title: "Error", message: "error! try again", viewController: self)
                            return
                        }
                          obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    // Get Location Name from Latitude and Longitude
    func GetAllPostsWithNotificaions() {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"status?userId=\(userid)"
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                if self.pulltorefresh == "1" {
                    self.pulltorefresh = "0"
                    self.refreshc.endRefreshing()
                }
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                self.manageUserData(mainDict: datadic)
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
                        if error == nil
                        {
                            obj.showAlert(title: "Error", message: "error! try again", viewController: self)
                            return
                        }
                        obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    func GetSocialLinks()
    {
        let url = BASEURL+"other/links"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y

        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSDictionary)
                            
                            if datadic.count > 0
                            {
                                FaceBookLink = (datadic.value(forKey: "data") as! NSDictionary).value(forKey: "facebook_link") as! String
                                TwitterLink = (datadic.value(forKey: "data") as! NSDictionary).value(forKey: "twitter_link") as! String
                                
                                YouTubeLink = (datadic.value(forKey: "data") as! NSDictionary).value(forKey: "twitter_link") as! String
                            }
                            else
                            {
                                
                            }
                        }
                        else
                        {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                        if error == nil
                        {
                            obj.showAlert(title: "Error", message: "error! try again", viewController: self)
                            return
                        }
                        obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    
    // Get Location Name from Latitude and Longitude
    func GetMorePosts() {
        let userid = defaults.value(forKey: "userid") as! String
        let lastid = arrstatusid[arrstatusid.count - 1]
        let url = BASEURL+"status?userId=\(userid)&offset=\(lastid)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                if self.pulltorefresh == "1" {
                    self.pulltorefresh = "0"
                    refreshControl.endRefreshing()
                }
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                
                                self.GetMorePostsManageData(mainDict: datadic)
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
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    
    func manageUserData(mainDict: NSDictionary) {
        do {
            self.arrname = [String]()
            self.arrdesc = [String]()
            self.arrcomment = [String]()
            self.arrlike = [String]()
            self.arrid = [String]()
            self.arrprofileimg = [String]()
            self.arrpostimg = [String]()
            self.arrisvideo = [String]()
            self.arrvideourl = [String]()
            self.arrvideoimg = [String]()
            self.arrtime = [String]()
            self.arrmylike = [String]()
            self.arrstatusid = [String]()
            self.lastindex = String()
            self.commenttag = Int()
            self.arrsubTypes = [Any]()
            
            if (mainDict as AnyObject).count > 0{
                let mainD = NSDictionary(dictionary: mainDict)
                
                let dataarray = mainD.value(forKey: "Data") as! NSArray
                // text = text.replacingOccurrences(of: "[", with: "") as NSString
                // text = text.replacingOccurrences(of: "]", with: "") as NSString
                
                if dataarray.count == 0 {
                    obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                }
                else {
                    DispatchQueue.main.async {
                        for tempdict in dataarray{
                            
                            let dict = tempdict as! NSDictionary
                            // print(dict)
                            self.arrsubTypes.append(dict.value(forKey: "SubType") as Any)
                            if let Name = dict.value(forKey: "Name") as? String {
                                self.arrname.append(Name)
                            }
                            else {
                                self.arrname.append("")
                            }
                            if let UserId = dict.value(forKey: "UserId") as? Int {
                                self.arrid.append(String(UserId))
                            }
                            else {
                                self.arrid.append("")
                            }
                            if let TotalComments = dict.value(forKey: "TotalComments") as? Int {
                                self.arrcomment.append(String(TotalComments))
                            }
                            else {
                                self.arrcomment.append("")
                            }
                            if let TotalLikes = dict.value(forKey: "TotalLikes") as? Int {
                                self.arrlike.append(String(TotalLikes))
                            }
                            else {
                                self.arrlike.append("")
                            }
                            if let Status = dict.value(forKey: "Status") as? String {
                                self.arrdesc.append(String(Status))
                            }
                            else {
                                self.arrdesc.append("")
                            }
                            if let ProfilePic = dict.value(forKey: "ProfilePic") as? String {
                                self.arrprofileimg.append(String(ProfilePic))
                            }
                            else {
                                self.arrprofileimg.append("")
                            }
                            if let ImagePath = dict.value(forKey: "ImagePath") as? String {
                                self.arrpostimg.append(String(ImagePath))
                            }
                            else {
                                self.arrpostimg.append("")
                            }
                            
                            
                            if let VideoThumb = dict.value(forKey: "VideoThumb") as? String {
                                self.arrvideoimg.append(String(VideoThumb))
                            }
                            else {
                                self.arrvideoimg.append("")
                            }
                            
                            if let VideoFile = dict.value(forKey: "VideoFile") as? String {
                                self.arrvideourl.append(String(VideoFile))
                            }
                            else {
                                self.arrvideourl.append("")
                            }
                            if let MyLike = dict.value(forKey: "MyLike") as? Int {
                                self.arrmylike.append(String(MyLike))
                            }
                            else {
                                self.arrmylike.append("")
                            }
                            if let StatusID = dict.value(forKey: "StatusID") as? Int {
                                self.arrstatusid.append(String(StatusID))
                            }
                            else {
                                self.arrstatusid.append("")
                            }
                            
                            if let CreatedOn = dict.value(forKey: "CreatedOn") as? String {
                                var strtime = CreatedOn.replacingOccurrences(of: "T", with: " ")
                                let dfmatter = DateFormatter()
                                dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                dfmatter.locale = Locale(identifier: "en_US_POSIX")
                                dfmatter.timeZone = TimeZone.autoupdatingCurrent //Current time zone
                                
                                strtime = strtime.components(separatedBy: ".")[0]
                                print(strtime)
                                
                                let agotime = obj.timeAgoSinceDate(dfmatter.date(from: strtime)!)
                                
                                self.arrtime.append(agotime!)
                            }
                            else {
                                self.arrtime.append("")
                            }
                            
                            if let IsVideo = dict.value(forKey: "IsVideo") as? Bool {
                                if IsVideo == true {
                                    self.arrisvideo.append("1")
                                }
                                else {
                                    self.arrisvideo.append("0")
                                }
                            }
                            else {
                                self.arrisvideo.append("0")
                            }
                            
                            // self.arrcity.append(tempcity)
                            // self.arrisactivecon.append(tempcityid)
                            if self.lastindex == self.arrstatusid.last! {
                                
                            }
                            else {
                                self.lastindex = self.arrstatusid.last!
                                DispatchQueue.main.async {
                                    DispatchQueue.main.async {
                                        self.tablev.reloadData()
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            else {
                obj.showAlert(title: "Alert", message: "try again", viewController: self)
            }
        }
        catch {
            
        }
    }
    
    func GetMorePostsManageData(mainDict: NSDictionary) {
        do {
            if (mainDict as AnyObject).count > 0{
                let mainD = NSDictionary(dictionary: mainDict)
                
                let dataarray = mainD.value(forKey: "Data") as! NSArray
                // text = text.replacingOccurrences(of: "[", with: "") as NSString
                // text = text.replacingOccurrences(of: "]", with: "") as NSString
                
                if dataarray.count == 0 {
                    obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                }
                else {
                    DispatchQueue.main.async {
                        for tempdict in dataarray {
                            let dict = tempdict as! NSDictionary
                            self.arrsubTypes.append(dict.value(forKey: "SubType") as Any)
                            // print(dict)
                            if let Name = dict.value(forKey: "Name") as? String {
                                self.arrname.append(Name)
                            }
                            else {
                                self.arrname.append("")
                            }
                            if let UserId = dict.value(forKey: "UserId") as? Int {
                                self.arrid.append(String(UserId))
                            }
                            else {
                                self.arrid.append("")
                            }
                            if let TotalComments = dict.value(forKey: "TotalComments") as? Int {
                                self.arrcomment.append(String(TotalComments))
                            }
                            else {
                                self.arrcomment.append("")
                            }
                            if let TotalLikes = dict.value(forKey: "TotalLikes") as? Int {
                                self.arrlike.append(String(TotalLikes))
                            }
                            else {
                                self.arrlike.append("")
                            }
                            if let Status = dict.value(forKey: "Status") as? String {
                                self.arrdesc.append(String(Status))
                            }
                            else {
                                self.arrdesc.append("")
                            }
                            if let ProfilePic = dict.value(forKey: "ProfilePic") as? String {
                                self.arrprofileimg.append(String(ProfilePic))
                            }
                            else {
                                self.arrprofileimg.append("")
                            }
                            if let ImagePath = dict.value(forKey: "ImagePath") as? String {
                                self.arrpostimg.append(String(ImagePath))
                            }
                            else {
                                self.arrpostimg.append("")
                            }
                            
                            
                            if let VideoThumb = dict.value(forKey: "VideoThumb") as? String {
                                self.arrvideoimg.append(String(VideoThumb))
                            }
                            else {
                                self.arrvideoimg.append("")
                            }
                            
                            if let VideoFile = dict.value(forKey: "VideoFile") as? String {
                                self.arrvideourl.append(String(VideoFile))
                            }
                            else {
                                self.arrvideourl.append("")
                            }
                            if let MyLike = dict.value(forKey: "MyLike") as? Int {
                                self.arrmylike.append(String(MyLike))
                            }
                            else {
                                self.arrmylike.append("")
                            }
                            if let StatusID = dict.value(forKey: "StatusID") as? Int {
                                self.arrstatusid.append(String(StatusID))
                            }
                            else {
                                self.arrstatusid.append("")
                            }
                            if let CreatedOn = dict.value(forKey: "CreatedOn") as? String {
                                var strtime = CreatedOn.replacingOccurrences(of: "T", with: " ")
                                let dfmatter = DateFormatter()
                                dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                dfmatter.locale = Locale(identifier: "en_US_POSIX")
                                dfmatter.timeZone = TimeZone.autoupdatingCurrent //Current time zone
                                
                                strtime = strtime.components(separatedBy: ".")[0]
                                print(strtime)
                                
                                let agotime = obj.timeAgoSinceDate(dfmatter.date(from: strtime)!)
                                
                                self.arrtime.append(agotime!)
                            }
                            else {
                                self.arrtime.append("")
                            }
                            
                            if let IsVideo = dict.value(forKey: "IsVideo") as? Bool {
                                if IsVideo == true {
                                    self.arrisvideo.append("1")
                                }
                                else {
                                    self.arrisvideo.append("0")
                                }
                            }
                            else {
                                self.arrisvideo.append("0")
                            }
                            
                            // self.arrcity.append(tempcity)
                            // self.arrisactivecon.append(tempcityid)
                            self.lastindex = self.arrstatusid.last!
                            DispatchQueue.main.async {
                                self.tablev.reloadData()
                                
                            }
                        }
                    }
                }
            }
            else {
                obj.showAlert(title: "Alert", message: "try again", viewController: self)
                
            }
        }
        catch {
            
        }
    }
   
    // Marks: - Like
    func like(tag: Int) {
        let tempPostUserID = arrid[tag]
        let statusid = arrstatusid[tag]
        let url = BASEURL+"Status/\(statusid)/like?userId=\(USERID)&statusCreatedBy=\(tempPostUserID)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        let parameters : Parameters =
            ["": ""]
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 { }
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
    func unlike(tag  : Int) {
        let statusid = arrstatusid[tag]
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"/Status/\(statusid)/Unlike?userId=\(userid)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        let parameters : Parameters =
            ["": ""]
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                
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
    
    //Marks: - Handle Notification
    @objc func handleNotificationshowComment() {
        var value = Int(self.arrcomment[commenttag])
        value = value! + 1
        
        var strvalue = String()
        strvalue = "\(value!)"
        
        self.arrcomment[commenttag] = strvalue
        
        let indexPath = IndexPath(item: commenttag, section: 0)
        self.tablev.reloadRows(at: [indexPath], with: .none)

    }
    //Marks: - Handle Notification
    @objc func handleNotificationshowPost() {
        DispatchQueue.main.async{
            self.GetAllPostsWithNotificaions()
        }
    }
    
    //Marks: - Pull to refresh
    @objc func pulltorefreshfun() {
        pulltorefresh = "1"
        DispatchQueue.main.async {
            self.GetAllPosts()
        }
    }
    
    @objc func handleNotificationUpdateChannel(){
        GetUserSponsoredChannels()
    }
    
    //MARK:- Delete card
    @objc func delete(tag  : Int) {
        let statusid = arrstatusid[tag]
        let url = BASEURL+"status/\(statusid)"
        
        andicator.startAnimating()
        obj.webServiceDelete(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                DispatchQueue.main.async {
                    if error == nil {
                        print(responseObject!)
                        let success = (responseObject!).value(forKey: "data") as! String
                        if success == "1" {
                            self.arrname.remove(at: tag)
                            self.arrdesc.remove(at: tag)
                            self.arrcomment.remove(at: tag)
                            self.arrlike.remove(at: tag)
                            self.arrid.remove(at: tag)
                            self.arrprofileimg.remove(at: tag)
                            self.arrpostimg.remove(at: tag)
                            self.arrisvideo.remove(at: tag)
                            self.arrvideourl.remove(at: tag)
                            self.arrvideoimg.remove(at: tag)
                            self.arrtime.remove(at: tag)
                            self.arrmylike.remove(at: tag)
                            self.arrstatusid.remove(at: tag)
                            self.arrsubTypes.remove(at: tag)
                            self.tablev.reloadData()
                            
                            obj.showAlert(title: "Alert!", message: "Post deleted successfully.", viewController: self)
                        }
                        else {
                            print("tarrideError")
                            obj.showAlert(title: "Alert!", message: "Failed to delete", viewController: self)
                        }
                    }
                    else {
                        var errorstr = String()
                        if error != nil{
                            errorstr = (error?.description)!
                        }
                        obj.showAlert(title: "Error!", message: errorstr, viewController: self)
                    }
                }
        })
    }

    
    // Marks: - Get all Groups
    func getallgroupsOld() {
        //let url = BASEURL+"group/GetAllGroups?userId=\(userid)&role=\(role)"
        let url = BASEURL+"channels/\(USERID)?tags=All&admin=\(USERROLE)"
        obj.webServicesGet(url: url, completionHandler: {
                responseObject, error in
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSArray)
                            if datadic.count == 0 {
                               
                            }
                            else {
                                let dataarray = datadic
                                if dataarray.count == 0 {
                                    obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                                }
                                else {
                                    for tempdict in dataarray{
                                        let dict = tempdict as! NSDictionary

                                        if let title = dict.value(forKey: "GroupTitle") as? String {
                                            self.arrgtitle.append(title)
                                        }
                                        else {
                                            self.arrgtitle.append("")
                                        }
                                        if let Type = dict.value(forKey: "Type") as? String {
                                            self.arrgtype.append(Type)
                                        }
                                        else {
                                            self.arrgtype.append("")
                                        }
                                        if let GroupId = dict.value(forKey: "GroupId") as? Int {
                                            //self.arrgid.append(String(GroupId))
                                        }
                                        else {
                                           // self.arrgid.append("")
                                        }
                                        if let GroupProfilePic = dict.value(forKey: "GroupProfilePic") as? String {
                                            self.arrgimgprofile.append(GroupProfilePic)
                                        }
                                        else {
                                            self.arrgimgprofile.append("")
                                        }
                                        if let Total = dict.value(forKey: "Total") as? Int {
                                            self.arrgtotalmember.append(String(Total))
                                        }
                                        else {
                                            self.arrgtotalmember.append("")
                                        }
                                        if let userstatus = dict.value(forKey: "userstatus") as? Int {
                                            self.arrguserstatus.append(String(userstatus))
                                        }
                                        else {
                                            self.arrguserstatus.append("")
                                        }

                                    }
                                }
                            }
                        }
                    }
                }
        })
    }
    
    func getallgroups() {
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String {
            userid = tempid
        }
        else {
            userid = ""
        }
        let url = BASEURL+"channels/\(userid)?tags=All&admin=\(USERROLE)"
        //print(url)

        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                let dataarr = (datadic.value(forKey: "data") as! NSArray)
                                self.arrgtitle.append("Timeline")
                                self.arrgid.append("Timeline")
                                self.arrguserstatus.append("Timeline")
                                self.arrgtype.append("Timeline")
                                self.arrgimgprofile.append("Timeline")
                                let tempgid = dataarr.value(forKey: "ChannelId") as! [Any]
                                self.arrgid = self.arrgid + tempgid
                                //self.arrCreatedBy = dataarr.value(forKey: "CreatedBy") as! [Any]
                                //self.arrCreatedon = dataarr.value(forKey: "Createdon") as! [Any]
                                //self.arrDescription = dataarr.value(forKey: "Description") as! [Any]
                                //self.arrIsActive = dataarr.value(forKey: "IsActive") as! [Any]
                                //self.arrRequestStatus = dataarr.value(forKey: "RequestStatus") as! [Any]
                                let tempstatus = dataarr.value(forKey: "Status") as! [String]
                                self.arrguserstatus = self.arrguserstatus + tempstatus
                                //self.arrTags = dataarr.value(forKey: "Tags") as! [Any]
                                let temptitle = dataarr.value(forKey: "Title") as! [String]
                                self.arrgtitle = self.arrgtitle + temptitle
                                let temptype = dataarr.value(forKey: "Type") as! [String]
                                self.arrgtype = self.arrgtype + temptype
                               // self.arrUpdatedby = dataarr.value(forKey: "Updatedby") as! [Any]
                               // self.arrUpdatedon = dataarr.value(forKey: "Updatedon") as! [Any]
                                //self.arrUserId = dataarr.value(forKey: "UserId") as! [Any]
                                let tempthumb = dataarr.value(forKey: "thumbnail") as! [String]
                                self.arrgimgprofile = self.arrgimgprofile + tempthumb
                                                                
                                self.tablev.reloadData()
                            }
                            else {
                                //showAlertPleaseWait(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else {
                            //viewController: self)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            obj.showAlert(title: "Error!", message: (error?.description ?? "Error Occured try again and check your internet connection") , viewController: self)
                        }
                    }
                }
        })
    }
    
        //////////////////// Marks: - Get time in since time ago
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = getCurrentLocalDate()
    
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    //MARK: - getting correct time was error of 4 hours now fix with this func
    func getCurrentLocalDate()-> NSDate {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = TimeZone(abbreviation: "GMT")!
        now = calendar.date(from: nowComponents)!
        return now as NSDate
    }
    
    //MARK:- Collection view work---for Sponserd and Following channels
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = 5.0
        let width = (self.colv.frame.size.height) - CGFloat(2 * margin)
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrChannel_Sponsored_ActiveRequest_Indexes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = arrChannel_Sponsored_ActiveRequest_Indexes[indexPath.row]
        let cell = colv.dequeueReusableCell(withReuseIdentifier: "PostColvCell", for: indexPath) as! PostColvCell
        let url = URL(string: imagepath + "\(arrthumbnail_Sponsored[index] as! String)")
        cell.imgv.kf.setImage(with: url)
        DispatchQueue.main.async{
            cell.imgv.layer.cornerRadius = cell.imgv.frame.size.height / 2
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "PageViewChannels") as! PageViewChannels
        guard let cell = self.colv.cellForItem(at: indexPath) as? PostColvCell else {
            return // or fatalError() or whatever
        }
        let tempRow = arrChannel_Sponsored_ActiveRequest_Indexes[indexPath.row]
        NEWsChannelID = "\(arrChannelId_Sponsored[tempRow])"
        NEWsChannelName = "\(arrTitle_Sponsored[tempRow])"
        NEWsChannelDescription = "\(arrDescription_Sponsored[tempRow])"
        NEWsChannelTags = "\("")"
        if cell.imgv.image == nil{
            NEWsHeaderimage = UIImage(named: "groupimg")!
        }
        else{
            NEWsHeaderimage = cell.imgv.image!
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    var arrChannel_Sponsored_ActiveRequest_Indexes = [Int]()
    var arrTitle_Sponsored = [Any]()
    var arrChannelId_Sponsored = [Any]()
    var arrCreatedBy_Sponsored = [Any]()
    var arrCreatedon_Sponsored = [Any]()
    var arrDescription_Sponsored = [Any]()
    var arrIsActive_Sponsored = [Any]()
    var arrRequestStatus_Sponsored = [Any]()
    var arrStatus_Sponsored = [Any]()
    var arrTags_Sponsored = [Any]()
    var arrType_Sponsored = [Any]()
    var arrUpdatedby_Sponsored = [Any]()
    var arrUpdatedon_Sponsored = [Any]()
    var arrUserId_Sponsored = [Any]()
    var arrthumbnail_Sponsored = [Any]()
    
    func GetUserSponsoredChannels() {
        let url = BASEURL+"channels/sponsored"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator_colv.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator_colv.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                let dataarr = (datadic.value(forKey: "data") as! NSArray)
                                
                                self.arrChannelId_Sponsored = dataarr.value(forKey: "ChannelId") as! [Any]
                                self.arrCreatedBy_Sponsored = dataarr.value(forKey: "CreatedBy") as! [Any]
                                self.arrCreatedon_Sponsored = dataarr.value(forKey: "Createdon") as! [Any]
                                self.arrDescription_Sponsored = dataarr.value(forKey: "Description") as! [Any]
                                self.arrIsActive_Sponsored = dataarr.value(forKey: "IsActive") as! [Any]
                                self.arrRequestStatus_Sponsored = dataarr.value(forKey: "RequestStatus") as! [Any]
                                self.arrStatus_Sponsored = dataarr.value(forKey: "Status") as! [Any]
                                self.arrTags_Sponsored = dataarr.value(forKey: "Tags") as! [Any]
                                self.arrTitle_Sponsored = dataarr.value(forKey: "Title") as! [Any]
                                self.arrType_Sponsored = dataarr.value(forKey: "Type") as! [Any]
                                self.arrUpdatedby_Sponsored = dataarr.value(forKey: "Updatedby") as! [Any]
                                self.arrUpdatedon_Sponsored = dataarr.value(forKey: "Updatedon") as! [Any]
                                self.arrUserId_Sponsored = dataarr.value(forKey: "UserId") as! [Any]
                                self.arrthumbnail_Sponsored = dataarr.value(forKey: "thumbnail") as! [Any]
                                self.arrChannel_Sponsored_ActiveRequest_Indexes = [Int]()
                                
                                for (index, element) in self.arrRequestStatus_Sponsored.enumerated(){
                                    if element as! Int == 1{
                                        self.arrChannel_Sponsored_ActiveRequest_Indexes.append(index)
                                    }
                                }
                                
                                self.GetUserChannels()
                            }
                            else {
                                self.GetUserChannels()
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
    
    var arrTitle_Channels = [Any]()
    var arrChannelId_Channels = [Any]()
    var arrCreatedBy_Channels = [Any]()
    var arrCreatedon_Channels = [Any]()
    var arrDescription_Channels = [Any]()
    var arrIsActive_Channels = [Any]()
    var arrRequestStatus_Channels = [Any]()
    var arrStatus_Channels = [Any]()
    var arrTags_Channels = [Any]()
    var arrType_Channels = [Any]()
    var arrUpdatedby_Channels = [Any]()
    var arrUpdatedon_Channels = [Any]()
    var arrUserId_Channels = [Any]()
    var arrthumbnail_Channels = [Any]()

    func GetUserChannels() {
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"channels/\(userid)"
       //let url = DataContainer.baseUrl()+"channels/\("35907")"
        
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator_colv.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator_colv.stopAnimating()
              
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                let dataarr = (datadic.value(forKey: "data") as! NSArray)
                                if dataarr.count == 0 && self.arrChannelId_Sponsored.count == 0 {
                                    
                                    self.colv.frame.size.height = 0
                                    self.tablev.frame.origin.y = self.colv.frame.maxY
                                    self.tablev.frame.size.height = (self.tabBarController?.tabBar.frame.minY)!
                                    
                                    return
                                }
                                else if dataarr.count == 0 {
                                    DispatchQueue.main.async{
                                        self.colv.reloadData()
                                    }
                                }
                                else {
                                    
                                    self.arrChannelId_Channels = dataarr.value(forKey: "ChannelId") as! [Any]
                                    self.arrCreatedBy_Channels = dataarr.value(forKey: "CreatedBy") as! [Any]
                                    self.arrCreatedon_Channels = dataarr.value(forKey: "Createdon") as! [Any]
                                    self.arrDescription_Channels = dataarr.value(forKey: "Description") as! [Any]
                                    self.arrIsActive_Channels = dataarr.value(forKey: "IsActive") as! [Any]
                                    self.arrRequestStatus_Channels = dataarr.value(forKey: "RequestStatus") as! [Any]
                                    self.arrStatus_Channels = dataarr.value(forKey: "Status") as! [Any]
                                    self.arrTags_Channels = dataarr.value(forKey: "Tags") as! [Any]
                                    self.arrTitle_Channels = dataarr.value(forKey: "Title") as! [Any]
                                    self.arrType_Channels = dataarr.value(forKey: "Type") as! [Any]
                                    self.arrUpdatedby_Channels = dataarr.value(forKey: "Updatedby") as! [Any]
                                    self.arrUpdatedon_Channels = dataarr.value(forKey: "Updatedon") as! [Any]
                                    self.arrUserId_Channels = dataarr.value(forKey: "UserId") as! [Any]
                                    self.arrthumbnail_Channels = dataarr.value(forKey: "thumbnail") as! [Any]
                                    
                                    for (index, element) in self.arrChannelId_Channels.enumerated() {
                                      print("Item \(index): \(element)")
                                        
                                        let temparray = self.arrChannelId_Sponsored as NSArray
                                        if temparray.contains(element){

                                        }
                                        else{
                                            self.arrChannelId_Sponsored.append(self.arrChannelId_Channels[index])
                                             self.arrCreatedBy_Sponsored.append(self.arrCreatedBy_Channels[index])
                                             self.arrCreatedon_Sponsored.append(self.arrCreatedon_Channels[index])
                                            self.arrDescription_Sponsored.append(self.arrDescription_Channels[index])
                                             self.arrIsActive_Sponsored.append(self.arrIsActive_Channels[index])
                                             self.arrRequestStatus_Sponsored.append(self.arrRequestStatus_Channels[index])
                                             self.arrStatus_Sponsored.append(self.arrStatus_Channels[index])
                                             self.arrTags_Sponsored.append(self.arrTags_Channels[index])
                                             self.arrTitle_Sponsored.append(self.arrTitle_Channels[index])
                                             
                                             self.arrType_Sponsored.append(self.arrType_Channels[index])
                                             self.arrUpdatedby_Sponsored.append(self.arrUpdatedby_Channels[index])
                                             self.arrUpdatedon_Sponsored.append(self.arrUpdatedon_Channels[index])
                                             self.arrUserId_Sponsored.append(self.arrUserId_Channels[index])
                                             self.arrthumbnail_Sponsored.append(self.arrthumbnail_Channels[index])
                                        }
                                    }
                                    self.arrChannel_Sponsored_ActiveRequest_Indexes = [Int]()
                                    for (index, element) in self.arrRequestStatus_Sponsored.enumerated(){
                                        if element as! Int == 1{
                                            self.arrChannel_Sponsored_ActiveRequest_Indexes.append(index)
                                        }
                                    }
                                    DispatchQueue.main.async{
                                        self.colv.reloadData()
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
}

// Marks : -  Custom CZPicker View
extension Post: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        //            if pickerView == pickerWithImage {
        //                return fruitImages[row]
        //            }
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        if (arrgimgprofile[row]) != "" {
            //Kingfisher Image upload
            let urlprofile = URL(string: userimagepath+arrgimgprofile[row])
            //this is working the bottom line
            //let urlprofile = URL(string: imagepath+arrgimgprofile[row])
            image.kf.setImage(with: urlprofile) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    image.image = value.image
                case .failure(let error):
                    print("Error: \(error)")
                    image.image = UIImage(named: "user")
                }
            }
        }
        else {
            image.image = #imageLiteral(resourceName: "groupimg")
        }
        
        return image.image
    }
    
    
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        arrpickerview  = arrgtitle
        return arrpickerview.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return arrpickerview[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
       // objmodel.shareingroup(type: "Private", groupid: "103", statusid: "3075", tag: "s", andicator: andicator)
        if row == 0{
            shareinTimeline(tag: row)
        }
        else{
            shareingroup(tag: row)
        }
    }
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        for row in rows {
            if let row = row as? Int {
                print(arrpickerview[row])
            }
        }
    }
    
    func shareingroup(tag : Int)
    {
        let statusid = self.arrstatusid[selectedrow]
        let groupid = self.arrgid[tag]
       // let gtype = self.arrgtype[tag]
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
    
        let url = BASEURL + "news/\(groupid)/share?userId=\(userid)&statusId=\(statusid)"
        
        let parameters : Parameters =
            ["": ""]
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil
            {
                if responseObject!.value(forKey: "data") as? Int == 1
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: ["searchtext":NEWsChannelSEARCHTags])
                    DispatchQueue.main.async {
                        obj.showAlert(title: "Alert!", message: responseObject!.value(forKey: "message") as? String ?? "", viewController: self)
                    }
                }
                else
                {
                    obj.showAlert(title: "Alert!", message: "Failed to Share", viewController: self)
                }
            }
            else
            {
                if error == nil
                {
                    obj.showAlert(title: "Error!", message: ("error?.description"), viewController: self)
                    return
                }
                obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
            }
        })
    }
    
    func shareinTimeline(tag : Int) {
        let statusid = self.arrstatusid[selectedrow]
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String {
            userid = tempid
        }
        else {
            userid = ""
        }
        let url = BASEURL + "news/share?userId=\(userid)&statusId=\(statusid)"
        
        let parameters : Parameters =
            ["": ""]
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil {
                if responseObject!.value(forKey: "data") as? Int == 1 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object: nil)
                    DispatchQueue.main.async {
                        obj.showAlert(title: "Alert!", message: responseObject!.value(forKey: "message") as? String ?? "", viewController: self)
                    }
                }
                else {
                    obj.showAlert(title: "Alert!", message: "Failed to Share", viewController: self)
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
    
    // Marks: - Update Fcm Token
    func updatefcm() {
        let url = BASEURL+"/user/\(USERID)"

        let parameters : Parameters =
            ["fcmId": defaults.value(forKey: "fcmtoken") as! String]
        
        obj.webServicePut(url: url, parameters: parameters, completionHandler:{ responseObject, error in
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                
                            }
                            else {
                                 //obj.showAlert(title: "Alert", message: "try again", viewController: self)
                            }
                        }
                        else {
                           // obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
}

// MARK: - IndicatorInfoProvider for page controller like android
extension Post: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Timeline")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Timeline")
        return itemInfo
    }
}
