//
//  PostInfo.swift
//  AMPL
//
//  Created by sameer on 10/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import Kingfisher

class PostInfo: UIViewController , UITableViewDelegate, UITableViewDataSource
{
 
    var celltag = Int()
    var imgname = String()
    var desc = String()
    var statusid = String()
    var videotag = String()
    
    ////////////////////////////
    var arrdeldatetime = NSMutableArray()
    var arrisdel = NSArray()
    var arrisonline = NSArray()
    var arrisseen = NSArray()
    var arrisuninstall = NSArray()
    var arrlastseen = NSArray()
    var arrlogout = NSArray()
    var arrimgprofile = NSArray()
    var arrseendatetime = NSMutableArray()
    var arrid = NSArray()
    var arrname = NSArray()
    var arrversion = NSArray()
    
    
    ////////////////////////////
    
    
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    /////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // MARK :- navigation title
        self.title = "Information"
        ////////////TAble view Auto Hight rows
        tablev.rowHeight = 128
        tablev.estimatedRowHeight = UITableView.automaticDimension
        
        DispatchQueue.main.async {
            self.getseenlist()
        }
       
    }
    
    ///////////////////////////////////////////////////////////////////////// Marks: - Delegates
    
    // Marks: - Table view datasource and delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrname.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "readcell") as! PostInfoReadCell
                cell.lbldesc.lineBreakMode = .byWordWrapping
                cell.lbldesc.numberOfLines = 0
                
                
                cell.lbldesc.text = desc
                cell.lbldesc.sizeToFit()
                
                if videotag == "1"
                {
                    cell.webv.isHidden = false
                    cell.andicator.startAnimating()
                    let urlvideo = URL(string: videopath+imgname+videoPlayEndPath)
                    cell.webv.allowsInlineMediaPlayback = true
                    cell.webv.mediaPlaybackRequiresUserAction = true

                    cell.webv.loadRequest(NSURLRequest(url: urlvideo!) as URLRequest)
                }
                else
                {
                    let urlimg = URL(string: imagepath+imgname)
                    cell.imgpost.kf.setImage(with: urlimg)
                }
                
                
                return cell

            }
            else
            {
                if arrname.count == indexPath.row
                {
                    let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! PostinfoEmptyCell
                    return cell
                }
                
            }
        }
        else if indexPath.section == 1
        {
            

            if arrisseen.object(at: indexPath.row) as? NSNumber == 1
            {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "seencell") as! PostInfoSeenCell
                cell.lblname.text = "\(arrname.object(at: indexPath.row) as! String)"
                cell.lbltime.text = String("\(arrdeldatetime.object(at: indexPath.row))")
                // pictuer load
                let urlprofile = URL(string: imagepath+"\(arrimgprofile[indexPath.row])")
                cell.imgvprofile.kf.setImage(with: urlprofile)
                
                return cell
            }
            else
            {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! PostinfoEmptyCell
                return cell
            }
        }
        else if indexPath.section == 2
        {
            if arrisdel.object(at: indexPath.row) as? NSNumber == 1
            {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "delivercell") as! PostInfoDeliverCell
                cell.lblname.text = arrname.object(at: indexPath.row) as? String
                cell.lbltime.text = String("\(arrdeldatetime.object(at: indexPath.row))")
                
                // pictuer load
                let urlprofile = URL(string: imagepath+"\(arrimgprofile[indexPath.row])")
                cell.imgvprofile.kf.setImage(with: urlprofile)
                
                return cell
            }
            else
            {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! PostinfoEmptyCell
                return cell
            }
        }
        else if indexPath.section == 3
        {
            if arrisdel.object(at: indexPath.row) as? NSNumber == 0
            {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "notdelivercell") as! PostInfoNotDeliverCell
                cell.lblname.text = "\(arrname.object(at: indexPath.row) as! String)"
                cell.lbllastseen.text = "Lastseen "+(arrseendatetime.object(at: indexPath.row) as? String)!
                cell.lblversion.text = "Version "+(arrversion.object(at: indexPath.row) as? String)!
                
                // pictuer load
                let urlprofile = URL(string: imagepath+"\(arrimgprofile[indexPath.row])")
                cell.imgvprofile.kf.setImage(with: urlprofile)
                
                
                return cell
            }
            else
            {
                let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! PostinfoEmptyCell
                return cell
            }

        }
        else
        {
            let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! PostinfoEmptyCell
            return cell
        }
        let cell = self.tablev.dequeueReusableCell(withIdentifier: "cell") as! PostinfoEmptyCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewh = UIView()
        let label = UILabel()
        viewh.frame = CGRect(x: 10, y: 0, width: self.view.frame.size.width - 20 , height: 40)
        label.frame = CGRect(x: 10, y: 40, width: self.view.frame.size.width - 20 , height: 40)
        label.backgroundColor = appcolor
        if section == 0
        {
             viewh.frame = CGRect(x: 0 , y: 0, width: 0 , height: 0)
             label.frame = CGRect(x: 0 , y: 0, width: 0 , height: 0)
            return viewh
        }
        else if section == 1
        {
            if arrname.count > 0
            {
                label.text = "Read by"
            }
        }
        else if section == 2
        {
            if arrname.count > 0
            {
                label.text = "Delivered to"
            }
        }
        else if section == 3
        {
            if arrname.count > 0
            {
                label.text = "Not Delivered to"
            }
        }
        
        label.backgroundColor = UIColor.white
        viewh.backgroundColor = UIColor.clear
        
        
        
        viewh.addSubview(label)
        
        return viewh
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 1
        {
                    let label = UILabel()
                    label.textAlignment = .left
                 label.text = "Seen By"            //
                    label.backgroundColor = UIColor.init(red:66/255.0, green: 165/255.0, blue: 245/255.0, alpha: 1.0)
                    label.textColor = UIColor.black
    
                    }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                return UITableView.automaticDimension
            }
            else
            {
                return 0.0
            }
        }
        else if indexPath.section == 1
        {
            if arrisseen.object(at: indexPath.row) as? NSNumber == 1
            {
               return 105
            }
            else
            {
                return 0.0
            }
        }
        else if indexPath.section == 2
        {
            if arrisdel.object(at: indexPath.row) as? NSNumber == 1
            {
               return 105
            }
            else
            {
                return 0.0
            }
        }
        else if indexPath.section == 3
        {
            if arrisdel.object(at: indexPath.row) as? NSNumber == 0
            {
               return 105
            }
            else
            {
                return 0.0
            }
            
        }
        else
        {
            return (0.0)
        }
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
               return UITableView.automaticDimension
            }
            else
            {
                return 0.0
            }
        }
        else if indexPath.section == 1
        {
            if arrisseen.object(at: indexPath.row) as? NSNumber == 1
            {
                return 105
            }
            else
            {
                return 0.0
            }
        }
        else if indexPath.section == 2
        {
            if arrisdel.object(at: indexPath.row) as? NSNumber == 1
            {
                return 105
            }
            else
            {
                return 0.0
            }
        }
        else if indexPath.section == 3
        {
            if arrisdel.object(at: indexPath.row) as? NSNumber == 0
            {
                return 105
            }
            else
            {
                return 0.0
            }
            
        }
        else
        {
            return (0.0)
        }

    }
    
    
    ////////////////////////////////
    // Marks: - Get all comments
    func getseenlist()
    {
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><getStatusSeenList xmlns='http://threepin.org/'><statusId>\(statusid)</statusId></getStatusSeenList></soap:Body></soap:Envelope>"
        
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://websrv.zederp.net/Apml/GroupService.asmx"
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
                dictionaryData as NSDictionary
                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "getStatusSeenListResponse")! as Any) as AnyObject).object(forKey:"getStatusSeenListResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
                    
                    
                    let text = mainD.value(forKey: "text") as! NSString
                    
                    ///                    var dictonary:NSDictionary?
                    
                    //                    if let data = text.data(using: String.Encoding.utf8.rawValue) {
                    //
                    //                        do {
                    //                            dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                    //
                    //                            if let myDictionary = dictonary
                    //                            {
                    //
                    //                                let arrseenCount = myDictionary.value(forKey: "SeenCount") as! NSArray
                    //                                let arrseenList = myDictionary.value(forKey: "SeenList") as! NSArray
                    //
                    //                                for arrdata in arrseenList
                    //                                {
                    //                                    let dicdata = arrdata as! NSDictionary
                    //                                   if  dicdata.value(forKey: "IsDelivered") as! NSNumber == 1
                    //                                   {
                    //
                    //                                    }
                    //                                    else if  dicdata.value(forKey: "IsDelivered") as! NSNumber == 0
                    //                                   {
                    //
                    //                                    }
                    //
                    //                                }
                    //                            }
                    //                        } catch let error as NSError {
                    //                            print(error)
                    //                        }
                    //                    }
                    //
                    
                    
                    
                    
                    
                    
                    
                    //////////////////////////
                    let array = self.convertToDictionary(text: text as String)
                    
                    
                    
                    _ = array?["TotalSeen"] as? [[String:Any]]
                    var count = array?.count
                    
                    if count! > 0
                    {
                        count = 0
                        for (dict) in array! {
                            
                            if count == 0
                            {
                                let  array = dict.value as! NSArray
                                
                                print(array.value(forKey: "TotalDelivered"))
                                print(array.value(forKey: "TotalSeen"))
                                
                            }
                            else
                            {
                                let  dic = dict.value as! NSArray
                                
                                let tempdatetimedel = dic.value(forKey: "DeliveredDatetime") as!  NSArray
                                self.arrisdel = dic.value(forKey: "IsDelivered") as! NSArray
                                
                                self.arrisonline = dic.value(forKey: "IsOnline") as! NSArray
                                self.arrisseen = dic.value(forKey: "IsSeen") as!  NSArray
                                self.arrisuninstall = dic.value(forKey: "IsUnistall") as! NSArray
                                self.arrlastseen = dic.value(forKey: "LastSeen") as!  NSArray
                                self.arrlogout = dic.value(forKey: "Logout") as!  NSArray
                                self.arrimgprofile = dic.value(forKey: "ProfilePic") as! NSArray
                                let tempseendate = dic.value(forKey: "SeenDatetime") as! NSArray
                                self.arrid = dic.value(forKey: "id") as!  NSArray
                                self.arrname = dic.value(forKey: "name") as! NSArray
                                self.arrversion = dic.value(forKey: "version") as!  NSArray
                                
                                for td in tempdatetimedel
                                {
                                    let str = String(format:"%@", td as! CVarArg)
                                    if str == "<null>"
                                    {
                                        self.arrdeldatetime.add("")
                                    }
                                    else
                                    {
                                        let prefix = "/Date("
                                        let suffix = ")/"
                                        let scanner = Scanner(string: str )
                                        // Check prefix:
                                        if scanner.scanString(prefix, into: nil) {
                                            
                                            // Read milliseconds part:
                                            var milliseconds : Int64 = 0
                                            if scanner.scanInt64(&milliseconds) {
                                                // Milliseconds to seconds:
                                                var timeStamp = TimeInterval(milliseconds)/1000.0
                                                
                                                // Read optional timezone part:
                                                var timeZoneOffset : Int = 0
                                                if scanner.scanInt(&timeZoneOffset) {
                                                    let hours = timeZoneOffset / 100
                                                    let minutes = timeZoneOffset % 100
                                                    // Adjust timestamp according to timezone:
                                                    timeStamp += TimeInterval(3600 * hours + 60 * minutes)
                                                }
                                                
                                                // Check suffix:
                                                if scanner.scanString(suffix, into: nil) {
                                                    // Success! Create NSDate and return.
                                                    //self(timeIntervalSince1970: timeStamp)
                                                    let date = NSDate(timeIntervalSince1970: timeStamp)
                                                    
                                                    
                                                    //print(agotime)
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                                                    dateFormatter.locale = NSLocale.current
                                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                                                    let strDate = dateFormatter.string(from: date as Date)
                                                    let ddate = dateFormatter.date(from: strDate)
                                                    
                                                    let agotime =  self.timeAgoSinceDate(date: ddate! as NSDate, numericDates: true)
                                                    //print(agotime)
                                                    self.arrdeldatetime.add(agotime)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                for td in tempseendate
                                {
                                    let str = String(format:"%@", td as! CVarArg)
                                    if str == "<null>"
                                    {
                                        self.arrseendatetime.add("")
                                    }
                                    else
                                    {
                                        let prefix = "/Date("
                                        let suffix = ")/"
                                        let scanner = Scanner(string: str )
                                        // Check prefix:
                                        if scanner.scanString(prefix, into: nil) {
                                            
                                            // Read milliseconds part:
                                            var milliseconds : Int64 = 0
                                            if scanner.scanInt64(&milliseconds) {
                                                // Milliseconds to seconds:
                                                var timeStamp = TimeInterval(milliseconds)/1000.0
                                                
                                                // Read optional timezone part:
                                                var timeZoneOffset : Int = 0
                                                if scanner.scanInt(&timeZoneOffset) {
                                                    let hours = timeZoneOffset / 100
                                                    let minutes = timeZoneOffset % 100
                                                    // Adjust timestamp according to timezone:
                                                    timeStamp += TimeInterval(3600 * hours + 60 * minutes)
                                                }
                                                
                                                // Check suffix:
                                                if scanner.scanString(suffix, into: nil) {
                                                    // Success! Create NSDate and return.
                                                    //self(timeIntervalSince1970: timeStamp)
                                                    let date = NSDate(timeIntervalSince1970: timeStamp)
                                                    
                                                    
                                                    //print(agotime)
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                                                    dateFormatter.locale = NSLocale.current
                                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                                                    let strDate = dateFormatter.string(from: date as Date)
                                                    let ddate = dateFormatter.date(from: strDate)
                                                    
                                                    let agotime =  self.timeAgoSinceDate(date: ddate! as NSDate, numericDates: true)
                                                    //print(agotime)
                                                    self.arrseendatetime.add(agotime)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            count = count! + 1
                        }
                        
                        
                        self.tablev.reloadData()
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

        // AFNETWORKING REQUEST
        
        // let mn = AFHTTPRequestOperation()
        
//        let manager = AFHTTPRequestOperation(request: mutableR as URLRequest)
//        
//        andicator.startAnimating()
//        manager.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation, responseObject : Any) -> Void in
//            
//            self.andicator.stopAnimating()
//            var dictionaryData = NSDictionary()
//            
//            do
//            {
//                dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! Data)) as NSDictionary
//                
//                let mainDict = ((((((dictionaryData.object(forKey: "soap:Envelope")! as Any) as AnyObject).object(forKey: "soap:Body")! as Any) as AnyObject).object(forKey: "getStatusSeenListResponse")! as Any) as AnyObject).object(forKey:"getStatusSeenListResult")   ?? NSDictionary()
//                
//                if (mainDict as AnyObject).count > 0{
//                    
//                    let mainD = NSDictionary(dictionary: mainDict as! NSDictionary)
//                    
//                    
//                    let text = mainD.value(forKey: "text") as! NSString
//                    
/////                    var dictonary:NSDictionary?
//                    
////                    if let data = text.data(using: String.Encoding.utf8.rawValue) {
////                        
////                        do {
////                            dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
////                            
////                            if let myDictionary = dictonary
////                            {
////                                
////                                let arrseenCount = myDictionary.value(forKey: "SeenCount") as! NSArray
////                                let arrseenList = myDictionary.value(forKey: "SeenList") as! NSArray
////                                
////                                for arrdata in arrseenList
////                                {
////                                    let dicdata = arrdata as! NSDictionary
////                                   if  dicdata.value(forKey: "IsDelivered") as! NSNumber == 1
////                                   {
////                                    
////                                    }
////                                    else if  dicdata.value(forKey: "IsDelivered") as! NSNumber == 0
////                                   {
////                                    
////                                    }
////                                    
////                                }
////                            }
////                        } catch let error as NSError {
////                            print(error)
////                        }
////                    }
////                    
//                    
//                    
//                    
//                    
//                    
//                    
//                    
//                    //////////////////////////
//                    let array = self.convertToDictionary(text: text as String)
//                    
//                    
//                    
//                    _ = array?["TotalSeen"] as? [[String:Any]]
//                    var count = array?.count
//                    
//                    if count! > 0
//                    {
//                        count = 0
//                        for (dict) in array! {
//                            
//                            if count == 0
//                            {
//                                let  array = dict.value as! NSArray
//                                
//                                print(array.value(forKey: "TotalDelivered"))
//                                print(array.value(forKey: "TotalSeen"))
//                                
//                            }
//                            else
//                            {
//                                let  dic = dict.value as! NSArray
//                                
//                                    let tempdatetimedel = dic.value(forKey: "DeliveredDatetime") as!  NSArray
//                                    self.arrisdel = dic.value(forKey: "IsDelivered") as! NSArray
//                                    
//                                    self.arrisonline = dic.value(forKey: "IsOnline") as! NSArray
//                                    self.arrisseen = dic.value(forKey: "IsSeen") as!  NSArray
//                                    self.arrisuninstall = dic.value(forKey: "IsUnistall") as! NSArray
//                                    self.arrlastseen = dic.value(forKey: "LastSeen") as!  NSArray
//                                    self.arrlogout = dic.value(forKey: "Logout") as!  NSArray
//                                    self.arrimgprofile = dic.value(forKey: "ProfilePic") as! NSArray
//                                    let tempseendate = dic.value(forKey: "SeenDatetime") as! NSArray
//                                    self.arrid = dic.value(forKey: "id") as!  NSArray
//                                    self.arrname = dic.value(forKey: "name") as! NSArray
//                                    self.arrversion = dic.value(forKey: "version") as!  NSArray
//                          
//                                for td in tempdatetimedel
//                                {
//                                    let str = String(format:"%@", td as! CVarArg)
//                                    if str == "<null>"
//                                    {
//                                        self.arrdeldatetime.add("")
//                                    }
//                                    else
//                                    {
//                                        let prefix = "/Date("
//                                        let suffix = ")/"
//                                        let scanner = Scanner(string: str )
//                                        // Check prefix:
//                                        if scanner.scanString(prefix, into: nil) {
//                                            
//                                            // Read milliseconds part:
//                                            var milliseconds : Int64 = 0
//                                            if scanner.scanInt64(&milliseconds) {
//                                                // Milliseconds to seconds:
//                                                var timeStamp = TimeInterval(milliseconds)/1000.0
//                                                
//                                                // Read optional timezone part:
//                                                var timeZoneOffset : Int = 0
//                                                if scanner.scanInt(&timeZoneOffset) {
//                                                    let hours = timeZoneOffset / 100
//                                                    let minutes = timeZoneOffset % 100
//                                                    // Adjust timestamp according to timezone:
//                                                    timeStamp += TimeInterval(3600 * hours + 60 * minutes)
//                                                }
//                                                
//                                                // Check suffix:
//                                                if scanner.scanString(suffix, into: nil) {
//                                                    // Success! Create NSDate and return.
//                                                    //self(timeIntervalSince1970: timeStamp)
//                                                    let date = NSDate(timeIntervalSince1970: timeStamp)
//                                                    
//                                                    
//                                                    //print(agotime)
//                                                    let dateFormatter = DateFormatter()
//                                                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//                                                    dateFormatter.locale = NSLocale.current
//                                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
//                                                    let strDate = dateFormatter.string(from: date as Date)
//                                                    let ddate = dateFormatter.date(from: strDate)
//                                                    
//                                                    let agotime =  self.timeAgoSinceDate(date: ddate! as NSDate, numericDates: true)
//                                                    //print(agotime)
//                                                    self.arrdeldatetime.add(agotime)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                                
//                                for td in tempseendate
//                                {
//                                    let str = String(format:"%@", td as! CVarArg)
//                                    if str == "<null>"
//                                    {
//                                        self.arrseendatetime.add("")
//                                    }
//                                    else
//                                    {
//                                        let prefix = "/Date("
//                                        let suffix = ")/"
//                                        let scanner = Scanner(string: str )
//                                        // Check prefix:
//                                        if scanner.scanString(prefix, into: nil) {
//                                            
//                                            // Read milliseconds part:
//                                            var milliseconds : Int64 = 0
//                                            if scanner.scanInt64(&milliseconds) {
//                                                // Milliseconds to seconds:
//                                                var timeStamp = TimeInterval(milliseconds)/1000.0
//                                                
//                                                // Read optional timezone part:
//                                                var timeZoneOffset : Int = 0
//                                                if scanner.scanInt(&timeZoneOffset) {
//                                                    let hours = timeZoneOffset / 100
//                                                    let minutes = timeZoneOffset % 100
//                                                    // Adjust timestamp according to timezone:
//                                                    timeStamp += TimeInterval(3600 * hours + 60 * minutes)
//                                                }
//                                                
//                                                // Check suffix:
//                                                if scanner.scanString(suffix, into: nil) {
//                                                    // Success! Create NSDate and return.
//                                                    //self(timeIntervalSince1970: timeStamp)
//                                                    let date = NSDate(timeIntervalSince1970: timeStamp)
//                                                    
//                                                    
//                                                    //print(agotime)
//                                                    let dateFormatter = DateFormatter()
//                                                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//                                                    dateFormatter.locale = NSLocale.current
//                                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
//                                                    let strDate = dateFormatter.string(from: date as Date)
//                                                    let ddate = dateFormatter.date(from: strDate)
//                                                    
//                                                    let agotime =  self.timeAgoSinceDate(date: ddate! as NSDate, numericDates: true)
//                                                    //print(agotime)
//                                                    self.arrseendatetime.add(agotime)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            count = count! + 1
//                        }
//                        
//                        
//                        self.tablev.reloadData()
//                    }
//                    else{
//                        
//                        obj.showAlert(title: "Alert", message: "try again", viewController: self)
//                        
//                    }
//                }
//            }
//            catch
//            {
//                print("Your Dictionary value nil")
//            }
//            
//            print(dictionaryData)
//            
//            
//        }, failure: { (operation : AFHTTPRequestOperation, error :Error) -> Void in
//            
//            print(error, terminator: "")
//            self.andicator.stopAnimating()
//            obj.showAlert(title: "Alert!", message: error.localizedDescription, viewController: self)
//        })
//        
//        manager.start()
    }
    
    func convertToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //////////////////// Marks: - Get time in since time ago
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }

}

