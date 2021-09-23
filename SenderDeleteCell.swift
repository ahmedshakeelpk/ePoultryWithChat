//
//  SenderDeleteCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 01/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class SenderDeleteCell: UITableViewCell {
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var vbg: UIImageView!
    @IBOutlet weak var imgvmsgstatus: UIImageView!
    @IBOutlet weak var vselection: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vbg.layer.cornerRadius = MESSAGECELL_RADIUS
        vbg.backgroundColor = appclrOwnMessageBg
        lblmsg.textColor = .white
        vselection.backgroundColor = appclrOwnMessageBg
        vbg.alpha = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
