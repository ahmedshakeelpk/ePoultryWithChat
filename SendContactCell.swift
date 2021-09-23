//
//  SendContactCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 10/06/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class SendContactCell: UITableViewCell {

    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var vbg: UIImageView!
    @IBOutlet weak var imgvcontact: UIImageView!
    @IBOutlet weak var vbgcontactimg: UIImageView!
    @IBOutlet weak var vbgpurple: UIImageView!
    @IBOutlet weak var imgvmsgstatus: UIImageView!
    @IBOutlet weak var vselection: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vbg.layer.cornerRadius = MESSAGECELL_RADIUS
        vbg.backgroundColor = appclrOwnMessageBg
        lblmsg.textColor = .white
        vselection.backgroundColor = appclrOwnMessageBg
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
