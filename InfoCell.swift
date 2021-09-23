//
//  InfoCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 04/09/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var bgv: UIImageView!
    @IBOutlet weak var lblmsg: LinkedLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgv.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
