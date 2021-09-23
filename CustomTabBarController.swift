
//
//  CustomTabBarViewController.swift
//  CustomTabBar
//
//  Created by Adam Bardon on 07/03/16.
//  Copyright © 2016 Swift Joureny. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase

var viewController: UIViewController?

var timer = Timer()
var tabval = Int()
var logouttag = String()

protocol MoviewSearch {
    func searchMoviee(_ ss: String)
    
}



class CustomTabBarViewController: UITabBarController  {
//    
//    //Custom Delegate
//    var delegate2 : MoviewSearch?
//    
//    var selectItem = String()
//
//    
//    var ob = Movies()
//    
//
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    override func viewDidAppear(_ animated: Bool) {
        // Marks: - Buttons Cornor Radius
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        logouttag = "1"
        getunreadcount()
        DispatchQueue.global(qos: .background).async {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.getunreadcount), userInfo: nil, repeats: true)
            
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationItem.leftBarButtonItem?.badge = nil
        }
        tabval = 0
    }
    override func viewDidLoad() {
        funObserverUserDevice()
        super.viewDidLoad()

        
       // self.navigationItem.leftBarButtonItem.badge = "5" //your value
        //
        //MARK : - Check tab value on which tab
        // Marks: - navigation title
        //self.title = "ePoltry"
        
        obj.autoUpDateIOSVersion(viewcontroller:self)
        //MARK:- Navigation Title Multilines
        obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
        // Marks: - Right Sear/channel button
        let rightDailyRatesBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(funRateList))
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(search))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem,rightDailyRatesBarButtonItem], animated: true)

        // Marks: - Left button multiple
        let btnnotification:UIBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "groupnav"), style: UIBarButtonItem.Style.done, target: self, action: #selector(funfriend))
        let btngroup:UIBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "notification"), style: UIBarButtonItem.Style.done, target: self, action: #selector(search))
        
        self.navigationItem.setLeftBarButtonItems([btngroup, btnnotification], animated: true)
        
        NotificationCenter.default.removeObserver(self)
        // Comment to receive notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "logout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationlogout), name: NSNotification.Name(rawValue: "logout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(likeAddNotifications), name: NSNotification.Name(rawValue: "likeAddNotifications"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(isChannelRequestStatus), name: NSNotification.Name(rawValue: "isChannelRequestStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isProfilePage), name: NSNotification.Name(rawValue: "isProfilePage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isUserList), name: NSNotification.Name(rawValue: "isUserList"), object: nil)
        
        isAppLaunch = false
    }
    //MARK: - Friend Function
    @objc func funfriend() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Friend") as! Friend
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func funRateList() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RateList_ViewController") as! RateList_ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleNotificationlogout() {
        timer.invalidate()
        if logouttag == "0"{
            return
        }
        else{
            logouttag = "0"
        }
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard
        .removePersistentDomain(forName: appDomain)
        DispatchQueue.main.async{
            //self.navigationController?.isNavigationBarHidden = true
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            let newViewControllerr = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
               self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(newViewControllerr, animated: true)
            }
        }
    }
    
    @objc func isChannelRequestStatus(){
        let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "Channels") as! Channels
        vc.isChannelRequest = true
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
     }
    
    @objc func isProfilePage() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Profile") as! Profile
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func isUserList() {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "UsersList") as! UsersList
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: - Tabbar Delegate
    //Tab Bar Selected Index
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        
//        let index = tabBar.items?.index(of: item)
//
//
//        
//        if index == 0
//        {
//            if tabval == 0
//            {
//                
//            }
//            else
//            {
//                tabval = 0
//                viewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! Post
//                self.view.insertSubview(viewController!.view!, belowSubview: self.tabBar)
//            }
//        }
//        else if index == 1
//        {
//            if tabval == 1
//            {
//                
//            }
//            else
//            {
//                tabval = 1
//                viewController = self.storyboard?.instantiateViewController(withIdentifier: "News") as! News
//                
//                
//                //self.view.insertSubview(viewController!.view!, belowSubview: self.tabBar)
//                self.view.insertSubview(viewController!.view!, aboveSubview: self.tabBar)
//                //self.view.insertSubview(viewController!.view!, at: 2)
//
//            }
//        }
//        else if index == 2
//        {
//            if tabval == 2
//            {
//                
//            }
//            else
//            {
//                tabval = 2
//                viewController = self.storyboard?.instantiateViewController(withIdentifier: "Groups") as! Groups
//               // self.view.insertSubview(viewController!.view!, belowSubview: self.tabBar)
//                self.view.insertSubview(viewController!.view!, at: 2)
//            }
//        }
//        else if index == 3
//        {
//           // tabBar.didMoveToWindow()
//            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if tabval == 0
//            {
//                viewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! Post
//            }
//            else if tabval == 1
//            {
//                viewController = self.storyboard?.instantiateViewController(withIdentifier: "News") as! News
//            }
//            else if tabval == 2
//            {
//                viewController = self.storyboard?.instantiateViewController(withIdentifier: "Groups") as! Groups
//            }
//            
//            viewController.setf
//
//            self.view.insertSubview(viewController!.view!, belowSubview: self.tabBar)
//            
//            DispatchQueue.main.async {
//                DispatchQueue.main.async {
//                    DispatchQueue.main.async {
//                        DispatchQueue.main.async {
//                            DispatchQueue.main.async {
//                                DispatchQueue.main.async {
//                                    self.optionbtn()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
    
        
            
