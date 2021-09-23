//
//  Details.swift
//  SE
//
//  Created by MacBook Pro on 17/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import MediaPlayer
import Alamofire
import RSKGrowingTextView
import RSKKeyboardAnimationObserver


class Details: UIViewController, UITextViewDelegate {
    @IBOutlet weak var lbllink: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var imgvVideoIcon: UIImageView!
    
    @IBOutlet weak var bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtvmsg: RSKGrowingTextView!
    
    var tempChannelId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbltitle.numberOfLines = 0
        lbltitle.lineBreakMode = .byWordWrapping
        lbldesc.numberOfLines = 0
        lbldesc.lineBreakMode = .byWordWrapping
        
        self.navigationItem.title = "SHARE...!"
        // Marks: - Left Post button
        let leftcancelbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftcancelbutton], animated: true)
        // Marks: - Right Post button
        let rightpostbutton:UIBarButtonItem = UIBarButtonItem(title:"POST", style: UIBarButtonItem.Style.done, target: self, action: #selector(btnpost))
        self.navigationItem.setRightBarButtonItems([rightpostbutton], animated: true)
        lbllink.text = linkTEXT
        lbltitle.text = titleText
        lbldesc.text = descTEXT
        self.lbldesc.frame.origin.y = self.lbltitle.frame.maxY + 8
        
        if let tempid = group_defaults.value(forKey: "userid") as? String {
             USERID = tempid
        }
        else{
            showAlert(title: "ePoultry", message: "Please login...!", viewController: self)
            return
        }
        if TYPETAG == IMAGE {
            imgv.image = selectedImage
        }
        else if TYPETAG == VIDEO{
            self.imgvVideoIcon.isHidden = false
            imgv.image = selectedImage
        }
        else if TYPETAG == TEXT{
            self.imgv.isHidden = true
            lbllink.text = linkTEXT
            lbllink.isHidden = true
            lbltitle.text = "Text for share...!"
            self.lbltitle.frame.origin.y = 20
            self.lbldesc.frame.origin.y = self.lbltitle.frame.maxY + 8
            self.lbldesc.numberOfLines = 38
            lbldesc.text = linkTEXT
            self.lbldesc.sizeToFit()
        }
        else if TYPETAG == DOCUMENT{
            lbllink.text = DATAFILEURL?.lastPathComponent
        }
        else if TYPETAG == LINK{
            imgv.image = selectedImage
        }
        
        self.registerForKeyboardNotifications()
        
        self.txtvmsg.layer.borderWidth = 0.5
        self.txtvmsg.layer.borderColor = UIColor.lightGray.cgColor
        
        self.txtvmsg.delegate = self
        DispatchQueue.main.async {
            self.txtvmsg.layer.cornerRadius = self.txtvmsg.frame.height / 2
        }
    }
    
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnpost(){
        if andicator.isAnimating{
            showAlertPleaseWait(title: "", message: "Please wait...", viewController: self)
            return
        }
        else{
            if TYPETAG == VIDEO{
                let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
                uploadMedia(type: VIDEO, object: imageData, completion: { filename in
                    guard let filename = filename else { return }
                    let items = filename.components(separatedBy: ",")
                    print(filename)
                    self.funAddPost(imagename: items[0], videoname: items[1], type: VIDEO)
                })
            }
            else if TYPETAG == IMAGE{
                let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
                uploadMedia(type: IMAGE, object: imageData, completion: { filename in
                    guard let filename = filename else { return }
                   // print(filename)
                    self.funAddPost(imagename: filename, videoname: "", type: IMAGE)
                })
            }
            else if TYPETAG == LINK {
                let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
                uploadMedia(type: IMAGE, object: imageData, completion: { filename in
                    guard let filename = filename else { return }
                    //print(filename)
                    self.funAddPost(imagename: filename, videoname: "", type: LINK)
                })
            }
            else if TYPETAG == TEXT {
                funAddPost(imagename: "", videoname: "", type: TEXT)
            }
            else if TYPETAG == DOCUMENT{
                uploadMedia(type: DOCUMENT, object: DATAFILE as NSData, completion: { filename in
                    guard let filename = filename else { return }
                    print(filename)
                    self.funAddPost(imagename: filename, videoname: "", type: DOCUMENT)
                })
            }
        }
    }

    //MARK:- Upload image or file to Firebase Storage
    func uploadMedia(type: Int, object: NSData, completion: @escaping (_ url: String?) -> Void) {
        
        let uploadData = object
        var imgdata = Data()
        var videodatatemp = Data()
        var videofilename = String()
        let timespam = Date().currentTimeMillis()
        var url = ""
        var imagefilename = ""
        var parameters : Parameters = ["":""]
        if type == IMAGE{
            imgdata = uploadData as Data
            imagefilename = "\("\(String(describing: timespam))").png"
            imagefilename = imagefilename.replacingOccurrences(of: " ", with: "_")
            parameters = ["filename":imagefilename]
            url = BASEURL + "Upload/Post?filename=\(imagefilename)"
        }
        else if type == VIDEO{
            videodatatemp = DATAFILE
            imgdata = uploadData as Data
            imagefilename = "\("\(String(describing: timespam))").png"
            videofilename = "\("\(String(describing: timespam))")video.mp4"
            imagefilename = imagefilename.replacingOccurrences(of: " ", with: "_")
            videofilename = videofilename.replacingOccurrences(of: " ", with: "_")
            url = BASEURL + "Upload/PostVideo?videofilename=\(videofilename)&filename=\(imagefilename)"
            parameters = ["filename":imagefilename, "videofilename": videofilename]
        }
        else if type == DOCUMENT {
            imgdata = uploadData as Data
            let tempfilename = (DATAFILEURL?.lastPathComponent.split(separator: "."))! as NSArray
            imagefilename = "\(tempfilename[0] as? String ?? "")\("\(timespam!)").\(DATAFILEURL?.pathExtension ?? "")"
            imagefilename = imagefilename.replacingOccurrences(of: " ", with: "_")
            parameters = ["filename":imagefilename]
            url = BASEURL + "upload/file?filename=\(imagefilename)"
        }
        
        andicator.startAnimating()
        webServiceWithPictureAudio(url: url, parameters: parameters, imagefilename: imagefilename, audiofilename:"" , videofilename: videofilename, imageData: imgdata, audioData: Data(), videoData: videodatatemp, completionHandler:{
            
            responseObject, error in
            self.andicator.stopAnimating()
            if error == nil{
                if type == VIDEO{
                    let tmepname = "\(imagefilename),\(videofilename)"
                    completion(tmepname)
                }else{
                    completion(imagefilename)
                }
            }
            else{
                completion("error")
            }
        })
    }
    @objc func btncancel(){
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    func funAddPost(imagename: String, videoname: String, type: Int){
        self.view.endEditing(true)
        var subType = ""
        var postGroupPublic = ""
        var descstr = ""
        
        var tempdesc = ""
        if txtvmsg.text! != "Write a message..."{
            tempdesc = txtvmsg.text!
        }
        descstr = tempdesc
        if type == LINK{
            subType = "link"
            descstr = lbltitle.text! + "_&epoultry&_" + lbldesc.text! + "_&epoultry&_" + lbllink.text! + "_&epoultry&_" + tempdesc
        }
        else if type == TEXT {
            subType = "text"
            descstr = lbllink.text!
        }
        else if type == VIDEO{
            subType = "video"
        }
        else if type == IMAGE{
            subType = "image"
        }
        else if type == DOCUMENT{
            subType = "document"
        }
        
        var statusType = ""
        if tempChannelId == ""{
            statusType = "status"
            postGroupPublic = "status"
        }
        else{
            statusType = "news"
            postGroupPublic = "news"
        }
        
        var url = ""
        if type == VIDEO{
            url = BASEURL+"\(statusType)/video"
        }
        else if type == DOCUMENT{
            url = BASEURL+"\(postGroupPublic)"
        }
        else{
            url = BASEURL+"\(statusType)"
        }
        
        let parameters : Parameters =
            ["userId": USERID,
             "filename": imagename,
             "status":descstr,
             "type":postGroupPublic,
             "subType":subType,
             "tag":"",
             "hashtag":statusType,
             "videoFilename":videoname,
             "ChannelId": tempChannelId,
             "groupId": tempChannelId]
        
        andicator.startAnimating()
        
        webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil{
                if (responseObject!.value(forKey: "data") as? String) != nil{
                    self.btncancel()
                }
                else{
                    showAlert(title: "Error!", message: "Error occured try again", viewController: self)
                }
            }
            else{
                DispatchQueue.main.async {
                    showAlert(title: "Error!", message: (error?.description ?? "Error Occured try again and check your internet connection") , viewController: self)
                }
            }
        })
    }
    
    
    //MARK:- Textview Delegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            DispatchQueue.main.async{
                //   obj.putRightViewAndButtonInTextViewField(button: self.btnCamera, view: self.boombutton, txtview: self.txtmsgv, x: 0, width: 40, height: 40)
            }
            return false
        }
        //Remove first white space
        if textView.text.count == 0 && text == " "{
            return false
        }
        let string = text
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            if textView.text.count > 0{
                //textView.text!.removeLast()
            }
            return true
        }
        return true
    }
    
    // MARK: - Helper Methods
    private var isVisibleKeyboard = true
       private func adjustContent(for keyboardRect: CGRect) {
           let keyboardHeight = keyboardRect.height + 10
           self.bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint
            .constant = self.isVisibleKeyboard ? keyboardHeight - self.bottomLayoutGuide.length : 10.0
           self.view.layoutIfNeeded()
       }
       
       @IBAction func handleTapGestureRecognizer(sender: UITapGestureRecognizer) {
           self.txtvmsg.resignFirstResponder()
       }
       
       private func registerForKeyboardNotifications() {
           self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                          willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                                           self.isVisibleKeyboard = isShowing
                                           self.adjustContent(for: keyboardRectEnd)
               }, onComplete: { (finished, isShown) -> Void in
                   self.isVisibleKeyboard = isShown
                   
           })
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: {
            [unowned self] (keyboardRectEnd, duration) -> Void in
               self.adjustContent(for: keyboardRectEnd)
               }, onComplete: nil)
       }
       
       private func unregisterForKeyboardNotifications() {
           self.rsk_unsubscribeKeyboard()
       }
}



