//
//  CommentsCell.swift
//  AMPL
//
//  Created by sameer on 05/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var imgvprofile: UIImageView!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblcomment: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgvprofile.layer.cornerRadius = imgvprofile.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
