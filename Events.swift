//
//  Events.swift
//  ePoltry
//
//  Created by MacBook Pro on 26/04/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import Alamofire

class Events: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrusername.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "EventsCell") as! EventsCell
        cell.lblname.text = arrName[indexPath.row] as? String ?? "NA"
        cell.lblmsg.numberOfLines = 0
        cell.lblmsg.lineBreakMode = .byWordWrapping
        cell.lblmsg.text = arrComment[indexPath.row] as? String
        cell.lblmsg.sizeToFit()
        //Kingfisher Image upload
        if let imgname = arrprofile_img[indexPath.row] as? String {
            let urlprofile = URL(string: imagepath+imgname)
            cell.imgv.kf.setImage(with: urlprofile!)
        }
        
        if let CreatedOn = arrCreationdate[indexPath.row] as? String {
            var strtime = CreatedOn.replacingOccurrences(of: "T", with: " ")
            let dfmatter = DateFormatter()
            dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dfmatter.locale = Locale(identifier: "en_US_POSIX")
            dfmatter.timeZone = TimeZone.autoupdatingCurrent //Current time zone
            
            strtime = strtime.components(separatedBy: ".")[0]
            print(strtime)
            
            let agotime = obj.timeAgoSinceDate(dfmatter.date(from: strtime)!)
            
            cell.lbldate.text = agotime
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    var isLiveLink = ""
    var isLiveTitle = ""
    
    var arrComment = [Any]()
    var arrCommentID = [Any]()
    var arrCreationdate = [Any]()
    var arrImagePath = [Any]()
    var arrName = [Any]()
    var arrStatusID = [Any]()
    var arrUpdatedBy = [Any]()
    var arrUpdationDate = [Any]()
    var arrisActive = [Any]()
    var arrisNews = [Any]()
    var arrprofile_img = [Any]()
    var arrusername = [Any]()
    
    var postid = String()
    
    @IBOutlet weak var webv: UIWebView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var bgmsg: UIView!
    @IBAction func txtmsg(_ sender: Any) {
    }
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var txtmsg: UITextField!
    @IBOutlet weak var btnsend: UIButton!
    @IBAction func btnsend(_ sender: Any) {
        sendComments()
    }
    
    @IBOutlet weak var lblcomment: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.txtmsg.layer.cornerRadius = self.txtmsg.frame.size.height / 2
            self.btnsend.layer.cornerRadius = self.btnsend.frame.size.height / 2
        }
    }
    override func viewDidLoad() {
        self.tablev.isHidden = true
        self.bgmsg.isHidden = true
        self.lblcomment.isHidden = true
        //self.tablev.tableHeaderView = webv

        self.title = "Live!"
        let leftbackbutton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        self.navigationItem.setLeftBarButtonItems([leftbackbutton], animated: true)
        //MARK:- Cell Register
        self.tablev.register(UINib(nibName: "EventsCell", bundle: nil), forCellReuseIdentifier: "EventsCell")
        // Do any additional setup after loading the view.
        GetEvents()
        txtmsg.delegate = self
        tablev.rowHeight = 128
        tablev.estimatedRowHeight = UITableView.automaticDimension
       
        self.txtmsg.layer.cornerRadius = self.txtmsg.frame.size.height / 2
        self.btnsend.layer.cornerRadius = self.btnsend.frame.size.height / 2
        self.webv.allowsInlineMediaPlayback = true
        
//        let url = NSURL(string: isLiveLink)!
//        let request = URLRequest(url: url as URL)
//        self.webv.loadRequest(request)
        
        load(url: isLiveLink)
        
        lblcomment.text = isLiveTitle
        super.viewDidLoad()
    }
    
    func load(url: String) {
        let html = "<video playsinline controls width=\"100%\" src=\"\(url)\"> </video>"
        self.webv.loadHTMLString(html, baseURL: nil)
    }
    
    @objc func funback(){
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func GetEvents() {
        //        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"/news/-1/channel?userid=\(USERID)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                let dataarr = ((datadic.value(forKey: "Data") as! NSArray)[0] as! NSDictionary)
                                //self.lblcomment.text = "\(dataarr.value(forKey: "Status") as! String)"
                                self.GetEventComments(statusid: "\(dataarr.value(forKey: "StatusID") as! Int)")
                                self.postid = "\(dataarr.value(forKey: "StatusID") as! Int)"
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
    
    func GetEventComments(statusid : String) {
        //        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"comments/\(statusid)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                let dataarr = (datadic.value(forKey: "data") as! NSArray)
                               
                                self.arrComment = (dataarr).value(forKey: "Comment") as! [Any]
                                self.arrCommentID = (dataarr).value(forKey: "CommentID") as! [Any]
                                
                                self.arrCreationdate = (dataarr).value(forKey: "Creationdate") as! [Any]
                                    
                                self.arrImagePath = (dataarr).value(forKey: "ImagePath") as! [Any]
                                
                                self.arrName = (dataarr).value(forKey: "Name") as! [Any]
                                
                                self.arrStatusID = (dataarr).value(forKey: "StatusID") as! [Any]
                                
                                self.arrUpdatedBy = (dataarr).value(forKey: "UpdatedBy") as! [Any]
                                
                                self.arrUpdationDate = (dataarr).value(forKey: "UpdationDate") as! [Any]
                                
                                self.arrisActive = (dataarr).value(forKey: "isActive") as! [Any]
                                
                                self.arrisNews = (dataarr).value(forKey: "isNews") as! [Any]
                                
                                self.arrprofile_img = (dataarr).value(forKey: "profile_img") as! [Any]
                                    
                                self.arrusername = (dataarr).value(forKey: "username") as! [Any]
                                
                                self.tablev.reloadData()
                                //self.GetLikeCounts(statusid: statusid, likes: "")
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
    
    func GetLikeCounts(statusid: String, likes: String) {
        //        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"Status/\(statusid)/likes=\(likes)"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler: {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                let dataarr = ((datadic.value(forKey: "Data") as! NSArray)[0] as! NSDictionary)
                                //self.lblcomment.text = "\(dataarr.value(forKey: "Status") as! String)"
                                self.GetEventComments(statusid: "\(dataarr.value(forKey: "StatusID") as! Int)")
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
    
    
    func sendComments() {
        //        let userid = defaults.value(forKey: "userid") as! String
        let url = BASEURL+"comment/\(postid)?comment=\(txtmsg.text!)&userId=\(defaults.value(forKey: "userid") as! String)"
        print(url)

        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        
        let parameters : Parameters =
            ["": ""]
        andicator.startAnimating()
        obj.webService(url: urlString!, parameters: parameters, completionHandler:{ responseObject, error in
            self.andicator.stopAnimating()
            if error == nil && responseObject != nil {
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil {
                        if responseObject!.count > 0 {
                            let datadic = (responseObject! as NSDictionary)
                            if datadic.count > 0 {
                                self.txtmsg.text = ""
                                self.GetEventComments(statusid : self.postid)
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
            }
        })
    }
    
    
//    func sendComments()
//    {
//        let url = DataContainer.baseUrl()+"comment/\(postid)?comment=\()&userId="
//
//        let number = ("\(code)\(txtphone.text!)")
//        let parameters : Parameters =
//            ["firstName":txtdisplayname.text!,
//             "LastName": fcmtoken,
//             "username": number,
//             "password": number,
//             "mobile": number,
//             "fcmId": fcmtoken,
//             "country": fcmtoken,
//             "source": "ios",
//             "city": "",
//             "company": "",
//             "compId": "",
//             "userCategory": "ios"]
//        andicator.startAnimating()
//        obj.webService(url: url, parameters: parameters, completionHandler:{ responseObject, error in
//            self.andicator.stopAnimating()
//
//            if error == nil && responseObject != nil
//            {
//                let dataarr = responseObject!.value(forKey: "data") as! NSArray
//                let datadic = dataarr[0] as! NSDictionary
//                if datadic.count > 0
//                {
//
//                }
//                else
//                {
//                    obj.showAlert(title: "Error!", message: "Error occured try again", viewController: self)
//                }
//            }
//            else
//            {
//                if error == nil
//                {
//                    obj.showAlert(title: "Error!", message: ("error?.description"), viewController: self)
//                    return
//                }
//                obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
//            }
//        })
//    }
    
    // Marks: - textfield Delegates Resign all fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Marks: - Uitextfields delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.view.endEditing(true)
        
        return true
    }
    
    //MARK:- Textfield Delegates
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        eview.dismiss()
        return true
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var keyboardtag = 0
    var tablevheight = CGFloat()
    var activeField: UITextField?

    @objc func keyboardWillShowNotification(notification: NSNotification){
        keyboardHeight = 0.0
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeightt = keyboardRectangle.height
            keyboardHeight = Float(keyboardHeightt + 115)
        }
        self.bgmsg.frame.origin.y = self.view.frame.maxY - CGFloat(keyboardHeight)
      
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        if IPAD{
            self.bgmsg.frame.origin.y = self.bgmsg.frame.origin.y + CGFloat(keyboardHeight - 60)
        }
        else{
            self.bgmsg.frame.origin.y = self.bgmsg.frame.origin.y + CGFloat(keyboardHeight - 115)
        }
        
    }
}
