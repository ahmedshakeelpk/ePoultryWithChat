//
//  Object.swift
//  ePoltry
//
//  Created by MacBook Pro on 23/04/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import Contacts
import CoreData
import FirebaseStorage


let defaults = UserDefaults.standard
let group_defaults = UserDefaults(suiteName: GROUPNAME)!


//MARK: - App Color
let appclr = UIColor(red: 241/255, green: 150/255, blue: 4/255, alpha: 1.0)
let appStatusBarClr = UIColor(red: 226/255, green: 140/255, blue: 0/255, alpha: 1.0)
let edgeColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)

var keyboardHeight = Float()
var txtfiledMaxY = Float()
var activeview = UIView()
//var imagepath = "http://websrv.zederp.net/ApmlMedia/"
//var videopath = "http://websrv.zederp.net/ApmlMedia/videos/"

//var imagepath = "http://epoultryapi.zederp.net/epoultrymedia/postimages/"
//var videopath = "http://epoultryapi.zederp.net/epoultrymedia/postvideos/"

var imagepathPost = "http://api.epoultry.pk/v0/upload/image"
var videopathPost = "http://api.epoultry.pk/v0/upload/video"
var userimagepathPost = "http://api.epoultry.pk/v0/upload/profileimage"

var imagepath = "http://epimages.epoultry.pk/postimages/"
var videopath = "http://epvod.epoultry.pk/postvideos/"
var videoPlayEndPath = "/index.m3u8"

var userimagepath = "http://epimages.epoultry.pk/usersimages/"
var docpath = "http://epoultryapi.zederp.net/epoultrymedia/postfiles/"

var appcolor = UIColor(red: 120.0/255, green: 27.0/255, blue: 15/255, alpha: 1.0)
var apppendingcolor = UIColor(red: 174.0/255, green: 135.0/255, blue: 32.0/255, alpha: 1.0)
var appgraycolor = UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0)
var PopUpVC: UIViewController?
var txtfield = UITextField()
var selectedrow = Int()
var refreshControl: UIRefreshControl!
var appver = "1.6.0"

//////////// Marks: - Picker view in keyboard

var rowno = Int()
var arrpickerview = [String]()
var COUNTRYCODE: String?

//MARK:- if ipad
let IPAD = UIDevice().userInterfaceIdiom == .pad
let IPHONE = UIDevice().userInterfaceIdiom == .phone
//MARK:- For Getting Version Build or Build Name
var APPVERSION_ON_APPLE = ""
let APPVERSIONNUMBER = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
let APPBUILDNUMBER = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
let APPBUILDNAME = Bundle.main.infoDictionary?["CFBundleName"] as? String
var IPHONESOSVERSION = UIDevice.current.systemVersion
let DEVICEID = UIDevice.current.identifierForVendor!.uuidString
let BUNDLEID = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
let LOGOUTMESSAGE = "You phone number is no longer registered on this phone. This is likely because you registered your phone number with \(APPBUILDNAME ?? "") on a different phone."
//MARK:- Story Board Declare
//let main = UIStoryboard(name: "Main", bundle: nil)
//let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)

//MARK:- Firebase Auth Verification id
var GlobalFireBaseverficationID = String()
var refFireBase = Database.database().reference()
var refStorageFireBase = Storage.storage().reference()

//MARK:- Firebase DataBase
let PrivateChatDB = refFireBase.child("PrivateChat")
let GroupsDB = refFireBase.child("Groups")
let MessagesDB = refFireBase.child("Messages")
let ChatDB = refFireBase.child("Chat")
let UserDB = refFireBase.child("Users")
let ParticipantsDB = refFireBase.child("Participants")
let IOSVersion = refFireBase.child("Version")

//Participants
var isAndroidUser = Bool()

var userid = String()
var userid2 = String()
var username = String()
var useremail = String()
var usertype = String()
var arrcity = [String]()

var Globalusername = String()
var Globalimage = String()
var Globalemail = String()
var Globalname = String()
var Globaluserid = String()
var Globalphoneno = String()
var Globalcompany_name = String()
var Globalaccount_type = String()
var GLastSeen = String()
var GOtherUserSeeAbout = String()
var ALLCONTACTS = [CNContact]()
var MEDIAPROGRESS = Float()
var USERDATA = NSMutableDictionary()
var NOT_DELIVERED = 2;
var SENT = 2;
var DELIVERED = 3;
var SEEN = 4;
var TEXT = 5;
var AUDIO = 6;
var IMAGE = 7;
var VIDEO = 8;
var LOCATION = 9;
var DOCUMENT = 10;
var CONTACT = 11;
var CREATE_GROUP = 12;
var MESSAGE_DELETED = 13;
var LEFT_GROUP = 14;
var ADD_MEMBER = 15;
var REMOVE_MEMBER = 16;
var GROUP_ADMIN = 17;
var GROUP_INFO_MESSAGE = 18;
var AUDIO_CALL = 21;
var VIDEO_CALL = 22;
var MISSED_CALL = 23;
var MISSED_VIDEO_CALL = 24;
var INCOMING_AUDIO = 25;
var INCOMING_VIDEO = 26;
var TYPING = 27
var RECORDING = 28
var STOP_TYPING_RECORDING = 29
var VIDEOIMAGE = 30
var CELLINCOMMING = 31
var CELLINCOMMINGWITHPIC = 32
var CELLOUTGOING = 33
var CELLOUTGOINGWITHPIC = 34
var CAMERA = 35;
var PROFILEPIC = 11111111
var LINK = 36

