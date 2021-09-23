//
//  ChannelLinks.swift
//  ePoltry
//
//  Created by Apple on 05/11/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import CZPicker

class ChannelLinks: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    var arrgid = [String]()
    var arrgimgprofile = [String]()
    var arrgtotalmember = [String]()
    var arrguserstatus = [String]()
    /////////////////////////////////////////
    
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
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
        return arrid.count
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
            self.GetMoreLinkPosts()
            print("came to last row")
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
  
    }
    
    //Marks: - Profile button
    @objc func profile(sender: UIButton)
    {
        //let tag = sender.tag
    }
    
    //Marks: - Profile button
    @objc func showimage(sender: UIButton)
    {
        //let tag = sender.tag
    }
    override func viewWillAppear(_ animated: Bool) {
        GetAllChannelLinks()
    }
    override func viewDidLoad() {
        GetAllChannelLinks()
        getallgroups()
        super.viewDidLoad()

        //MARK:- Unimited rows in cell
        tablev.rowHeight = 128
        tablev.estimatedRowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        //MARK:- Register Cell for Send and Receive Message
        self.tablev.register(UINib(nibName: "LinkCell", bundle: nil), forCellReuseIdentifier: "LinkCell")
        self.tablev.register(UINib(nibName: "TagFilterSearchTagCell", bundle: nil), forCellReuseIdentifier: "TagFilterSearchTagCell")
        self.tablev.register(UINib(nibName: "BlankSpaceCell", bundle: nil), forCellReuseIdentifier: "BlankSpaceCell")
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationshowNewsPost), name: NSNotification.Name(rawValue: "newspost"), object: nil)
        }
        
        //Marks: - Handle Notification
        @objc func handleNotificationshowNewsPost(notification: Notification)
        {
            GetAllChannelLinks()
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
            vc.type = "Public"
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
                               
                               obj.showAlert(title: "Alert!", message: "Post deleted successfully.", viewController: self)
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
    func GetAllChannelLinks()
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
        let url = BASEURL + "news/\(NEWsChannelID)/channel?channelid=\(NEWsChannelID)&userId=\(userid)&type=All&subType=\("link")&hashtag=\(NEWsChannelSEARCHTags)&limit=\(40)&offset=\(0)&eventDate=\(NEWsChannelEventDate)&FromDate=\(NEWsChannelFromDate)&ToDate=\(NEWsChannelToDate)&search=\(NEWsChannelSEARCHTitle)"
        
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
       // andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
              //  self.andicator.stopAnimating()
               
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
                               // obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
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
                    self.tablev.reloadData()
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
                                
                                
                            }
                        }
                        DispatchQueue.main.async {
                            DispatchQueue.main.async {
                                self.tablev.reloadData()
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
    
    // Get Location Name from Latitude and Longitude
        func GetMoreLinkPosts()
        {
            //let url = DataContainer.baseUrl()+"news/\(channelID)/channel?userid=\(userid)"
            let userid = defaults.value(forKey: "userid") as! String
            let lastid = arrstatusid.last!
          //  let url = DataContainer.baseUrl()+"news/\(channelID)/channel?userid=\(userid)&offset=\(lastid)"
          
            let url = BASEURL + "news/\(NEWsChannelID)/channel?channelid=\(NEWsChannelID)&userId=\(userid)&type=All&subType=\("link")&hashtag=\(NEWsChannelSEARCHTags)&limit=\(40)&offset=\(lastid)&eventDate=\(NEWsChannelEventDate)&FromDate=\(NEWsChannelFromDate)&ToDate=\(NEWsChannelToDate)&search=\(NEWsChannelSEARCHTitle)"
            
            print(url)
            //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
            andicator.startAnimating()
            obj.webServicesGetwithJsonResponse(url: url, completionHandler:
                {
                    responseObject, error in
                    self.andicator.stopAnimating()
    //                if self.pulltorefresh == "1"
    //                {
    //                    self.pulltorefresh = "0"
    //                    refreshControl.endRefreshing()
    //                }
                    //print(responseObject)
                    DispatchQueue.main.async {
                        if error == nil
                        {
                            if responseObject!.count > 0
                            {
                                let datadic = (responseObject! as NSDictionary)
                                if datadic.count > 0
                                {
                                    
                                    self.GetMorePostsManageData(mainDict: datadic)
                                }
                                else
                                {
                                    //obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
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
    
    func GetMorePostsManageData(mainDict: NSDictionary)
     {
         do
         {
             if (mainDict as AnyObject).count > 0{
                 let mainD = NSDictionary(dictionary: mainDict)
                 
                 let dataarray = mainD.value(forKey: "Data") as! NSArray
                 // text = text.replacingOccurrences(of: "[", with: "") as NSString
                 // text = text.replacingOccurrences(of: "]", with: "") as NSString
                 
                 if dataarray.count == 0 && arrid.count == 0 {
                     obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
                 }
                 else
                 {
                     DispatchQueue.main.async {
                         for tempdict in dataarray{
                             let dict = tempdict as! NSDictionary
                             self.arrsubTypes.append(dict.value(forKey: "SubType") as Any)
                             // print(dict)
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
                             self.lastindex = self.arrstatusid.last!
                             DispatchQueue.main.async {
                                 self.tablev.reloadData()
                                 
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
    // Marks: - Get all Groups
    func getallgroups()
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
        //let url = BASEURL + "group/GetAllGroups?userId=\(userid)&role=\(role)"
        let url = BASEURL+"channels/\(userid)?tags=All&admin=\(USERROLE)"
        obj.webServicesGet(url: url, completionHandler: {
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
                                            self.arrgid.append(String(GroupId))
                                        }
                                        else
                                        {
                                            self.arrgid.append("")
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
    //Marks: - Like button
    @objc func likefun(sender: UIButton)
    {
        let tag = sender.tag
        
        if arrmylike[tag] == "0" || arrmylike[tag] == ""
        {
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Comments") as! Comments
        vc.type = "Public"
        vc.statusid = arrstatusid[tag]
        vc.totallike = arrlike[tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Activity andicator with footer view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tempdic = ["tablev": tablev]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollviewScroll"), object: tempdic)
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
         let url = BASEURL + "/Status/\(statusid)/Unlike?userId=\(userid)"
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

}

// Marks : -  Custom CZPicker View
extension ChannelLinks: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        //            if pickerView == pickerWithImage {
        //                return fruitImages[row]
        //            }
        let image = UIImageView()
        if (arrgimgprofile[row]) != ""
        {
            //Kingfisher Image upload
            let urlprofile = URL(string: userimagepath+arrgimgprofile[row])
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
        return arrpickerview[row]+" ("+(arrgtotalmember[row])+")"
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
// MARK: - IndicatorInfoProvider for page controller like android
extension ChannelLinks: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "LINKS")
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "LINKS")
        return itemInfo
    }
}
