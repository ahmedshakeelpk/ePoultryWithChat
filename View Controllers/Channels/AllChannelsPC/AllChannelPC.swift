//
//  AllChannelPC.swift
//  ePoltry
//
//  Created by Apple on 19/11/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AllChannelPC: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var customcolv: ButtonBarView!
    
    @IBOutlet weak var btnaddChannel: UIButton!
    @IBAction func btnaddChannel(_ sender: Any) {
    }
    @IBOutlet weak var scrollv: UIScrollView!
    override func viewDidLoad() {

        // Do any additional setup after loading the view.
        ////////////////////////////////////////////////
        UINavigationBar.appearance().barTintColor = appclr
        group_defaults.setValue(USERUID, forKey: "uid")
        group_defaults.setValue(USERID, forKey: "userid")
      
        // bar seperator color
        settings.style.buttonBarBackgroundColor = appclr
        // change bar cell bg color
        settings.style.buttonBarItemBackgroundColor = appclr
        //MARK:- bottom line color
        settings.style.selectedBarBackgroundColor = .white
        //MARK: - Cell Height
        settings.style.buttonBarHeight = 50
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        //MARK:- bottom line height
        settings.style.selectedBarHeight = 3.0
        //MARK:- set Y Axes of bar view (its create by me manual)
        settings.style.buttonBarFrameYAxes = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT
        if IPAD {
            settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 23)
            //MARK: - Cell Height
            settings.style.buttonBarHeight = 90
            //MARK:- bottom line height
            settings.style.selectedBarHeight = 6.0
            //MARK:- set Y Axes of bar view (its create by me manual)
            settings.style.buttonBarFrameYAxes = 64
        }
        
        //MARK:- Center spacing between items
        settings.style.buttonBarMinimumLineSpacing = 5
        settings.style.buttonBarItemTitleColor = .red
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarItemLeftRightMargin = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
            //MARK:- unselected text color
            oldCell?.label.textColor = .white
            //MARK:- bottom line height
            //MARK:- Selected text color
            newCell?.label.textColor = .white
        }
        
        super.viewDidLoad()

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "Channels")
        let child_2 = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "FollowedChannel")
        let child_3 = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "YourChannel")
        return [child_1, child_2, child_3]
    }
}
