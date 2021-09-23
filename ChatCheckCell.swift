//
//  ChatCheckCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 29/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ChatCheckCell: UITableViewCell {
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
