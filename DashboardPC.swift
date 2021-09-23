//
//  DashboardPC.swift
//  ZedChat
//
//  Created by MacBook Pro on 13/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.


import UIKit
import XLPagerTabStrip
import DropDown
import Contacts
import ContactsUI
import Firebase
import FirebaseDatabase
import Alamofire
import CallKit
import PushKit


var DASHBOARDSCREEN = ""
//class PageController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
class DashboardPC: ButtonBarPagerTabStripViewController, CNContactPickerDelegate, CXProviderDelegate
{
    
    var viewno = 0
    let dropDown = DropDown()
    var dots = UIBarButtonItem()
    var cross = UIBarButtonItem()
    var search = UIBarButtonItem()
    var buttonedit = UIBarButtonItem()
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    var dataarray = ["Profile", "New Group", "Settings"]
    
    @IBOutlet weak var customcolv: ButtonBarView!
    
    ///////////////////////////////
    override func viewDidAppear(_ animated: Bool) {
        // self.view.frame.origin.y = 20
        // self.view.frame.size.height = self.view.frame.size.height - 20
        
        //MARK:- Hide Navigation Bar
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //self.btnlogin.bringSubviewToFront(self.view)
        DispatchQueue.main.async {
            obj.showNavBar(viewcontroller: self)
            obj.navBarColor(color: appclr)
            
//            let parametersdic = [
//                "id":callUser_Receiver_id,
//                "current_profile": defaults.value(forKey: "userimage") as! String,
//                "user_profile": callUser_image_Sender,
//                "phoneNumber": callUser_PhoneNumber_Receiver,
//                "current_username": defaults.value(forKey: "phoneno") as! String,
//                "current_fireBase_user_id": callUser_FBID,
//                "fireBaseUserId": callUser_FBID_Receiver,
//                "firebase_group_id": callGroup_Id
//                ] as [String : AnyObject]
//            let call = sinclientG?.call().callUser(withId: "70", headers: parametersdic)
        }
        
    }
    var arrImages:[Data] = []
    
    @IBOutlet weak var imgNotification: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        objG.statusbarcolor(viewcontroller: self)
        obj.showNavBar(viewcontroller: self)
        obj.hideNavBarBackButton(viewcontroller: self)
        obj.navBarColor(color: appclr)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        //MARK:- When new version approved this function will run once and comment : updateIOSVersion()
        // updateIOSVersion()
        /////////////////
        //        let tempobj = InstalledAppReader()
        //        tempobj.installedApp()
        //        let generatedURL = ["",""]
        //        // get the documents folder url
        //        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        //
        //        for index in 0..<generatedURL.count {
        //
        //            let fileDestinationUrl = documentDirectoryURL.appendingPathComponent(String(index)+".htm")
        //
        //        print(fileDestinationUrl)
        //        }
        //        let fm = FileManager.default
        //        let path = Bundle.main.resourcePath!
        //
        //        var strpath = "\(documentDirectoryURL)".replacingOccurrences(of: "file://", with: "")
        //        strpath = "/var/mobile/Containers/Data/Application/5D1E5CBF-2FFE-4D4E-8518-133EADF07CF4/library"
        //        do {
        //            ////////
        //            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        //            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        //            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        //            if let dirPath          = paths.first
        //            {
        //                ///////////
        //                strpath = "\(dirPath)".replacingOccurrences(of: "Documents", with: "Library/Caches/Snapshots")
        //                let items = try fm.contentsOfDirectory(atPath: strpath)
        //
        //                for item in items {
        //                    print("Found \(item)")
        //                }
        //                //////////
        //                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Image2.png")
        //             //   let image    = UIImage(contentsOfFile: imageURL.path)
        //                print(imageURL)
        //                // Do whatever you want with the image
        //            }
        //
        //            ///////////
        //            let items = try fm.contentsOfDirectory(atPath: strpath)
        //
        //            for item in items {
        //                print("Found \(item)")
        //            }
        //        } catch {
        //            // failed to read directory – bad permissions, perhaps?
        //            print(error.localizedDescription)
        //        }
        ////////////////////////////////////////////////
        //let phoneNumber = defaults.value(forKey: "phoneno") as! String
        
