////
////  AddnewPost.swift
////  AMPL
////
////  Created by Paragon Marketing on 06/06/2017.
////  Copyright © 2017 sameer. All rights reserved.
////
//
import UIKit
import MobileCoreServices
import AVFoundation
import ISEmojiView
import Alamofire
import AVKit

class AddnewPost: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate,EmojiViewDelegate, UITextViewDelegate, UIDocumentPickerDelegate, AVPlayerViewControllerDelegate {
    
    var buttonTag = 0
    var postTypeNewsORTimeLine = ""
    var selectedFilePath: URL?
    var posttype = String()
    var groupid = String()
    var isvideo = String()
    var edit = String()
    var type = String()
    var statusid = String()
    var url = String()
    var strpost = String()
    var strvideolbl = String()
    
    var textviewy = Float()
    
    var newsvideostag = String()
    
    
    //MARK:- Upload image or video Image Picker
    var imagePicker: UIImagePickerController!
    var popover = UIViewController()
    var videodata = NSData()
    var videoimgDocumentdata = NSData()
    ////////////////////////////////
    
    @IBOutlet weak var btnemoji: UIButton!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var btnpublic: UIButton!
    
    @IBOutlet weak var txtdesc: UITextView!
    
    @IBOutlet weak var btncancel: UIButton!
    
    @IBOutlet weak var btnuploadimg: UIButton!
    
    @IBOutlet weak var btnuploadvideo: UIButton!
    @IBOutlet weak var imgv: UIImageView!
    
    @IBOutlet weak var lblvideo: UILabel!
    @IBOutlet weak var bgupload: UIView!
    
