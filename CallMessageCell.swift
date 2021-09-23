//
//  CallMessageCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 26/08/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CallMessageCell: UITableViewCell {

    @IBOutlet weak var btnvideo: UIButton!
    @IBOutlet weak var btnaudio: UIButton!
    
    @IBOutlet weak var imgvaudio: UIImageView!
    @IBOutlet weak var imgvvideo: UIImageView!
    @IBOutlet weak var imgvbgprofile: UIView!
    @IBOutlet weak var imgvbottomline: UIImageView!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var imgvprofile: UIImageView!
    
    @IBOutlet weak var btnprofilepic: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
