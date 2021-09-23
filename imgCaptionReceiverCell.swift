//
//  imgReceiverCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 14/10/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class imgCaptionReceiverCell: UITableViewCell {

     @IBOutlet weak var lbltime: UILabel!
      @IBOutlet weak var lblmsg: UILabel!
      @IBOutlet weak var imgv: UIImageView!
      @IBOutlet weak var imgvbg: UIImageView!
      @IBOutlet weak var btnplay: UIButton!
      @IBOutlet weak var imgvplayvideo: UIImageView!
      
      @IBOutlet weak var vselection: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgv.layer.borderWidth = 1
        imgv.layer.borderColor = UIColor.yellow.cgColor
        imgv.layer.cornerRadius = MESSAGECELL_RADIUS
        obj.setImageViewShade(imageview: imgvbg)
        
        imgvbg.layer.cornerRadius = MESSAGECELL_RADIUS
        imgvbg.backgroundColor = appclrOtherMessageBg
        vselection.backgroundColor = appclrOwnMessageBg
        lblmsg.textColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
