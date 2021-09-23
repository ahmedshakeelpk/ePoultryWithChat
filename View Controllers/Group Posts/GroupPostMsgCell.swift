//
//  GroupPostMsgCell.swift
//  AMPL
//
//  Created by sameer on 09/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class GroupPostMsgCell: UITableViewCell {

    
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var btnoption: UIButton!
    
    @IBOutlet weak var bgv: UIView!
    @IBOutlet weak var imgvprofile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
