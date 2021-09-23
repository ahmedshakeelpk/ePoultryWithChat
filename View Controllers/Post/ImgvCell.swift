//
//  ImgvCell.swift
//  ePoltry
//
//  Created by Macbook 2017 on 10/31/19.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class ImgvCell: UITableViewCell {
    
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
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                imgpost.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                imgpost.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }

    func setCustomImage(image : UIImage) {
        let aspect = image.size.width / image.size.height

        let constraint = NSLayoutConstraint(item: self.imgpost!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.imgpost, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        self.aspectConstraint = constraint
        DispatchQueue.main.async {
            self.imgpost.image = image
        }
    }
    
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