        // This test verification code is specified for the given test phone number in the developer console.
        //let testVerificationCode = "123456"
        
      //  Auth.auth().settings!.isAppVerificationDisabledForTesting = true
//        PhoneAuthProvider.provider().verifyPhoneNumber("+" + phoneNumber, uiDelegate:nil) {
//            verificationID, error in
//            if ((error) != nil) {
//                // Handles error
//
//                return
//            }
//            
//            let cred = PhoneAuthProvider.credential(PhoneAuthProvider.provider())
//            
//            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",
//                                                                     verificationCode: testVerificationCode)
//            
//            Auth.auth().signInAndRetrieveData(with: credential) { authData, error in
//                if ((error) != nil) {
//                    // Handles error
//
//                    return
//                }
//
//            };
//        };
        
        ////////////////////////////////////////////////
        UINavigationBar.appearance().barTintColor = appclr
        self.title = APPBUILDNAME
        tabBarScreen = "chat"
        group_defaults.setValue(USERUID, forKey: "uid")
        group_defaults.setValue(USERID, forKey: "userid")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOnButtons"), object: ["screen": "chat"])
        
        // Marks: - Right bar button
        buttonedit  = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funedit))
        
        self.navigationItem.leftBarButtonItem = buttonedit
        // bar seperator color
        settings.style.buttonBarBackgroundColor = appclr
        // change bar cell bg color
        settings.style.buttonBarItemBackgroundColor = appclr
        //MARK:- bottom line color
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        //MARK:- bottom line height
        settings.style.selectedBarHeight = 2.0
        
        //MARK:- Center spacing between items
        settings.style.buttonBarMinimumLineSpacing = 0
        
        //MARK: - Cell Height
        settings.style.buttonBarHeight = 50
        
        settings.style.buttonBarItemTitleColor = .red
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        settings.style.buttonBarItemLeftRightMargin = 8
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            //MARK:- unselected text color
            oldCell?.label.textColor = .white
            
            //MARK:- Selected text color
            newCell?.label.textColor = .white
        }
        
        super.viewDidLoad()
        
        //        Auth.auth().signInAnonymously { result, error in
        //            // User signed in
        //           // print(result)
        //        }
        
        // Search Button Dots Button with image
        dots = UIBarButtonItem(image: UIImage.init(named: "dots"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funDots))
        
        //MARK:- Add Single Button
        //self.navigationItem.rightBarButtonItem = dots
        
        let searchbtn = UIButton(type: .system)
        searchbtn.setImage(UIImage(named: "searchbar"), for: .normal)
        searchbtn.addTarget(self, action: #selector(self.funSearch), for: .touchUpInside)
        searchbtn.sizeToFit()
        search = UIBarButtonItem(customView: searchbtn)
        self.navigationItem.rightBarButtonItems = [dots, search]
        
        let crossbtn = UIButton(type: .system)
        crossbtn.setImage(UIImage(named: "crosssmall"), for: .normal)
        crossbtn.addTarget(self, action: #selector(funCross), for: .touchUpInside)
        crossbtn.sizeToFit()
        cross = UIBarButtonItem(customView: crossbtn)
        
        //        let search = UIBarButtonItem(image: UIImage.init(named: "searchbar"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(funSearch))
        
        
        
        //Move to specific view controller
        DispatchQueue.main.async {
            //self.moveToViewController(at: self.viewno, animated: true)
        }
        obj.hideBottomLineNavBar(viewcontroller: self)
        funcallAllServices()
        
        //MARK:- Notification when tap on some user
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(funChatScreen), name: NSNotification.Name(rawValue: "taponuser"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(funTapOnUserScreen), name: NSNotification.Name(rawValue: "taponuserscreen"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tapOnButtons), name: NSNotification.Name(rawValue: "tapOnButtons"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tapOnCallButtonCallScreen), name: NSNotification.Name(rawValue: "tapOnCallButtonCallScreen"), object: nil)
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(getOtherUserLastOnlineTime), name: NSNotification.Name(rawValue: "getOtherUserLastOnlineTime"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCallNotificaions), name: NSNotification.Name(rawValue: "receivecall"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCallNotificaions), name: NSNotification.Name(rawValue: "isBGCallReceive"), object: nil)
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleCallNotificaions), name: NSNotification.Name(rawValue: "isVideoCallReceive"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCallNotificaionsReceiveBackGroundcall), name: NSNotification.Name(rawValue: "receiveBackGroundcall"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(funeditWithNotification), name: NSNotification.Name(rawValue: "edittableview"), object: nil)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let currentdate = formatter.string(from: date)
        
        if let fromdate = defaults.value(forKey: "contactupload") as? String
        {
            let result = obj.isPassedMoreThan(days: 5, fromDate: formatter.date(from: fromdate )!, toDate: formatter.date(from: currentdate)!)
            if result == true
            {
                funUploadContactToServer()
            }
        }
        else
        {
            funUploadContactToServer()
        }
        //  funOpenSetPassword(viewController: self)
        //  funLockScreenCheck(viewController: self)
    }
    var tabBarScreen = ""
    @objc func funCross(){
        funWithSearch(screen: tabBarScreen)
    }
    
    @objc func funWithSearch(screen: String)
    {
        UIApplication.shared.keyWindow!.endEditing(true)
        navigationItem.titleView = nil
        self.title = APPBUILDNAME
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "btncancelSearch"), object: nil)
        self.navigationItem.rightBarButtonItems = [dots, search]
        if screen == "chat"{
            self.navigationItem.leftBarButtonItem = buttonedit
        }
    }
    @objc func funWithCancel()
    {
        self.navigationItem.rightBarButtonItems = [dots, cross]
    }
    
    @objc func funeditWithNotification()
    {
        // Marks: - Left bar button
        if buttonedit.title == "Edit"
        {
            buttonedit = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funedit))
        }
        else if buttonedit.title == "Done"
        {
            buttonedit = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funedit))
        }
        self.navigationItem.leftBarButtonItem = buttonedit
    }
    @objc func funedit()
    {
        // Marks: - Left bar button
        if buttonedit.title == "Edit"
        {
            buttonedit = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funedit))
        }
        else if buttonedit.title == "Done"
        {
            buttonedit = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funedit))
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funTableSelectUnselect"), object: nil)
        self.navigationItem.leftBarButtonItem = buttonedit
    }
    @objc func funeditWithDefaultsStatus()
    {
        // Marks: - Left bar button
        if buttonedit.title == "Edit"
        {
            buttonedit = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funedit))
        }
        else if buttonedit.title == "Done"
        {
            buttonedit = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(funedit))
        }
        self.navigationItem.leftBarButtonItem = buttonedit
    }
    @objc func handleCallNotificaions(notification: Notification)
    {
        isOutGoing = 0
        let application = UIApplication.shared
        if notification.name.rawValue == "isBGCallReceive" && application.applicationState == .background{
            sincall = (notification.object as! SINCall)
            if sincall?.details.isVideoOffered == true{
                //MARK:- If Video Call
                if let navController = self.navigationController, let viewController = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "VideoCall") as? VideoCall{
                    DispatchQueue.main.async {
                        self.navigationController?.navigationBar.isHidden = true
                        navController.pushViewController(viewController, animated: true)
                    }
                }
            }
            else{
                //MARK:- If Audio Call
                if let navController = self.navigationController, let viewController = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AudioCall") as? AudioCall{
                    DispatchQueue.main.async {
                        self.navigationController?.navigationBar.isHidden = true
                        navController.pushViewController(viewController, animated: true)
                    }
                }
            }
        }else{
            
        }
        if application.applicationState == .active{
            //MARK:- If Forground Call Screen                                                                                                       
            if let navController = self.navigationController, let viewController = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AnswerCall") as? AnswerCall{
                DispatchQueue.main.async {
                    self.navigationController?.navigationBar.isHidden = true
                    navController.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func providerDidReset(_ provider: CXProvider) {
        
    }
    @objc func handleCallNotificaionsReceiveBackGroundcall(notification: Notification)
    {
        DispatchQueue.main.async {
            // self.unwindForNewCall(UIStoryboardSegue.init(identifier: "unwindSegueIdentifier", source: NewCallViewController.init(), destination: self))
        }
        
        
        //        let config = CXProviderConfiguration(localizedName: "ZedChat")
        //        config.iconTemplateImageData = UIImage(named: "user")!.pngData()
        //        config.ringtoneSound = "incomming.mp3"
        //        if #available(iOS 11.0, *) {
        //            config.includesCallsInRecents = false
        //        } else {
        //            // Fallback on earlier versions
        //        };
        //        config.supportsVideo = true;
        //        let provider = CXProvider(configuration: config)
        //        provider.setDelegate(self, queue: nil)
        //        let update = CXCallUpdate()
        //        update.remoteHandle = CXHandle(type: .generic, value: "")
        //        update.hasVideo = true
        //        DispatchQueue.main.async {
        //            provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
        //        }
    }
    
    //    @IBAction private func unwindForNewCall(_ segue: UIStoryboardSegue) {
    //        guard
    //            let newCallController = segue.source as? NewCallViewController,
    //            let handle = newCallController.handle
    //            else {
    //                return
    //        }
    //
    //        let videoEnabled = newCallController.videoEnabled
    //        let incoming = true//newCallController.incoming
    //
    //        if incoming {
    //            let backgroundTaskIdentifier =
    //                UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
    //
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    //                //'/''///
    //                AppDelegate.shared.displayIncomingCall(
    //                    uuid: UUID(),
    //                    handle: handle,
    //                    hasVideo: videoEnabled
    //                ) { _ in
    //                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
    //                }
    //            }
    //        } else {
    //           // callManager.startCall(handle: handle, videoEnabled: videoEnabled)
    //        }
    //    }
    
    @objc func tapOnCallButtonCallScreen(notification: Notification){
        let vc = UIStoryboard.init(name: "Calling", bundle: nil).instantiateViewController(withIdentifier: "AnswerCall") as! AnswerCall
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func tapOnButtons(notification: Notification)
    {
        let datadic = notification.object as! NSDictionary
        let screen = datadic.value(forKey: "screen") as! String
        tabBarScreen = screen
        switch screen {
        case "chat":
            dataarray = ["Profile", "New Group", "Settings"]
            dropDown.direction = .bottom
            dropDown.width = 100
            // Marks: - Right bar button
            funeditWithDefaultsStatus()
        case "calls":
            dataarray = ["Clear Log", "Settings"]
            dropDown.direction = .bottom
            dropDown.width = 100
            self.navigationItem.leftBarButtonItem = nil
        case "contacts":
            // dataarray = ["Invite a friend", "Contacts", "Refresh", "Help", "Settings"]
            dataarray = ["Invite a friend", "Contacts", "Refresh",  "Settings"]
            dropDown.direction = .bottom
            dropDown.width = 130
            self.navigationItem.leftBarButtonItem = nil
        default:
            break
        }
        funWithSearch(screen: screen)
    }
    @objc func funback()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func funDots()
    {
        dropDown.dataSource = dataarray
        // The view to which the drop down will appear on
        self.dropDown.anchorView = self.dots
        dropDown.show()
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDown.hide()
            //MARK:-
            switch self.dataarray[index] {
            case "Profile":
                let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "Profile") as! Profile
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case "Settings":
                let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "Settings") as! Settings
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case "Refresh":
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contactrefresh"), object: nil)
                //                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                //                    print("Fire timer \(timer)")
                //                    //obj.showToast(message: "Contact Refresh.", viewcontroller: self)
                //                }
                break
            case "Invite a friend":
                let button = UIButton()
                button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                button.center = self.view.center
                self.funinvite(sender: button)
                break
            case "Contacts":
                let cnPicker = CNContactPickerViewController()
                cnPicker.delegate = self
                DispatchQueue.main.async {
                    self.present(cnPicker, animated: true, completion: nil)
                }
                break
            case "New Group":
                let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "CreateGroup") as! CreateGroup
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case "Clear Log":
                self.funClearLog()
                break
            default:
                print("no match")
                break
            }
        }
    }
    @objc func funSearch()
    {
        funWithCancel()
        self.navigationItem.leftBarButtonItem = nil
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: navigationController?.navigationBar.frame.size.width ?? 0.0, height: 21.0))
        
        navigationItem.titleView = textField
        textField.becomeFirstResponder()
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchshowhide"), object: ["textfield": textField])
    }
    
    @objc func funClearLog(){
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Contacts!", message: "Are you sure you want to Clear all logs?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        { (action) in
            //self.dissmiss()
        }
        let Share = UIAlertAction(title: "Clear", style: .default)
        { (action) in
            DispatchQueue.main.async{
                objCDB.deleteAllData(entityName: "CallRecords")
            }
        }
        alert.addAction(cancel)
        alert.addAction(Share)
        
        self.present(alert, animated: true)
    }
    @objc func funinvite(sender: UIButton)
    {
        // print(sender.tag)
        //Set the default sharing message.
        //Set the link to share.
        let objectsToShare = [SHAREMESSAGE ,SHARELINKANDROID, SHARELINKIOS]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            activityVC.popoverPresentationController?.sourceView = sender
            activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            activityVC.popoverPresentationController?.permittedArrowDirections = .any
        default:
            break
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    @objc func funChatScreen(notification: Notification)
    {
        let datadic = notification.object as! NSDictionary
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "Messagingg") as! Messagingg
            vc.fromuid = datadic.value(forKey: "fromuid") as! String
            vc.touid = datadic.value(forKey: "touid") as! String
            vc.username = datadic.value(forKey: "username") as! String
            vc.userprofilepic = datadic.value(forKey: "userprofilepic") as! String
            vc.groupId = datadic.value(forKey: "groupid") as! String
            vc.groupType = datadic.value(forKey: "grouptype") as! String
            vc.imagename = datadic.value(forKey: "imagename") as! String
            vc.otherUserPhone_Number = datadic.value(forKey: "otherUserPhone_Number") as! String
            if let temp = datadic.value(forKey: "unSeenCount") as? String{
                vc.unSeenCount = temp
            }
            else if (datadic.value(forKey: "unSeenCount") as? Int) != nil{
                vc.unSeenCount = "1"
            }
              
            if let temp = datadic.value(forKey: "useridserver") as? String
            {
                vc.useridserver = temp
            }
            else if let temp = datadic.value(forKey: "useridserver") as? Int
            {
                vc.useridserver = "\(temp)"
            }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func funTapOnUserScreen(notification: Notification)
    {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "Contacts") as! Contacts
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "Chats")
//        let child_2 = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "Calls")
//        let child_3 = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "Contacts")
          return [child_1]
        //return [child_1, child_2, child_3]
    }
    func funcallAllServices()
    {
        //  funRenovation()
        //  funMaintenance()
    }
    
    func updateIOSVersion()
    {
        IOSVersion.updateChildValues(["IOS_Version":1.0, "min_version": 24], withCompletionBlock: {
            error, snapshot in
            if error == nil
            {
                print(snapshot)
            }
            else{
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    //MARK:- Run Time Message Delivery Status
    @objc func getOtherUserLastOnlineTime(notification: Notification)
    {
        let datadic = notification.object as! NSDictionary
        let otheruserid = datadic.value(forKey: "otherUserId") as! String
        
        UserDB.child(otheruserid).queryOrdered(byChild: "onLineUpdatedAt")
            .observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount > 0
            {
                let datadic = snapshot.value as! NSDictionary
                let lasttime = datadic.value(forKey: "onLineUpdatedAt") as! Int
                obj.convertTimespamIntoFullDateTime(timestring: "\(lasttime)", completion:{ isOnline, timestring in
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "otherUserOnlineTime"), object: ["isOnline":isOnline, "time": timestring])
                })
            }
            else if snapshot.childrenCount == 0
            {
                
            }
        })
        
    }
    
    
    //Sample for Fetching the Fresh data from FIREBASE database
    @objc func readFromFB(userid: String) {
        UserDB.keepSynced(true)
        UserDB.child(userid).observe(.value, with: { snapshot in
            if snapshot.exists() {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveUserProfileData"), object: nil)
            }
        })
    }
    
    
    @objc func funUploadContactToServer()
    {
        let temparray = NSMutableArray()
        var jsondata = NSArray()
        //MARK:- Convert Contacts in Dictionary
        for (index, _) in arrGnumber.enumerated()
        {
            let temparr = ["name":arrGfullname[index], "number":arrGnumber[index], "userid": defaults.value(forKey: "userid") as! String]
            temparray.add(temparr)
        }
        
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: temparray, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            var jsonstring = ""
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                jsonstring = JSONString
            }
            
            
            let data = jsonstring.data(using: .utf8)!
            do {
                if let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSArray
                {
                    jsondata = dictionary
                }else {
                    print("ewtyewytyetwytewytewtewytew","bad json")
                }
            } catch let error as NSError {
                print("ewtyewytyetwytewytewtewytew",error)
            }
            
        } catch {
            print(error)
        }
        var request = URLRequest(url: URL(string: CONTACT_UPLOAD_API)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let values = jsondata
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values)
        
        Alamofire.request(request)
            .responseJSON { response in
                // do whatever you want here
                switch response.result {
                case .failure(let error):
                    print(error)
                    
                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                        print(responseString)
                    }
                case .success(let responseObject):
                    print(responseObject)
                    //MARK:- Save Updated Date in userdefaults
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    let result = formatter.string(from: date)
                    defaults.setValue(result, forKey: "contactupload")
                }
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////
    
    //NOTE:
    //MARK: - Above mention code is for 3rd party page controller and the below mention code is for default ios page controller
    
    
    //////////////////////////////////////////////////////////////////////////
    
    //    @IBOutlet weak var pageControl: UIPageControl!
    //    var pagecontaner : UIPageViewController!
    //    var arrvc = [UIViewController]()
    //    var currentIndex: Int?
    //    private var pendingIndex: Int?
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        pagecontrlfunc()
    //        // Marks: - Right bar button
    //        let logButton : UIBarButtonItem = UIBarButtonItem(title: "Live Posts", style: UIBarButtonItemStyle.plain, target: self, action: #selector(right))
    //
    //        self.navigationItem.rightBarButtonItem = logButton
    //
    //        // Marks: - Right bar button
    //        let back : UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(right))
    //
    //        self.navigationItem.leftBarButtonItem = logButton
    //    }
    //
    //    func right()
    //    {
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialPost") as! SocialPost
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //
    //   func pagecontrlfunc()
    //   {
    //
    //    super.viewDidLoad()
    //
    //    //Title
    //    self.title = "Fetured"
    //
    //       // self.navigationController?.setNavigationBarHidden(true, animated: true)
    //
    //        let page1: UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "Dashboard")
    //        let page2: UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "Follower")
    //
    //
    //        let page3: UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "Friends")
    //
    //        arrvc.append(page1)
    //        arrvc.append(page2)
    //        arrvc.append(page3)
    //
    //
    //        // Create the page container
    //        pagecontaner = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    //        pagecontaner.delegate = self
    //        pagecontaner.dataSource = self
    //        pagecontaner.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    //
    //        // Add it to the view
    //        view.addSubview(pagecontaner.view)
    //
    //
    //
    //        // Configure our custom pageControl
    //        view.bringSubview(toFront: pageControl)
    //
    //
    //        pageControl.numberOfPages = arrvc.count
    //        pageControl.currentPage = 0
    //
    //        // Do any additional setup after loading the view.
    //
    //    }
    //
    //    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    //    {
    //        let currentIndex = arrvc.index(of: viewController)!
    //        //Left to Right
    //        //For title of the page in the navigation bar
    //        if currentIndex == 0
    //        {
    //            self.title = "Featured"
    //        }
    //        if currentIndex == 1
    //        {
    //            self.title = "Follow"
    //        }
    //        if currentIndex == 2
    //        {
    //            self.title = "Rank"
    //        }
    //
    //        if currentIndex == 0
    //        {
    //            return nil
    //        }
    //
    //        let previousIndex = abs((currentIndex - 1) % arrvc.count)
    //        return arrvc[previousIndex]
    //    }
    //
    //
    //
    //    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    //    {
    //        let currentIndex = arrvc.index(of: viewController)!
    //        //Right to left swipe
    //        //For title of the page in the navigation bar
    //        if currentIndex == 0
    //        {
    //            self.title = "Featured"
    //        }
    //        if currentIndex == 1
    //        {
    //            self.title = "Follow"
    //        }
    //        if currentIndex == 2
    //        {
    //            self.title = "Friends"
    //        }
    //        if currentIndex == arrvc.count-1
    //        {
    //            return nil
    //        }
    //        let nextIndex = abs((currentIndex + 1) % arrvc.count)
    //        return arrvc[nextIndex]
    //    }
    //
    //    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    //    {
    //        pendingIndex = arrvc.index(of:pendingViewControllers.first!)
    //    }
    //
    //    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    //        if completed
    //        {
    //            currentIndex = pendingIndex
    //            if let index = currentIndex
    //            {
    //                pageControl.currentPage = index
    //            }
    //        }
    //    }
    //
    //    // function prifile
    //    func profileview()
    //    {
    //
    //    }
    ///////////////////////////////////
    
    
    // MARK: - Actions
}






















