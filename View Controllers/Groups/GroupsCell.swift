//
//  GroupsCell.swift
//  AMPL
//
//  Created by Paragon Marketing on 08/06/2017.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit


class GroupsCell: UITableViewCell {

    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var btnprofile: MIBadgeButton!
    @IBOutlet weak var lblmsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgv.layer.cornerRadius = imgv.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