//MARK:- Data and Storage Variables
var WIFI_DATA = String()
var MOBILE_DATA = String()
var ROAMING_DATA = String()
var LOW_DATAUSAGE = Bool()
var READ_RECEIPT = Bool()
/////////Sinch Variables
var SinCallDataDic = [String: AnyObject]()

//Core Data

//Singlton instance




var CONTACTKEY = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey] as! [CNKeyDescriptor]
var SHAREMESSAGE = "Hey there, i am using \(APPBUILDNAME ?? "") for message and call.\n\n"
var SHARELINKANDROID = "https://play.google.com/store/apps/details?id=com.zaryansgroup.epoultry&hl=en_US\n\n"
var SHARELINKIOS = "https://apps.apple.com/us/app/epoultry-pk/id1463154294"

var SIGNATURE = "\n\n\(defaults.value(forKey: "fullname") as? String ?? "")\n\t\t\t ____________________\nSent from ePoultry-An interactive mobile app for Pakistan Poultry Industry.\nAndroid: \(SHARELINKANDROID)\niPhone: \(SHARELINKIOS)\n";

let arrcolor = [[appclrContact10, appclrContact11, appclrContact12],[appclrContact21, appclrContact22, appclrContact23],[appclrContact31, appclrContact32, appclrContact33],[appclrContact41, appclrContact42, appclrContact43],[appclrContact51, appclrContact52, appclrContact53],[appclrContact6, appclrContact6, appclrContact6]]

//BASE URL AND API's
//var BASEURL = "http://epoultryapi.zederp.net/api/"
var BASEURL = "https://apiv1.epoultry.pk/api/"
var BASEURL_AONE = "https://apiv2.epoultry.pk/"
//var BASEURLaONECHAT = "http://epapi.aonechat.com/api/"
var BASEURLaONECHAT = BASEURL_AONE+"api/"
//var BASEURL_IMAGES = "https://chatapi.aonechat.com/Media/"
var BASEURL_IMAGES = BASEURL_AONE+"Media/"
public var USER_IMAGE_PATH = userimagepath;
public var GROUP_IMAGE_PATH = BASEURL_IMAGES + "GroupImages/";
let EMPTY_CHAT_INBOX_START = "To start messaging contacts who have ePoultry, tap  "
let EMPTY_CHAT_INBOX_END = "  at the right bottom of your screen"

var REGISTERATION = BASEURLaONECHAT + "User/RegisterUserV2"
var RECTIFYUSER = BASEURLaONECHAT + "User/RectifyUser"
var UPLOAD_USER_IMAGE = BASEURLaONECHAT + "User/PostFile?fcmId=&userId=\(defaults.value(forKey: "userid") as!  String)&filename="

//var SENDCURRENTLOCATION = "https://chatapi.aonechat.com/api/" + "Comm/postlocV2"
var SENDCURRENTLOCATION = BASEURLaONECHAT+"/Comm/postlocV2"
var CUSTOM_AUTHENTICATION = BASEURLaONECHAT+"/user/GetToken?userid=\(group_defaults.object(forKey: "phoneNumber") as! String)&uid=\(group_defaults.object(forKey: "uid") as! String)"
//PostFile?fcmId=&userId=&filename="
var UPLOAD_IMAGE = BASEURLaONECHAT + "Upload/Image/";
var UPLOAD_GROUP_THUMB = BASEURLaONECHAT + "Upload/GroupImage/?filename=";
var UPLOAD_VIDEO = BASEURLaONECHAT + "Upload/Video/";

//var CONTACT_UPLOAD_API = "https://chatapi.aonechat.com/api/Comm/postct"
var CONTACT_UPLOAD_API = BASEURLaONECHAT+"/Comm/postct"

var UID = group_defaults.value(forKey: "uid") as! String
var USERID = defaults.value(forKey: "userid") as! String
//var CUSTOM_AUTHENTICATION = "https://chatapi.aonechat.com/api/user/GetToken?userid=\(group_defaults.object(forKey: "phoneNumber") as! String)&uid=\(group_defaults.object(forKey: "uid") as! String)"