//MARK: - Post WebServices
func webServiceWithPictureAudio(url:String , parameters:Dictionary<String,Any>,imagefilename: String, audiofilename: String, videofilename: String, imageData:Data, audioData:Data, videoData:Data, completionHandler: @escaping ([NSDictionary]?, String?) -> ()){
    //        var headers = HTTPHeaders()
    //        headers = [
    //            //"Content-Type" :"text/html; charset=UTF-8",
    //            //"Content-Type": "application/json",
    //            "Content-Type": "application/x-www-form-urlencoded",
    //            //"Accept": "application/json",
    //            "Accept": "multipart/form-data"
    //        ]
    //        headers = [ "Content-type": "multipart/form-data",
    //                    "Accept" : "text/html; charset=UTF-8"]
    
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 40
    //configuration.httpAdditionalHeaders = headers
    //configuration.urlCredentialStorage = nil
    let sessionManager = Alamofire.SessionManager(configuration: configuration)
    
    sessionManager.upload(multipartFormData: { (multipartFormData) in
        
        for (key, value) in parameters {
            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
        }
        if imageData.isEmpty != true {
            multipartFormData.append((imageData), withName: "filename", fileName: imagefilename, mimeType: "image/png/jpeg/jpg")
        }
        if audioData.isEmpty != true {
            multipartFormData.append((audioData), withName: "voice", fileName: audiofilename, mimeType: "audio/m4a/wav/mp4")
        }
        if videoData.isEmpty != true {
            multipartFormData.append((videoData), withName: "videoFilename", fileName: videofilename, mimeType: "mp3/m4a/wav/mp4")
        }
    }, to: url,
       encodingCompletion: {    response in
        switch(response){
        case .success(let upload, _, _):
            //MARK:- Handle progress
            upload.uploadProgress { progress in
                print("Progress: ", progress.fractionCompleted)
                
                // self.bar_progress.progress = Float(progress.fractionCompleted)
                // self.lbl_uploadProgress.text = "Upload Progress: \( Int(progress.fractionCompleted * 100))%"
                
                if progress.isPausable{
                    print("Pausable")      // THIS IS WHAT I WANT
                }
                else{
                    print("Not pausable")    // THIS IS MY PROBLEM
                    
                    //                        UIApplication.shared.keyWindow!.addSubview(self.vnavigation)
                }
                
            }
            //MARK:- Handle Response
            upload.responseJSON {
                response in
                print(  "response" , response)
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                var jsonstring = String()
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    jsonstring = utf8Text
                }
                if jsonstring != ""
                {
                    if let data = jsonstring.data(using: String.Encoding.utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                            if json != nil{
                                completionHandler(json! as [NSDictionary], nil)
                                print(json!)
                            }
                            else{
                                completionHandler([NSDictionary](), nil)
                            }
                            
                        } catch let parseError {
                            print(parseError)
                            print(jsonstring)
                            print("Something went wrong")
                            print(response.description)
                            print(Error.self)
                            
                            completionHandler(nil, "Not JSON Data.")
                        }
                    }
                }
                else{
                    if let json = response.result.value {
                        print("JSON: \(json)") // serialized json response
                        completionHandler(([json as! NSDictionary]), nil)
                    }
                    else{
                        completionHandler(nil,"")
                    }
                }
                sessionManager.session.invalidateAndCancel()
            }
            break
        case .failure(let error):
            if error._code == NSURLErrorCannotParseResponse{
                completionHandler(nil, "Not JSON Data.")
            }
            else if error._code == NSURLErrorTimedOut{
                completionHandler(nil, "Server is not responding, request time out please try again.")
            }
            else if error._code == NSURLErrorCannotFindHost{
                completionHandler(nil, error.localizedDescription)
            }
            else if error._code == NSURLErrorNotConnectedToInternet{
                completionHandler(nil, error.localizedDescription)
            }
            else{
                completionHandler(nil, error.localizedDescription)
            }
            sessionManager.session.invalidateAndCancel()
            break
        }
    })
}


