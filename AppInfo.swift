//
//  AppInfo.swift
//  ZedChat
//
//  Created by MacBook Pro on 28/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class AppInfo: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBOutlet weak var lblappversion: UILabel!
    @IBOutlet weak var bhview: UIView!
    
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var lbllicense: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "App Info"

        self.lblappversion.text = "App Version: \(String(describing: APPVERSIONNUMBER!))"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        
        lbldesc.frame.origin.y = imgv.frame.maxY + 20
        lbldesc.numberOfLines = 0
        lbldesc.lineBreakMode = .byWordWrapping
        
        DispatchQueue.main.async {
            self.lbldesc.text = "© 2019 ePoultry\nDeveloped by Zaryans Consulting PVT Ltd.\nAll Rights Reserved"
            self.lbldesc.sizeToFit()
            self.lbldesc.center.x = self.view.center.x
            self.lbllicense.frame.origin.y = self.lbldesc.frame.maxY + 10
        }
    }
    @objc func funback() {
        self.navigationController?.popViewController(animated: true)
    }

}
