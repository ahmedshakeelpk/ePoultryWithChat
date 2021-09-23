//
//  NewGroupCell.swift
//  AMPL
//
//  Created by Paragon Marketing on 03/07/2017.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class NewGroupCell: UITableViewCell {

    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var imgprofile: UIImageView!
    
    @IBOutlet weak var btnprofile: UIButton!
    
    @IBOutlet weak var imgvlogo: UIImageView!
    @IBOutlet weak var imgvcheck: UIImageView!
    @IBOutlet weak var imgvadd: UIImageView!
    
    @IBOutlet weak var btncheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //MARK: - imgview corner raduis, border width, and border color
        imgprofile.layer.cornerRadius = imgprofile.frame.width / 2
        imgprofile.layer.borderWidth = 2
        imgprofile.layer.borderColor = appcolor.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
