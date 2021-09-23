//
//  Groups.swift
//  AMPL
//
//  Created by sameer on 02/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit
import Kingfisher


class Groups: UIViewController, UITableViewDataSource, UITableViewDelegate {
    /////////////////
   var load = String()
    ///
   
    var arrActiveMember = [Any]()
    var arrChat = [Any]()
    var arrChatDatetime = [Any]()
    var arrCreatedBy = [Any]()
    var arrCreatedTime = [Any]()
    var arrGroupCount = [Any]()
    var arrGroupId = [Any]()
    var arrGroupProfilePic = [Any]()
    var arrGroupTitle = [Any]()
    var arrInActiveMember = [Any]()
    var arrLastMessageType = [Any]()
    var arrTotal = [Any]()
    var arrType = [Any]()
    var arruserstatus = [Any]()
    
    @IBOutlet weak var btnaddgroup: UIButton!
    let refresh = UIRefreshControl()
    
    ///////////////////////////////////////
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    override func viewDidDisappear(_ animated: Bool) {
        defaults.setValue("", forKey: "view")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defaults.setValue("Groups", forKey: "view")
        
        /////
        
        DispatchQueue.main.async {
            self.getallgroups()
        }
        
    }
   
    override func viewDidLoad() {
        
        let popvc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "Chats") as! Chats
        self.addChild(popvc)
        popvc.view.frame = self.view.frame
        self.view.addSubview(popvc.view)
        
        popvc.view.frame.origin.y = STATUSBAR_HEIGHT
        popvc.view.frame.size.height = (tabBarController?.tabBar.frame.minY)!
            //- (self.navigationController?.navigationBar.frame.maxY)!
        
        
        //self.view.frame.origin.y = (self.navigationController?.navigationBar.frame.maxY)!
               self.view.frame.size.height = (tabBarController?.tabBar.frame.minY)!
              
        
        
        //popvc.didMove(toParent: viewController)
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Configure the view for the selected state
//        DispatchQueue.main.async {
//            for view in self.view.subviews {
//                //self.btnaddchannel.sendSubviewToBack(view)
//            }
//            //self.view.addSubview(self.btnaddchannel)
//        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
               // getallgroups()
        
//        // MARK : - Remove Notification
//        NotificationCenter.default.removeObserver(self)
//        // Comment to receive notification
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshh), name: NSNotification.Name(rawValue: "updategroupstatus"), object: nil)
//
//        tablev.rowHeight = 128
//        tablev.estimatedRowHeight = UITableView.automaticDimension
//
//        tablev.tableFooterView = UIView()
//        load = "1"
//        // MARK : - UIRefresh controll in table View
//
//        tablev.delegate = self
//        tablev.dataSource = self
//        refresh.attributedTitle = NSAttributedString(string: "Pull to Refresh")
//        refresh.addTarget(self, action: #selector(refreshh), for: UIControl.Event.valueChanged)
//        tablev.addSubview(refresh) // not required when using UITableViewController
//        let role = defaults.value(forKey: "role") as? String
//
//        if role != "1"
//        {
//           //btnaddgroup.isHidden = true
//        }
//
//        btnaddgroup.layer.cornerRadius = btnaddgroup.frame.width / 2
        
        //self.getallgroups()
    }
    
     // Marks: - Button addgroup
    @IBAction func btnaddgroup(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewGroup") as! NewGroup
        //vc.memberid = arrgroupid[]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    //MARK: - Refresh if no group found
    @objc func refreshh()
    { 
        getallgroups()
    }
    
        // Marks: - Delegates
/////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Marks: - Table view datasource and delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGroupId.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tablev.dequeueReusableCell(withIdentifier: "GroupsCell") as! GroupsCell
        cell.lblname.text = arrGroupTitle[indexPath.row] as? String
        cell.lblmsg.numberOfLines = 0
        cell.lblmsg.lineBreakMode = .byWordWrapping
        cell.lblmsg.text = arrChat[indexPath.row] as? String
        cell.lblmsg.sizeToFit()
        //Kingfisher Image upload
//        if let imgname = arrprofile_img[indexPath.row] as? String
//        {
//            let urlprofile = URL(string: imagepath+imgname)
//            cell.imgv.kf.setImage(with: urlprofile!)
//        }
        
        if let CreatedOn = arrCreatedTime[indexPath.row] as? String
        {
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
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupPosts") as! GroupPosts
        vc.groupid = "\(self.arrGroupId[indexPath.row])"
        vc.type = "group"
        vc.strtitle = "\(arrGroupTitle[indexPath.row])"
        vc.groupimage = "\(arrGroupProfilePic[indexPath.row])"
        /////// Marks: - For Groups Array
        vc.arrgtitle = arrGroupTitle as! [String]
        vc.arrgtype = arrType as! [String]
        vc.arrgid = arrGroupId as NSArray
        vc.arrgimgprofile = arrGroupProfilePic as! [String]
        vc.arrgtotalmember = arrTotal 
        vc.arrguserstatus = arruserstatus
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
            self.arrGroupCount[indexPath.row] = "0" as String
            let indexPath = IndexPath(item: indexPath.row, section: 0)
            self.tablev.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    
    func getallgroups()
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
       // let url = BASEURL+"group/GetAllGroups?userId=\(userid))&role=\(USERROLE)"
        let url = BASEURL+"channels/\(userid)?tags=All&admin=\(USERROLE)"
        
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGet(url: url, completionHandler:
            {
                responseObject, error in
                self.refresh.endRefreshing()
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let tempdatadic = (responseObject as [Dictionary<String, Any>]?)
                            let datadic = tempdatadic! as NSArray
                            if datadic.count > 0
                            {
                                let dataarr = (datadic)
                                
                                self.arrActiveMember = (dataarr ).value(forKey: "ActiveMember") as! [Any]
                                self.arrChat = (dataarr ).value(forKey: "Chat") as! [Any]
                                
                                self.arrChatDatetime = (dataarr ).value(forKey: "ChatDatetime") as! [Any]
                                
                                self.arrCreatedBy = (dataarr ).value(forKey: "CreatedBy") as! [Any]
                                
                                self.arrCreatedTime = (dataarr ).value(forKey: "CreatedTime") as! [Any]
                                
                                self.arrGroupCount = (dataarr ).value(forKey: "GroupCount") as! [Any]
                                
                                self.arrGroupId = (dataarr ).value(forKey: "GroupId") as! [Any]
                                
                                self.arrGroupProfilePic = (dataarr ).value(forKey: "GroupProfilePic") as! [Any]
                                
                                self.arrGroupTitle = (dataarr ).value(forKey: "GroupTitle") as! [Any]
                                
                                self.arrInActiveMember = (dataarr ).value(forKey: "InActiveMember") as! [Any]
                                
                                self.arrLastMessageType = (dataarr ).value(forKey: "LastMessageType") as! [Any]
                                
                                self.arrTotal = (dataarr ).value(forKey: "Total") as! [Any]
                                
                                self.arrType = (dataarr ).value(forKey: "Type") as! [Any]
                                self.arruserstatus = (dataarr ).value(forKey: "userstatus") as! [Any]
                                self.tablev.reloadData()
                                //self.GetLikeCounts(statusid: statusid, likes: "")
                            }
                            else
                            {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else
                        {
                           // obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                          obj.showAlert(title: "Error", message: error ?? "", viewController: self)
                    }
                }
        })
    }
}


