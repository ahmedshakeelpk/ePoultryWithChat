//
//  PageViewChannelCell.swift
//  ePoltry
//
//  Created by MacBook Pro on 22/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

protocol PageViewChannelCellDelegates: class {
    func addThisViewControllerAsChild(pcvc :ChannelsPC)
}

class PageViewChannelCell: UITableViewCell {

    @IBOutlet weak var containerv: UIView!
    
    var pcVC = ChannelsPC()
    weak var pageViewChannelCellDelegate:PageViewChannelCellDelegates?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        pcVC  = storyboard.instantiateViewController(withIdentifier: "ChannelsPC") as! ChannelsPC
        pcVC.view.frame = self.contentView.bounds
        
        pcVC.view.frame.size.height = pcVC.view.frame.size.height
        self.contentView.addSubview(pcVC.view)

        if self.pageViewChannelCellDelegate != nil {
            self.pageViewChannelCellDelegate?.addThisViewControllerAsChild(pcvc: pcVC)
        }
    }
    
}
