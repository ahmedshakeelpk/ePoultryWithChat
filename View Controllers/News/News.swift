//
//  News.swift
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


var NEWsChannelID = String()
var NEWsChannelName = String()
var NEWsChannelDescription = String()
var NEWsChannelTags = String()
var NEWsChannelSEARCHTags = String()
var NEWsHeaderimage = UIImage()
var NEWsChannelisAdmin = false
var NEWsChannelFromDate = String()
var NEWsChannelToDate = String()
var NEWsChannelEventDate = String()
var NEWsChannelSEARCHTitle = String()

class News: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    var pulltorefresh = String()
    //////////////////////////////
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
    
    /////// Marks: - For Groups Arrays
    var arrgtitle = [String]()
    var arrgtype = [String]()
    var arrgid = [Any]()
    var arrgimgprofile = [String]()
    var arrgtotalmember = [String]()
    var arrguserstatus = [String]()
    var arrsubTypes = [Any]()
    
    ///////////////////////////////////////
    var channelID = String()
    var channelName = String()
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!

    @IBOutlet weak var andicator2: UIActivityIndicatorView!
    @IBOutlet weak var btnnewspost: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NEWsChannelSEARCHTags = "All"
        // Do any additional setup after loading the view.
        channelName = NEWsChannelName
        channelID = NEWsChannelID
        
        //MARK : - Activity andicator in footer view
        tablev.tableFooterView = andicator2
        self.title = channelName
        // MARK : - UIRefresh controll in table View
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(pulltorefreshfun), for: UIControl.Event.valueChanged)
        tablev.addSubview(refreshControl) // not required when using UITableViewController
        
        // MARK : - Remove Notification
        NotificationCenter.default.removeObserver(self)
        // Comment to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationshowNewsComment), name: NSNotification.Name(rawValue: "updatenewscomment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationshowNewsPost), name: NSNotification.Name(rawValue: "newspost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funisAdmin), name: NSNotification.Name(rawValue: "isAdmin"), object: nil)
        
        btnnewspost.layer.cornerRadius = btnnewspost.frame.width / 2
        btnnewspost.isHidden = true
        tablev.rowHeight = 128
        tablev.estimatedRowHeight = UITableView.automaticDimension
        self.pulltorefresh = "0"
        NEWsChannelFromDate = ""
        NEWsChannelToDate = ""
        NEWsChannelSEARCHTitle = ""
        NEWsChannelSEARCHTags = "All"
        NEWsChannelEventDate = ""
        self.GetAllNewsPosts()
        DispatchQueue.global(qos: .background).async {
            self.getallgroups()
        }
        //MARK:- Cell Register
        self.tablev.register(UINib(nibName: "ImgvCell", bundle: nil), forCellReuseIdentifier: "ImgvCell")
        //MARK:- Cell Register
        self.tablev.register(UINib(nibName: "LinkCell", bundle: nil), forCellReuseIdentifier: "LinkCell")
        self.tablev.register(UINib(nibName: "DocumentCell", bundle: nil), forCellReuseIdentifier: "DocumentCell")
        self.tablev.register(UINib(nibName: "TagFilterSearchTagCell", bundle: nil), forCellReuseIdentifier: "TagFilterSearchTagCell")
        self.tablev.register(UINib(nibName: "VideoPostCell", bundle: nil), forCellReuseIdentifier: "cellvideo")
        self.tablev.register(UINib(nibName: "VideoPostCell", bundle: nil), forCellReuseIdentifier: "cellvideo")
        self.tablev.register(UINib(nibName: "BlankSpaceCell", bundle: nil), forCellReuseIdentifier: "BlankSpaceCell")
    }
        
    @objc func funisAdmin(){
        //btnnewspost.isHidden = false
    }
    
    //MARK: - Activity andicator with footer view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            // call method to add data to tableView
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hidefooter), userInfo: nil, repeats: false)
        }
        let tempdic = ["tablev": tablev]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollviewScroll"), object: tempdic)
    }
    
    //MARK: - Hide Footer
    @objc func hidefooter() {
        tablev.tableFooterView!.isHidden = true
    }
    
    // Marks: - News Post
    @IBAction func btnnewspost(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddnewPost") as! AddnewPost
        vc.newsvideostag = "public"
        vc.type = "News"
        vc.posttype = "news"
        vc.statusid = channelID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Marks: - Pull to refresh
    @objc func pulltorefreshfun()
    {
        pulltorefresh = "1"
        DispatchQueue.main.async {
            self.GetAllNewsPosts()
        }
    }
    
    //Marks: - Handle Notification
    @objc func handleNotificationshowNewsPost(notification: Notification)
    {
        GetAllNewsPosts()
    }
    
    //Marks: - Handle Notification
    @objc func handleNotificationshowNewsComment()
    {
        var value = Int(self.arrcomment[commenttag])
        value = value! + 1
        
        var strvalue = String()
        strvalue = "\(value!)"
        
        self.arrcomment[commenttag] = strvalue
        
        let indexPath = IndexPath(item: commenttag, section: 1)
        self.tablev.reloadRows(at: [indexPath], with: .none)
    }
    
    //Marks: - Profile button
    @objc func profile(sender: UIButton)
    {
        //let tag = sender.tag
    }
    
    //Marks: - Video Play button
    @objc func playvideo(sender: UIButton) {
        let tag = sender.tag
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
        vc.videoimagetag = VIDEO
        vc.videoimagename = arrvideourl[tag]
        let urlString = videopath+arrvideourl[tag]+videoPlayEndPath
        
        vc.strurl = urlString
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//     obj.funForceDownloadPlayShow(urlString: urlString, isProgressBarShow: true, viewController: self, completion: {
//         url in
//
//         if url == ""{
//             vc.profilepic = UIImage(named: "tempimg")!
//         }
//         else{
//             vc.strurl = url!
//         }
//         //MARK:- Reload image row after download
//
//         DispatchQueue.main.async {
//             self.navigationController?.pushViewController(vc, animated: true)
//         }
//     })
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
    @objc func likefun(sender: UIButton)
    {
        let tag = sender.tag
        
        if arrmylike[tag] == "0" || arrmylike[tag] == "" {
            self.like(tag: tag)
            var value = Int(self.arrlike[tag])
            if value == nil{
                value = 0
            }
            value = value! + 1
            
            if value! < 0
            {
                value = 0
            }
            var strvalue = String()
            strvalue = "\(value!)"
            
            self.arrlike[tag] = strvalue
            
            if self.arrmylike[tag] == "0"
            {
                self.arrmylike[tag] = "1"
            }
            else
            {
                self.arrmylike[tag] = "0"
            }
            if value == 0
            {
                self.arrmylike[tag] = "0"
            }
        }
        else
        {
            
            self.unlike(tag: tag)
            var value = Int(self.arrlike[tag])
            if value == nil{
                value = 0
            }
            value = value! - 1
            
            if value! < 0
            {
                value = 0
            }
            var strvalue = String()
            strvalue = "\(value!)"
            
            self.arrlike[tag] = strvalue
            
            if self.arrmylike[tag] == "0"
            {
                self.arrmylike[tag] = "1"
            }
            else
            {
                self.arrmylike[tag] = "0"
            }
            if value == 0
            {
                self.arrmylike[tag] = "0"
            }
        }
        let indexPath = IndexPath(item: tag, section: 1)
        DispatchQueue.main.async {
            self.tablev.reloadRows(at: [indexPath], with: .none)
        }
    }
    //Marks: - Comment button
    @objc func commentfun(sender: UIButton)
    {
        let tag = sender.tag
        
        commenttag = tag
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Comments") as! Comments
        vc.type = "News"
        vc.statusid = arrstatusid[tag]
        vc.totallike = arrlike[tag]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Marks: = Share button
    @objc func sharefun(sender: UIButton)
    {
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
    func shareChat(tag: Int, is_ePoultryContacts: Bool){
        
        var desc = self.arrdesc[tag]
        desc = desc.replacingOccurrences(of: "_&epoultry&_", with: "\n")
        var tempselectedMessageType = 0
        var tempselectedMessageImage = UIImage()
        let tempselectedMessageText = desc
        let tempis_ePoultryContacts = is_ePoultryContacts
        if self.arrsubTypes[tag] as? String == "video"
        {
            //MARK:- Video
            tempselectedMessageType = VIDEO
            let indexPath = IndexPath(item: tag, section: 1)
            guard let cell = self.tablev.cellForRow(at: indexPath) as? VideoPostCell else {
                return // or fatalError() or whatever
            }
            tempselectedMessageImage = cell.imgpost.image!
            let videoUrl = videopath+arrvideourl[tag]+videoPlayEndPath
            let tempFileName = arrvideourl[tag]
            obj.funForceDownloadPlayShow(urlString: videoUrl, isProgressBarShow: true, viewController: self, completion: {
                    url in
                       
                    if url == ""{

                    }
                    else{

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
            let indexPath = IndexPath(item: tag, section: 1)
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
    // Marks: - Button option
    @objc func optionbtn(sender: UIButton)
    {
        let tag = sender.tag
        let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Edit", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddnewPost") as! AddnewPost
            
            vc.newsvideostag = "public"
            vc.type = "News"
            vc.edit = "1"
            vc.statusid = self.arrstatusid[tag]
            
            vc.postTypeNewsORTimeLine = "news"
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
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 2{
            return 2
        }
        return arrname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
             let cell = tablev.dequeueReusableCell(withIdentifier: "TagFilterSearchTagCell", for: indexPath) as! TagFilterSearchTagCell
            cell.lbltitle.numberOfLines = 0
            cell.lbltitle.lineBreakMode = .byWordWrapping
            cell.lbltitle.text = NEWsChannelSEARCHTags
            cell.lblFilterTag.text = "Filter Tag"
            cell.lbltitle.sizeToFit()
            return cell
        }
        else if indexPath.section == 2{
            let cell = tablev.dequeueReusableCell(withIdentifier: "BlankSpaceCell", for: indexPath) as! BlankSpaceCell
            return cell
        }
        if arrsubTypes[indexPath.row] as? String == "video"
        {
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
        else if arrsubTypes[indexPath.row] as? String == "image"
        {
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
        else if arrsubTypes[indexPath.row] as? String == "link"{
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
        else if arrsubTypes[indexPath.row] as? String == "document"{
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "DocumentCell") as! DocumentCell
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
        else
        {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! NewsCell
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if NEWsChannelSEARCHTags == "All" || NEWsChannelSEARCHTags == ""{
                return 0
            }
            else{
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
    //Show Last Cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row+1 == arrstatusid.count {
            let laststatusid = arrstatusid.last
            if laststatusid == lastindex
            {
                
            }
            else
            {
                
            }
            self.GetMoreNewsPosts()
            print("came to last row")
        }
    }
    
    // Get Location Name from Latitude and Longitude
    func GetAllNewsPosts() {
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        let url = BASEURL+"news/\(NEWsChannelID)/channel?channelid=\(NEWsChannelID)&userId=\(userid)&type=All&subType=\(NEWsChannelSEARCHTags)&hashtag=All&limit=\(40)&offset=\(0)&eventDate=\(NEWsChannelEventDate)&FromDate=\(NEWsChannelFromDate)&ToDate=\(NEWsChannelToDate)&search=\(NEWsChannelSEARCHTitle)"
        
     //  let url = DataContainer.baseUrl()+"http://epoultryapi.zederp.net/api/news/\(channelID)/channel?channelid=\(channelID)&userId=\(userid)&type=All&subType=All&hashtag=\(hashtag)&limit=40&offset=0&eventDate="
        
        
       // let url = DataContainer.baseUrl()+"news/\(channelID)/channel?userid=\(userid)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
                if self.pulltorefresh == "1"
                {
                    self.pulltorefresh = "0"
                    refreshControl.endRefreshing()
                }
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0
                            {
                                self.manageUserData(mainDict: datadic)
                            }
                            else
                            {
                                self.tablev.reloadData()
                                DispatchQueue.main.async {
                                    obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                                }
                            }
                        }
                        else
                        {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    
    // Get Location Name from Latitude and Longitude
    func GetMoreNewsPosts() {
        //let url = DataContainer.baseUrl()+"news/\(channelID)/channel?userid=\(userid)"
        let userid = defaults.value(forKey: "userid") as! String
        let lastid = arrstatusid.last!
      //  let url = DataContainer.baseUrl()+"news/\(channelID)/channel?userid=\(userid)&offset=\(lastid)"
        let url = BASEURL + "news/\(NEWsChannelID)/channel?channelid=\(NEWsChannelID)&userId=\(userid)&type=All&subType=\(NEWsChannelSEARCHTags)&hashtag=All&limit=\(40)&offset=\(lastid)&eventDate=\(NEWsChannelEventDate)&FromDate=\(NEWsChannelFromDate)&ToDate=\(NEWsChannelToDate)&search=\(NEWsChannelSEARCHTitle)"
                
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
                    if error == nil && responseObject != nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                self.GetMoreNewsPostsManageData(mainDict: datadic)
                            }
                            else {
                                //obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
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
    
    func setcustomimage(cell: ImgvCell, imgvv: UIImageView) {
        cell.setCustomImage(image: imgvv.image!)
    }
    
    
//    // Marks: - Get All Posts
//    func GetMoreNewsPosts()
//    {
//
//        var userid = String()
//        if let tempid = defaults.value(forKey: "userid") as? String
//        {
//            userid = tempid
//        }
//        else
//        {
//            userid = ""
//        }
//
//        let lastid = arrstatusid.last!
//
//        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <GetmoreSpecificTypeStatuses xmlns='http://threepin.org/'><id>\(userid)</id><type>News</type><lastId>\(lastid)</lastId></GetmoreSpecificTypeStatuses></soap:Body></soap:Envelope>"
//
//
//        let soapLenth = String(soapMessage.count)
//        let theUrlString = "http://websrv.zederp.net/Apml/StatusService.asmx"
//        let theURL = URL(string: theUrlString)
//        let mutableR = NSMutableURLRequest(url: theURL!)
//
//        // MUTABLE REQUEST
//
//        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
//        mutableR.httpMethod = "POST"
//        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
//
//        let session = URLSession.shared
//
//        andicator2.startAnimating()
//
//        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
//            //print("Response: \(response)")
//            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            //print("Body: \(strData)")
//
//
//            self.andicator2.stopAnimating()
//            var dictionaryData = NSDictionary()
//
//            do
//            {
//                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
//
//                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetmoreSpecificTypeStatusesResponse")! as Any) as AnyObject).object(forKey:"GetmoreSpecificTypeStatusesResult")   ?? NSDictionary()
//
//
//
//                if (mainDict as AnyObject).count > 0{
//
//                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//
//                    let text = mainD.value(forKey: "text") as! NSString
//                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
//                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
//
//                    if text == "0"
//                    {
//                        obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
//                    }
//                    else
//                    {
//                        let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
//
//                        for dict in json {
//                            // dump(dict)
//
//                            self.arrsubTypes.append(dict.value(forKey: "SubType") as Any)
//                            if let Name = dict.value(forKey: "Name") as? String
//                            {
//                                self.arrname.append(Name)
//                            }
//                            else
//                            {
//                                self.arrname.append("")
//                            }
//                            if let UserId = dict.value(forKey: "UserId") as? Int
//                            {
//                                self.arrid.append(String(UserId))
//                            }
//                            else
//                            {
//                                self.arrid.append("")
//                            }
//                            if let TotalComments = dict.value(forKey: "TotalComments") as? Int
//                            {
//                                self.arrcomment.append(String(TotalComments))
//                            }
//                            else
//                            {
//                                self.arrcomment.append("")
//                            }
//                            if let TotalLikes = dict.value(forKey: "TotalLikes") as? Int
//                            {
//                                self.arrlike.append(String(TotalLikes))
//                            }
//                            else
//                            {
//                                self.arrlike.append("")
//                            }
//                            if let Status = dict.value(forKey: "Status") as? String
//                            {
//                                self.arrdesc.append(String(Status))
//                            }
//                            else
//                            {
//                                self.arrdesc.append("")
//                            }
//                            if let ProfilePic = dict.value(forKey: "ProfilePic") as? String
//                            {
//                                self.arrprofileimg.append(String(ProfilePic))
//                            }
//                            else
//                            {
//                                self.arrprofileimg.append("")
//                            }
//                            if let ImagePath = dict.value(forKey: "ImagePath") as? String
//                            {
//                                self.arrpostimg.append(String(ImagePath))
//                            }
//                            else
//                            {
//                                self.arrpostimg.append("")
//                            }
//
//
//                            if let VideoThumb = dict.value(forKey: "VideoThumb") as? String
//                            {
//                                self.arrvideoimg.append(String(VideoThumb))
//                            }
//                            else
//                            {
//                                self.arrvideoimg.append("")
//                            }
//
//                            if let VideoFile = dict.value(forKey: "VideoFile") as? String
//                            {
//                                self.arrvideourl.append(String(VideoFile))
//                            }
//                            else
//                            {
//                                self.arrvideourl.append("")
//                            }
//                            if let MyLike = dict.value(forKey: "MyLike") as? Int
//                            {
//                                self.arrmylike.append(String(MyLike))
//                            }
//                            else
//                            {
//                                self.arrmylike.append("")
//                            }
//                            if let StatusID = dict.value(forKey: "StatusID") as? Int
//                            {
//                                self.arrstatusid.append(String(StatusID))
//                            }
//                            else
//                            {
//                                self.arrstatusid.append("")
//                            }
//
//                            if let CreatedOn = dict.value(forKey: "CreatedOn") as? String
//                            {
//
//                                let prefix = "/Date("
//                                let suffix = ")/"
//                                let scanner = Scanner(string: CreatedOn)
//
//                                // Check prefix:
//                                if scanner.scanString(prefix, into: nil) {
//
//                                    // Read milliseconds part:
//                                    var milliseconds : Int64 = 0
//                                    if scanner.scanInt64(&milliseconds) {
//                                        // Milliseconds to seconds:
//                                        var timeStamp = TimeInterval(milliseconds)/1000.0
//
//                                        // Read optional timezone part:
//                                        var timeZoneOffset : Int = 0
//                                        if scanner.scanInt(&timeZoneOffset) {
//                                            let hours = timeZoneOffset / 100
//                                            let minutes = timeZoneOffset % 100
//                                            // Adjust timestamp according to timezone:
//                                            timeStamp += TimeInterval(3600 * hours + 60 * minutes)
//                                        }
//
//                                        // Check suffix:
//                                        if scanner.scanString(suffix, into: nil) {
//                                            // Success! Create NSDate and return.
//                                            //self(timeIntervalSince1970: timeStamp)
//                                            let date = NSDate(timeIntervalSince1970: timeStamp)
//
//
//                                            //print(agotime)
//                                            let dateFormatter = DateFormatter()
//                                            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//                                            dateFormatter.locale = NSLocale.current
//                                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
//                                            let strDate = dateFormatter.string(from: date as Date)
//                                            let ddate = dateFormatter.date(from: strDate)
//
//                                            let agotime =  self.timeAgoSinceDate(date: ddate! as NSDate, numericDates: true)
//                                            //print(agotime)
//                                            self.arrtime.append(agotime)
//                                        }
//                                    }
//                                }
//                            }
//                            else
//                            {
//                                self.arrtime.append("")
//                            }
//
//                            if let IsVideo = dict.value(forKey: "IsVideo") as? Bool
//                            {
//                                if IsVideo == true
//                                {
//                                    self.arrisvideo.append("1")
//                                }
//                                else
//                                {
//                                    self.arrisvideo.append("0")
//                                }
//                            }
//                            else
//                            {
//                                self.arrisvideo.append("0")
//                            }
//
//                            // self.arrcity.append(tempcity)
//                            // self.arrisactivecon.append(tempcityid)
//                            self.lastindex = self.arrstatusid.last!
//                            DispatchQueue.main.async {
//                                self.tablev.reloadData()
//
//                            }
//                        }
//
//                    }
//                }
//                else{
//
//                    obj.showAlert(title: "Alert", message: "try again", viewController: self)
//
//                }
//
//            }
//            catch
//            {
//                print("Your Dictionary value nil")
//            }
//
//
//            if error != nil
//            {
//                self.andicator2.stopAnimating()
//                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
//            }
//        })
//
//        task.resume()
//
//
//        // AFNETWORKING REQUEST
//
//        // let mn = AFHTTPRequestOperation()
//

//
//    }
    
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
                
                if dataarray.count == 0
                {
                    self.tablev.reloadData()
                    DispatchQueue.main.async {
                        //obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        for tempdict in dataarray{
                            
                            let dict = tempdict as! NSDictionary
                            // print(dict)
                            
                            self.arrsubTypes.append(dict.value(forKey: "SubType") as Any)
                            
                            if let Name = dict.value(forKey: "Name") as? String {
                                self.arrname.append(Name)
                            }
                            else
                            {
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
                            else
                            {
                                self.arrvideoimg.append("")
                            }
                            
                            if let VideoFile = dict.value(forKey: "VideoFile") as? String
                            {
                                self.arrvideourl.append(String(VideoFile))
                            }
                            else
                            {
                                self.arrvideourl.append("")
                            }
                            if let MyLike = dict.value(forKey: "MyLike") as? Int
                            {
                                self.arrmylike.append(String(MyLike))
                            }
                            else
                            {
                                self.arrmylike.append("")
                            }
                            if let StatusID = dict.value(forKey: "StatusID") as? Int
                            {
                                self.arrstatusid.append(String(StatusID))
                            }
                            else
                            {
                                self.arrstatusid.append("")
                            }
                            
                            if let CreatedOn = dict.value(forKey: "CreatedOn") as? String
                            {
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
                            else
                            {
                                self.arrtime.append("")
                            }
                            
                            if let IsVideo = dict.value(forKey: "IsVideo") as? Bool
                            {
                                if IsVideo == true
                                {
                                    self.arrisvideo.append("1")
                                }
                                else
                                {
                                    self.arrisvideo.append("0")
                                }
                            }
                            else
                            {
                                self.arrisvideo.append("0")
                            }
                            
                            // self.arrcity.append(tempcity)
                            // self.arrisactivecon.append(tempcityid)
                            if self.lastindex == self.arrstatusid.last!
                            {
                                
                            }
                            else
                            {
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
            else{
                obj.showAlert(title: "Alert", message: "try again", viewController: self)
            }
        }
        catch
        {
            
        }
    }
    
    
    func GetMoreNewsPostsManageData(mainDict: NSDictionary)
    {
        do
        {
            if (mainDict as AnyObject).count > 0{
                let mainD = NSDictionary(dictionary: mainDict)
                
                let dataarray = mainD.value(forKey: "Data") as! NSArray
                // text = text.replacingOccurrences(of: "[", with: "") as NSString
                // text = text.replacingOccurrences(of: "]", with: "") as NSString
                
                if dataarray.count == 0
                {
                    //obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                }
                else
                {
                    DispatchQueue.main.async {
                        for tempdict in dataarray{
                            
                            let dict = tempdict as! NSDictionary
                            // print(dict)
                            
                            self.arrsubTypes.append(dict.value(forKey: "SubType") as Any)
                            
                            if let Name = dict.value(forKey: "Name") as? String
                            {
                                self.arrname.append(Name)
                            }
                            else
                            {
                                self.arrname.append("")
                            }
                            if let UserId = dict.value(forKey: "UserId") as? Int
                            {
                                self.arrid.append(String(UserId))
                            }
                            else
                            {
                                self.arrid.append("")
                            }
                            if let TotalComments = dict.value(forKey: "TotalComments") as? Int
                            {
                                self.arrcomment.append(String(TotalComments))
                            }
                            else
                            {
                                self.arrcomment.append("")
                            }
                            if let TotalLikes = dict.value(forKey: "TotalLikes") as? Int
                            {
                                self.arrlike.append(String(TotalLikes))
                            }
                            else
                            {
                                self.arrlike.append("")
                            }
                            if let Status = dict.value(forKey: "Status") as? String
                            {
                                self.arrdesc.append(String(Status))
                            }
                            else
                            {
                                self.arrdesc.append("")
                            }
                            if let ProfilePic = dict.value(forKey: "ProfilePic") as? String
                            {
                                self.arrprofileimg.append(String(ProfilePic))
                            }
                            else
                            {
                                self.arrprofileimg.append("")
                            }
                            if let ImagePath = dict.value(forKey: "ImagePath") as? String
                            {
                                self.arrpostimg.append(String(ImagePath))
                            }
                            else
                            {
                                self.arrpostimg.append("")
                            }
                            
                            
                            if let VideoThumb = dict.value(forKey: "VideoThumb") as? String
                            {
                                self.arrvideoimg.append(String(VideoThumb))
                            }
                            else
                            {
                                self.arrvideoimg.append("")
                            }
                            
                            if let VideoFile = dict.value(forKey: "VideoFile") as? String
                            {
                                self.arrvideourl.append(String(VideoFile))
                            }
                            else
                            {
                                self.arrvideourl.append("")
                            }
                            if let MyLike = dict.value(forKey: "MyLike") as? Int
                            {
                                self.arrmylike.append(String(MyLike))
                            }
                            else
                            {
                                self.arrmylike.append("")
                            }
                            if let StatusID = dict.value(forKey: "StatusID") as? Int
                            {
                                self.arrstatusid.append(String(StatusID))
                            }
                            else
                            {
                                self.arrstatusid.append("")
                            }
                            
                            if let CreatedOn = dict.value(forKey: "CreatedOn") as? String
                            {
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
                            else
                            {
                                self.arrtime.append("")
                            }
                            
                            if let IsVideo = dict.value(forKey: "IsVideo") as? Bool
                            {
                                if IsVideo == true
                                {
                                    self.arrisvideo.append("1")
                                }
                                else
                                {
                                    self.arrisvideo.append("0")
                                }
                            }
                            else
                            {
                                self.arrisvideo.append("0")
                            }
                            
                            // self.arrcity.append(tempcity)
                            // self.arrisactivecon.append(tempcityid)
                            if self.lastindex == self.arrstatusid.last!
                            {
                                
                            }
                            else
                            {
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
            else{
                obj.showAlert(title: "Alert", message: "try again", viewController: self)
            }
        }
        catch
        {
            
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
                if error == nil
                {
                    if responseObject!.count > 0
                    {
                        let datadic = (responseObject! as NSDictionary)
                        if datadic.count > 0
                        {
                            
                        }
                        else
                        {
                            obj.showAlert(title: "Alert", message: "try again", viewController: self)
                        }
                    }
                    else
                    {
                        obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                    }
                }
                else
                {
                    //  obj.showAlert(title: "Error", message: error!, viewController: self)
                }
            }
        })
    }
    
    // Marks: - Like
    func unlike(tag: Int) {
        let statusid = arrstatusid[tag]
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"Status/\(statusid)/Unlike?userId=\(userid)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        let parameters : Parameters =
            ["": ""]
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            
            self.andicator.stopAnimating()
            //print(responseObject)
            DispatchQueue.main.async {
                if error == nil
                {
                    if responseObject!.count > 0
                    {
                        let datadic = (responseObject! as NSDictionary)
                        if datadic.count > 0
                        {
                            
                        }
                        else
                        {
                            obj.showAlert(title: "Alert", message: "try again", viewController: self)
                        }
                    }
                    else
                    {
                        obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                    }
                }
                else
                {
                    //  obj.showAlert(title: "Error", message: error!, viewController: self)
                }
            }
        })
    }
    //MARK:- Delete card
    @objc func delete(tag  : Int)
    {
        refreshControl.endRefreshing()
        let statusid = arrstatusid[tag]
        let url = BASEURL+"status/\(statusid)"
        
        andicator.startAnimating()
        obj.webServiceDelete(url: url, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
                DispatchQueue.main.async {
                    if error == nil
                    {
                        print(responseObject!)
                        
                        let success = (responseObject!).value(forKey: "data") as! String
                        if success == "1" || success == "2"
                        {
                            self.arrsubTypes.remove(at: tag)
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
                            
                            self.tablev.reloadData()
                            DispatchQueue.main.async {
                                obj.showAlert(title: "Alert!", message: "Post deleted successfully.", viewController: self)
                            }
                        }
                        else
                        {
                            print("tarrideError")
                            obj.showAlert(title: "Alert!", message: "Failed to delete", viewController: self)
                        }
                    }
                    else
                    {
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
    func getallgroupsOld()
    {
        var role = String()
        if let tempid = defaults.value(forKey: "role") as? String
        {
            role = tempid
        }
        else
        {
            role = "1"
        }
        
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        //let url = BASEURL+"group/GetAllGroups?userId=\(userid)&role=\(role)"
        let url = BASEURL+"channels/\(userid)?tags=All&admin=\(USERROLE)"
        obj.webServicesGet(url: url, completionHandler:
            {
                responseObject, error in
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSArray)
                            if datadic.count == 0
                            {
                                
                            }
                            else
                            {
                                let dataarray = datadic
                                if dataarray.count == 0
                                {
                                    obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                                }
                                else
                                {
                                    for tempdict in dataarray{
                                        let dict = tempdict as! NSDictionary
                                        
                                        if let title = dict.value(forKey: "GroupTitle") as? String
                                        {
                                            self.arrgtitle.append(title)
                                        }
                                        else
                                        {
                                            self.arrgtitle.append("")
                                        }
                                        if let Type = dict.value(forKey: "Type") as? String
                                        {
                                            self.arrgtype.append(Type)
                                        }
                                        else
                                        {
                                            self.arrgtype.append("")
                                        }
                                        if let GroupId = dict.value(forKey: "GroupId") as? Int
                                        {
                                            //self.arrgid.append(String(GroupId))
                                        }
                                        else
                                        {
                                            //self.arrgid.append("")
                                        }
                                        if let GroupProfilePic = dict.value(forKey: "GroupProfilePic") as? String
                                        {
                                            self.arrgimgprofile.append(GroupProfilePic)
                                        }
                                        else
                                        {
                                            self.arrgimgprofile.append("")
                                        }
                                        if let Total = dict.value(forKey: "Total") as? Int
                                        {
                                            self.arrgtotalmember.append(String(Total))
                                        }
                                        else
                                        {
                                            self.arrgtotalmember.append("")
                                        }
                                        if let userstatus = dict.value(forKey: "userstatus") as? Int
                                        {
                                            self.arrguserstatus.append(String(userstatus))
                                        }
                                        else
                                        {
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
    
    func getallgroups()
    {
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        let url = BASEURL+"channels/\(userid)?tags=All&admin=\(USERROLE)"
        print(url)

        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0
                            {
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
                            else
                            {
                                //showAlertPleaseWait(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else
                        {
                            //viewController: self)
                        }
                    }
                    else
                    {
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


}

// Marks : -  Custom CZPicker View
extension News: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        //            if pickerView == pickerWithImage {
        //                return fruitImages[row]
        //            }
        let image = UIImageView()
        if (arrgimgprofile[row]) != ""
        {
            //Kingfisher Image upload
            let urlprofile = URL(string: userimagepath+arrgimgprofile[row])
            //this is working the bottom line
            //let urlprofile = URL(string: imagepath+arrgimgprofile[row])
            
            image.kf.setImage(with: urlprofile)
        }
        else
        {
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
    
    func shareingroupOld(tag : Int)
    {
        let statusid = self.arrstatusid[selectedrow]
        let groupid = self.arrgid[tag]
        let gtype = self.arrgtype[tag]
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><ShareGroupStatus xmlns='http://threepin.org/'><userId>\(userid)</userId><status></status><type>\(gtype)</type><groupId>\(groupid)</groupId><tag>\("s")</tag><parentStatusID>\(statusid)</parentStatusID></ShareGroupStatus></soap:Body></soap:Envelope>"
        
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/StatusService.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
        
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        
        let session = URLSession.shared
        
        self.view.addSubview(andicator)
        andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            //print("Response: \(response)")
            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Body: \(strData)")
            
           
            self.andicator.stopAnimating()
            self.andicator.removeFromSuperview()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "ShareGroupStatusResponse")! as Any) as AnyObject).object(forKey:"ShareGroupStatusResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Failed to Share", viewController: self)
                    }
                    else
                    {
                        obj.showAlert(title: "Alert!", message: "Post share on channel successfully.", viewController: self)
                        
                    }
                }
                else{
                    
                    obj.showAlert(title: "Alert", message: "try again", viewController: self)
                }
                
                
            }
            catch
            {
                print("Your Dictionary value nil")
            }

            if error != nil
            {
                self.andicator.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
        
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
    
    func shareinTimeline(tag : Int)
    {
        let statusid = self.arrstatusid[selectedrow]
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        let url = BASEURL + "news/share?userId=\(userid)&statusId=\(statusid)"
        
        let parameters : Parameters =
            ["": ""]
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil
            {
                if responseObject!.value(forKey: "data") as? Int == 1
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object: nil)
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
    
    
}


// MARK: - IndicatorInfoProvider for page controller like android
extension News: IndicatorInfoProvider {
    //MARK:- Display Title name
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "HOME")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "News")
        return itemInfo
    }
}
