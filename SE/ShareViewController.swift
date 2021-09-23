//
//  ShareViewController.swift
//  SE
//
//  Created by MacBook Pro on 14/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import MediaPlayer
import Photos
import Kanna
import Alamofire
import Kingfisher
import Firebase



var DATAFILE = Data()
var DATAFILEURL: URL?
var TYPETAG = 0
var isLinkTag = 0


var linkTEXT = String()
var titleText = String()
var descTEXT = String()
var selectedImage = UIImage()

var arrGfullname = [String]()
var arrGfname = [String]()
var arrGlname = [String]()
var arrGnumber = [String]()
var arrGnumberWithoutSpaces = NSMutableArray()
var arrGpic = NSMutableArray()

var arrGfullname_AppUser = [String]()
var arrGfname_AppUser = [String]()
var arrGlname_AppUser = [String]()
var arrGnumber_AppUser = [String]()
var arrGuserid_AppUser = [String]()
var arrGnumberWithoutSpaces_AppUser = NSMutableArray()
var arrGpic_AppUser = NSMutableArray()


var arrGRectifyPhone = NSMutableArray()
var arrGuserphone = NSMutableArray()
var arrGuserid = NSMutableArray()
var arrGusername = NSMutableArray()
var arrGuserpic = NSMutableArray()
var arrGuserFBToken = NSMutableArray()
var arrGuserUid = NSMutableArray()

class ShareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    var isLoadApi = false
    var arrTitle = NSArray()
    var arrChannelId = [Any]()
    var arrCreatedBy = [Any]()
    var arrCreatedon = [Any]()
    var arrDescription = [Any]()
    var arrIsActive = [Any]()
    var arrRequestStatus = [Any]()
    var arrStatus = [Any]()
    var arrTags = [Any]()
    var arrType = [Any]()
    var arrUpdatedby = [Any]()
    var arrUpdatedon = [Any]()
    var arrUserId = [Any]()
    var arrthumbnail = [Any]()
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = 70
        if IPAD{
            return CGFloat(height*2)
        }
        return CGFloat(height)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return arrTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "ShareViewControllerCell") as! ShareViewControllerCell
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                cell.lbltitle.text = "Timeline"
                cell.imgv.image = UIImage(named: "home")
                break
            case 1:
                cell.lbltitle.text = "Chat"
                cell.imgv.image = UIImage(named: "chatEmoji")
                break
            case 2:
                
                cell.lbltitle.text = "ePoultry Contacts"
                cell.imgv.image = UIImage(named: "contactno")
                break
            default:
                break
            }
        }
        else{
            cell.lbltitle.text = arrTitle[indexPath.row] as? String ?? ""
            let url = URL(string: "\(imagepath)\(self.arrthumbnail[indexPath.row] as! String)")
            cell.imgv.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    cell.imgv.image = value.image

                case .failure(let error):
                    print("Error: \(error)")
                    cell.imgv.image = UIImage(named: "group")
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let tempid = group_defaults.value(forKey: "userid") as? String
        {
            //USERID = tempid
            print(tempid)
        }
        else
        {
            showAlert(title: "", message: "Please login...!", viewController: self)
            return
        }
        if isLoadApi == false {
            showAlertPleaseWait(title: "", message: "Please wait...", viewController: self)
            return
        }
        
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                didSelect(indexPath: indexPath)
                break
            case 1:
                self.shareChat(tag: indexPath.row, is_ePoultryContacts: false)
                break
            case 2:
                self.shareChat(tag: indexPath.row, is_ePoultryContacts: true)
                break
            default:
                break
            }
        }
        else{
            didSelect(indexPath: indexPath)
        }
    }
    
    func didSelect(indexPath: IndexPath){
        let vc = UIStoryboard.init(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "Details") as! Details
        if indexPath.section == 0{
            vc.tempChannelId = ""
        }
        else{
            if arrChannelId.count > 0{
                vc.tempChannelId = "\(arrChannelId[indexPath.row] as? Int ?? 101010)"
                if vc.tempChannelId == "101010"{
                    showAlertPleaseWait(title: "", message: "No channel found try again...", viewController: self)
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func shareChat(tag: Int, is_ePoultryContacts: Bool){
        
        var desc = descTEXT
        desc = desc.replacingOccurrences(of: "_&epoultry&_", with: "\n")
        var tempselectedMessageType = 0
        let tempselectedMessageImage = selectedImage
        let tempselectedMessageText = desc
        let tempis_ePoultryContacts = is_ePoultryContacts
        
        let tempFileName = titleText
        if TYPETAG == VIDEO || TYPETAG == DOCUMENT
        {
            //MARK:- Video
            tempselectedMessageType = VIDEO
            if TYPETAG == DOCUMENT{
                //MARK:- Document
                tempselectedMessageType = DOCUMENT
            }
            
            //MARK:- Reload image row after download
            self.openShareViewController(tempFileName: tempFileName, tempselectedMessageVideoData: DATAFILE, is_ePoultryContacts: tempis_ePoultryContacts, tempselectedMessageText: tempselectedMessageText, tempselectedMessageType: tempselectedMessageType, tempselectedMessageImage: tempselectedMessageImage)
            
            return
        }
        else if TYPETAG == IMAGE{
            //MARK:- Image
            tempselectedMessageType = IMAGE
        }
        else if TYPETAG == LINK{
            //MARK:- Link
            tempselectedMessageType = TEXT
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
    
    
    
    
    
    
    
    
    // SLComposeServiceViewController {

//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//
//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//
//    override func configurationItems() -> [Any]! {
//        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//        return []
//    }
    
    
    @IBOutlet weak var tablev: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        if let temp = group_defaults.value(forKey: "arrGuserid") as? NSMutableArray
        {
            if temp.count != 0
            {
                arrGfullname = group_defaults.value(forKey: "arrGfullname") as! [String]
                arrGfname = group_defaults.value(forKey: "arrGfname") as! [String]
                arrGlname = group_defaults.value(forKey: "arrGlname") as! [String]
                arrGnumber = group_defaults.value(forKey: "arrGnumber") as! [String]

                let decoded  = group_defaults.object(forKey: "arrGpic") as! Data
                arrGpic = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSMutableArray
                //arrGpic = defaults.value(forKey: "arrGpic") as! NSMutableArray
                arrGnumberWithoutSpaces = group_defaults.value(forKey: "arrGnumberWithoutSpaces") as! NSMutableArray
                //////////
                arrGRectifyPhone = group_defaults.value(forKey: "arrGRectifyPhone") as! NSMutableArray
                arrGuserphone = group_defaults.value(forKey: "arrGuserphone") as! NSMutableArray
                arrGuserid = group_defaults.value(forKey: "arrGuserid") as! NSMutableArray

                arrGuserid = group_defaults.value(forKey: "arrGuserUid") as! NSMutableArray
                arrGRectifyPhone = group_defaults.value(forKey: "arrGRectifyPhone") as! NSMutableArray
                let decoded2  = group_defaults.object(forKey: "arrGuserpic") as! Data
                arrGuserpic = NSKeyedUnarchiver.unarchiveObject(with: decoded2) as! NSMutableArray

                //arrGuserpic = defaults.value(forKey: "arrGuserpic") as! NSMutableArray
                arrGusername = group_defaults.value(forKey: "arrGusername") as! NSMutableArray
                arrGuserphone = group_defaults.value(forKey: "arrGuserphone") as! NSMutableArray
                arrGuserFBToken = group_defaults.value(forKey: "arrGuserFBToken") as! NSMutableArray
                arrGuserUid =  group_defaults.value(forKey: "arrGuserUid") as! NSMutableArray


                arrGfullname_AppUser = group_defaults.value(forKey: "arrGfullname_AppUser") as! [String]
                arrGfname_AppUser = group_defaults.value(forKey: "arrGfname_AppUser") as! [String]
                arrGlname_AppUser = group_defaults.value(forKey: "arrGlname_AppUser") as! [String]
                arrGnumber_AppUser = group_defaults.value(forKey: "arrGnumber_AppUser") as! [String]

                let decoded_AppUser  = group_defaults.object(forKey: "arrGpic_AppUser") as! Data
                arrGpic_AppUser = NSKeyedUnarchiver.unarchiveObject(with: decoded_AppUser) as! NSMutableArray
                //arrGpic = defaults.value(forKey: "arrGpic") as! NSMutableArray
                arrGnumberWithoutSpaces_AppUser = group_defaults.value(forKey: "arrGnumberWithoutSpaces_AppUser") as! NSMutableArray
            }
        }
    }
    override func viewDidLoad() {
        FirebaseApp.app()
        //MARK:- Firebase Configration
        if let _ = FirebaseApp.app() { } else {
            FirebaseApp.configure()
        }
        
        super.viewDidLoad()
        self.andicator.startAnimating()
        //MARK:- Register Cell for Send and Receive Message
        self.tablev.register(UINib(nibName: "ShareViewControllerCell", bundle: nil), forCellReuseIdentifier: "ShareViewControllerCell")
        self.navigationItem.title = "SHARE...!"
        // Marks: - Left Post button
        let leftcancelbutton:UIBarButtonItem = UIBarButtonItem(title:"CANCEL", style: UIBarButtonItem.Style.done, target: self, action: #selector(btncancel))
        self.navigationItem.setLeftBarButtonItems([leftcancelbutton], animated: true)
        // Marks: - Right Post button
       
        if let tempid = group_defaults.value(forKey: "userid") as? String{
             USERID = tempid
        }
        else{
            showAlert(title: "ePoultry", message: "Please login...!", viewController: self)
            return
        }
        GetAllchannels()
        manageData()
        
        tablev.tableFooterView = UIView()
    }

    @objc func btncancel(){
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
   
    private var urlString: String?
    private var textString: String?
    
    func manageData() {
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        
        let contentTypeURL = kUTTypeURL as String
        let contentTypeText = kUTTypeText as String
        let contentTypeImage = kUTTypeImage as String
        let contentTypeVideo = kUTTypeVideo as String
        let contentTypeVideo1 = kUTTypeMP3 as String
        let contentTypeVideo2 = kUTTypeMPEG as String
        let contentTypeVideo3 = kUTTypeMPEG2Video as String
        let contentTypePublicItems = "public.item"
        
        let contentTypeVideoCamera = "com.apple.quicktime-movie"
    
        for (index, attachment) in (content.attachments!).enumerated() {
            if attachment.hasItemConformingToTypeIdentifier(contentTypeVideo1) {
                print(contentTypeVideo1)
            }
            if attachment.hasItemConformingToTypeIdentifier(contentTypeVideo2) {
                print(contentTypeVideo2)
            }
            if attachment.hasItemConformingToTypeIdentifier(contentTypeVideo3) {
                print(contentTypeVideo3)
            }
            if attachment.hasItemConformingToTypeIdentifier(contentTypeText) {
                print(contentTypeText)
                self.andicator.startAnimating()
                attachment.loadItem(forTypeIdentifier: contentTypeText, options: nil) { [weak self] data, error in
                    //MARK:- If select image from local phone
                    do {
                        if error == nil, let _ = data as? URL {
                            
                            isLinkTag = 0
                            TYPETAG = TEXT
                            linkTEXT = "\(data!)"
                            // GETTING RAW DATA
                            //let rawData = try Data(contentsOf: url)
                            
                            
                        }
                        else if data is String{
                            isLinkTag = 0
                            TYPETAG = TEXT
                            linkTEXT = "\(data!)"
                            // GETTING RAW DATA
                            //let rawData = try Data(contentsOf: url)
                        }
                        else {
                            print("GETTING ERROR")
                            self!.showAlert(title: "Error", message: "Error loading...", viewController: self!)
                        }
                    }
                }
            }
            else if attachment.hasItemConformingToTypeIdentifier(contentTypeURL) {
                print(contentTypeURL)
                
                attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil) { [weak self] data, error in
                    //MARK:- If select image from local phone
                    if error == nil, let url = data as? URL {
                        do {
                            if attachment.hasItemConformingToTypeIdentifier(contentTypeImage) {
                                //MARK:- If select image from local phone
                                print(contentTypeImage)
                                attachment.loadItem(forTypeIdentifier: contentTypeImage, options: nil) { [weak self] data, error in
                                                //MARK:- If select image from local phone
                                if error == nil, let url = data as? URL, let this = self {
                                    do {
                                            isLinkTag = 0
                                            TYPETAG = IMAGE
                                            // GETTING RAW DATA
                                            let rawData = try Data(contentsOf: url)
                                            DATAFILE = rawData
                                            print(url)
                                            // CONVERTED INTO FORMATTED FILE : OVER COME MEMORY WARNING
                                            // YOU USE SCALE PROPERTY ALSO TO REDUCE IMAGE SIZE
                                            //let image = UIImage.resizeImage(image: rawImage!, width: 400, height: 400)
                                            // let imgData = image.pngData()
                                            this.andicator.startAnimating()
                                            if let image = UIImage(data: rawData) {
                                            DispatchQueue.main.async {
                                                selectedImage = image
                                            }
                                        }
                                    }
                                    catch let exp {
                                        print("GETTING EXCEPTION \(exp.localizedDescription)")
                                    }
                                } else {
                                    print("GETTING ERROR")
                                    self!.showAlert(title: "Error", message: "Error loading...", viewController: self!)
                                    }
                                }
                            }
                            else if "\(url)".contains("https://") || "\(url)".contains("http://") {
                                print("internet URL exists")
                                isLinkTag = 1
                                TYPETAG = LINK
                                linkTEXT = "\(url)"
                                // GETTING RAW DATA
                                //let rawData = try Data(contentsOf: url)
                                self!.andicator.startAnimating()
                                self!.loadLinkData(link:"\(url)")
                            }
                            else{
                                //MARK:- If Local File Selected
                                self!.checkAttachment(url: url)
                            }
                        }
                    }
                    else {
                        print("GETTING ERROR")
                        
                    }
                }
            }
            else if attachment.hasItemConformingToTypeIdentifier(contentTypePublicItems) {
            //MAKR:- if video make by Camera
            print(contentTypeVideoCamera)
                attachment.loadItem(forTypeIdentifier: contentTypePublicItems, options: nil) { [weak    self] data, error in
                        //MARK:- If select image from local phone

                    if error == nil, let url = data as? URL {
                        do {
                            //MARK:- If Local File Selected
                            self!.checkAttachment(url: url)
                        }
                    } else {
                        print("GETTING ERROR")
                        //self!.showAlert(title: "Error", message: "Error loading...", viewController:  self!)
                    }
                }
            }
            else if attachment.hasItemConformingToTypeIdentifier(contentTypeVideoCamera) {
                //MAKR:- if video make by Camera
                print(contentTypeVideoCamera)
                attachment.loadItem(forTypeIdentifier: contentTypeVideoCamera, options: nil) { [weak self] data, error in
                    //MARK:- If select image from local phone
                    if error == nil, let url = data as? URL, let this = self {
                        do {
                            isLinkTag = 0
                            TYPETAG = VIDEO
                            // GETTING RAW DATA
                            let rawData = try Data(contentsOf: url)
                            DATAFILE = rawData
                            
                            let imageThumb = this.thumbnailForVideoAtURL(url: url as URL)
                            
                            self!.andicator.startAnimating()
                            if let image = UIImage(data: imageThumb!.pngData()!) {
                                DispatchQueue.main.async {
                                    selectedImage = image
                                    
                                }
                            }
                            print(url)
                            // CONVERTED INTO FORMATTED FILE : OVER COME MEMORY WARNING
                            // YOU USE SCALE PROPERTY ALSO TO REDUCE IMAGE SIZE
                            //let image = UIImage.resizeImage(image: rawImage!, width: 400, height: 400)
                            // let imgData = image.pngData()
                            
                            
                            //                            this.selectedImages.append(image)
                            //                            this.imagesData.append(imgData!)
                            //
                            if index == (content.attachments?.count)! - 1 {
                                //                                DispatchQueue.main.async {
                                //                                    group_defaults.set(this.imagesData, forKey: this.sharedKey)
                                //                                    group_defaults.synchronize()
                                //                                }
                            }
                        }
                        catch let exp {
                            print("GETTING EXCEPTION \(exp.localizedDescription)")
                        }
                        
                    } else {
                        print("GETTING ERROR")
                        self!.showAlert(title: "Error", message: "Error loading...", viewController: self!)
                    }
                }
            }
            else if attachment.hasItemConformingToTypeIdentifier(contentTypeVideo) {
                //MARK:- If select image from local Video
                print(contentTypeVideo)
                attachment.loadItem(forTypeIdentifier: contentTypeVideo, options: nil) { [weak self] data, error in
                    //MARK:- If select image from local phone
                    if error == nil, let url = data as? URL, let this = self {
                        do {
                            TYPETAG = VIDEO
                            // GETTING RAW DATA
                            let rawData = try Data(contentsOf: url)
                            DATAFILE = rawData
                            let imageThumb = this.thumbnailForVideoAtURL(url: url as URL)
                            print(url)
                            // CONVERTED INTO FORMATTED FILE : OVER COME MEMORY WARNING
                            // YOU USE SCALE PROPERTY ALSO TO REDUCE IMAGE SIZE
                            //let image = UIImage.resizeImage(image: rawImage!, width: 400, height: 400)
                            // let imgData = image.pngData()
                            
                            selectedImage = imageThumb!
                            //                            this.selectedImages.append(image)
                            //                            this.imagesData.append(imgData!)
                            //
                            if index == (content.attachments?.count)! - 1 {
                                //                                DispatchQueue.main.async {
                                //                                    group_defaults.set(this.imagesData, forKey: this.sharedKey)
                                //                                    group_defaults.synchronize()
                                //                                }
                            }
                        }
                        catch let exp {
                            print("GETTING EXCEPTION \(exp.localizedDescription)")
                        }
                        
                    } else {
                        print("GETTING ERROR")
                        self!.showAlert(title: "Error", message: "Error loading...", viewController: self!)
                    }
                }
            }
//            else if attachment.hasItemConformingToTypeIdentifier(contentTypeImage) {
//                //MARK:- If select image from local phone
//                print(contentTypeImage)
//                attachment.loadItem(forTypeIdentifier: contentTypeImage, options: nil) { [weak self] data, error in
//                    //MARK:- If select image from local phone
//                    if error == nil, let url = data as? URL, let this = self {
//                        do {
//                            isLinkTag = 0
//                            TYPETAG = IMAGE
//                            // GETTING RAW DATA
//                            let rawData = try Data(contentsOf: url)
//                            DATAFILE = rawData
//                            print(url)
//                            // CONVERTED INTO FORMATTED FILE : OVER COME MEMORY WARNING
//                            // YOU USE SCALE PROPERTY ALSO TO REDUCE IMAGE SIZE
//                            //let image = UIImage.resizeImage(image: rawImage!, width: 400, height: 400)
//                           // let imgData = image.pngData()
//                            this.andicator.startAnimating()
//                            if let image = UIImage(data: rawData) {
//                                DispatchQueue.main.async {
//                                    selectedImage = image
//                                }
//                            }
//                        }
//                        catch let exp {
//                            print("GETTING EXCEPTION \(exp.localizedDescription)")
//                        }
//
//                    } else {
//                        print("GETTING ERROR")
//                        self!.showAlert(title: "Error", message: "Error loading...", viewController: self!)
//                    }
//                }
//            }
        }
    }
    
    //MARK:- If Local File Selected
    func checkAttachment(url: URL){
        do {
            self.andicator.stopAnimating()
            let tempExtension = url.pathExtension
            let tempImageTypes = ["png", "jpg", "jpeg", "tiff" ]
            let tempVideoTypes = ["mp4", "m4a", "m4v", "f4v", "f4a", "m4b", "m4r", "f4b", "mov", "WMV", "MPEG", "mpeg-4", "MPEG-2", "MPEG-TS", "MPEG1", "MPEG-4*", "MPEG4"]
            if tempImageTypes.contains(where: {$0.compare(tempExtension, options: .caseInsensitive) == .orderedSame}) {
                //MARK:- If Image
                TYPETAG = IMAGE
                isLinkTag = 0
                TYPETAG = IMAGE
                // GETTING RAW DATA
                let rawData = try Data(contentsOf: url)
                DATAFILE = rawData
                print(url)
                // CONVERTED INTO FORMATTED FILE : OVER COME MEMORY WARNING
                // YOU USE SCALE PROPERTY ALSO TO REDUCE IMAGE SIZE
                //let image = UIImage.resizeImage(image: rawImage!, width: 400, height: 400)
                // let imgData = image.pngData()
                if let image = UIImage(data: rawData) {
                    DispatchQueue.main.async {
                        selectedImage = image
                    }
                }
            }
            else if tempVideoTypes.contains(where: {$0.compare(tempExtension, options: .caseInsensitive) == .orderedSame}) {
                //MARK:- If Video
                TYPETAG = VIDEO
                // GETTING RAW DATA
                let rawData = try Data(contentsOf: url)
                DATAFILE = rawData
                let imageThumb = self.thumbnailForVideoAtURL(url: url as URL)
                print(url)
                // CONVERTED INTO FORMATTED FILE : OVER COME MEMORY WARNING
                                      
                // YOU USE SCALE PROPERTY ALSO TO REDUCE IMAGE SIZE
                //let image = UIImage.resizeImage(image: rawImage!, width: 400, height: 400)
                // let imgData = image.pngData()
                selectedImage = imageThumb!
            }
            else{
                TYPETAG = DOCUMENT
                let rawData = try Data(contentsOf: url)
                                     
                DATAFILE = rawData
                //                            let url = data as! NSURL
        //                            let fileExtension = url.pathExtension as  String?
                                     
                DATAFILEURL = url as URL
                isLinkTag = 1
                linkTEXT = "\(url)"
                // GETTING RAW DATA
                //let rawData = try Data(contentsOf: url)
            }
            
        }
        catch let exp {
            print("GETTING EXCEPTION \(exp.localizedDescription)")
        }

    }
    
    
    
    func loadLinkData(link: String){
        if let url = URL(string: link) {
            url.fetchPageInfo({ (title, description, previewImage) -> Void in
                
                if let title = title {
                    titleText = title
                }
                if let description = description {
                    descTEXT = description
                }
                if let imageUrl = previewImage {
                    self.downloadImage(URL(string: imageUrl)!, imageView: UIImageView())
                }
                else{
                    self.isLoadApi = true
                    self.andicator.stopAnimating()
                }
            }, failure: { (errorMessage) -> Void in
                print(errorMessage)
                self.showAlert(title: "Error!", message: ("Error Occured try again and check your internet connection") , viewController: self)
            })
        } else {
            print("Invalid URL!")
        }
    }
    func downloadImage(_ url: URL, imageView: UIImageView){
        print("Download Started")
        print("lastPathComponent: " + url.lastPathComponent)
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async(execute: {
                guard let data = data , error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.isLoadApi = true
                self.andicator.stopAnimating()
                DispatchQueue.main.async{
                    selectedImage = UIImage(data: data)!
                }
            })
        }
    }
    // helper for loading image
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error)
        }).resume()
    }
    // Mrks: -  Get thumbnail of video with the Upload image and video
       public func thumbnailForVideoAtURL(url: URL) -> UIImage? {
           
           let asset = AVAsset(url: url)
           let assetImageGenerator = AVAssetImageGenerator(asset: asset)
           
           var time = asset.duration
           time.value = min(time.value, 2)
           
           do {
               let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
               return UIImage(cgImage: imageRef)
           } catch {
               print("error")
               return nil
           }
       }
    
    func GetAllchannels() {
        let url = BASEURL+"channels/\(USERID)?tags=All&admin=\(USERROLE)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                
                if TYPETAG == LINK {
                    
                }
                else{
                    self.andicator.stopAnimating()
                    self.isLoadApi = true
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
                                let dataarr = (datadic.value(forKey: "data") as! NSArray)
                                
                                self.arrChannelId = dataarr.value(forKey: "ChannelId") as! [Any]
                                self.arrCreatedBy = dataarr.value(forKey: "CreatedBy") as! [Any]
                                self.arrCreatedon = dataarr.value(forKey: "Createdon") as! [Any]
                                self.arrDescription = dataarr.value(forKey: "Description") as! [Any]
                                self.arrIsActive = dataarr.value(forKey: "IsActive") as! [Any]
                                self.arrRequestStatus = dataarr.value(forKey: "RequestStatus") as! [Any]
                                self.arrStatus = dataarr.value(forKey: "Status") as! [Any]
                                self.arrTags = dataarr.value(forKey: "Tags") as! [Any]
                                self.arrTitle = dataarr.value(forKey: "Title") as! NSArray
                                self.arrType = dataarr.value(forKey: "Type") as! [Any]
                                self.arrUpdatedby = dataarr.value(forKey: "Updatedby") as! [Any]
                                self.arrUpdatedon = dataarr.value(forKey: "Updatedon") as! [Any]
                                self.arrUserId = dataarr.value(forKey: "UserId") as! [Any]
                                self.arrthumbnail = dataarr.value(forKey: "thumbnail") as! [Any]
                                
                                self.tablev.reloadData()
                            }
                            else
                            {
                                showAlertPleaseWait(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else
                        {
                            self.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error!", message: (error?.description ?? "Error Occured try again and check your internet connection") , viewController: self)
                        }
                    }
                }
        })
    }
    
    public func showAlert(title: String, message: String, viewController: UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        { (action) in
            self.btncancel()
        }
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
}
//MARK:- Resize Image
extension UIImage {
    class func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

public extension URL {
    
