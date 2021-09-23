//
//  imgSenderCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 14/10/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class imgCaptionSenderCell: UITableViewCell {

    @IBOutlet weak var lbltime: UILabel!
       @IBOutlet weak var lblmsg: UILabel!
       @IBOutlet weak var imgv: UIImageView!
       @IBOutlet weak var imgvbg: UIImageView!
       @IBOutlet weak var vselection: UIView!
       @IBOutlet weak var imgvmsgstatus: UIImageView!

       @IBOutlet weak var imgvplayvideo: UIImageView!
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgv.layer.borderWidth = 1
        imgv.layer.borderColor = UIColor.yellow.cgColor
        imgv.layer.cornerRadius = MESSAGECELL_RADIUS
        obj.setImageViewShade(imageview: imgvbg)
        
        imgvbg.layer.cornerRadius = MESSAGECELL_RADIUS
        imgvbg.backgroundColor = appclrOwnMessageBg
        lblmsg.textColor = .white
        vselection.backgroundColor = appclrOwnMessageBg
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
