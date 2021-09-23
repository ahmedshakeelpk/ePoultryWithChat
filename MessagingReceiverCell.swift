//
//  MessagingReceiverCell.swift
//  TeleMedican
//
//  Created by IOS Dev on 02/05/2018.
//  Copyright © 2018 Paragon Marketing. All rights reserved.
//

import UIKit
import GoogleMaps

class MessagingReceiverCell: UITableViewCell {

    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var imgvbg: UIImageView!
    @IBOutlet weak var vformap: GMSMapView!
    @IBOutlet weak var imgvmsgstatus: UIImageView!

    @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var imgvplayvideo: UIImageView!
    @IBOutlet weak var imgvreceiver: UIImageView!
    @IBOutlet weak var btnmap: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblcurrentvoicetime: UILabel!
    @IBOutlet weak var lbltotalvoicetime: UILabel!
   
    @IBOutlet weak var vselection: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgvbg.layer.cornerRadius = MESSAGECELL_RADIUS
        imgvbg.backgroundColor = appclrOwnMessageBg
        vselection.backgroundColor = appclrOwnMessageBg
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if IPAD
        {
            if slider != nil{
                let ypoint = btnplay.center.y
                self.slider.frame.origin.y = ypoint - (self.slider.frame.size.height / 2)
            }
        }
        else
        {
            if slider != nil{
                self.slider.setThumbImage(UIImage.init(named: "slider"), for: .normal)
                self.btnplay.imageView?.setImageColor(color: .white)
            }
        }
        
    }

}
