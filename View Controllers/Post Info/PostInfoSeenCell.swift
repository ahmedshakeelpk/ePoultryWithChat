//
//  PostInfoSeenCell.swift
//  AMPL
//
//  Created by Paragon Marketing on 14/06/2017.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class PostInfoSeenCell: UITableViewCell {

    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbltime: UILabel!
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
