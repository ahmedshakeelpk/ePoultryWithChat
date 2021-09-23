//
//  Likes.swift
//  AMPL
//
//  Created by sameer on 05/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import CZPicker
import Alamofire

class Likes: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var statusid = String()
    var isNotification = false
    var totallike = String()
    /////// Marks: - For Groups Arrays
    var arrgtitle = [String]()
    var arrgtype = [String]()
    var arrgid = [Any]()
    var arrgimgprofile = [String]()
    var arrgtotalmember = [String]()
    var arrguserstatus = [String]()
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    ///////////////////////////////////////
    @IBOutlet weak var tablev: UITableView!
    
    var arrtime = [String]()
    var arrusername = [String]()
    var arrcity = [Any]()
    var arrprofileimg = [Any]()
    var arrlikeuserid = [Any]()
    /////////////////////////////////////////
    override func viewDidLoad() {
        self.tablev.register(UINib(nibName: "LikesCell", bundle: nil), forCellReuseIdentifier: "cell")
        getalllikes()
        if isNotification {
            //MARK:- Cell Register
            self.tablev.register(UINib(nibName: "ImgvCell", bundle: nil), forCellReuseIdentifier: "ImgvCell")
            self.tablev.register(UINib(nibName: "LinkCell", bundle: nil), forCellReuseIdentifier: "LinkCell")
            self.tablev.register(UINib(nibName: "DocumentCell", bundle: nil), forCellReuseIdentifier: "DocumentCell")
            self.tablev.register(UINib(nibName: "VideoPostCell", bundle: nil), forCellReuseIdentifier: "cellvideo")
            self.tablev.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
            DispatchQueue.global(qos: .background).async {
                self.getallgroups()
            }
            getPostDetails()
        }

        // Back Button with image
        let backBtn = UIBarButtonItem(image: UIImage.init(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Likes"
    }

    @objc func funback() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setcustomimage(cell: ImgvCell, imgvv: UIImageView) {
        cell.setCustomImage(image: imgvv.image!)
    }
    
    // Marks: - Table view datasource and delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isNotification {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isNotification {
            if section == 0 {
                if postType == "" {
                    return 0
                }
                else {
                    return 1
                }
            }
        }
        return arrusername.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNotification && indexPath.section == 0 && postType != "" {
            if postType == "video" {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "cellvideo") as! VideoPostCell
                cell.lbldesc1.text = nil
                let lblwidth = cell.lbldesc1.frame.size.width
                cell.lbldesc1.lineBreakMode = .byWordWrapping
                cell.lbldesc1.numberOfLines = 0
                cell.lbldesc1.textAlignment = .natural

                cell.lblname.text = tempStrName
                cell.lblcomments.text = tempStrTotalComments
                cell.lbllikes.text = totallike
                cell.lbldesc1.text = tempDesc
                cell.lbltime.text = tempStrTimeAgo

                cell.lbldesc1.sizeToFit()
                obj.findLinkInText(label: cell.lbldesc1)
                cell.lbldesc1.frame.size.width = lblwidth

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
                if tempMyLike == "1" {
                    cell.imglike.image = #imageLiteral(resourceName: "likeg")
                }
                else {
                    cell.imglike.image = #imageLiteral(resourceName: "like")
                }

                //Kingfisher Image upload
                let urlprofile = URL(string: userimagepath+tempUserProfilePic)
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
                let urlpost = URL(string:  imagepath+tempImagePath)
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
            else if postType == "image" {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "ImgvCell") as! ImgvCell
                //let lblwidth = cell.lbldesc1.frame.size.width
                cell.lbldesc1.text = nil
                cell.lbldesc1.lineBreakMode = .byWordWrapping
                cell.lbldesc1.numberOfLines = 0
                cell.lbldesc1.textAlignment = .natural


                cell.lblname.text = tempStrName
                cell.lblcomments.text = tempStrTotalComments
                cell.lbllikes.text = totallike
                cell.lbldesc1.text = tempDesc
                cell.lbltime.text = tempStrTimeAgo
                
                let stringToDecode = tempDesc
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
                            // Marks: - Check my post
                            if statusid == USERID || defaults.value(forKey: "isadmin") as? String == "1"
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
                            if tempMyLike == "1"
                            {
                                cell.imglike.image = #imageLiteral(resourceName: "likeg")
                            }
                            else
                            {
                                cell.imglike.image = #imageLiteral(resourceName: "like")
                            }

                            //Kingfisher Image upload
                            let urlprofile = URL(string: userimagepath+tempUserProfilePic)
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
                            let urlpost = URL(string:  imagepath+tempImagePath)
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
            else if postType == "link" {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "LinkCell") as! LinkCell
                //let lblwidth = cell.lbldesc1.frame.size.width
                cell.lbldesc1.text = nil
                cell.lbldesc1.numberOfLines = 0
                cell.lbldesc1.lineBreakMode = .byWordWrapping
                cell.lbldesc1.textAlignment = .natural
                
                cell.lblname.text = tempStrName
                cell.lblcomments.text = tempStrTotalComments
                cell.lbllikes.text = totallike
                cell.lbldesc1.text = tempDesc
                cell.lbltime.text = tempStrTimeAgo
                let tempstr = tempDesc
                let tempstrarray = tempstr.components(separatedBy: "_&epoultry&_")
                var teampdesc1 = ""
                if tempstrarray.count == 0 {
                    teampdesc1 = "\(tempstrarray[0])"
                }
                else if tempstrarray.count > 3 {
                    teampdesc1 = "\(tempstrarray[0])\n\(tempstrarray[1])\n\n\(tempstrarray[2])\n\n\(tempstrarray[3])"
                }
                else if tempstrarray.count > 2{
                    teampdesc1 = "\(tempstrarray[0])\n\(tempstrarray[1])\n\n\(tempstrarray[2])"
                }
                else if tempstrarray.count > 1 {
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
                if tempMyLike == "1" {
                    cell.imglike.image = #imageLiteral(resourceName: "likeg")
                }
                else
                {
                    cell.imglike.image = #imageLiteral(resourceName: "like")
                }

                //Kingfisher Image upload
                let urlprofile = URL(string: userimagepath+tempImagePath)
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
                let urlpost = URL(string:  imagepath+tempImagePath)
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
            else if postType == "document" {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "DocumentCell") as! DocumentCell
                //let lblwidth = cell.lbldesc1.frame.size.width
                cell.lbldesc1.text = nil
                cell.lbldesc1.numberOfLines = 0
                cell.lbldesc1.lineBreakMode = .byWordWrapping
                cell.lbldesc1.textAlignment = .natural
                cell.lblname.text = tempStrName
                cell.lblcomments.text = tempStrTotalComments
                cell.lbllikes.text = totallike
                cell.lbldesc1.text = tempDesc
                cell.lbltime.text = tempStrTimeAgo

                cell.lbltime.text = arrtime[indexPath.row]
                let tempdesc = tempDesc
                if tempdesc != "" {
                    cell.lbldesc1.text = tempImagePath + "\n\n\(tempdesc)"
                }
                else {
                    cell.lbldesc1.text = tempImagePath
                }
                cell.lbldesc1.sizeToFit()

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
                if tempMyLike == "1" {
                    cell.imglike.image = #imageLiteral(resourceName: "likeg")
                }
                else {
                    cell.imglike.image = #imageLiteral(resourceName: "like")
                }

                //Kingfisher Image upload
                let urlprofile = URL(string: userimagepath+tempUserProfilePic)
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
                let urlpost = URL(string:  docpath+tempImagePath)

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
                self.tablev.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
                cell.lbldesc1.text = nil
                let lblwidth = cell.lbldesc1.frame.size.width

                cell.lbldesc1.lineBreakMode = .byWordWrapping
                cell.lbldesc1.numberOfLines = 0
                cell.lbldesc1.textAlignment = .natural

                cell.lblname.text = tempStrName
                cell.lblcomments.text = tempStrTotalComments
                cell.lbllikes.text = totallike
                cell.lbldesc1.text = tempDesc
                cell.lbltime.text = tempStrTimeAgo

                let stringToDecode = tempDesc
                let newStr = String(utf8String: stringToDecode.cString(using: .utf8)!)
                cell.lbldesc1.text = newStr

                cell.lbldesc1.sizeToFit()
                cell.lbldesc1.frame.size.width = lblwidth

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
                if tempMyLike == "1" {
                    cell.imglike.image = #imageLiteral(resourceName: "likeg")
                }
                else {
                    cell.imglike.image = #imageLiteral(resourceName: "like")
                }
                //Kingfisher Image upload
                let urlprofile = URL(string: userimagepath+tempImagePath)
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
        else {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! LikesCell
            cell.lblusername.text = arrusername[indexPath.row]
            cell.lblcity.text = "From: \(arrcity[indexPath.row] as? String ?? "")"
            let tempUrl = "\(userimagepath)\(arrprofileimg[indexPath.row] as? String ?? "")"
                  let urlprofile = URL(string: tempUrl)
                  cell.imgvprofile.kf.setImage(with: urlprofile) { result in
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
    }
    
    //Marks: - Comment button
    @objc func commentfun(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Comments") as! Comments
        vc.type = "Public"
        vc.statusid = statusid
        vc.totallike = totallike
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func getalllikes() {
        // let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"status/\(statusid)/likedUsers"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:{
            responseObject, error in
            self.andicator.stopAnimating()
            //print(responseObject)
            DispatchQueue.main.async {
                if error == nil && responseObject != nil{
                    if responseObject!.count > 0 {
                        let datadic = responseObject?.value(forKey: "data") as! NSArray
                        if datadic.count > 0 {
                            self.arrusername = datadic.value(forKey: "Name") as! [String]
                            self.arrcity = datadic.value(forKey: "city") as! [Any]
                            self.arrprofileimg = datadic.value(forKey: "profile_img") as! [Any]
                            self.arrlikeuserid = datadic.value(forKey: "id") as! [Any]
                            self.tablev.reloadData()
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description) ?? "", viewController: self)
                        }
                    }
                    else {
                        obj.showAlert(title: "Error!", message: (error?.description ?? "Error Occured try again and check your internet connection") , viewController: self)
                    }
                }
            }
        })
    }
    
@objc func getPostDetails() {
        let url = BASEURL+"status/\(statusid)/comments?userId=\(USERID)"
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:{
            responseObject, error in
            self.andicator.stopAnimating()
            //print(responseObject)
            DispatchQueue.main.async {
                if error == nil && responseObject != nil{
                    if responseObject!.count > 0{
                        let datadic = responseObject?.value(forKey: "data") as! NSArray
                        if datadic.count > 0 {
                            let detailsData = datadic[0] as! NSDictionary
                            self.totallike = "\(detailsData.value(forKey: "TotalLikes") ?? "")"
                            self.postType = detailsData.value(forKey: "SubType") as? String ?? ""
                            self.tempStrName = detailsData.value(forKey: "Name") as? String ?? ""
                            self.tempDesc = detailsData.value(forKey: "Status") as? String ?? ""
                            self.tempStrTotalComments = "\(detailsData.value(forKey: "TotalComments") ?? "")"
                            self.tempPostTag = detailsData.value(forKey: "tag") as? String ?? ""
                            self.tempVideoFile = detailsData.value(forKey: "VideoFile") as? String ?? ""
                            self.tempImagePath = detailsData.value(forKey: "ImagePath") as? String ?? ""
                            self.tempMyLike = detailsData.value(forKey: "MyLike") as? String ?? ""
                            self.tempUserProfilePic = detailsData.value(forKey: "ProfilePic") as? String ?? ""
                            
                            if let CreatedOn = detailsData.value(forKey: "CreatedOn") as? String {
                                var strtime = CreatedOn.replacingOccurrences(of: "T", with: " ")
                                let dfmatter = DateFormatter()
                                dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                dfmatter.locale = Locale(identifier: "en_US_POSIX")
                                dfmatter.timeZone = TimeZone.autoupdatingCurrent //Current time zone
                                
                                strtime = strtime.components(separatedBy: ".")[0]
                                print(strtime)
                                
                                let agotime = obj.timeAgoSinceDate(dfmatter.date(from: strtime)!)
                                
                                self.tempStrTimeAgo = agotime!
                            }
                            else {
                                self.arrtime.append("")
                            }
                            self.tablev.reloadData()
                        }
                        else {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else {
                        obj.showAlert(title: "Error!", message: (error?.description ?? "Error Occured try again and check your internet connection") , viewController: self)
                    }
                }
            }
        })
    }
    
    var postType = ""
    var tempStrName = ""
    var tempDesc = ""
    var tempStrTotalComments = ""
    var tempStrTimeAgo = ""
    var tempPostTag = ""
    var tempVideoFile = ""
    var tempImagePath = ""
    var tempMyLike = ""
    var tempUserProfilePic = ""
    
    // Marks: - Button option
    @objc func optionbtn(sender: UIButton) {
        let alertController = UIAlertController(title: "Perform Action!", message: "", preferredStyle:UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Edit", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddnewPost") as! AddnewPost
            
            vc.newsvideostag = "public"
            vc.type = "Public"
            vc.edit = "1"
            vc.postTypeNewsORTimeLine = "status"
            vc.statusid = self.statusid
            if self.postType == "video" {
                vc.buttonTag = VIDEO
                vc.url = self.tempVideoFile
                vc.strvideolbl = "Video uploaded"
            }
            else if self.postType == "image" {
                vc.buttonTag = IMAGE
            }
            else if self.postType == "link"{
                vc.buttonTag = TEXT
            }
            else if self.postType == "document"{
                vc.buttonTag = DOCUMENT
            }
            if self.postType != "1" {
                vc.url = self.tempImagePath
                vc.strvideolbl = ""
            }
            if self.tempDesc == "" {
                vc.strpost = "Write your post here"
            }
            else {
                vc.strpost = self.tempDesc
            }
            self.navigationController?.pushViewController(vc, animated: true)
        })
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            //self.delete(tag: tag)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Marks: - Profile button
    @objc func profile(sender: UIButton) {
        //let tag = sender.tag
    }
    
    //Marks: - Video Play button
    @objc func playvideo(sender: UIButton) {
         let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
         vc.videoimagetag = VIDEO
         vc.videoimagename = tempVideoFile
         
         obj.funForceDownloadPlayShow(urlString: videopath+tempVideoFile+videoPlayEndPath, isProgressBarShow: true, viewController: self, completion: {
             url in
             
             if url == "" {
                 vc.profilepic = UIImage(named: "tempimg")!
             }
             else {
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
        if postType == "document" {
            if let url = URL(string: "\(docpath)\(tempImagePath)") {
                UIApplication.shared.open(url)
            }
        }
        else{
            let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DisplayVideoImage") as! DisplayVideoImage
             vc.videoimagetag = IMAGE
             vc.videoimagename = tempImagePath
             
             obj.funForceDownloadPlayShow(urlString: imagepath+tempImagePath, isProgressBarShow: true, viewController: self, completion: {
                 url in
                 
                 if url == "" {
                     vc.profilepic = UIImage(named: "tempimg")!
                 }
                 else {
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
        if tempMyLike == "0" || tempMyLike == "" {
            self.like()
            var value = Int(totallike)
            if value == nil {
                value = 0
            }
            value = value! + 1
            
            if value! < 0 {
                value = 0
            }
            var strvalue = String()
            strvalue = "\(value!)"
            
            totallike = strvalue
            
            if tempMyLike == "0" {
                tempMyLike = "1"
            }
            else {
                tempMyLike = "0"
            }
            if value == 0 {
                tempMyLike = "0"
            }
        }
        else {
            
            self.unlike()
            var value = Int(totallike)
            if value == nil {
                value = 0
            }
            value = value! - 1
            
            if value! < 0 {
                value = 0
            }
            var strvalue = String()
            strvalue = "\(value!)"
            
            totallike = strvalue
            
            if tempMyLike == "0" {
                tempMyLike = "1"
            }
            else {
                tempMyLike = "0"
            }
            if value == 0 {
                tempMyLike = "0"
            }
        }
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: 0, section: 0)
            self.tablev.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // Marks: - Like
       func like() {
           let url = BASEURL+"/Status/\(statusid)/like?userId=\(USERID)"
           print(url)
           //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
           let parameters : Parameters = ["": ""]
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
       func unlike() {
           let url = BASEURL+"/Status/\(statusid)/Unlike?userId=\(USERID)"
           let parameters : Parameters = ["": ""]
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
    
    // Marks: = Share button
    @objc func sharefun(sender: UIButton) {
        let alertController = UIAlertController(title: "Share it!", message: "", preferredStyle:UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Share it to Other", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            
            var desc = self.tempDesc
            desc = desc + SIGNATURE
            var shareUrl = ""
            UIPasteboard.general.string = desc
            var activityVC = UIActivityViewController(activityItems: [], applicationActivities: nil)
            
            if self.postType == "video" {
                //MARK:- Video
                shareUrl = videopath+self.tempVideoFile+videoPlayEndPath+"\n\n"
            }
            else if self.postType == "image" {
                //MARK:- Image
                shareUrl = imagepath+self.tempImagePath+"\n\n"
            }
                
            else if self.self.postType == "link"{
                //MARK:- Link
            }
            else if self.self.postType == "document"{
                //MARK:- Document
                shareUrl = docpath+self.tempImagePath+"\n\n"
            }
            else
            {
                //MARK:- Simple Text

            }
            desc = desc.replacingOccurrences(of: "_&epoultry&_", with: "\n", options: .literal, range: nil)

            activityVC = UIActivityViewController(activityItems: [shareUrl +  desc], applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop,UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]

            self.present(activityVC, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "ePoultry Share", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            // Marks: - For the Custome Picker view
            
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
            self.shareChat(is_ePoultryContacts: false)
        })
        alertController.addAction(UIAlertAction(title: "ePoultry Contacts", style: UIAlertAction.Style.default)
        { action -> Void in
            self.shareChat(is_ePoultryContacts: true)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getallgroups() {
        let url = BASEURL+"channels/\(USERID)?tags=All&admin=\(USERROLE)"
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
    
    func shareChat(is_ePoultryContacts: Bool) {
        var desc = tempDesc
        desc = desc.replacingOccurrences(of: "_&epoultry&_", with: "\n")
        var tempselectedMessageType = 0
        var tempselectedMessageImage = UIImage()
        let tempselectedMessageText = desc
        let tempis_ePoultryContacts = is_ePoultryContacts
        if postType == "video" {
            //MARK:- Video
            tempselectedMessageType = VIDEO
            let indexPath = IndexPath(item: 0, section: 0)
            guard let cell = self.tablev.cellForRow(at: indexPath) as? VideoPostCell else {
                return // or fatalError() or whatever
            }
            tempselectedMessageImage = cell.imgpost.image!
            let videoUrl = videopath+tempVideoFile+videoPlayEndPath
            let tempFileName = tempVideoFile
            obj.funForceDownloadPlayShow(urlString: videoUrl, isProgressBarShow: true, viewController: self, completion: {
                    url in
                       
                    if url == ""{ }
                    else{ }
                    //MARK:- Reload image row after download
                       
                let tempVideoData = NSData(contentsOf: URL(string: url!)!)
                self.openShareViewController(tempFileName: tempFileName, tempselectedMessageVideoData: tempVideoData! as Data, is_ePoultryContacts: tempis_ePoultryContacts, tempselectedMessageText: tempselectedMessageText, tempselectedMessageType: tempselectedMessageType, tempselectedMessageImage: tempselectedMessageImage)
            })
            
            return
        }
        else if postType == "image" {
            //MARK:- Image
            tempselectedMessageType = IMAGE
            let indexPath = IndexPath(item: 0, section: 0)
            guard let cell = self.tablev.cellForRow(at: indexPath) as? ImgvCell else {
                return // or fatalError() or whatever
            }
            tempselectedMessageImage = cell.imgpost.image!
        }
        else if postType == "link" {
            //MARK:- Link
            tempselectedMessageType = TEXT
        }
        else if postType == "document" {
            //MARK:- Document
            //shareUrl = docpath+self.arrpostimg[tag]+"\n\n"
            tempselectedMessageType = DOCUMENT
            
            let documentUrl = "\(docpath)\(tempImagePath)"
            let tempFileName = tempImagePath
            obj.funForceDownloadPlayShow(urlString: documentUrl, isProgressBarShow: true, viewController: self, completion: {
                    url in
                       
                    if url == ""{ }
                    else{ }

                let tempVideoData = NSData(contentsOf: URL(string: url!)!)
                self.openShareViewController(tempFileName: tempFileName, tempselectedMessageVideoData: tempVideoData! as Data, is_ePoultryContacts: tempis_ePoultryContacts, tempselectedMessageText: tempselectedMessageText, tempselectedMessageType: tempselectedMessageType, tempselectedMessageImage: tempselectedMessageImage)
            })
            return
        }
        else {
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
}



// Marks : -  Custom CZPicker View
extension Likes: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        //            if pickerView == pickerWithImage {
        //                return fruitImages[row]
        //            }
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        if (arrgimgprofile[row]) != ""
        {
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
    
    func shareingroup(tag : Int) {
        let groupid = self.arrgid[tag]
      
        let url = BASEURL + "news/\(groupid)/share?userId=\(USERID)&statusId=\(statusid)"
        let parameters : Parameters = ["": ""]
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
    
    func shareinTimeline(tag : Int) {
        let url = BASEURL + "news/share?userId=\(USERID)&statusId=\(statusid)"
        
        let parameters : Parameters = ["": ""]
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
