//
//  CompanyDetails.swift
//  ePoltry
//
//  Created by MacBook Pro on 07/05/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class CompanyDetails: UIViewController {

    var companyname = String()
    var address = String()
    var phone = String()
    var fax = String()
    var email = String()
    var strimg = String()
    var desc = String()
    var latitude = String()
    var longitude = String()
    var catid = String()
    @IBOutlet weak var bgvmap: UIView!
    @IBOutlet weak var bgvtop: UIView!
    
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblfax: UILabel!
    @IBOutlet weak var lbladdress: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    
    @IBOutlet weak var btnmap: UIButton!
    @IBOutlet weak var lblphone: UILabel!
    @IBAction func btnmap(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "CompanyMap") as! CompanyMap
        vc.latitude = latitude
        vc.longitude = longitude
        vc.catid = catid
        vc.name = companyname
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //MARK:- Navigation Title Multilines
        obj.navigationTwoLineTitle(topline: "ePoultry", bottomline: "Smart Poultry System", viewcontroller: self)
        
        bgvmap.layer.cornerRadius = 8
        bgvmap.layer.borderWidth = 1
        bgvmap.layer.borderColor = UIColor.gray.cgColor
        
        lbladdress.lineBreakMode = .byWordWrapping
        lbladdress.numberOfLines = 0
        lbldesc.lineBreakMode = .byWordWrapping
        lbldesc.numberOfLines = 0
        
        lblname.text = companyname
        lblphone.text = phone
        lbladdress.text = address
        lblfax.text = fax
        lbldesc.text = desc
        
        lbladdress.sizeToFit()
        lbldesc.sizeToFit()
        DispatchQueue.main.async {
            self.lbldesc.frame.origin.y = self.lbladdress.frame.maxY + 10
            self.bgvtop.frame.size.height = self.lbldesc.frame.maxY + 20
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