//        else if index == 4
//        {
//            if let _ = self.navigationController
//            {
//                
//            }
//        }
 //   }
    
    //MARK: - Option button click action
    // Marks: - Button option
    func optionbtn() {
        let alertController = UIAlertController(title: "Alert", message: "", preferredStyle:UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Setting", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Setting") as! Setting
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
//        alertController.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default)
//        { action -> Void in
//            
//        })
//        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default)
//        { action -> Void in
//            // Put your code here
//            
//        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    @objc func search() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! Search
        self.navigationController?.pushViewController(vc, animated: true)
    }
//asdf
    @objc func likeAddNotifications(notification: Notification) {
        let notification_Action = notificationData_userInfo["gcm.notification.action"] as! String
        if notification_Action == "newChannelPost" {
            let vc = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "PageViewChannels") as! PageViewChannels
            NEWsChannelID = "\(notificationData_userInfo["gcm.notification.channel_id"] as! String)"
            NEWsChannelName = "\("")"
            NEWsChannelDescription = "\("")"
            NEWsChannelTags = "\("")"
            NEWsHeaderimage = UIImage(named: "groupimg")!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if notification_Action == "like" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Likes") as! Likes
            vc.statusid = notificationData_userInfo["gcm.notification.statusId"] as! String
            vc.isNotification = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if notification_Action == "comment" {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Comments") as! Comments
            vc.type = "Public"
            vc.statusid = notificationData_userInfo["gcm.notification.statusId"] as! String
            vc.totallike = ""
            vc.isNotification = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if notification_Action == "ChannelLive" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Events") as! Events
            vc.isLiveLink = notificationData_userInfo["gcm.notification.channel_livelink"] as! String
            vc.isLiveTitle = notificationData_userInfo["gcm.notification.channel_livetitle"] as! String
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        print(notificationData_userInfo)
    }
    //MARK:- self last online time
    @objc func funObserverUserDevice()
    {
        if let userid = defaults.value(forKey: "uidIfLogout") as? String
        {
            UserDB.child(userid).keepSynced(true)
            UserDB.child(userid)
                .queryOrdered(byChild: "UserDeviceId")
                .observe(.childChanged) { (snapshot) in
                    if snapshot.key == "UserDeviceId" && snapshot.value as! String != DEVICEID
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funUserLogOut"), object: nil)
                    }
            }
            self.readFromFB(userid: userid)
        }
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
    // Marks: - Get all comments
    @objc func getunreadcount()
    {
        return
        if logouttag == "1"
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
            
            let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetNotificationsCount xmlns='http://threepin.org/'><id>\(userid)</id></GetNotificationsCount></soap:Body></soap:Envelope>"
            
            
            let soapLenth = String(soapMessage.count)
            let theUrlString = "http://websrv.zederp.net/Apml/EPoultryDirectory.asmx"
            let theURL = URL(string: theUrlString)
            let mutableR = NSMutableURLRequest(url: theURL!)
            
            // MUTABLE REQUEST
            
            mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
            mutableR.httpMethod = "POST"
            mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
            
            let session = URLSession.shared
            
            //andicator.startAnimating()
            
            let task = session.dataTask(with: mutableR as URLRequest, completionHandler: {data, response, error -> Void in
                //self.andicator.stopAnimating()
                var dictionaryData = NSDictionary()
                
                do
                {
                    //dictionaryData = try XMLReader.dictionary(forXMLData: (data)) as NSDictionary
                    dictionaryData as NSDictionary
                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetNotificationsCountResponse")! as Any) as AnyObject).object(forKey:"GetNotificationsCountResult")   ?? NSDictionary()
                    
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
                                
                                
                                //                            self.tabBar.items![0].badgeValue = dict.value(forKey: "GroupCount") as? String
                                //                            self.tabBar.items![1].badgeValue = dict.value(forKey: "GroupCount") as? String
                                //                            self.tabBar.items![2].badgeValue = dict.value(forKey: "GroupCount") as? String
                                
                                if let GroupCount = dict.value(forKey: "GroupCount") as? Int
                                {
                                    if GroupCount == 0
                                    {
                                        self.tabBar.items![2].badgeValue = nil
                                    }
                                    else
                                    {
                                        if defaults.value(forKey: "view") as! String == "Groups"
                                        {
                                            self.tabBar.items![2].badgeValue = nil
                                        }
                                        else
                                        {
                                            
                                            self.tabBar.items![2].badgeValue = String(GroupCount)
                                            self.tabBar.items![2].badgeColor = appcolor
                                        }
                                        
                                    }
                                    
                                }
                                else
                                {
                                    self.tabBar.items![2].badgeValue = ""
                                }
                                
                                if let NewsCount = dict.value(forKey: "NewsCount") as? Int
                                {
                                    if NewsCount == 0
                                    {
                                        self.tabBar.items![1].badgeValue = nil
                                    }
                                    else
                                    {
                                        self.tabBar.items![1].badgeValue = String(NewsCount)
                                        self.tabBar.items![1].badgeColor = appcolor
                                    }
                                }
                                else
                                {
                                    self.tabBar.items![1].badgeValue = nil
                                    
                                }
                                
                                if let FriendRequestCount = dict.value(forKey: "FriendRequestCount") as? Int
                                {
                                    if FriendRequestCount == 0
                                    {
                                        //self.tabBar.items![1].badgeValue = nil
                                    }
                                    else
                                    {
                                        //self.tabBar.items![1].badgeValue = String(FriendRequestCount)
                                    }
                                }
                                else
                                {
                                    //self.tabBar.items![1].badgeValue = nil
                                }
                                
                                if let total = dict.value(forKey: "TotalCount") as? Int
                                {
                                    if total == 0
                                    {
                                        self.navigationItem.leftBarButtonItem?.badge = nil
                                    }
                                    else
                                    {
                                        self.navigationItem.leftBarButtonItem?.badgeValue = String(total)
                                        self.navigationItem.leftBarButtonItem?.badgeBGColor = UIColor.orange
                                    }
                                    
                                }
                                else
                                {
                                    self.navigationItem.leftBarButtonItem?.badge = nil
                                }
                                // self.tablev.reloadData()
                                
                            }
                        }
                    }
                    else{
                        
                        // obj.showAlert(title: "Alert", message: "try again", viewController: self)
                    }
                    
                }
                catch
                {
                    // print("Your Dictionary value nil")
                }
                if error != nil
                {
                    //self.andicator.stopAnimating()
                    //obj.showAlert(title: "Alert!", message: (error?.localizedDescription)!, viewController: self)
                }
            })
            
            task.resume()
            

            // AFNETWORKING REQUEST
            
            // let mn = AFHTTPRequestOperation()
            