    struct ValidationQueue {
        static var queue = OperationQueue()
    }
    
    func fetchPageInfo(_ completion: @escaping ((_ title: String?, _ description: String?, _ previewImage: String?) -> Void), failure: @escaping ((_ errorMessage: String) -> Void)) {
        
        let request = NSMutableURLRequest(url: self)
        let newUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36"
        request.setValue(newUserAgent, forHTTPHeaderField: "User-Agent")
        ValidationQueue.queue.cancelAllOperations()
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: ValidationQueue.queue, completionHandler: { (response: URLResponse?, data: Data?, error: Error?) -> Void in
            if error != nil {
                DispatchQueue.main.async(execute: {
                    failure("Url receive no response")
                })
                return
            }
            
            if let urlResponse = response as? HTTPURLResponse {
                if urlResponse.statusCode >= 200 && urlResponse.statusCode < 400 {
                    if let data = data {
                        
                        if let doc = try? Kanna.HTML(html: data, encoding: String.Encoding.utf8) {
                            let title = doc.title
                            var description: String? = nil
                            var previewImage: String? = nil
                            
                            if let nodes = doc.head?.xpath("//meta").enumerated() {
                                for node in nodes {
                                    if node.element["property"]?.contains("description") == true ||
                                    node.element["name"] == "description" {
                                        description = node.element["content"]
                                    }
                                    
                                    if node.element["property"]?.contains("image") == true &&
                                        node.element["content"]?.contains("http") == true {
                                            previewImage = node.element["content"]
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async(execute: {
                                completion(title, description, previewImage)
                            })
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async(execute: {
                        failure("Url received \(urlResponse.statusCode) response")
                    })
                    return
                }
            }
        })
    }
}



enum MyError: Error {
    case FoundNil(String)
}



   public func showAlertPleaseWait(title: String, message: String, viewController: UIViewController)
   {
       let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let ok = UIAlertAction(title: "OK", style: .default)
       { (action) in
           
       }
       alert.addAction(ok)
       
       viewController.present(alert, animated: true)
   }

//MARK:- Hyper link label
class LinkedLabel: UILabel {
    
    fileprivate let layoutManager = NSLayoutManager()
    fileprivate let textContainer = NSTextContainer(size: CGSize.zero)
    fileprivate var textStorage: NSTextStorage?
    
    
    override init(frame aRect:CGRect){
        super.init(frame: aRect)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LinkedLabel.handleTapOnLabel))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    override var attributedText: NSAttributedString?{
        didSet{
            if let _attributedText = attributedText{
                self.textStorage = NSTextStorage(attributedString: _attributedText)
                
                self.layoutManager.addTextContainer(self.textContainer)
                self.textStorage?.addLayoutManager(self.layoutManager)
                
                self.textContainer.lineFragmentPadding = 0.0;
                self.textContainer.lineBreakMode = self.lineBreakMode;
                self.textContainer.maximumNumberOfLines = self.numberOfLines;
            }
        }
    }
    
    @objc func handleTapOnLabel(tapGesture:UITapGestureRecognizer){
        
        let link = findLink(string: self.text!)
        if link == ""{
            return
        }
        let locationOfTouchInLabel = tapGesture.location(in: tapGesture.view)
        let labelSize = tapGesture.view?.bounds.size
        let textBoundingBox = self.layoutManager.usedRect(for: self.textContainer)
        let textContainerOffset = CGPoint(x: ((labelSize?.width)! - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: ((labelSize?.height)! - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = self.layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        self.attributedText?.enumerateAttribute(NSAttributedString.Key.link, in: NSMakeRange(0, (self.attributedText?.length)!), options: NSAttributedString.EnumerationOptions(rawValue: UInt(0)), using:{
            (attrs: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
            
            if NSLocationInRange(indexOfCharacter, range){
                if let _attrs = attrs{
                    //MARK:- Developer removed the handling lines here
                }
            }
        })
    }
}

func findLink(string: String) -> String {
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let matches = detector.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        
        var link = ""
        var array = [String]()
        if matches.count == 0{
            return ""
        }
        for match in matches {
            //guard let range = Range(match.range, in: input) else { continue }
            guard let range = Range(match.range, in: string) else { return ""}
            let url = string[range]
            print(url)
            link = "\(url)"
            if link.contains("https://"){
                
            }
            else if link.contains("http://"){
            
            }
            else{
               // link = "https://\(link)"
            }
            
            link = link.replacingOccurrences(of: "https://https://", with: "https://")
            link = link.replacingOccurrences(of: "http://http://", with: "http://")
            link = "\(url)"
            
            
            // do something
            if NSURL(string: link) != nil {
                link = "\(url)"
                array.append(link)
//                if NSData(contentsOf: url as URL) == nil {
//
//                }
//                else {
//                    //link = "\(url)"
//                    //array.append(link)
//                }
            }
        }
        if array.count > 0{
            link = array.joined(separator: ",")
        }
        else{
            link = ""
        }
        
        return link
        
    }//END find link in label and string