let appclrOtherMessageBg = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
let appclrProfileBG = UIColor(red: 122/255, green: 206/255, blue: 228/255, alpha: 1.0)




//Tariq jamil ki api
//var CONTACT_UPLOAD_API = "https://api2.aonechat.com/api/Comm/postct"
let FIREBASE_SERVERKEY = "AIzaSyDhEnbXJ4To2HfYM_eV8s77BADjUt8O4hA"
let FBASE_SEND_NOTIFICATION_URL = "https://fcm.googleapis.com/fcm/send"

let SINCH_KEY = "d7d43371-ba83-4742-b226-38c7e9cab583"
let SINCH_SECRET_KEY = "NwXfZaWsyUmKroZKOKdAKA=="
let SINCH_URL = "clientapi.sinch.com"
//
//let GOOGLE_SERVICES_KEY = "AIzaSyA-TXMTIe_VCg0gvPYQMjPw18ZlawVfW80"
//let GOOGLE_PLACES_KEY = "AIzaSyA-TXMTIe_VCg0gvPYQMjPw18ZlawVfW80"

let GOOGLE_SERVICES_KEY = "AIzaSyCdeNPJdY9W2eEajaKFXz9DR0Am2iqxOMU"
let GOOGLE_PLACES_KEY = "AIzaSyCdeNPJdY9W2eEajaKFXz9DR0Am2iqxOMU"


let CORE_DB_NAME = "CoreDB"

let GROUPNAME = "group.ePoultry.Zaryan"

var NAVIGATIONBAR_HEIGHT = CGFloat()

let MESSAGECELL_RADIUS = CGFloat(6)

let appclrOwnMessageBg = appclr

let AppTextFieldBorderColor = UIColor(red: 228.0/255, green: 228.0/255, blue: 228.0/255, alpha: 1.0)

//MARK:- Contact Backgroud Circle Color
let appclrContact10 = UIColor(red: 201/255, green: 108/255, blue: 249/255, alpha: 1.0)
let appclrContact11 = UIColor(red: 168/255, green: 153/255, blue: 204/255, alpha: 1.0)
let appclrContact12 = UIColor(red: 96/255, green: 148/255, blue: 231/255, alpha: 1.0)

//255, 51, 90
//231, 128, 205
//255, 3, 213
let appclrContact21 = UIColor(red: 255/255, green: 51/255, blue: 90/255, alpha: 1.0)
let appclrContact22 = UIColor(red: 231/255, green: 128/255, blue: 205/255, alpha: 1.0)
let appclrContact23 = UIColor(red: 255/255, green: 3/255, blue: 213/255, alpha: 1.0)

//38, 255, 0
//128, 231, 210
//3, 196, 255
let appclrContact31 = UIColor(red: 38/255, green: 255/255, blue: 0/255, alpha: 1.0)
let appclrContact32 = UIColor(red: 128/255, green: 231/255, blue: 210/255, alpha: 1.0)
let appclrContact33 = UIColor(red: 3/255, green: 196/255, blue: 255/255, alpha: 1.0)

//255, 0, 0
//255, 152, 0
//255, 218, 0
let appclrContact41 = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
let appclrContact42 = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0)
let appclrContact43 = UIColor(red: 255/255, green: 218/255, blue: 0/255, alpha: 1.0)

//255, 51, 90
//231, 128, 205
//255, 3, 213
let appclrContact51 = UIColor(red: 255/255, green: 51/255, blue: 90/255, alpha: 1.0)
let appclrContact52 = UIColor(red: 231/255, green: 128/255, blue: 205/255, alpha: 1.0)
let appclrContact53 = UIColor(red: 255/255, green: 3/255, blue: 213/255, alpha: 1.0)

let appclrContact6 = UIColor(red: 1.0/255, green: 183.0/255, blue: 233.0/255, alpha: 1.0)

let USERUniqueID = defaults.value(forKey: "phoneno") as? String ?? ""
var USERUID = defaults.value(forKey: "uid") as? String ?? ""
let USERROLE = defaults.value(forKey: "role") as? String ?? "0"
let PRIVATECHAT = "Private Chat"
let PUBLICGROUP = "Public Group"
let SOURCECODE = "ios"

let ALLDOCUMENTSTYPE = ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.video", "public.audio", "public.text", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.pdf", "public.doc"]

let objUserDBM = UsersDBModel()
let objChatDBM = ChatDBModel()
let objMessageDBM = MessagesDBModel()
let objGroupsDBM = GroupsDBModel()
let objParticipantsDBM = ParticipantsDBModel()
let objPrivateChatDBM = PrivateChatDBModel()

var notificationData_userInfo = [AnyHashable:Any]()

var isAppLaunch = false

