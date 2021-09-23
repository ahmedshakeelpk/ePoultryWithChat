//
//  ChatSendCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 28/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ChatSendCell: UITableViewCell {

    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet var lblmsg: UILabel!
    @IBOutlet weak var vbg: UIImageView!
    @IBOutlet weak var imgvmsgstatus: UIImageView!
    @IBOutlet weak var vselection: UIView!

    @IBOutlet weak var bubbleview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vbg.layer.cornerRadius = MESSAGECELL_RADIUS
        vbg.backgroundColor = appclrOwnMessageBg
        vbg.alpha = 0.5
        lblmsg.textColor = .black
        vselection.backgroundColor = appclrOwnMessageBg
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
