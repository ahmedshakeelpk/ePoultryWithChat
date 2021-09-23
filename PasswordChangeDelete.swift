//
//  PasswordChangeDelete.swift
//  ZedChat
//
//  Created by MacBook Pro on 31/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class PasswordChangeDelete: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let arrtitle = ["Change Password", "Remove Password"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "PersonalInfoCell") as! PersonalInfoCell
        
        cell.lbltitle.text = arrtitle[indexPath.row]
        cell.lblselection.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrtitle[indexPath.row] == "Remove Password"{
            funRemovePassword()
        }
        else if arrtitle[indexPath.row] == "Change Password"{
            funLockScreen(viewController: self, isCancelButton: true, type: "change")
        }
    }
    @objc func funback()
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var tablev: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "PersonalInfoCell", bundle: nil), forCellReuseIdentifier: "PersonalInfoCell")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        
        self.title = "Setting Lock Screen"
        tablev.tableFooterView = UIView()
    }
    
    func funRemovePassword()
    {
        let alert = UIAlertController(title: "Security!", message: "Are you sure you want to Remove App Lock Screen password?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        { (action) in
            //self.dissmiss()
        }
        let Share = UIAlertAction(title: "Remove", style: .default)
        { (action) in
            defaults.setValue(nil, forKey: "lockpassword")
            defaults.setValue("0", forKey: "isLock")
            self.funback()
        }
        alert.addAction(cancel)
        alert.addAction(Share)
        DispatchQueue.main.async{
            self.present(alert, animated: true)
        }
    }
    


}
