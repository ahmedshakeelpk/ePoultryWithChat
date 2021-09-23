//
//  SearchCell.swift
//  AMPL
//
//  Created by sameer on 10/07/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblfrom: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var btnadd: UIButton!
    @IBOutlet weak var lbladd: UILabel!
    
    @IBOutlet weak var imgvadd: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgv.layer.cornerRadius = imgv.frame.width / 2
        // Swift
        lbltitle.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        lbltitle.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