/////////////////////////
func webService(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (NSDictionary?, String?) -> ()){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
      //  sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON
          sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
                response in
                let data = response.result
                switch(data){
                case .success(let JSON):
                    completionHandler(JSON as? NSDictionary, nil)
                    
                    sessionManager.session.invalidateAndCancel()
                    break
                    
                case .failure(let error):
                    if error._code == NSURLErrorCannotParseResponse{
                        completionHandler(nil, "Not JSON Data.")
                        break
                    }
                    else if error._code == NSURLErrorTimedOut{
                        completionHandler(nil, "Server is not responding, please try again.")
                        break
                    }
                    else if error._code == NSURLErrorCannotFindHost{
                        completionHandler(nil, error.localizedDescription)
                        break
                    }
                    else if error._code == NSURLErrorNotConnectedToInternet{
                        completionHandler(nil, error.localizedDescription)
                        break
                    }
                    else{
                        completionHandler(nil, error.localizedDescription)
                        break
                    }
                }
    }
}


//MARK: - Get WebServices
func webServicesGetwithJsonResponse(url:String, completionHandler: @escaping (NSDictionary?, String?) -> ()){
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 14
    
    let sessionManager = Alamofire.SessionManager(configuration: configuration)
    
    Alamofire.request(url).validate().responseData(completionHandler: {
        response in
        
        if let json = response.result.value {
            print("JSON: \(json)") // serialized json response
        }
        var jsonstring = String()
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            // print("Data: \(utf8Text)") // original server data as UTF8 string
            jsonstring = utf8Text
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
                //print(json!)
            }
            catch let parseError {
                print(parseError)
                print(jsonstring)
                print("Something went wrong")
                print(response.description)
                print(Error.self)
                
            }
        }
        let data = response.result
        switch(data){
        case .success(let jsonstr):
            print(jsonstr)
            if let data = jsonstring.data(using: String.Encoding.utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    completionHandler(json! as NSDictionary, nil)
                    print(json!)
                } catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    
                    completionHandler(nil, "Not JSON Data.")
                }
            }
            sessionManager.session.invalidateAndCancel()
            break
            
        case .failure(let error):
            if error._code == NSURLErrorCannotParseResponse{
                completionHandler(nil, "Not JSON Data.")
                break
            }
            else if error._code == NSURLErrorTimedOut{
                completionHandler(nil, "Server is not responding, please try again.")
                break
            }
            else if error._code == NSURLErrorCannotFindHost{
                completionHandler(nil, error.localizedDescription)
                break
            }
            else if error._code == NSURLErrorNotConnectedToInternet{
                completionHandler(nil, error.localizedDescription)
                break
            }
            else{
                completionHandler(nil, error.localizedDescription)
                break
            }
        }
        
        ///////////////////////
        switch response.result {
        case .success:
            print("Validation Successful")
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            else{
                completionHandler(nil, "Not JSON Data.")
            }
            //MARK: Data in string
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
        case .failure(let error):
            print(error)
            completionHandler(nil, error as? String)
        }
        //////////////////////
        
    })
}
//MARK: - Post WebServices
func webService2(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping ([NSDictionary]?, String?, [String:Any]?) -> ()){
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 20
    
    let sessionManager = Alamofire.SessionManager(configuration: configuration)
    //        let headers: HTTPHeaders = [
    //            "Content-Type": "application/json",
    //       //     "Content-Type": "application/x-www-form-urlencoded",
    //            "Accept": "application/json"
    //        ]
    
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
        
    sessionManager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: headers).responseData(completionHandler: {
        response in
        if let json = response.result.value {
            print("JSON: \(json)") // serialized json response
        }
        var jsonstring = String()
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            // print("Data: \(utf8Text)") // original server data as UTF8 string
            jsonstring = utf8Text
            if jsonstring.count > 2{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    print(json as Any)
                }
                catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    //print(url)
                }
            }
        }
        
        let data = response.result
        switch(data){
        case .success(let json):
            print(json)
            if let data = jsonstring.data(using: String.Encoding.utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                    if json != nil{
                        completionHandler(json! as [NSDictionary], nil, nil)
                        print(json!)
                    }
                    else{
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            // print("Data: \(utf8Text)") // original server data as UTF8 string
                            jsonstring = utf8Text
                            if jsonstring.count > 2{
                                do{
                                    
                                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                                    if json != nil
                                    {
                                        completionHandler([NSDictionary](), nil, json! as [String: Any])
                                    }
                                    print(json as Any)
                                }
                                catch let parseError {
                                    print(parseError)
                                    print(jsonstring)
                                    print("Something went wrong")
                                    print(response.description)
                                    print(Error.self)
                                    //print(url)
                                }
                            }
                        }
                    }
                    
                } catch let parseError {
                    print(parseError)
                    print(jsonstring)
                    print("Something went wrong")
                    print(response.description)
                    print(Error.self)
                    
                    completionHandler(nil, "Not JSON Data.", nil)
                }
            }
            
            
            sessionManager.session.invalidateAndCancel()
            break
            
            //            case .success(let JSON):
            //                                    completionHandler(JSON as? NSDictionary, nil)
            //
            //                                    sessionManager.session.invalidateAndCancel()
        //                                break
        case .failure(let error):
            if error._code == NSURLErrorCannotParseResponse
            {
                completionHandler(nil, "Not JSON Data.", nil)
                
            }
            else if error._code == NSURLErrorTimedOut
            {
                completionHandler(nil, "Server is not responding, request time out please try again.", nil)
                
            }
            else if error._code == NSURLErrorCannotFindHost
            {
                completionHandler(nil, error.localizedDescription, nil)
                
            }
            else if error._code == NSURLErrorNotConnectedToInternet
            {
                completionHandler(nil, error.localizedDescription, nil)
                
            }
            else
            {
                completionHandler(nil, error.localizedDescription, nil)
                
            }
            sessionManager.session.invalidateAndCancel()
            break
        }
    })
    
}

extension Date {
    func currentTimeMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
