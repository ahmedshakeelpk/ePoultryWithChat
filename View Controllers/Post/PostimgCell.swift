//
//  PostimgCell.swift
//  AMPL
//
//  Created by sameer on 04/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class PostimgCell: UITableViewCell {

    
    @IBOutlet weak var lbllikes: UILabel!
    @IBOutlet weak var lblcomments: UILabel!
    @IBOutlet weak var lbldesc2: UILabel!
    @IBOutlet weak var lbldesc1: LinkedLabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var imgpost: UIImageView!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var btncomment: UIButton!
    @IBOutlet weak var btnshare: UIButton!

    @IBOutlet weak var btnprofile: UIButton!
    
    @IBOutlet weak var imglike: UIImageView!
    @IBOutlet weak var imgcomment: UIImageView!
    
    @IBOutlet weak var btnoption: UIButton!
    
    @IBOutlet weak var btnshowimage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgprofile.layer.cornerRadius = imgprofile.frame.width / 2
        lbldesc1.textAlignment = .natural
        
        imgcomment.setImageColor(color:appclr)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
