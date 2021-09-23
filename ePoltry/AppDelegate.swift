//
//  AppDelegate.swift
//  AMPL
//
//  Created by sameer on 31/05/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.


import UIKit
import Sinch
import CoreData
//////////////////////////
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseMessaging
import UserNotifications
import UserNotificationsUI
import Crashlytics
import Fabric
//Sinch Handling
var sincall: SINCall?
var sinclientG: SINClient?
var sinAudioController: SINAudioController?
var sinVideoController: SINVideoController?
var playerCall: AVAudioPlayer?
var v = 0


@UIApplicationMain class AppDelegate: UIResponder, SINClientDelegate, SINCallClientDelegate,SINManagedPushDelegate, UIApplicationDelegate, UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
    private var push: SINManagedPush?
    private var callKitProvider: SINCallKitProvider?
    var client: SINClient?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ////////---------Sinch Start---------//////////
        #if DEBUG
        push = Sinch.managedPush(with: SINAPSEnvironment.development)
        #else
        push = Sinch.managedPush(with: SINAPSEnvironment.production)
        #endif
        
        print("[AppDelegate] didFinishLaunchingWithOptions: ")
        push?.delegate = self
        //MARK:- SINPushTypeVoIP Declare in SINUIViewController.h view controller file if we use stringpush will not receive
        //MARK:- i have waste 2 days because this was not declare SINPushTypeVoIP
        push?.setDesiredPushType(SINPushTypeVoIP)
        //push?.setDesiredPushType("SINPushTypeRemote")
        
        let onUserDidLogin: ((String?) -> Void)? = { userId in
            //self.push?.registerUserNotificationSettings()
            self.initSinchClientWithUserId(withUserId: userId)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("UserDidLoginNotification"),object: nil, queue: nil, using: { note in
            let userId = note.userInfo!["userId"] as? String
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.synchronize()
            onUserDidLogin!(userId)
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SinchLogout"), object: nil,queue: nil, using: { note in
            if self.client != nil{
                self.client!.stop()
            }
        })
        
        ///////////-----------SinchEnd------------////////////
        //Google Map Api
        GMSServices.provideAPIKey(GOOGLE_SERVICES_KEY)
        //Google Places Api
        GMSPlacesClient.provideAPIKey(GOOGLE_PLACES_KEY)
        
        UNUserNotificationCenter.current().delegate = self
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in
//                    //register for voip notifications
//
//            })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//            //register for voip notifications
//        }
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared
                .registerUserNotificationSettings(UIUserNotificationSettings(types:
                    [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
        
        //MARK:- Crashlytics Configration
        
        //MARK:- Firebase Configration
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        //Crashlytics.sharedInstance().crash()
        //Firebase apps automatically handle temporary network interruptions for you. Cached data willstill be available while offline and your writes will be resent when network connectivity isrecovered. Enabling disk persistence allows our app to also keep all of its state even afteran app restart. We can enable disk persistence with just one line of code.
        Database.database().isPersistenceEnabled = true
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(self.tokenRefreshNotification),
                                                name: NSNotification.Name.InstanceIDTokenRefresh,
                                                object: nil)
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                defaults.setValue(result.token, forKey: "fcmtoken")
                defaults.setValue(result.instanceID, forKey: "fcmid")
            }
        }
        connectToFcm()
        // [END FireBase]
        defaults.setValue("0", forKey: "sinclientG")
        //MARK:- Save User Profile
    