    ////////////////////////////////
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardHeight = 0.0
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeightt = keyboardRectangle.height
            keyboardHeight = Float(keyboardHeightt + 64 + 43)
        }
    }
    @IBOutlet weak var imgvplay: UIImageView!
    @IBOutlet weak var btnplayvideo: UIButton!
    @IBAction func btnplayvideo(_ sender: Any) {
        //MARK:- Play video in player
        let vc = AVPlayerViewController()
        let player = AVPlayer(url: selectedFilePath!)
        vc.player = player
        vc.delegate = self
        self.present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgvuploadplus.image = imgvuploadplus.image?.withRenderingMode(.alwaysTemplate)
        if #available(iOS 13.0, *) {
            imgvuploadplus.tintColor = UIColor.link
        } else {
            // Fallback on earlier versions
            imgvuploadplus.tintColor = UIColor.blue
        }
        txtdesc.layer.cornerRadius = 4
        txtdesc.layer.borderColor = UIColor.lightGray.cgColor
        txtdesc.layer.borderWidth = 1
        imgv.layer.cornerRadius = 4
        imgv.clipsToBounds = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        // Do any additional setup after loading the view.
        self.txtdesc.becomeFirstResponder()
        //MARK: - Check type if group hide public button
        self.title = "Add Post"
        if type == "Group" {
            btnpublic.isHidden = true
        }
        txtdesc.delegate = self
        
        //Marks: - Show user image
        if let imgstr = defaults.value(forKey: "profileimg") as? String
        {
            let urlprofile = URL(string:  "\(imagepath)\(imgstr)")!
            imgprofile.kf.setImage(with: urlprofile)
        }
        
        //Marks: - Show user Name
        lblusername.text = defaults.value(forKey: "fullname") as? String
        
        if edit == "1" {
            btnuploadimg.tag = buttonTag
            // Marks: - Right Post button
            let rightpostbutton:UIBarButtonItem = UIBarButtonItem(title:"Update", style: UIBarButtonItem.Style.done, target: self, action: #selector(btnedit))
            self.navigationItem.setRightBarButtonItems([rightpostbutton], animated: true)
            
            // Marks: - Data input
            txtdesc.text = strpost
            lblvideo.text = strvideolbl
            
            if url != "" {
                btncancel.isHidden = false
            }

            if strpost != "Write your post here" {
                txtdesc.textColor = UIColor.black
            }
            if isvideo == "1" {
                let urlvideo = URL(string: videopath+url+videoPlayEndPath)
                let videoDataURL = urlvideo
               
                let image = thumbnailForVideoAtURL(url: videoDataURL! as URL)
               // let imageData: NSData = image!.jpegData(compressionQuality: 0.4)! as NSData
                let imageData = image!.jpegData(compressionQuality: 0.40)
                videoimgDocumentdata = imageData! as NSData
                
                let video = NSData(contentsOf: (videoDataURL?.absoluteURL)!)
                
                videodata = video! as NSData
                lblvideo.text = "Video Selected"
            }
            else {
                //Kingfisher Image upload
                let urlimg = URL(string: imagepath+url)
                imgv.kf.setImage(with: urlimg)
                
                lblvideo.text = ""
            }
        }
        else {
            // Marks: - Right Post button
            let rightpostbutton:UIBarButtonItem = UIBarButtonItem(title:"Post", style: UIBarButtonItem.Style.done, target: self, action: #selector(btnpost))
            self.navigationItem.setRightBarButtonItems([rightpostbutton], animated: true)
        }

        btnpublic.layer.borderWidth = 1.0
        btnpublic.layer.cornerRadius = 4
        btnpublic.layer.borderColor = UIColor.lightGray.cgColor
        
        // Marks: - Left button multiple
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
    }
    
    @objc func btnback(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnemoji(_ sender: Any) {
        
        let emojiView = EmojiView()
        emojiView.delegate = self
        self.txtdesc.inputView = emojiView
        DispatchQueue.main.async {
            self.txtdesc.becomeFirstResponder()
        }
    }

    @IBAction func btnuploadimg(_ sender: Any) {
        showActionSheet(sender: sender)
    }
    
    @IBAction func btnuploadvideo(_ sender: Any) {
        btnuploadimg.tag = 0
        btnuploadvideo.tag = 1
        showActionSheet(sender: sender)
    }
    @IBAction func btnpublic(_ sender: Any) {
    }
    
    @IBAction func btncancel(_ sender: Any) {
        imgv.image = nil
        lblvideo.text = ""
        videodata = NSData()
        btncancel.isHidden = true
    }

    // Marks: - textfiled delegates
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtdesc.inputView = nil
        self.view.endEditing(true)
    }
    
    // Marks: - Return button delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.txtdesc.inputView = nil
        return true
    }
    
    //Marks: - Textview delegates
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
      // self.bgupload.frame.origin.y = self.bgupload.frame.maxY - (180 + 64 + 43)
        DispatchQueue.main.async{
            self.bgupload.frame.origin.y = self.view.frame.maxY - CGFloat(keyboardHeight)
        }
        
        if txtdesc.text == "Write your post here" {
            txtdesc.text = ""
            txtdesc.textColor = UIColor.black
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.bgupload.frame.origin.y = self.view.frame.maxY - (43 + 64)
        if txtdesc.text == "" {
            txtdesc.text = "Write your post here"
            txtdesc.textColor = UIColor.lightGray
        }
    }
    //MARK: - Retrun from textview on keyboard retrun button
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
        
    //Open Action Sheet for Camera and Gallery
    func showActionSheet(sender: Any) {
        let title = "Choose Attachment"
        self.view.endEditing(true)
        
        let alert:UIAlertController=UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.btnuploadimg.tag = CAMERA
            self.OpenCamera()
        }
        let gallaryAction = UIAlertAction(title: "Photo Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.btnuploadimg.tag = IMAGE
            self.OpenGallary()
        }
        let videoAction = UIAlertAction(title: "Video Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.btnuploadimg.tag = VIDEO
            self.OpenVideoGallary()
        }
        let documentsAction = UIAlertAction(title: "Documents", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.btnuploadimg.tag = DOCUMENT
            self.OpenDocumentGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        // Add the actions
        imagePicker?.delegate = self
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(videoAction)
        alert.addAction(documentsAction)
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
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        //        //  - See more at: http://www.theappguruz.com/blog/user-interaction-camera-using-uiimagepickercontroller-swift#sthash.WnJ7r5sU.dpuf
    }
    
    func OpenCamera() {
        imgv.contentMode = .scaleToFill
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func OpenGallary() {
        imgv.contentMode = .scaleToFill
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func OpenVideoGallary() {
        imgv.contentMode = .scaleToFill
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }

    func OpenDocumentGallary() {
        imgv.contentMode = .scaleAspectFit
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        let documentPickerAllFiles = UIDocumentPickerViewController(documentTypes: ALLDOCUMENTSTYPE, in: .import)

        documentPickerAllFiles.delegate = self
        present(documentPickerAllFiles, animated: true, completion: nil)
    }
    
    //MARK:- Documents Picker Delegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {

     let cico = url as URL
     print(cico)
     print(url)
     print(url.lastPathComponent)
     print(url.pathExtension)
        if url.pathExtension == ""{
            obj.showAlert(title: "Alert!", message: "Please select valid file format", viewController: self)
            return
        }
        selectedFilePath = url
        let documentData = NSData(contentsOf: (cico.absoluteURL))
        videoimgDocumentdata = documentData!
        
        lblvideo.lineBreakMode = .byWordWrapping
        lblvideo.numberOfLines = 2
        lblvideo.text = "Document Selected \n\(url.lastPathComponent)"
        lblvideo.sizeToFit()
        
        imgv.image = UIImage(named: "document")
        imgv.frame.origin.y = lblvideo.frame.maxY + 8
        lblvideo.center.x = self.view.center.x
        btncancel.isHidden = false
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            btnuploadimg.tag = IMAGE
            imgv.image = image
            lblvideo.text = "Image Selected"
            videodata = NSData()
            btncancel.isHidden = false
            lblvideo.isHidden = true
            
            imgvplay.isHidden = true
            btnplayvideo.isHidden = true
        }
        else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            btnuploadimg.tag = VIDEO
            // let videoPath = videoDataURL?.path
            let image = thumbnailForVideoAtURL(url: videoURL as URL)
            let imageData = image?.jpegData(compressionQuality: 0.4)
            DispatchQueue.main.async {
                self.imgv.image = image
            }
            videoimgDocumentdata = imageData! as NSData
            selectedFilePath = videoURL
            let video = NSData(contentsOf: (videoURL.absoluteURL))
            videodata = video!
            lblvideo.text = "Video Selected"
            btncancel.isHidden = false
            imgv.image = nil
            lblvideo.isHidden = false
            imgvplay.isHidden = false
            btnplayvideo.isHidden = false
        }
        else {
            obj.showAlert(title: "Alert!", message: "Your selected video format is not correct", viewController: self)
        }
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        picker.dismiss(animated: true, completion: nil)
    }
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//    {
//        // Local variable inserted by Swift 4.2 migrator.
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//   
//        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! String
//       if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
//       {
//        imgv.image = image
//        lblvideo.text = ""
//        videodata = ""
//        btncancel.isHidden = false
//        lblvideo.isHidden = true
//       }
//       else
//       {
//            if mediaType == "public.movie"
//            {
//                
////              let imageData: NSData = UIImageJPEGRepresentation(imgv.image!, 0.4)! as NSData
////              let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
//    
//                let videoDataURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as! NSURL!
//                // let videoPath = videoDataURL?.path
//                let image = thumbnailForVideoAtURL(url: videoDataURL! as URL)
//                let imageData: NSData = image!.jpegData(compressionQuality: 0.4)! as NSData
//                
//                videoimgDocumentdata = imageData.base64EncodedString(options: .lineLength64Characters)
//                
//                let video = NSData(contentsOf: (videoDataURL?.absoluteURL)!)
//                
//                //let video = NSData(contentsOfMappedFile: videoPath!)
//                
//                videodata = (video?.base64EncodedString(options: .lineLength64Characters))!
//                
//                lblvideo.text = "Video uploaded"
//                
//                btncancel.isHidden = false
//                imgv.image = nil
//                lblvideo.isHidden = false
//                
//            }
//            else
//            {
//                obj.showAlert(title: "Alert!", message: "Your selected video format is not correct", viewController: self)
//            }
//        }
//        
//        
//        //        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        //        {
//        //            let headers: HTTPHeaders = [ "auth-token": "(profile_pic)" ]
//        //            let URL = try! URLRequest(url: ContainerClass.returnBaseURL()+"uploadpic", method: .post, headers: headers)
//        //
//        //            Alamofire.upload(multipartFormData: { multipartFormData in
//        //
//        //                if let imageData = UIImageJPEGRepresentation(image, 1.0)
//        //                {
//        //                    self.activity.startAnimating()
//        //
//        //                    multipartFormData.append(imageData, withName: "profilepic", fileName: "picture.jpeg", mimeType: "image/jpeg")
//        //
//        //                    multipartFormData.append("8".data(using: .utf8)!, withName: "cid")
//        //                }
//        //            }, with: URL, encodingCompletion:
//        //                {
//        //                    encodingResult in
//        //                    switch encodingResult
//        //                    {
//        //                    case .success(let upload, _, _):
//        //                        upload.responseJSON { response in
//        //                            print(response.result.value!)
//        //                            debugPrint("SUCCESS RESPONSE: \(response)")
//        //
//        //                            self.imgViewTop.image = image
//        //                            self.activity.stopAnimating()
//        //                        }
//        //                    case .failure(let encodingError):
//        //                        // hide progressbas here
//        //                        print("ERROR RESPONSE: \(encodingError)")
//        //                    }
//        //            })
//        //        }
//        //        else
//        //        {
//        //            print("Something went wrong")
//        //        }
//        
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Mrks: -  Get thumbnail of video with the Upload image and video
    private func thumbnailForVideoAtURL(url: URL) -> UIImage? {
        
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
    
     /////////////////////////////////////////////////// Finish Upload image and video from gallery
    
    
    @IBOutlet weak var imgvuploadplus: UIImageView!
    //Marks Post button right menu
    @objc func btnpost() {
        self.view.endEditing(true)
        if imgv.image == nil && txtdesc.text == "Write your post here" && lblvideo.text == "" {
            obj.showAlert(title: "Alert!", message: "Please type post or select some video or picture", viewController: self)
        }
        else if btnuploadimg.tag == IMAGE {
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            uploadMedia(type: "IMAGE", object: imageData, completion: { filename in

                guard let filename = filename else { return }
                if filename == "error" {
                    obj.showAlert(title: "Error", message: "Media not upload try again", viewController: self)
                    return
                }
                print(filename)
                DispatchQueue.main.async {
                    self.funAddPost(postType: IMAGE, imagename: filename, videoname: "")
                }
            })
        }
        else if btnuploadimg.tag == VIDEO {
            uploadMedia(type: "VIDEO", object: videoimgDocumentdata, completion: { filename in
                guard let filename = filename else { return }
                print(filename)
                let items = filename.components(separatedBy: ",")
                DispatchQueue.main.async {
                    self.funAddPost(postType:VIDEO, imagename: items[0], videoname: items[1])
                }
            })
        }
        else if btnuploadimg.tag == DOCUMENT {
            uploadMedia(type: "DOCUMENT", object: videoimgDocumentdata, completion: { filename in
                guard let filename = filename else { return }
                print(filename)
                DispatchQueue.main.async {
                    self.funAddPost(postType: DOCUMENT, imagename: filename, videoname: "")
                }
            })
        }
        else if (txtdesc.text != "Write your post here" && imgv.image != nil) {
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            uploadMedia(type: "IMAGE", object: imageData, completion: { filename in
                
                guard let filename = filename else { return }
                
                print(filename)
                DispatchQueue.main.async {
                    self.funAddPost(postType: IMAGE, imagename: filename, videoname: "")
                }
            })
        }
        
        else {
            self.funAddPost(postType: TEXT, imagename: "", videoname: "")
        }
    }
    
    @objc func btnedit() {
        self.view.endEditing(true)
        if btnuploadimg.tag == IMAGE {
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            uploadMedia(type: "IMAGE", object: imageData, completion: { filename in

                guard let filename = filename else { return }
                
                print(filename)
                DispatchQueue.main.async {
                    self.funUpDatePost(postType: IMAGE, imagename: filename, videoname: "")
                }
            })
        }
        else if btnuploadimg.tag == VIDEO {
            uploadMedia(type: "VIDEO", object: videoimgDocumentdata, completion: { filename in
                guard let filename = filename else { return }
                print(filename)
                let items = filename.components(separatedBy: ",")
                DispatchQueue.main.async {
                    self.funUpDatePost(postType:VIDEO, imagename: items[0], videoname: items[1])
                }
            })
            
        }
        else if btnuploadimg.tag == DOCUMENT {
            uploadMedia(type: "DOCUMENT", object: videoimgDocumentdata, completion: { filename in
                guard let filename = filename else { return }
                print(filename)
                DispatchQueue.main.async {
                    self.funUpDatePost(postType: DOCUMENT, imagename: filename, videoname: "")
                }
            })
        }
        else {
            funUpDatePost(postType: TEXT, imagename: "", videoname: "")
        }
    }
    
    //Marks Add post to server
    func addpost() {
        var soapMessage = String()
        
        let desc = txtdesc.text!
        var descstr = desc
        
        if txtdesc.text! != "" {
            descstr = descstr.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        }

        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String {
            userid = tempid
        }
        else {
            userid = ""
        }
        
        if (txtdesc.text != "Write your post here" && imgv.image != nil) {
            let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
            //print(timespam)
            
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
            
            //Marks: - image and text both post
            soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateStatus xmlns='http://threepin.org/'><filename>\(String(timespam)+".jpg")</filename><user_id>\(userid)</user_id><type>\(type)</type><status>\(descstr)</status><img>\(imageStr)</img><isNew>1</isNew><tag></tag></UpdateStatus></soap:Body></soap:Envelope>"
        }
        else if imgv.image != nil {
            let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
            //print(timespam)
            
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
            
            //Marks: - simple image post
            soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateStatus xmlns='http://threepin.org/'><filename>\(String(timespam)+".jpg")</filename><user_id>\(userid)</user_id><type>\(type)</type><status>\("")</status><img>\(imageStr)</img><isNew>1</isNew><tag></tag></UpdateStatus></soap:Body></soap:Envelope>"
        }
        else {
            //Marks: - simple text post
            soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateStatus xmlns='http://threepin.org/'><filename>\("")</filename><user_id>\(userid)</user_id><type>\(type)</type><status>\(descstr)</status><img>\("")</img><isNew>1</isNew><tag></tag></UpdateStatus></soap:Body></soap:Envelope>"
        }

        let soapLenth = String(soapMessage.count)
        
//        theUrlString = theUrlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
//        var characterSet = NSMutableCharacterSet() //create an empty mutable set
//        characterSet.formUnion(with: NSCharacterSet.urlQueryAllowed)
//        characterSet.addCharacters(in: soapMessage)
//        
//        characterSet = characterSet
//            .stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        // exclude alpha and numeric == "full" encoding
//        soapLenth = soapLenth.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!;
//        
//        // exclude hostname and symbols &,/ and etc
//        soapLenth = soapLenth.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!;
//        soapLenth = soapLenth.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        
        
        let theUrlString = "http://websrv.zederp.net/Apml/StatusService.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
//        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
//        mutableR.httpMethod = "POST"
//        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)

        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "ISO-8859-1")
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.addValue(String(soapLenth.count), forHTTPHeaderField: "Content-Length")
       
        mutableR.httpMethod = "POST"
         mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateStatusResult")   ?? NSDictionary()
                
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
                        if self.type == "Group"
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroup"), object: nil)
                        }
                        else if self.type == "Public"
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object: nil)
                        }
                        
                        self.txtdesc.text = "Write your post here"
                        self.txtdesc.textColor = UIColor.lightGray
                        
                        self.imgv.image = nil
                        self.lblvideo.text = ""
                        
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                        //obj.showAlert(title: "Alert!", message: "Post uploaded successfully.", viewController: self)
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
    
    //Marks Add video post to server
    func addvideopost() {
        //let type = "Public"
        
        var descstr = txtdesc.text!
        if descstr == "Write your post here" {
            descstr = ""
        }
    
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String {
            userid = tempid
        }
        else {
            userid = ""
        }
        
        let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
        print(timespam)
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateVideoStatus xmlns='http://threepin.org/'><videoName>\(String(timespam)+".mp4")</videoName><videoFile>\(videodata)</videoFile><thumbName>\(String(timespam)+".jpg")</thumbName><thumbFile>\(videoimgDocumentdata)</thumbFile><user_id>\(userid)</user_id><status>\(descstr)</status><tag>1</tag></UpdateVideoStatus></soap:Body></soap:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Uploader.asmx"
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

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateVideoStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateVideoStatusResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Failed to po.", viewController: self)
                    }
                    else
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object: nil)
                        if self.edit == "1"
                        {
                            // obj.showAlert(title: "Alert!", message: "Post edit successfully.", viewController: self)
                        }
                        else
                        {
                            // obj.showAlert(title: "Alert!", message: "New Post add successfully.", viewController: self)
                        }
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
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
    
    //Edit News Video Post
    func editpublicvideo()
    {
        //let type = "Public"
        
        var descstr = txtdesc.text!
        if descstr == "Write your post here"
        {
            descstr = ""
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
        
        let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
        print(timespam)
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><EditNewsVideoStatus xmlns='http://threepin.org/'><videoName>\(String(timespam)+".mp4")</videoName><videoFile>\(videodata)</videoFile><thumbName>\(String(timespam)+".jpg")</thumbName><thumbFile>\(videoimgDocumentdata)</thumbFile><userId>\(userid)</userId><statusId>\(statusid)</statusId><status>\(descstr)</status><tag>1</tag><subType>News</subType></EditNewsVideoStatus></soap:Body></soap:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Uploader.asmx"
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

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateVideoStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateVideoStatusResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Failed to po.", viewController: self)
                    }
                    else
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: ["searchtext":NEWsChannelSEARCHTags])
                        if self.edit == "1"
                        {
                            //  obj.showAlert(title: "Alert!", message: "Post edit successfully.", viewController: self)
                        }
                        else
                        {
                            // obj.showAlert(title: "Alert!", message: "New Post add successfully.", viewController: self)
                        }
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
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
    
    
    ////////////////////////////////////////////////////////////////
    //Marks : - News Post
    func addnewspost() {
        var soapMessage = String()
        
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String {
            userid = tempid
        }
        else {
            userid = ""
        }
        
        let descstr = "\"\(txtdesc.text!)\""
        
        // Setup Custom Emoji
        
        //let strData = descstr.data(using: String.Encoding.utf8)
        
            //    descstr  = descstr.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        
//        let s = String.Encoding.ascii
//        
//        descstr = descstr.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!          
        let f = String(describing: descstr.cString(using: String.Encoding.utf8))
//        let v = descstr.cString(using: String.Encoding.utf8)
        
      
      //  let encodedName = descstr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
      //  descstr.addingPercentEncoding(withAllowedCharacters: <#T##CharacterSet#>)
      //  let encodedName = f.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
      //                     let datastr =
        if (txtdesc.text != "Write your post here" && imgv.image != nil) {
            let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
            //print(timespam)
            
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
            
            //Marks: - image and text both post
            soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetSpecificTypeStatuses xmlns='http://threepin.org/'><filename>\(String(timespam)+".jpg")</filename><user_id>\(userid)</user_id><type>\(type)</type><status>\(descstr)</status><img>\(imageStr)</img><isNew>1</isNew><tag></tag></GetSpecificTypeStatuses></soap:Body></soap:Envelope>"
        }
        else if imgv.image != nil
        {
            let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
            //print(timespam)
            
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
            
            //Marks: - simple image post
            soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetSpecificTypeStatuses xmlns='http://threepin.org/'><filename>\(String(timespam)+".jpg")</filename><user_id>\(userid)</user_id><type>\(type)</type><status></status><img>\(imageStr)</img><isNew>1</isNew><tag></tag></GetSpecificTypeStatuses></soap:Body></soap:Envelope>"
        }
        else
        {
            //Marks: - simple text post
            soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateStatus xmlns='http://threepin.org/'><filename>\("")</filename><user_id>\(userid)</user_id><type>\(type)</type><status>\(f)</status><img>\("")</img><isNew>1</isNew><tag>1</tag></UpdateStatus></soap:Body></soap:Envelope>"
        }
        

        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/StatusService.asmx"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        
        // MUTABLE REQUEST
      //  mutableR.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        mutableR.httpMethod = "POST"
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Accept")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Accept")
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("application/json", forHTTPHeaderField: "Accept")
       
        
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: true)
         mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        
        let session = URLSession.shared
        
        andicator.startAnimating()
        
        let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
            self.andicator.stopAnimating()
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateStatusResult")   ?? NSDictionary()
                
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: ["searchtext":NEWsChannelSEARCHTags])
                        self.txtdesc.text = "Write your post here"
                        self.txtdesc.textColor = UIColor.lightGray
                        
                        self.imgv.image = nil
                        self.lblvideo.text = ""
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                        // obj.showAlert(title: "Alert!", message: "Post uploaded successfully.", viewController: self)
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
    

    //Marks Add video post to server
    func addvideogrouppost() {
        //let type = "Public"
        var descstr = txtdesc.text!
        if descstr == "Write your post here"
        {
            descstr = ""
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
        
        let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
//        print(timespam)
//    
//        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateGroupVideoStatus xmlns='http://threepin.org/'><videoName>\(String(timespam)+".mp4")</videoName><videoFile>\(videodata)</videoFile><thumbName>\(String(timespam)+".jpg")</thumbName><thumbFile>\(videoimgDocumentdata)</thumbFile><status>\(descstr)</status><userId>\(userid)</userId><groupId>\(groupid)</groupId></UpdateGroupVideoStatus></soap:Body></soap:Envelope>"
//        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateGroupVideoStatus xmlns='http://threepin.org/'><videoName>\(String(timespam)+".mp4")</videoName><videoFile>\(videodata)</videoFile><thumbName>\(String(timespam)+".jpg")</thumbName><thumbFile>\(videoimgDocumentdata)</thumbFile><status>\(descstr)</status><userId>\(userid)</userId><groupId>\(groupid)</groupId></UpdateGroupVideoStatus></soap:Body></soap:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Uploader.asmx"
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

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateGroupVideoStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateGroupVideoStatusResult")   ?? NSDictionary()
                
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroup"), object: nil)
                        if self.edit == "1"
                        {
                            //obj.showAlert(title: "Alert!", message: "Post edit successfully.", viewController: self)
                        }
                        else
                        {
                            //obj.showAlert(title: "Alert!", message: "New Post add successfully.", viewController: self)
                        }
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
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


    
    //////////////////////////////////////////////////////////////
    // Marks: - Edit
    func editfunc()
    {
        var soapMessage = String()
        var userid = String()
        var descstr = txtdesc.text!
        if descstr == "Write your post here"
        {
            descstr = ""
        }
        if let tempid = defaults.value(forKey: "userid") as? String
        {
            userid = tempid
        }
        else
        {
            userid = ""
        }
        
        let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
        //print(timespam)
        
        var imageStr = String()
        var imagename = String()
        if imgv.image != nil
        {
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
            imagename = String(timespam)+".jpg"
        }
        else
        {
            imageStr = ""
            imagename = ""
        }
        
        soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateEditedStatus xmlns='http://threepin.org/'><filename>\(imagename)</filename><user_id>\(userid)</user_id><type>\(type)</type><status_id>\(statusid)</status_id><status>\(descstr)</status><img>\(imageStr)</img><isNew>1</isNew></UpdateEditedStatus></soap:Body></soap:Envelope>"
        
        
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
//            if self.view.isHidden == false{
            DispatchQueue.main.async{
                self.andicator.stopAnimating()
            }
//            }
            
            var dictionaryData = NSDictionary()
            
            do
            {
                //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary

                if self.type == "Public"
                {
                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateEditedStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateEditedStatusResult")   ?? NSDictionary()
                    
                    if (mainDict as AnyObject).count > 0{
                        
                        let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                        
                        let text = mainD.value(forKey: "text") as! NSString
                        // text = text.replacingOccurrences(of: "[", with: "") as NSString
                        // text = text.replacingOccurrences(of: "]", with: "") as NSString
                        
                        if text == "0"
                        {
                            obj.showAlert(title: "Alert!", message: "Failed to Edit Post", viewController: self)
                        }
                        else
                        {
                            if self.type == "Public"
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object: nil)
                            }
                            else if self.type == "Group"
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroup"), object: nil)
                            }
                            DispatchQueue.main.async {
                                self.txtdesc.text = "Write your post here"
                                self.txtdesc.textColor = UIColor.lightGray
                                
                                self.imgv.image = nil
                                self.lblvideo.text = ""
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        
                    }
                    else{
                        
                        obj.showAlert(title: "Alert", message: "try again", viewController: self)
                    }
                }
                else
                {
                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateEditedStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateEditedStatusResult")   ?? NSDictionary()
                    
                    if (mainDict as AnyObject).count > 0{
                        
                        let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                        
                        let text = mainD.value(forKey: "text") as! NSString
                        // text = text.replacingOccurrences(of: "[", with: "") as NSString
                        // text = text.replacingOccurrences(of: "]", with: "") as NSString
                        
                        if text == "0"
                        {
                            obj.showAlert(title: "Alert!", message: "Failed to Edit Post", viewController: self)
                        }
                        else
                        {
                            if self.type == "Public"
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object: nil)
                            }
                            else if self.type == "Group"
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroup"), object: nil)
                            }
                            else if self.type == "News"
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: ["searchtext":NEWsChannelSEARCHTags])
                            }
                            
                            self.txtdesc.text = "Write your post here"
                            self.txtdesc.textColor = UIColor.lightGray
                            
                            self.imgv.image = nil
                            self.lblvideo.text = ""
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                            //obj.showAlert(title: "Alert!", message: "Post edit successfully.", viewController: self)
                        }
                        
                    }
                    else{
                        
                        obj.showAlert(title: "Alert", message: "try again", viewController: self)
                    }
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

    
    //Edit News Video Post
    func editnewsvideo()
    {
        //let type = "Public"
        
        var descstr = txtdesc.text!
        if descstr == "Write your post here"
        {
            descstr = ""
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
        
        let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
        print(timespam)
        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><EditNewsVideoStatus xmlns='http://threepin.org/'><videoName>\(String(timespam)+".mp4")</videoName><videoFile>\(videodata)</videoFile><thumbName>\(String(timespam)+".jpg")</thumbName><thumbFile>\(videoimgDocumentdata)</thumbFile><userId>\(userid)</userId><statusId>\(statusid)</statusId><status>\(descstr)</status><tag>News</tag><subType>News</subType></EditNewsVideoStatus></soap:Body></soap:Envelope>"
        
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Uploader.asmx"
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

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateVideoStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateVideoStatusResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Failed to po.", viewController: self)
                    }
                    else
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: ["searchtext":NEWsChannelSEARCHTags])
                        if self.edit == "1"
                        {
                            //obj.showAlert(title: "Alert!", message: "Post edit successfully.", viewController: self)
                        }
                        else
                        {
                            //obj.showAlert(title: "Alert!", message: "New Post add successfully.", viewController: self)
                        }
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
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
///////////////////////////////////////// MARK : - Add Post in Group
    //Marks Add post to server
    func addgrouppost()
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
        
        
        var desstr = txtdesc.text!
