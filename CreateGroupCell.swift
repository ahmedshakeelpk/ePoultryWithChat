//
//  CreateGroupCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 16/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

protocol CreateGroupCellDelegate: class {
    func didTapOnCheck(row: NSInteger)
}
class CreateGroupCell: UITableViewCell {
    
    weak var celldelegate: CreateGroupCellDelegate?
    
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblnumber: UILabel!
    @IBOutlet weak var btncheck: UIButton!
    @IBOutlet weak var imgvbg: UIView!
    @IBOutlet weak var imgvcheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func cellConfigration(row: NSInteger, delegate: CreateGroupCellDelegate)
    {
        btncheck.tag = row
        celldelegate = delegate
    }
    
    @IBAction func btncheck(_ sender: Any) {
        celldelegate?.didTapOnCheck(row: (sender as AnyObject).tag)
//        if imgvcheck.accessibilityIdentifier == "check"
//        {
//            imgvcheck.image = UIImage(named: "uncheck")
//        }else{
//            imgvcheck.image = UIImage(named: "check")
//        }
        
    }
    
}
