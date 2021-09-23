//
//  TagFilterCell.swift
//  ePoltry
//
//  Created by Apple on 11/11/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class TagFilterCell: UITableViewCell {

    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var imgvcheck: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
