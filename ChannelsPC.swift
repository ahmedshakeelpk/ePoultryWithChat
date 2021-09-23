//
//  ChannelsPC.swift
//  ePoltry
//
//  Created by MacBook Pro on 22/10/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ChannelsPC: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var customcolv: ButtonBarView!
    
    
    override func viewDidLoad() {

        // Do any additional setup after loading the view.
        ////////////////////////////////////////////////
        UINavigationBar.appearance().barTintColor = appclr
        self.title = APPBUILDNAME
        group_defaults.setValue(USERUID, forKey: "uid")
        group_defaults.setValue(USERID, forKey: "userid")
      
        // bar seperator color
        settings.style.buttonBarBackgroundColor = appclr
        // change bar cell bg color
        settings.style.buttonBarItemBackgroundColor = appclr
        //MARK:- bottom line color
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        
        //MARK:- bottom line height
        settings.style.selectedBarHeight = 2.0
        
        //MARK:- Center spacing between items
        settings.style.buttonBarMinimumLineSpacing = 5
        
        //MARK: - Cell Height
        settings.style.buttonBarHeight = 50

        settings.style.buttonBarItemTitleColor = .red
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        settings.style.buttonBarItemLeftRightMargin = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,
            progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            //MARK:- unselected text color
            oldCell?.label.textColor = .white
            //MARK:- Selected text color
            newCell?.label.textColor = .white
        }
        super.viewDidLoad()
    }
   
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "News")
        
        let child_2 = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "ChannelVideos")
        let child_3 = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "ChannelImages")
        
        let child_4 = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "ChannelDocuments")
        
        let child_5 = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "ChannelLinks")
        
        let child_6 = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "Community")
        return [child_1, child_2, child_3, child_4, child_5, child_6]
       // return [child_1, child_2, child_3, child_5, child_6]
    }
}
