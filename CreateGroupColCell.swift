//
//  CreateGroupColCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 16/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

protocol CreateGroupColCellDelegate: class {
    func didTapOnColvRow(row: NSInteger)
}

class CreateGroupColCell: UICollectionViewCell, UICollectionViewDelegate {

    weak var celldelegate: CreateGroupColCellDelegate?
    
    @IBOutlet weak var bgv: UIView!
    @IBOutlet weak var imgvuser: UIImageView!
    @IBOutlet weak var bgvcancel: UIView!
    @IBOutlet weak var imgvcancel: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    //MARK:- set image Circle
    func cellConfigration(viewcontroller: UIViewController, delegate: CreateGroupColCellDelegate)
    {
        obj.setimageCircle(image: imgvuser, viewcontroller: viewcontroller)
        obj.setimageCircle(image: imgvcancel, viewcontroller: viewcontroller)
        obj.setViewCircle(view: bgvcancel, viewcontroller: viewcontroller)
        celldelegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        celldelegate?.didTapOnColvRow(row: indexPath.row)
    }
    
}
