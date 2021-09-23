//
//  DirectoryCell.swift
//  ePoltry
//
//  Created by MacBook Pro on 26/04/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class DirectoryCell: UITableViewCell {
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //imgv.layer.cornerRadius = imgv.frame.size.height / 2
        //imgv.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