//            desstr = "\u{1F496}" // 💖, Unicode scalar U+1F496
       
            desstr = desstr.encodeEmoji
        
        
        if (txtdesc.text != "Write your post here" && imgv.image != nil)
        {
            let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
            //print(timespam)
            
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
            
            //Marks: - image and text both post
            soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateStatus xmlns='http://threepin.org/'><filename>\(String(timespam)+".jpg")</filename><user_id>\(userid)</user_id><type>\(type)</type><status>\(desstr)</status><img>\(imageStr)</img><isNew>1</isNew><tag></tag></UpdateStatus></soap:Body></soap:Envelope>"
        }
        else if imgv.image != nil
        {
            let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
            //print(timespam)
            
            let imageData: NSData = imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
            let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
            
            //Marks: - simple image post
            soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateGroupStatus xmlns='http://threepin.org/'><filename>\(String(timespam)+".jpg")</filename><user_id>\(userid)</user_id><status></status><type>\(type)</type><groupId>\(groupid)</groupId><img>\(imageStr)</img><isNew>1</isNew><tag>s</tag></UpdateGroupStatus></soap:Body></soap:Envelope>"
        }
        else
        {
            //Marks: - simple text post
            soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateGroupStatus xmlns='http://threepin.org/'><filename></filename><user_id>\(userid)</user_id><status>\(desstr)</status><type>\(type)</type><groupId>\(groupid)</groupId><img></img><isNew>1</isNew><tag>s</tag></UpdateGroupStatus></soap:Body></soap:Envelope>"
            
            
        }
        
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroup"), object: nil)
                        DispatchQueue.main.async {
                            self.txtdesc.text = "Write your post here"
                            self.txtdesc.textColor = UIColor.lightGray
                            self.imgv.image = nil
                            self.lblvideo.text = ""
                            self.navigationController?.popViewController(animated: true)
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
    

    //Marks Add video post to server
    func addvideonewspost()
    {
        //let type = "Public"
        //let type = "Public"
        let subtype = "News"
        
        var descstr = txtdesc.text!
        if descstr == "Write your post here"
        {
            descstr = ""
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
        
        let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
        //print(timespam)
        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateNewsVideoStatus xmlns='http://threepin.org/'><videoName>\(String(timespam)+".mp4")</videoName><videoFile>\(videodata)</videoFile><thumbName>\(String(timespam)+".jpg")</thumbName><thumbFile>\(videoimgDocumentdata)</thumbFile><user_id>\(userid)</user_id><status>\(descstr)</status><tag>1</tag><type>\(type)</type><subType>\(subtype)</subType></UpdateNewsVideoStatus></soap:Body></soap:Envelope>"

        
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Uploader.asmx"
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

                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateNewsVideoStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateNewsVideoStatusResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Failed to upload video in news try again.", viewController: self)
                    }
                    else
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: ["searchtext":NEWsChannelSEARCHTags])
                        if self.edit == "1"
                        {
                            //obj.showAlert(title: "Alert!", message: "Post edit successfully.", viewController: self)
                        }
                        else
                        {
                            //obj.showAlert(title: "Alert!", message: "New Post add successfully.", viewController: self)
                        }
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
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
    
    //Edit Group Video Post
    func editgroupvideo()
    {
        
        var descstr = txtdesc.text!
        if descstr == "Write your post here"
        {
            descstr = ""
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
        
        let timespam = Int64(NSDate().timeIntervalSince1970 * 1000)
        print(timespam)
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><EditVideoStatus xmlns='http://threepin.org/'><videoName>\(String(timespam)+".mp4")</videoName><videoFile>\(videodata)</videoFile><thumbName>\(String(timespam)+".jpg")</thumbName><thumbFile>\(videoimgDocumentdata)</thumbFile><userId>\(userid)</userId><statusId>\(statusid)</statusId><status>\(descstr)</status><tag>\(type)</tag><subType>\(type)</subType></EditVideoStatus></soap:Body></soap:Envelope>"
        
        
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/Uploader.asmx"
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
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "UpdateVideoStatusResponse")! as Any) as AnyObject).object(forKey:"UpdateVideoStatusResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    // text = text.replacingOccurrences(of: "[", with: "") as NSString
                    // text = text.replacingOccurrences(of: "]", with: "") as NSString
                    
                    if text == "0"
                    {
                        obj.showAlert(title: "Alert!", message: "Failed to po.", viewController: self)
                    }
                    else
                    {
                        
                        if self.edit == "1"
                        {
                            if self.type == "Group"
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroup"), object: nil)
                            }
                            else if self.type == "News"
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: ["searchtext":NEWsChannelSEARCHTags])
                            }
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                            //obj.showAlert(title: "Alert!", message: "Post edit successfully.", viewController: self)
                        }
                        else
                        {
                            obj.showAlert(title: "Alert!", message: "New Post add successfully.", viewController: self)
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
    
    func funAddPost(postType: Int, imagename: String, videoname: String) {
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String {
            userid = tempid
        }
        else {
            userid = ""
        }
        var descstr = txtdesc.text!
        if descstr == "Write your post here" {
            descstr = ""
        }
        var subType = ""
        var url = ""
        if postType == VIDEO {
            url = BASEURL+"\(posttype)/video"
            subType = "video"
        }
        else if postType == IMAGE {
            url = BASEURL+"\(posttype)?"
            subType = "image"
        }
        else if postType == DOCUMENT{
            url = BASEURL+"\(posttype)"
            subType = "document"
        }
        else if postType == TEXT{
            url = BASEURL+"\(posttype)?"
            subType = "Public"
        }
        let parameters : Parameters =
            ["userId": userid,
             "status":descstr,
             "type":type,
             "subType":subType,
             "tag":"",
             "hashtag":"",
             "filename": imagename,
             "videoFilename":videoname,
             "ChannelId": statusid,
             "groupId": statusid]
        print(parameters)
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil {
                if (responseObject!.value(forKey: "data") as? Any) != nil {
                    if self.type == "News" {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: ["searchtext":NEWsChannelSEARCHTags])
                    }
                    else if self.type == "Public" {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object: nil)
                    }
                    else if self.type == "Group" {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroup"), object: nil)
                    }
                    self.txtdesc.text = "Write your post here"
                    self.txtdesc.textColor = UIColor.lightGray
                    
                    self.imgv.image = nil
                    self.lblvideo.text = ""
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
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
    
    func funUpDatePost(postType: Int, imagename: String, videoname: String) {
        var userid = String()
        if let tempid = defaults.value(forKey: "userid") as? String {
            userid = tempid
        }
        else {
            return
        }
        var subType = ""
        if postType == VIDEO {
            url = BASEURL+"\(posttype)/video"
            subType = "video"
        }
        else if postType == IMAGE {
            url = BASEURL+"\(posttype)?"
            subType = "image"
        }
        else if postType == DOCUMENT{
            url = BASEURL+"\(posttype)"
            subType = "document"
        }
        else if postType == TEXT{
            url = BASEURL+"\(posttype)?"
            subType = "Public"
        }
        
        var descstr = txtdesc.text!
        if descstr == "Write your post here" {
            descstr = ""
        }
        postTypeNewsORTimeLine = "news"
        let url = BASEURL+"\(postTypeNewsORTimeLine)/\(statusid)"
        var tempChannelId = statusid
        
        if type == "Public"{
            tempChannelId = ""
        }
       
        let parameters : Parameters =
        ["userId": userid,
         "status":descstr,
         "type":type,
         "subType":subType,
         "tag":"",
         "hashtag":"",
         "filename": imagename,
         "videoFilename":videoname,
         "ChannelId": tempChannelId,
         "groupId": statusid,
         "body":""]
        
        print(parameters)
        
        andicator.startAnimating()
        obj.webServicePutUpdateUser(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
              if error == nil && responseObject != nil {
                if (responseObject!.value(forKey: "data") as? Int) != nil {
                    if self.type == "News" {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newspost"), object: ["searchtext":NEWsChannelSEARCHTags])
                    }
                    else if self.type == "Public" {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object: nil)
                    }
                    else if self.type == "Group" {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updategroup"), object: nil)
                    }
                    self.txtdesc.text = "Write your post here"
                    self.txtdesc.textColor = UIColor.lightGray
                    
                    self.imgv.image = nil
                    self.lblvideo.text = ""
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
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
    //MARK: - Emoji's Keyboard Delegate
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        txtdesc.insertText(emoji)
    }
    
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        txtdesc.deleteBackward()
    }
    
    
    //MARK:- Upload image or file to Firebase Storage
    func uploadMedia(type: String, object: NSData, completion: @escaping (_ url: String?) -> Void) {
        
        let uploadData = object
        var imgdata = Data()
        var videodatatemp = Data()
        var videofilename = String()
        let timespam = Date().currentTimeMillis()!
        var url = ""
        var filename = ""
        var parameters : Parameters = ["":""]
        if type == "IMAGE" {
            imgdata = uploadData as Data
            filename = "\("\(String(describing: timespam))").png"
            parameters = ["filename":filename]
            url = BASEURL + "Upload/Post?filename=\(filename)"
        }
        else if type == "VIDEO" {
            videodatatemp = videodata as Data
            imgdata = uploadData as Data
            filename = "\("\(String(describing: timespam))").png"
            videofilename = "\("\(String(describing: timespam))")video.mp4"
            url = BASEURL + "Upload/PostVideo?videofilename=\(videofilename)&filename=\(filename)"
            parameters = ["filename":filename, "videofilename": videofilename]
        }
        else if type == "DOCUMENT" {
            imgdata = uploadData as Data
            let tempfilename = (selectedFilePath?.lastPathComponent.split(separator: "."))! as NSArray
            
            filename = "\(tempfilename[0])\("\(String(describing: timespam))").\(selectedFilePath?.pathExtension ?? "")"
            parameters = ["filename":filename]
            url = BASEURL + "upload/file?filename=\(filename)"
        }
        
        andicator.startAnimating()
        obj.webServiceWithPictureAudio(url: url, parameters: parameters, imagefilename: filename, audiofilename:"" , videofilename: videofilename, imageData: imgdata, audioData: Data(), videoData: videodatatemp, viewController: self, completionHandler:{
            
            responseObject, error in
            
            self.andicator.stopAnimating()
            if error == nil || error == "success" {
                if type == "VIDEO" {
                    let tmepname = "\(filename),\(videofilename)"
                    completion(tmepname)
                }
                else{
                    completion(filename)
                }
            }
            else {
                completion("error")
            }
        })
    }
}
extension String {
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

