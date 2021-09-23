//
//  GroupInfoCell.swift
//  AMPL
//
//  Created by Paragon Marketing on 19/07/2017.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class GroupInfoCell: UITableViewCell {

    
    @IBOutlet weak var imgvprof: UIImageView!
    @IBOutlet weak var btnprofile: UIButton!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblfrom: UILabel!
    @IBOutlet weak var lbladmin: UILabel!
    @IBOutlet weak var lblversion: UILabel!
    @IBOutlet weak var lblseen: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgvprof.layer.cornerRadius = imgvprof.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
