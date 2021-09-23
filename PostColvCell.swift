//
//  PostColvCell.swift
//  ePoltry
//
//  Created by MacBook Pro on 21/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class PostColvCell: UICollectionViewCell {

    @IBOutlet weak var imgv: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgv.layer.borderColor = appclr.cgColor
        imgv.layer.borderWidth = 0.3
    }

}
