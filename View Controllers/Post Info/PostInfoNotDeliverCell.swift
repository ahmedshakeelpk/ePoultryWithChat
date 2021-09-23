//
//  PostInfoNotDeliverCell.swift
//  AMPL
//
//  Created by sameer on 10/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class PostInfoNotDeliverCell: UITableViewCell {

    
    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbllastseen: UILabel!
    @IBOutlet weak var lblversion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        imgvprofile.layer.cornerRadius = imgvprofile.frame.width / 2
    }

}
