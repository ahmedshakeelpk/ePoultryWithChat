//
//  GroupPosts.swift
//  AMPL
//
//  Created by sameer on 09/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import CZPicker
import Kingfisher
import ISEmojiView
import Alamofire

class GroupPosts: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,EmojiViewDelegate {

    var and = UIActivityIndicatorView()
    
    var groupimage = String()
    var pulltorefresh = String()
    
    var strtitle = String()
    var groupid = String()
    var lastindex = String()
    var type = String()
    var commenttag = Int()
    
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
    var arrtag = [String]()
    var arrsubTypes = [Any]()
    
    /////// Marks: - For Groups Arrays
    var arrgtitle = [Any]()
    var arrgtype = [Any]()
    var arrgid = NSArray()
    var arrgimgprofile = [Any]()
    var arrgtotalmember = [Any]()
    var arrguserstatus = [Any]()

    //////////////////////////////////////////////////////
    @IBOutlet weak var andicator2: UIActivityIndicatorView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var btnaddgrouppost: UIButton!
    @IBOutlet weak var btntag: UIButton!
    @IBOutlet weak var btnsend: UIButton!
    @IBOutlet weak var txtcomment: UITextField!
    
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardHeight = 0.0
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeightt = keyboardRectangle.height
            keyboardHeight = Float(keyboardHeightt)
        }
    }
    override func viewDidLoad() {
        self.tablev.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0); //values
        super.viewDidLoad()
        txtcomment.delegate = self
        // Do any additional setup after loading the view.
       //MARK : - Activity andicator in footer view
        tablev.tableFooterView = andicator2
        andicator2.hidesWhenStopped = true
        andicator2.stopAnimating()
        //MARK : - btn tag cornor radius
        btntag.layer.cornerRadius = btntag.frame.width / 2
        
        // MARK : - UIRefresh controll in table View
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(pulltorefreshfun), for: UIControl.Event.valueChanged)
        tablev.addSubview(refreshControl) // not required when using UITableViewController
        
        // MARK : - Remove Notification
        NotificationCenter.default.removeObserver(self)
        // Update Comment to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationGroupComment), name: NSNotification.Name(rawValue: "updategroupcomment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationGroupPost), name: NSNotification.Name(rawValue: "updategroup"), object: nil)
        // Leave Group to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationleavegroup), name: NSNotification.Name(rawValue: "leavegroup"), object: nil)
        btnaddgrouppost.layer.cornerRadius = btnaddgrouppost.frame.width / 2
        
        tablev.rowHeight = 128
        tablev.estimatedRowHeight = UITableView.automaticDimension
        
        /////////////////
        self.title = strtitle
        //MARK : - textfield touch event with add target
        txtcomment.addTarget(self, action: #selector(txtcommentfun), for: .allEvents)
        
       // MARK:- Right bar button
        let btninfo:UIBarButtonItem = UIBarButtonItem(image:UIImage.init(named: "info"), style: UIBarButtonItem.Style.done, target: self, action: #selector(btninfofun))
        self.navigationItem.setRightBarButtonItems([btninfo], animated: true)
        
        self.GetAllGroupPosts()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        //MARK:- Cell Register
        self.tablev.register(UINib(nibName: "ImgvCell", bundle: nil), forCellReuseIdentifier: "ImgvCell")
        //MARK:- Cell Register
        self.tablev.register(UINib(nibName: "LinkCell", bundle: nil), forCellReuseIdentifier: "LinkCell")
        self.tablev.register(UINib(nibName: "DocumentCell", bundle: nil), forCellReuseIdentifier: "DocumentCell")
        self.tablev.register(UINib(nibName: "TagFilterSearchTagCell", bundle: nil), forCellReuseIdentifier: "TagFilterSearchTagCell")
        self.tablev.register(UINib(nibName: "VideoPostCell", bundle: nil), forCellReuseIdentifier: "cellvideo")
    }
    
    //MARK:- Leave Group Notification
    @objc func handleNotificationleavegroup()
    {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            DispatchQueue.main.async {
                
            }
        }
    }
    
    
    //MARK:- Function Group Info
    @objc func btninfofun()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupInfo") as! GroupInfo
        vc.groupid = groupid
        vc.groupname = strtitle
        vc.groupimage = groupimage
        
        DispatchQueue.main.async {
             self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //Marks: - Function touchup inside of textfield
    @objc func txtcommentfun()
    {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                self.tablev.frame = CGRect(x: 0, y: 0, width:   self.tablev.frame.size.width, height:   self.view.frame.maxY)
                self.view.frame.origin.y = 64
                self.view.frame.origin.y = -(CGFloat(keyboardHeight-74))
                self.tablev.frame = CGRect(
                    x: 0,
                    y:     CGFloat(keyboardHeight+10),
                    width:     self.tablev.frame.size.width,
                    height:   self.view.frame.maxY)
            }
        }
    }
    
    // Marks: - Return button delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // self.view.endEditing(true)
        
        DispatchQueue.main.async{
            let indexPath = IndexPath(row: 0, section: 0)
            let indexPath1 = IndexPath(row: 3, section: 0)
           // self.tablev.scrollToRow(at: indexPath, at: .top, animated: true)
            self.tablev.moveRow(at: indexPath, to: indexPath1)
        }
        
        
        txtcomment.inputView = nil
        return true
    }

    
    //MARK : - Activity andicator in footer view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        self.view.frame.origin.y = 64
        self.tablev.frame = CGRect(x: 0, y: 0, width: self.tablev.frame.size.width, height: self.view.frame.maxY)
        
        txtcomment.inputView = nil
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            // call method to add data to tableView
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hidefooter), userInfo: nil, repeats: false)
        }
    }
    
    //MARK: - Hide Footer
    @objc func hidefooter()
    {
        andicator2.stopAnimating()
        tablev.tableFooterView!.isHidden = true
    }    //Marks: - Send
    @IBAction func btnsend(_ sender: Any) {
        if txtcomment.text != ""
        {
            addmsgpost()
        }
    }
    //Marks: - Add Group
    @IBAction func btnaddgrouppost(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddnewPost") as! AddnewPost
        vc.type = "Group"
        vc.statusid = groupid
        vc.posttype = "v1/Group/Post"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //Marks: - Tag
    @IBAction func btntag(_ sender: Any) {
        
        let emojiView = EmojiView()
        emojiView.delegate = self
        self.txtcomment.inputView = emojiView
        
        txtcomment.becomeFirstResponder()
    }
    
    //Marks: - Profile button
    @objc func profile(sender: UIButton)
    {
        //let tag = sender.tag
    }
    
    //Marks: - Video Play button
    @objc func playvideo(sender: UIButton)
    {
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
    @objc func showimage(sender: UIButton)
    {
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
        
        if arrmylike[tag] == "0" || arrmylike[tag] == ""
        {
            like(tag: tag)
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
            
            if self.arrmylike[tag] == "0" || self.arrmylike[tag] == ""
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
            
            if self.arrmylike[tag] == "0" || self.arrmylike[tag] == ""
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
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: tag, section: 0)
            self.tablev.reloadRows(at: [indexPath], with: .none)
        }
    }
    //Marks: - Comment button
    @objc func commentfun(sender: UIButton)
    {
        let tag = sender.tag
        
        commenttag = tag
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Comments") as! Comments
        vc.type = "Groups"
        vc.statusid = arrstatusid[tag]
        vc.totallike = arrlike[tag]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Marks: = Share button
    @objc func sharefun(sender: UIButton)
    {
        let tag = sender.tag
        let alertController = UIAlertController(title: "Share it!", message: "", preferredStyle:UIAlertController.Style.alert)
        
        
        alertController.addAction(UIAlertAction(title: "Social Media", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            
            let desc = self.arrdesc[tag]
            let image = imagepath+self.arrpostimg[tag]+"\n\n"
            let video = videopath+self.arrpostimg[tag]+videoPlayEndPath
            var activityVC = UIActivityViewController(activityItems: [], applicationActivities: nil)
            
            if self.arrisvideo[tag] == "1"
            {
                activityVC = UIActivityViewController(activityItems: [desc, video], applicationActivities: nil)
            }
            else if self.arrpostimg[tag] != ""
            {
                activityVC = UIActivityViewController(activityItems: [desc, image], applicationActivities: nil)
            }
            else
            {
                activityVC = UIActivityViewController(activityItems: [desc], applicationActivities: nil)
            }
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
            DispatchQueue.main.async
                {
                    // let obj = Movies()
                    // obj.Andicator.stopAnimating()
            }
        })
        alertController.addAction(UIAlertAction(title: "Groups Share", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            // Marks: - For the Custome Picker view
            
            selectedrow = tag
          //  arrpickerview = arrcities
            self.view.endEditing(true)
            // Marks: - Custome CZPicker View
            czpicker = CZPickerView(headerTitle: "Select group.", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
            czpicker.delegate = self
            czpicker.dataSource = self
            
            czpicker.headerBackgroundColor = appcolor
            czpicker.needFooterView = false
            czpicker.show()

            
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Marks: - Pull to refresh
    @objc func pulltorefreshfun()
    {
        pulltorefresh = "1"
        DispatchQueue.main.async {
            self.GetAllGroupPosts()
        }
    }
    
    //Marks: - Handle Notification
    @objc func handleNotificationGroupComment()
    {
        var value = Int(self.arrcomment[commenttag])
        value = value! + 1
        
        var strvalue = String()
        strvalue = "\(value!)"
        
        self.arrcomment[commenttag] = strvalue
        
        let indexPath = IndexPath(item: commenttag, section: 0)
        self.tablev.reloadRows(at: [indexPath], with: .none)
        
    }
    //Marks: - Handle Notification
    @objc func handleNotificationGroupPost()
    {
        GetAllGroupPosts()
        
    }
    
    // Marks: - Button option
    @objc func optionbtn(sender: UIButton)
    {
        let tag = sender.tag
        let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Info", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostInfo") as! PostInfo
            vc.statusid = self.arrstatusid[tag]
            
            vc.desc = self.arrdesc[tag]
            
            if self.arrisvideo[tag] == "1"
            {
                vc.imgname = self.arrvideourl[tag]
                vc.videotag = "1"
            }
            else
            {
                vc.imgname = self.arrpostimg[tag]
                vc.videotag = "0"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "Edit", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddnewPost") as! AddnewPost
            
            vc.newsvideostag = "public"
            vc.type = "group"
            vc.edit = "1"
            vc.statusid = self.arrstatusid[tag]
            
            
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

    

    
    
    ///////////////////////////////////////////////////////////////////////// Marks: - Delegates

    // Marks: - Table view datasource and delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrname.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
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
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! PostCell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    //Show Last Cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row+1 == arrstatusid.count {
            let laststatusid = arrstatusid.last
            if laststatusid == lastindex
            {
                DispatchQueue.main.async {
                    self.hidefooter()
                }

            }
            else
            {
                
            }
            self.GetMoreGroupPosts()
            print("came to last row")
        }
        else
        {
            DispatchQueue.main.async {
                self.hidefooter()
            }
            
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////
    // Marks: - 
    
    // Get Location Name from Latitude and Longitude
    func GetAllGroupPosts()
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
        let url = BASEURL+"group/GetGroupStatus?id=\(userid)&groupId=\(groupid)"
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
    
    func manageUserData(mainDict: NSDictionary)
    {
        do
        {
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
                    obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
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
    // Marks: - Get All Posts
    func GetAllGroupPostsOld()
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
        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetGroupPosts xmlns='http://threepin.org/'><id>\(userid)</id><groupId>\(groupid)</groupId></GetGroupPosts></soap:Body></soap:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/GroupService.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
        
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        
        let session = URLSession.shared
        
        if pulltorefresh != "1"
        {
            obj.startandicator(viewController: self)
            //obj.showActivityIndicatory(uiView: self.view)
//            and = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//            and.tintColor = appcolor
//            and.center = self.view.center
//            and.startAnimating()
//            self.view.addSubview(and)
//            self.tablev.bringSubview(toFront: and)
        }
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            
            if self.pulltorefresh != "1"
            {
                DispatchQueue.main.async {
                    obj.stopandicator(viewController: self)
                }
                
            }

            self.pulltorefresh = "0"
           
            refreshControl.endRefreshing()
            var dictionaryData = NSDictionary()
            
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetGroupPostsResponse")! as Any) as AnyObject).object(forKey:"GetGroupPostsResult")   ?? NSDictionary()
                
                
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
                self.arrtag = [String]()
                
               
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                    }
                    else
                    {
                        let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        
                        DispatchQueue.main.async {
                            for dict in json {
                                // dump(dict)
                                
                                
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
                                if let tag = dict.value(forKey: "tag") as? String
                                {
                                    self.arrtag.append(tag)
                                }
                                else
                                {
                                    self.arrtag.append("")
                                }
                                
                                
                                if let CreatedOn = dict.value(forKey: "CreatedOn") as? String
                                {
                                    
                                    let prefix = "/Date("
                                    let suffix = ")/"
                                    let scanner = Scanner(string: CreatedOn)
                                    
                                    // Check prefix:
                                    if scanner.scanString(prefix, into: nil) {
                                        
                                        // Read milliseconds part:
                                        var milliseconds : Int64 = 0
                                        if scanner.scanInt64(&milliseconds) {
                                            // Milliseconds to seconds:
                                            var timeStamp = TimeInterval(milliseconds)/1000.0
                                            
                                            // Read optional timezone part:
                                            var timeZoneOffset : Int = 0
                                            if scanner.scanInt(&timeZoneOffset) {
                                                let hours = timeZoneOffset / 100
                                                let minutes = timeZoneOffset % 100
                                                // Adjust timestamp according to timezone:
                                                timeStamp += TimeInterval(3600 * hours + 60 * minutes)
                                            }
                                            
                                            // Check suffix:
                                            if scanner.scanString(suffix, into: nil) {
                                                // Success! Create NSDate and return.
                                                //self(timeIntervalSince1970: timeStamp)
                                                let date = NSDate(timeIntervalSince1970: timeStamp)
                                                
                                                
                                                //print(agotime)
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                                                dateFormatter.locale = NSLocale.current
                                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                                                let strDate = dateFormatter.string(from: date as Date)
                                                let ddate = dateFormatter.date(from: strDate)
                                                
                                                let agotime =  self.timeAgoSinceDate(date: ddate! as NSDate, numericDates: true)
                                                //print(agotime)
                                                self.arrtime.append(agotime)
                                            }
                                        }
                                    }
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
                                    obj.stopandicator(viewController: self)
                                    DispatchQueue.main.async {
                                        
                                        self.tablev.reloadData()
                                        
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
                print("Your Dictionary value nil")
            }
                
            if error != nil
            {
                refreshControl.endRefreshing()
                self.pulltorefresh = "0"
                //self.andicator.stopAnimating()
                self.andicator.removeFromSuperview()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }
    
    // Marks: - Get All Posts
    func GetMoreGroupPosts()
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
        
        let lastid = arrstatusid.last!
        
//        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMoreStatus xmlns='http://threepin.org/'><user_id>\(userid)</user_id><last_id>\(lastid)</last_id><type>Group</type></GetMoreStatus></soap:Body></soap:Envelope>"
//        
//        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetmoreGroupPosts xmlns='http://threepin.org/'><id>\(userid)</id><groupId>\(groupid)</groupId><lastId>\(lastid)</lastId></GetmoreGroupPosts></soap:Body></soap:Envelope>"
        
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/GroupService.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
        
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        
        let session = URLSession.shared
        
        andicator2.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            self.andicator2.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetmoreGroupPostsResponse")! as Any) as AnyObject).object(forKey:"GetmoreGroupPostsResult")   ?? NSDictionary()
                
                
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                    }
                    else
                    {
                        let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        
                        for dict in json {
                            // dump(dict)
                            
                            
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
                            if let tag = dict.value(forKey: "tag") as? String
                            {
                                self.arrtag.append(tag)
                            }
                            else
                            {
                                self.arrtag.append("")
                            }
                            
                            if let CreatedOn = dict.value(forKey: "CreatedOn") as? String
                            {
                                
                                let prefix = "/Date("
                                let suffix = ")/"
                                let scanner = Scanner(string: CreatedOn)
                                
                                // Check prefix:
                                if scanner.scanString(prefix, into: nil) {
                                    
                                    // Read milliseconds part:
                                    var milliseconds : Int64 = 0
                                    if scanner.scanInt64(&milliseconds) {
                                        // Milliseconds to seconds:
                                        var timeStamp = TimeInterval(milliseconds)/1000.0
                                        
                                        // Read optional timezone part:
                                        var timeZoneOffset : Int = 0
                                        if scanner.scanInt(&timeZoneOffset) {
                                            let hours = timeZoneOffset / 100
                                            let minutes = timeZoneOffset % 100
                                            // Adjust timestamp according to timezone:
                                            timeStamp += TimeInterval(3600 * hours + 60 * minutes)
                                        }
                                        
                                        // Check suffix:
                                        if scanner.scanString(suffix, into: nil) {
                                            // Success! Create NSDate and return.
                                            //self(timeIntervalSince1970: timeStamp)
                                            let date = NSDate(timeIntervalSince1970: timeStamp)
                                            
                                            
                                            //print(agotime)
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                                            dateFormatter.locale = NSLocale.current
                                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                                            let strDate = dateFormatter.string(from: date as Date)
                                            let ddate = dateFormatter.date(from: strDate)
                                            
                                            let agotime =  self.timeAgoSinceDate(date: ddate! as NSDate, numericDates: true)
                                            //print(agotime)
                                            self.arrtime.append(agotime)
                                        }
                                    }
                                }
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
                            self.lastindex = self.arrstatusid.last!
                            DispatchQueue.main.async {
                                self.tablev.reloadData()
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
                print("Your Dictionary value nil")
            }
            if error != nil
            {
                self.andicator2.stopAnimating()
                obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
            }
        })
        
        task.resume()
    }
    
    // Marks: - Like
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
    func unlike(tag  : Int)
    {
        let statusid = arrstatusid[tag]
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"status/\(statusid)/unlike?userId=\(userid)"
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
                        if success == "1"
                        {
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

    //Marks Add post to server
    func addmsgpost()
    {
        var soapMessage = String()
        
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        
        
            //Marks: - simple text post
        //Marks: - simple text post
        soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateGroupStatus xmlns='http://threepin.org/'><filename></filename><user_id>\(userid)</user_id><status>\(txtcomment.text!)</status><type>\(type)</type><groupId>\(groupid)</groupId><img></img><isNew>1</isNew><tag>m</tag></UpdateGroupStatus></soap:Body></soap:Envelope>"
        
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
        andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateGroupStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateGroupStatusResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Failed to uploaded post try agian.", viewController: self)
                    }
                    else
                    {
                       
                        
                        self.GetAllGroupPosts()
                        DispatchQueue.main.async {
                             self.txtcomment.text = ""
                        }
                        
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
    func setcustomimage(cell: ImgvCell, imgvv: UIImageView){
        cell.setCustomImage(image: imgvv.image!)
    }
    //MARK: - Emoji's Keyboard Delegate
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        txtcomment.insertText(emoji)
    }
    
    
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        txtcomment.deleteBackward()
    }
}

// Marks : -  Custom CZPicker View
extension GroupPosts: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        //            if pickerView == pickerWithImage {
        //                return fruitImages[row]
        //            }
        let image = UIImageView()
        if arrgimgprofile[row] as? String != ""
        {
            let urlprofile = URL(string: imagepath + "\(arrgimgprofile[row])")
            image.kf.setImage(with: urlprofile)
        }
        else
        {
            image.image = #imageLiteral(resourceName: "groupimg")
        }
        return image.image
    }
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        arrpickerview  = arrgtitle as! [String]
        
        return arrpickerview.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return arrpickerview[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
        // objmodel.shareingroup(type: "Private", groupid: "103", statusid: "3075", tag: "s", andicator: andicator)
        shareingroup(tag: row)
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
        //let gtype = self.arrgtype[tag]
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        
        let url = BASEURL + "group/share?userId=\(userid)&groupId=\(groupid)&statusId=\(statusid)"
        
        let parameters : Parameters =
            ["": ""]
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil
            {
                if (responseObject!.value(forKey: "data") as? String) != nil
                {
                    obj.showAlert(title: "Alert!", message: "Post share on group successfully.", viewController: self)
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
