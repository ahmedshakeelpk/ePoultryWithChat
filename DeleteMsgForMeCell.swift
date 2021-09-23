//
//  DeleteMsgForMeCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class DeleteMsgForMeCell: UITableViewCell {

    var viewController = UIViewController()
    @IBOutlet weak var btnForMe: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var bgv: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnForMe(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removePopup"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteMessages"), object: ["isDeletedFromEveryOne": 0])
    }
    @IBAction func btnCancel(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removePopup"), object: nil)
    }
    
}
