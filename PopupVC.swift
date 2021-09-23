//
//  PopupVC.swift
//  ZedChat
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class PopupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewController = UIViewController()
    var isDeleteForEveryOne = Int()
    @IBOutlet weak var tablev: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.frame.origin.y = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //MARK:- Register Cell for Send and Receive Message
        self.tablev.register(UINib(nibName: "DeleteMsgEveryOneCell", bundle: nil), forCellReuseIdentifier: "DeleteMsgEveryOneCell")
        self.tablev.register(UINib(nibName: "DeleteMsgForMeCell", bundle: nil), forCellReuseIdentifier: "DeleteMsgForMeCell")
        NotificationCenter.default.addObserver(self, selector: #selector(handleMsgNotificaions), name: NSNotification.Name(rawValue: "removePopup"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDeleteForEveryOne == 1
        {
            let cell = tablev.dequeueReusableCell(withIdentifier: "DeleteMsgEveryOneCell") as! DeleteMsgEveryOneCell
            cell.viewController = viewController
            obj.setViewShade(view: cell.bgv)
            return cell
        }
        else
        {
            let cell = tablev.dequeueReusableCell(withIdentifier: "DeleteMsgForMeCell") as! DeleteMsgForMeCell
            cell.viewController = viewController
            obj.setViewShade(view: cell.bgv)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isDeleteForEveryOne == 1
        {
            if IPAD{
                return 426
            }
            return 213
        }
        else
        {
            if IPAD{
                return 244
            }
            return 122
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if IPAD
        {
            return 300
        }
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    @objc func handleMsgNotificaions(notification: Notification)
    {
        if notification.name.rawValue == "removePopup"
        {
            objG.removeVerificationPopup()
        }
    }

}
