//
//  FriendCell.swift
//  AMPL
//
//  Created by Paragon Marketing on 05/07/2017.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var btnunfriend: UIButton!
    @IBOutlet weak var lblfrom: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgv.layer.cornerRadius = imgv.frame.width / 2
        imgv.layer.borderColor = appcolor.cgColor
        imgv.layer.borderWidth = 2
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