//////////////////////////////////////////////////////////////////////////////////////////
////  PageController.swift
////  Schedulix
////
////  Created by MacBook on 22/03/2017.
////  Copyright © 2017 MacBook. All rights reserved.
////
//
//import UIKit
//
//
//class PageController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
//{
//    ///////////
//
//    @IBOutlet weak var pageControl: UIPageControl!
//    var pagecontaner : UIPageViewController!
//    var arrvc = [UIViewController]()
//    var currentIndex: Int?
//    private var pendingIndex: Int?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
//        pagecontrlfunc()
//    }
//
//    func right()
//    {
//        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialPost") as! SocialPost
//       // self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//   func pagecontrlfunc()
//   {
//
//        super.viewDidLoad()
//
//    //Title
//    self.title = "Fetured"
//
//       // self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//        let page1: UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "MakeAnAppointment")
//        let page2: UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "Appointment")
//        let page3: UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "Doctors")
//
//        arrvc.append(page1)
//        arrvc.append(page2)
//        arrvc.append(page3)
//
//
//        // Create the page container
//        pagecontaner = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pagecontaner.delegate = self
//        pagecontaner.dataSource = self
//        pagecontaner.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
//
//        // Add it to the view
//        view.addSubview(pagecontaner.view)
//
//
//
//        // Configure our custom pageControl
//        view.bringSubview(toFront: pageControl)
//
//
//        pageControl.numberOfPages = arrvc.count
//        pageControl.currentPage = 0
//
//        // Do any additional setup after loading the view.
//
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
//    {
//        let currentIndex = arrvc.index(of: viewController)!
//        //Left to Right
//        //For title of the page in the navigation bar
//        if currentIndex == 0
//        {
//            self.title = "Make an Appointment"
//        }
//        if currentIndex == 1
//        {
//            self.title = "Appointment"
//        }
//        if currentIndex == 2
//        {
//            self.title = "Doctors"
//        }
//
//        if currentIndex == 0
//        {
//            return nil
//        }
//
//        let previousIndex = abs((currentIndex - 1) % arrvc.count)
//        return arrvc[previousIndex]
//    }
//
//
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
//    {
//        let currentIndex = arrvc.index(of: viewController)!
//        //Right to left swipe
//        //For title of the page in the navigation bar
//        if currentIndex == 0
//        {
//            self.title = "Make an Appointment"
//        }
//        if currentIndex == 1
//        {
//            self.title = "Appointment"
//        }
//        if currentIndex == 2
//        {
//            self.title = "Doctors"
//        }
//        if currentIndex == arrvc.count-1
//        {
//            return nil
//        }
//        let nextIndex = abs((currentIndex + 1) % arrvc.count)
//        return arrvc[nextIndex]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
//    {
//        pendingIndex = arrvc.index(of:pendingViewControllers.first!)
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed
//        {
//            currentIndex = pendingIndex
//            if let index = currentIndex
//            {
//                pageControl.currentPage = index
//            }
//        }
//    }
//
//    // function prifile
//    func profileview()
//    {
//
//    }
//}
extension DataContainer {
    static let shared = DataContainer()
}