//            let manager = AFHTTPRequestOperation(request: mutableR as URLRequest)
//            
//            
//            manager.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation, responseObject : Any) -> Void in
//                
//                var dictionaryData = NSDictionary()
//                
//                do
//                {
//                    dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! Data)) as NSDictionary
//                    
//                    let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "GetNotificationsCountResponse")! as Any) as AnyObject).object(forKey:"GetNotificationsCountResult")   ?? NSDictionary()
//                    
//                    if (mainDict as AnyObject).count > 0{
//                        
//                        let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//                        
//                        let text = mainD.value(forKey: "text") as! NSString
//                        // text = text.replacingOccurrences(of: "[", with: "") as NSString
//                        // text = text.replacingOccurrences(of: "]", with: "") as NSString
//                        
//                        if text == "0"
//                        {
//                            obj.showAlert(title: "Alert!", message: "No Record found.", viewController: self)
//                        }
//                        else
//                        {
//                            let json/*: [AnyObject]*/ = try JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
//                            
//                            for dict in json {
//                                
//                                
//                                //                            self.tabBar.items![0].badgeValue = dict.value(forKey: "GroupCount") as? String
//                                //                            self.tabBar.items![1].badgeValue = dict.value(forKey: "GroupCount") as? String
//                                //                            self.tabBar.items![2].badgeValue = dict.value(forKey: "GroupCount") as? String
//                                
//                                if let GroupCount = dict.value(forKey: "GroupCount") as? Int
//                                {
//                                    if GroupCount == 0
//                                    {
//                                        self.tabBar.items![2].badgeValue = nil
//                                    }
//                                    else
//                                    {
//                                        if defaults.value(forKey: "view") as! String == "Groups"
//                                        {
//                                            self.tabBar.items![2].badgeValue = nil
//                                        }
//                                        else
//                                        {
//                                            self.tabBar.items![2].badgeValue = String(GroupCount)
//                                            self.tabBar.items![2].badgeColor = appcolor
//                                        }
//                                        
//                                    }
//                                    
//                                }
//                                else
//                                {
//                                    self.tabBar.items![2].badgeValue = ""
//                                }
//                                
//                                if let NewsCount = dict.value(forKey: "NewsCount") as? Int
//                                {
//                                    if NewsCount == 0
//                                    {
//                                        self.tabBar.items![1].badgeValue = nil
//                                    }
//                                    else
//                                    {
//                                        self.tabBar.items![1].badgeValue = String(NewsCount)
//                                    }
//                                }
//                                else
//                                {
//                                    self.tabBar.items![1].badgeValue = nil
//                                    
//                                }
//                                
//                                if let FriendRequestCount = dict.value(forKey: "FriendRequestCount") as? Int
//                                {
//                                    if FriendRequestCount == 0
//                                    {
//                                        //self.tabBar.items![1].badgeValue = nil
//                                    }
//                                    else
//                                    {
//                                        //self.tabBar.items![1].badgeValue = String(FriendRequestCount)
//                                    }
//                                }
//                                else
//                                {
//                                    //self.tabBar.items![1].badgeValue = nil
//                                }
//                                
//                                if let total = dict.value(forKey: "TotalCount") as? Int
//                                {
//                                    if total == 0
//                                    {
//                                        self.navigationItem.leftBarButtonItem?.badge = nil
//                                    }
//                                    else
//                                    {
//                                        self.navigationItem.leftBarButtonItem?.badgeValue = String(total)
//                                        self.navigationItem.leftBarButtonItem?.badgeBGColor = UIColor.orange
//                                    }
//                                    
//                                }
//                                else
//                                {
//                                    self.navigationItem.leftBarButtonItem?.badge = nil
//                                }
//                                // self.tablev.reloadData()
//                                
//                            }
//                        }
//                    }
//                    else{
//                        
//                        // obj.showAlert(title: "Alert", message: "try again", viewController: self)
//                    }
//                    
//                }
//                catch
//                {
//                    // print("Your Dictionary value nil")
//                }
//                
//                //print(dictionaryData)
//                
//                
//            }, failure: { (operation : AFHTTPRequestOperation, error :Error) -> Void in
//                
//                // print(error, terminator: "")
//                
//                //obj.showAlert(title: "Alert!", message: error.localizedDescription, viewController: self)
//            })
//            
//            manager.start()
        }

    }
    
    
}



