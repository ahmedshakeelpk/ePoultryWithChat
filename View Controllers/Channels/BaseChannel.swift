//
//  BaseChannel.swift
//  ePoltry
//
//  Created by Apple on 25/11/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit

class BaseChannel: UIViewController {

    override func viewDidLoad() {
        btnaddchannel.frame.origin.y = (tabBarController?.tabBar.frame.minY)! - (btnaddchannel.frame.height + 20)
        btnaddchannel.layer.cornerRadius = btnaddchannel.frame.width / 2
        
        let popvc = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "AllChannelPC") as! AllChannelPC
        self.addChild(popvc)
        popvc.view.frame = self.view.frame
        self.view.addSubview(popvc.view)
        //popvc.didMove(toParent: viewController)
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Configure the view for the selected state
        DispatchQueue.main.async {
            for view in self.view.subviews {
                //self.btnaddchannel.sendSubviewToBack(view)
            }
            self.view.addSubview(self.btnaddchannel)
        }
    }
    @IBOutlet weak var btnaddchannel: UIButton!
    @IBAction func btnaddchannel(_ sender: Any) {
        
        
        let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "AddNewChannel") as! AddNewChannel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//Respected Sir,
//I Shakeel Ahmed CNIC 1430150995593
//I have blocked my CNIC, and after complete my all process get the letter from SSP later no 931/PO-SSP/IBD the Islamabad office near with Peshawar more they told me today 25 Nov 2019 at 1045 am we have no record of you latter and we have not received it yet after that I approach HQ at 1130 Mail department the verify me, that latter has been received on 22Nov19, on information help desk there was on counter no2 person asked me its will take 6 days I insist to talk with your senior person he, forward me to his senior supervise which were sitting in alone cabins!
//At once he rushes me and try To Presserise me and rude behave me, when I said this Clearence latter is from police Station, He Replyed police is nothing for Nadra, I will complaint against you on the citizen portal he replied go-ahead, and after that says it will take 10 days when I asked him To give me the written for that or tell me the reason he denied my issue is first Nadra is facilitating centre a pressing the people? its minute the rude behave with all illiterate people its only not my problème its Pakistan public problème take action against this behave, and open my CNIC on urgent basis, why it will take 10 days? It means you people are wasting the time of the public? or your director are not able to clear the mails in a day? I will also complain against Nadra on the citizen portal, if you will not properly follow up with me.
