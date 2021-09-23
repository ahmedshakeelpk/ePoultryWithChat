//
//  AddNewChannel.swift
//  ePoltry
//
//  Created by Apple on 04/11/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import Alamofire
class AddNewChannel: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var isEdit = false
    var channelimage = UIImage()
    var channeltitle = String()
    var channeldesc = String()
    var channelid = String()
    
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var btnadd: UIButton!
    @IBAction func btnadd(_ sender: UIButton) {
        lblhashtag.numberOfLines = 4
        lblhashtag.lineBreakMode = .byWordWrapping
        if txttag.text == ""{
            return
        }
        lblhashtag.frame.origin.x = txttitle.frame.minX
        lblhashtag.frame.size.width = txttitle.frame.maxX
        if lblhashtag.text == ""{
            lblhashtag.text = txttag.text
        }
        else{
            lblhashtag.text = lblhashtag.text! + ", " + txttag.text!
        }
        txttag.text = ""
        lblhashtag.sizeToFit()
        lblhashtag.frame.size.width = txttitle.frame.maxX
        txtvdesc.frame.origin.y = lblhashtag.frame.maxY + 8
        btnrequest.frame.origin.y = txtvdesc.frame.maxY + 20
    }
    @IBOutlet weak var btnrequest: UIButton!
    @IBAction func btnrequest(_ sender: Any) {
        if imgv.image!.isEqualToImage(image: UIImage(named: "groupimg")!) {
            obj.showAlert(title: "Alert!", message: "Please select image for channel", viewController: self)
        }
        else if txttitle.text == ""{
            obj.showAlert(title: "Alert!", message: "Please enter title", viewController: self)
        }
        else if txtvdesc.text == "Channel Description"{
            obj.showAlert(title: "Alert!", message: "Please type description for channel", viewController: self)
        }
        else{
            self.view.endEditing(true)
            DispatchQueue.main.async {
                let imageData: NSData = self.imgv.image!.jpegData(compressionQuality: 0.4)! as NSData
                self.uploadMedia(type: "IMAGE", object: imageData, completion: { filename in
                    guard let filename = filename else { return }
                    print(filename)
                    if self.isEdit {
                        self.updateChannel(imagename: filename)
                    }
                    else {
                        self.addNewChannel(imagename: filename)
                    }
                })
            }
        }
    }
    
    @IBOutlet weak var txttitle: UITextField!
    @IBOutlet weak var txtvdesc: UITextView!
    
    @IBOutlet weak var txttag: UITextField!
    
    @IBOutlet weak var btnaddphoto: UIButton!
    @IBAction func btnaddphoto(_ sender: Any) {
        showActionSheet(sender: sender)
    }
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblhashtag: UILabel!
    
    @IBOutlet weak var bgvplus: UIView!
    @IBOutlet weak var imgvplus: UIImageView!
    
    @IBOutlet weak var bgvcross: UIView!
    @IBOutlet weak var btncross: UIButton!
    @IBAction func btncross(_ sender: Any) {
        lblhashtag.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtvdesc.frame = CGRect(x: txttitle.frame.origin.x, y: lblhashtag.frame.origin.y , width: self.txttitle.frame.size.width, height: 131)
        if isEdit {
            self.title = "Update Channel"
        }
        else{
            self.title = "Add New Channel"
        }
        
        // Do any additional setup after loading the view.
        obj.setimageCircle(image: imgv, viewcontroller: self)
        obj.setviewCircle(view: bgvplus, viewcontroller: self)
        obj.setImageHeighWidth4Pad(image: imgv, viewcontroller: self)
        obj.setImageHeighWidth4Pad(image: imgvplus, viewcontroller: self)
        
        obj.txtbottomline(textfield: txttitle)
        obj.txtbottomline(textfield: txttag)
        
        txtvdesc.layer.cornerRadius = 3
        btnadd.layer.cornerRadius = 3
        btnrequest.layer.cornerRadius = 3
        txtvdesc.layer.borderColor = UIColor.lightGray.cgColor
        txtvdesc.layer.borderWidth = 0.3
        
        txtvdesc.frame.origin.y = lblhashtag.frame.minY
        btnrequest.frame.origin.y = txtvdesc.frame.maxY + 20
        
        // Back Button with image
        let backBtn = UIBarButtonItem(image: UIImage.init(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funback))
        self.navigationItem.leftBarButtonItem = backBtn
        
        bgvcross.layer.borderColor = UIColor.lightGray.cgColor
        bgvcross.layer.borderWidth = 0.3
        DispatchQueue.main.async {
            obj.setViewHeighWidth4Pad(view: self.bgvcross, viewcontroller: self)
            self.bgvcross.layer.cornerRadius = self.bgvcross.frame.size.height / 2
        }
        if isEdit == true {
            imgv.image = channelimage
            txttitle.text = channeltitle
            txtvdesc.text = channeldesc
            btnrequest.setTitle("Update", for: .normal)
            txtvdesc.textColor = UIColor.black
            
            lblhashtag.numberOfLines = 4
            lblhashtag.lineBreakMode = .byWordWrapping
            lblhashtag.frame.origin.x = txttitle.frame.minX
            lblhashtag.frame.size.width = txttitle.frame.maxX
            lblhashtag.text = NEWsChannelTags
            txttag.text = ""
            lblhashtag.sizeToFit()
            lblhashtag.frame.size.width = txttitle.frame.maxX
            txtvdesc.frame.origin.y = lblhashtag.frame.maxY + 8
            btnrequest.frame.origin.y = txtvdesc.frame.maxY + 20
            
            // Back Button with image
            let backBtn = UIBarButtonItem(image: UIImage.init(named: "delete"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funDeleteAlert))
            self.navigationItem.rightBarButtonItem = backBtn
        }
    }
    
    @objc func funback()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func funDeleteAlert(){
        let alert = UIAlertController(title: "Confirmation!", message: "Are you sure do you want to delete this channel?", preferredStyle: .alert)
        let DELETE = UIAlertAction(title: "DELETE", style: .default)
        { (action) in
            self.funDeleteChannel()
        }
        let CANCEL = UIAlertAction(title: "CANCEL", style: .default)
        { (action) in

        }
        alert.addAction(CANCEL)
        alert.addAction(DELETE)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // Marks: - Return button delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.txtvdesc.inputView = nil
        return true
    }
    
    //Marks: - Textview delegates
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.view.frame.origin.y = -65
        
        if txtvdesc.text == "Channel Description"
        {
            txtvdesc.text = ""
            txtvdesc.textColor = UIColor.black
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.frame.origin.y = 64
        if txtvdesc.text == ""
        {
            txtvdesc.text = "Channel Description"
            txtvdesc.textColor = UIColor.lightGray
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
    var imagePicker: UIImagePickerController!
    func showActionSheet(sender: Any)
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.OpenCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.OpenGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
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
    }
    
    func OpenCamera()
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func OpenGallary()
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    /// what app will do when user choose & complete the selection image :
    //image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgv.image = pickedImage
            //self.andicator.startAnimating()
        }
        else
        {
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //MARK:- Upload image or file to Firebase Storage
    func uploadMedia(type: String, object: NSData, completion: @escaping (_ url: String?) -> Void) {
        
        let uploadData = object
        var imgdata = Data()
        var videodatatemp = Data()
        var videofilename = String()
        let timespam = Date().currentTimeMillis()!
        var url = ""
        var imagefilename = ""
        var parameters : Parameters = ["":""]
        if type == "IMAGE" {
            imgdata = uploadData as Data
            imagefilename = "\("\(String(describing: timespam))").png"
            parameters = ["filename":imagefilename]
            url = BASEURL + "Upload/Post?filename=\(imagefilename)"
            uploadMediaProfilePicture(type: "IMAGE", object: imgdata as NSData, completion: { filename in
                guard let filename = filename else {
                    completion("error")
                    return}
                // print(filename)
                completion(filename)
            })
        }
        else if type == "VIDEO" {
            videodatatemp = imgdata as Data
            imgdata = uploadData as Data
            imagefilename = "\("\(String(describing: timespam))").png"
            videofilename = "\("\(String(describing: timespam))")video.mp4"
            url = BASEURL + "Upload/PostVideo?videofilename=\(videofilename)&filename=\(imagefilename)"
            parameters = ["filename":imagefilename, "videofilename": videofilename]
            
            obj.webServiceWithPictureAudio(url: url, parameters: parameters, imagefilename: imagefilename, audiofilename:"" , videofilename: videofilename, imageData: imgdata, audioData: Data(), videoData: videodatatemp, viewController: self, completionHandler:{
                
                responseObject, error in
                self.andicator.stopAnimating()
                if error == nil {
                    if type == "VIDEO" {
                        let tmepname = "\(imagefilename),\(videofilename)"
                        completion(tmepname)
                    }
                    else {
                        completion(imagefilename)
                    }
                }
                else
                {
                    completion("error")
                }
            })
        }
        
        andicator.startAnimating()
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
    func addNewChannel(imagename: String){
        
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL + "channel"
        let parameters : Parameters =
            ["UserId": userid,
             "Title":txttitle.text!,
             "Description":txtvdesc.text!,
             "Type":"ChannelRequest",
             "Tags":lblhashtag.text!,
             "IsActive":true,
             "Thumbnail":imagename,
             "CreatedBy":userid,
             "RequestStatus":"0",
             "Status":"Draft",
             "Link":""]
        
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil {
                if (responseObject!.value(forKey: "data") as? Int) != nil {
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetAllchannels"), object: nil)
                    let alert = UIAlertController(title: "Successfully", message: "New channel request send to admin successfully", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    { (action) in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
                        self.funback()
                    }
                    alert.addAction(ok)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true)
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
    
    func updateChannel(imagename: String){
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL + "channel/\(channelid)"
        let parameters : Parameters =
            ["UserId": userid,
             "Title":txttitle.text!,
             "Description":txtvdesc.text!,
             "Type":"ChannelRequest",
             "Tags":lblhashtag.text!,
             "IsActive":true,
             "Thumbnail":imagename,
             "CreatedBy":userid,
             "RequestStatus":"0",
             "Status":"Draft",
             "Link":""]
        andicator.startAnimating()
        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            
            if error == nil && responseObject != nil {
                if (responseObject!.value(forKey: "data") as? Int) != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetAllchannels"), object: nil)
                    let alert = UIAlertController(title: "Successfully", message: "Channel update successfully", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    { (action) in
                        
                        NEWsChannelName = self.txttitle.text!
                        NEWsChannelDescription = self.txtvdesc.text!
                        NEWsHeaderimage = self.imgv.image!
                        NEWsChannelTags = self.lblhashtag.text!
                        
                        DispatchQueue.main.async {
                            self.funback()
                        }
                    }
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true)
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
    
    func funDeleteChannel(){
        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL + "channel/\(NEWsChannelID)?userId=\(userid)"
        andicator.startAnimating()
        obj.webServiceDelete(url: url, completionHandler:
        {
            responseObject, error in
            self.andicator.stopAnimating()
            self.andicator.stopAnimating()
            DispatchQueue.main.async {
                if error == nil {
                    print(responseObject!)
                    let success = (responseObject!).value(forKey: "success") as! Bool
                    if success == true {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChannel"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetAllchannels"), object: nil)
                        let alert = UIAlertController(title: "Confirmation!", message: "Channel deleted successfully!", preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK", style: .default)
                        { (action) in
                            let viewControllers = self.navigationController?.viewControllers
                            for vv in viewControllers! {
                                if vv.isKind(of: CustomTabBarViewController.self){
                                    self.navigationController?.popToViewController(vv, animated: true)
                                }
                            }
                        }
                        alert.addAction(OK)
                        DispatchQueue.main.async {
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        })
    }
}