//        if let temp = defaults.value(forKey: "fcmId") as? String{
//            if USERUID != "" {
//                UserDB.child(tempuid).updateChildValues(["fcmId":temp])
//            }
//        }
        funSetObservers()
        
                 // This is the workaround for Xcode 11.2 UITxtView Crash Fix
        UITextViewWorkaround.unique.executeWorkaround()
        
        //MARK:- For iphone Drak and Light Theme Issue
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        isAppLaunch = true
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur forcertain types of temporary interruptions (such as an incoming phone call or SMS message) orwhen the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics renderingcallbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and storeenough application state information to restore your application to its current state in caseit is terminated later.
        // If your application supports background execution, this method is called instead ofapplicationWillTerminate: when the user quits.
        //Hide Keyboard
        self.window?.endEditing(true)
        //MARK:- Stop Player when app enter in background
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopPlayer"), object: nil)
        
        if USERUID != "" {
            let timespam = Date().currentTimeMillis()!
            
            let tempkeyarray = USERDATA.allKeys as NSArray
            if tempkeyarray.contains("onLine")
            {
                USERDATA.setValue(timespam, forKey: "onLine")
            }
            if tempkeyarray.contains("onLineUpdatedAt")
            {
                USERDATA.setValue(timespam, forKey: "onLineUpdatedAt")
            }
            
            UserDB.child(USERUID).updateChildValues(USERDATA as! [AnyHashable : Any])
            print(USERDATA)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. Ifthe application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See alsoapplicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopPlayer"), object: nil)
        if USERUID != "" {
            UserDB.child(USERUID).updateChildValues(USERDATA as! [AnyHashable : Any])
        }
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
            The persistent container for the application. This implementation
            creates and returns a container, having loaded the store for the
            application to it. This property is optional since there are legitimate
            error conditions that could cause the creation of the store to fail.
            */
        
        let container = NSPersistentContainer(name: CORE_DB_NAME)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You shouldnot use this function in a shipping application, although it may be useful duringdevelopment.
                
                /*
                    Typical reasons for an error here include:
                    * The parent directory does not exist, cannot be created, or disallows writing.
                    * The persistent store is not accessible, due to permissions or data protection when thedevice is locked.
                    * The device is out of space.
                    * The store could not be migrated to the current model version.
                    Check the error message to determine what the actual problem was.
                    */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You shouldnot use this function in a shipping application, although it may be useful duringdevelopment.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
            
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken as Data
        
//        #if DEVELOPMENT
//        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
//        #else
//        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
//        #endif
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error:Error) {
        //MARK:- If fail for Register Remote notification
        print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        funAppEnterInForeGround()
        if client == nil {
            return
        }
        weak var call = callKitProvider!.currentEstablishedCall()
        // If there is one established call, show the callView of the current call when the App is broughtto foreground.
        // This is mainly to handle the UI transition when clicking the App icon on the lockscreen CallKitUI.
        if (call != nil) {
            var top = window!.rootViewController
            while ((top?.presentedViewController) != nil) {
                top = top?.presentedViewController
            }
            // When trying to enter the application via the App button on the callkit lockscreen, andunlocking the device by
            // pincode/touch id, applicationWillEnterForeground will be invoked twice, and "top" willbecome CallViewController
            // after the first invocation, which will make the second invocation ofapplicationWillEnterForeground throw the
            // following exception: 'Receiver (<CallViewController:0x151e51a80>) has no segue withidentifier 'callView'', we
            // use the condition guard below to ensure the segue will only be performed once.
            // Note applicationWillEnterForeground will only be invoked once if no pin code is set on thedevice.
            
            if !(type(of: top!) === AnswerCall.self) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivecall"),object: nil)
                // top!.performSegue(withIdentifier: "callView", sender: call)
            }
        }
    }
    
    //////////---------Sinch Code Start--------/////////
    func initSinchClientWithUserId(withUserId userId: String?) {
        if (client == nil) {
            client = Sinch.client(withApplicationKey: SINCH_KEY, applicationSecret: SINCH_SECRET_KEY,environmentHost: SINCH_URL, userId: userId)
            
            client!.delegate = self
            client!.call().delegate = self
            client!.setSupportCalling(true)
            client!.enableManagedPushNotifications()
            client!.setPushNotificationDisplayName("Test")
            client!.start()
            callKitProvider = SINCallKitProvider(client: client!)
        }
    }
    
    func handleRemoteNotification(_ userInfo: [AnyHashable : Any]?) {
        if (client == nil) {
            let userId = UserDefaults.standard.object(forKey: "userId") as? String
            if userId != nil {
                print("[AppDelegate] initSinchClientWithUserId: upon push payload")
                initSinchClientWithUserId(withUserId: userId)
            }
        }
        //This func were not working in Swift so use it in Objective C
        
        // let result = SINUIViewController().handleRemoteNotificationResultManual(userInfo, callClientID:client)
        
        //let result = client?.relayRemotePushNotification(userInfo)
        // let result = client?.relayRemotePushNotification(userInfo!)
        let result = client?.relayRemotePushNotification(userInfo)
        //MARK:- Get in comming call Header Data
        SinCallDataDic = result?.call()?.headers! as! [String : AnyObject]
        // print(userInfo!["identifier"])
        //
        //        presentMissedCallNotification(withRemoteUserId:
        //            "Message alert Test")
//        if result?.isCall() != nil && result?.call()?.isCallCanceled == true{
//            presentMissedCallNotification(withRemoteUserId:
//                //result?.call()?.remoteUserId
//                "\((SinCallDataDic["current_username"] as? String)!)")
//
//            if SinCallDataDic["current_username"]! as? String != defaults.value(forKey: "phoneno")as? String
//            {
//                objCDB.updateCallRecord(datadic: userInfo as! [String : Any], call_type: MISSED_CALL,completion: {
//                    success in
//
//                    if success!{
//                        print("Misscall save")
//
//                    }
//                    else{
//                        print("Misscall not save")
//                    }
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "funRefresh"),object: nil)
//                })
//            }
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    func managedPush(_ unused: SINManagedPush?, didReceiveIncomingPushWithPayload payload: [AnyHashable :Any]?, forType pushType: String?) {
        print("[AppDelegate] didReceiveIncomingPushWithPayload: \(payload?.description ?? "")")
        // print(payload!["identifier"])
        
        let datadic = payload! as NSDictionary
//        let sindatastr = datadic.value(forKey: "sin") as! String
//        
//        let dict = convertToDictionary(text: sindatastr)
//        
//        if let temp = dict?["public_headers"] as? NSDictionary
//        {
//            //From IOS
//            callUser_PhoneNumberIncomming = temp.value(forKey: "current_username") as! String
//        }
//        else
//        {
//            //From Android
//            callUser_PhoneNumberIncomming = dict!["current_username"] as! String
//        }
//        DispatchQueue.main.async{
//            DispatchQueue.main.async{
//                self.handleRemoteNotification(payload)
//            }
//        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    // MARK: - SINCallClientDelegate
    func client(_ client: SINCallClient?, didReceiveIncomingCall call: SINCall?) {
        // Find MainViewController and present CallViewController from it.
        var top = window!.rootViewController
        while ((top?.presentedViewController) != nil) {
            top = top?.presentedViewController
        }
        //  top?.performSegue(withIdentifier: "callView", sender: call)
        sincall = call
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivecall"), object: nil)
    }
    
    func client(_ client: SINCallClient!, willReceiveIncomingCall call: SINCall!) {
        sincall = call
        callKitProvider!.reportNewIncomingCall(callUser_PhoneNumberIncomming, callClientID: call)
    }
    private func client(_ client: SINClient?, willReceiveIncomingCall call: SINCall?) {
        sincall = call
        callKitProvider!.reportNewIncomingCall(callUser_PhoneNumberIncomming, callClientID: call)
    }
    
    func presentMissedCallNotification(withRemoteUserId remoteUserId: String?) {
        let application = UIApplication.shared
        if application.applicationState == .background {
            
            let content = UNMutableNotificationContent()
            let contactUserName = obj.getContactNameFromNumber(contactNumber:
                "\(remoteUserId!)")
            let identifier = "Missed call"
            content.title = ""
            content.body = "Missed call from \(contactUserName)"
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.5, repeats: false)
            
            let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger:trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: { (error) in
                print(request)
                print(error as Any)
                
            })
        }
    }
    
    //MARK:- Sinch Code
    func clientDidStart(_ client: SINClient!) {
        print("Sinch client started successfully\(String(describing: Sinch.version()))")
    }
    
    func clientDidFail(_ client: SINClient?, error: Error?) {
        print("[AppDelegate] Sinch client error: \(error?.localizedDescription ?? "")")
    }
    
    func client(_ client: SINClient?, logMessage message: String?, area: String?, severity:SINLogSeverity, timestamp: Date?) {
        print("[\(area ?? "")] \(message ?? "")")
    }//////////---------Sinch Code End--------/////////
    
    ///////////////////---------Firebase Start--------//////////////////
    //MARK:- When Firebase Token Refresh
    @objc func tokenRefreshNotification(_ notification: Notification) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                defaults.setValue(result.token, forKey: "fcmtoken")
                defaults.setValue(result.instanceID, forKey: "fcmid")
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    /// This method will be called whenever FCM receives a new, default FCM token for your
    /// Firebase project's Sender ID.
    /// You can send this token to your application server to send notifications to this device.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        defaults.set(fcmToken, forKey: "fcmtoken")
        print(fcmToken)
    }
    //Firebase Message Receive when app in fore Ground Working
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        
    }
    ////////----End Fire Base Handling----////////
    ////////----Fire Base Handling----////////
    func connectToFcm() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    //MARK:- Apple Push Receive code in BackGround
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable:Any],
                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) ->Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching theapplication.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        //        var bool = false
        //        for _ in callManager.calls {
        //            //call.end()
        //            bool = true
        //        }
        //        if bool == true{
        //
        //        }
        //        else{
        notificationData_userInfo = userInfo
        let state = UIApplication.shared.applicationState
        if state != .active {
            //scheduleNotification(event: "Incoming call 00", body: "test call notificaion", interval: 0.5)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"),object: nil)
        }
        else {
            
            //asdf
        }
       // funDeviceAuthentication(userInfo: userInfo)
        //        }
        //
        //        // Print message ID.
        //        print("Message ID: 2")
        //        if let messageID = userInfo[""] {
        //            print("Message ID: \(messageID)")
        //        }
        //
        //        // Print full message.
        //        print(userInfo)
        //  handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable:Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching theapplication.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        print("Message ID:")
        Messaging.messaging().appDidReceiveMessage(userInfo)
        //scheduleNotification(event: "Incoming call", body: "test call notificaion 1", interval: 0.0)
        // Print message ID.
        if let messageID = userInfo[""] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        if push != nil
        {
            
        }
        push!.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    
    
    //MARK:- Handle Message for foreground
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject :AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
        // scheduleNotification(event: "Incoming call", body: "test call notificaion 2", interval: 0.0)
        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveBackGroundcall"),object: nil)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    /////////////
    //MARK:- Apple Push Receive code in ForeGround
    
    private func application(_ application: UIApplication, didReceive notification: UNNotification) {
        
        // scheduleNotification(event: "Incoming call", body: "test call notificaion 3", interval: 0.0)
        print("application(_ application: UIApplication, didReceive notification: UNNotification")
    }
    //    //MARK:- Push Kit
    //    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload,for type: PKPushType, completion: @escaping () -> Void) {
    //        let datadic = payload.dictionaryPayload
    //        //scheduleNotification(event: "", body: "didReceiveIncomingPushWith payload completion",interval: 0.5)
    //        showCallNotification(payload: datadic)
    //    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        return true
    }
    
    ///////////////////---------Firebase End--------//////////////////
    
    /////////////////---------Local Hit--------//////////////////
    @objc func funSetObservers(){
        //MARK:- Check if Firebase Database Connected
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                print("Connected")
                if USERUID != "" {
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue:"funObserverUserDevice"), object: nil)
                }
            } else {
                print("Not connected")
            }
        })
        // #1.1 - Create "the notification's category value--its type."
        let debitOverdraftNotifCategory = UNNotificationCategory(identifier: "debitOverdraftNotification",actions: [], intentIdentifiers: [], options: [])
        // #1.2 - Register the notification type.
        UNUserNotificationCenter.current().setNotificationCategories([debitOverdraftNotifCategory])
        NotificationCenter.default.addObserver(forName:NSNotification.Name("DeviceAuthenticationReceive"), object: nil, queue: nil, using: { note in
            //self.funDeviceAuthentication()
        })
        NotificationCenter.default.addObserver(forName: NSNotification.Name("updateProfile"), object: nil,queue: nil, using: { note in
            let userimg = defaults.value(forKey: "userimage") as! String
            let userstatus = defaults.value(forKey: "userstatus") as! String
            let username = defaults.value(forKey: "username") as! String
            USERDATA.setValue(username, forKey: "UserName")
            USERDATA.setValue(userstatus, forKey: "UserStatus")
            USERDATA.setValue(userimg, forKey: "UserLink")
        })
        NotificationCenter.default.addObserver(forName: NSNotification.Name("saveUserProfileData"),object: nil, queue: nil, using: { note in
            self.saveUserProfileData(completion: { profileDict in
                USERDATA = profileDict!
                //MARK:- This observer is used for when app enter in ForGround
                NotificationCenter.default.removeObserver(self, name:   NSNotification.Name(rawValue:"funAppEnterInForeGround"),   object: nil)
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.funAppEnterInForeGround), name:  NSNotification.Name(rawValue:"funAppEnterInForeGround"),   object: nil)
            })
        })
    }
    
    
    var tempcount = 0
    //Local API Hit for Save User data in Firebase DB
    func saveUserProfileData(completion: @escaping (_ profileDict: NSMutableDictionary?) -> Void)
    {
       // tempcount = 0
        if USERUID != "" {
            UserDB.keepSynced(true)
            DispatchQueue.main.async{
                UserDB.child(USERUID).observeSingleEvent(of: .value, with: {
                snapshot in
                    if snapshot.exists() {
                        print(snapshot)
                        if self.tempcount > 0{
                            return
                        }
                        self.tempcount = self.tempcount + 1
                        
                        var timespam = Date().currentTimeMillis()!
                        
                        USERDATA = snapshot.value as! NSMutableDictionary
                        
                        let tempkeyarray = USERDATA.allKeys as NSArray
                        if tempkeyarray.contains("onLine")
                        {
                            USERDATA.setValue(timespam, forKey: "onLine")
                        }
                        if tempkeyarray.contains("onLineUpdatedAt")
                        {
                            USERDATA.setValue(timespam, forKey: "onLineUpdatedAt")
                        }
                        USERDATA.setValue("ios", forKey: "Source")
                        timespam = 1
                        if tempkeyarray.contains("onLine")
                        {
                            USERDATA.setValue(timespam, forKey: "onLine")
                        }
                        USERDATA.removeObject(forKey: "UserDeviceId")
                        UserDB.child(USERUID).updateChildValues(USERDATA as! [AnyHashable : Any])
                    }
                })
            }
        }
    }
    @objc func funAppEnterInForeGround(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contactrefresh"), object:["isPull":"1"])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatepost"), object:nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
        if USERDATA.count == 0 {
            return
        }
        if USERUID != "" {
            var timespam = Date().currentTimeMillis()!
            
            let tempkeyarray = USERDATA.allKeys as NSArray
            if tempkeyarray.contains("onLineUpdatedAt") {
                USERDATA.setValue(timespam, forKey: "onLineUpdatedAt")
            }
            timespam = 1
            if tempkeyarray.contains("onLine") {
                USERDATA.setValue(timespam, forKey: "onLine")
            }
            UserDB.child(USERUID).updateChildValues(USERDATA as! [AnyHashable : Any])
            //print(USERDATA)
        }
    }
    //MARK:- This code is use for send local notificaion in Notificaion services
    func funDeviceAuthentication(userInfo: [AnyHashable:Any]){
        // find out what are the user's notification preferences
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            // we're only going to create and schedule a notification
            // if the user has kept notifications authorized for this app
            guard settings.authorizationStatus == .authorized else { return }
            // create the content and style for the local notification
            let content = UNMutableNotificationContent()
            // #2.1 - "Assign a value to this property that matches the identifier
            // property of one of the UNNotificationCategory objects you
            // previously registered with your app."
            content.categoryIdentifier = "DeviceAuthentication"
            // create the notification's content to be presented
            // to the user
            let tempTitle = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "title") as? String ?? "ePoultry"
            let tempBody = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as? String ?? "ePoultry"
            content.title = tempTitle
            content.subtitle = ""
            content.body = tempBody
            content.sound = UNNotificationSound.default
            // #2.2 - create a "trigger condition that causes a notification
            // to be delivered after the specified amount of time elapses";
            // deliver after 10 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            // create a "request to schedule a local notification, which
            // includes the content of the notification and the trigger conditions for delivery"
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            // "Upon calling this method, the system begins tracking the
            // trigger conditions associated with your request. When the
            // trigger condition is met, the system delivers your notification."
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } // end getNotificationSettings
    }
    ////////End Local API Hit
    
    //AppDelegate.swift
    /// Handle push notification actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response:UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //    NotificationCenter.default.addObserver(self, selector: #selector(funtest), name:NSNotification.Name(rawValue: "test"), object: nil)
        
        if isAppLaunch {
            repeat {
                if !isAppLaunch {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likeAddNotifications"),object: nil)
                }
            } while isAppLaunch == false
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likeAddNotifications"),object: nil)
        
        completionHandler()
    }
    //
    //    func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping(UNNotificationContent) -> Void) {
    //
    //
    //    }
    @objc func funtest()
    {
        presentMissedCallNotification(withRemoteUserId:
            //result?.call()?.remoteUserId
            "\(("SinCallDataDic[] as? String"))")
    }
}
extension AppDelegate {
    
    func application(_ app: UIApplication,
                        open url: URL,
                        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
       // let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let homeVC = storyboard.instantiateViewController(withIdentifier: "DashboardPC") as!DashboardPC
//
//        let navVC = storyboard.instantiateViewController(withIdentifier: "DashboardPC2") as!UINavigationController
//
//        navVC.viewControllers = [homeVC]
//        self.window?.rootViewController = navVC
//        self.window?.makeKeyAndVisible()
        
//        let userDefaults = UserDefaults(suiteName: "group.com.nickelfox.testpush")
//        if let key = url.absoluteString.components(separatedBy: "=").last,
//            let sharedArray = userDefaults?.object(forKey: key) as? [Data] {
//
//            var imageArray: [CellModel] = []
//
//            for imageData in sharedArray {
//                let model = CellModel(image: UIImage(data: imageData)!)
//                imageArray.append(model)
//            }
//
// c
//
//            return true
    //        }
            
            return true
        }
        
    }

