//
//  ProgressBar.swift
//  ZedChat
//
//  Created by MacBook Pro on 16/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit


class ProgressBar: UIViewController {

    @IBOutlet weak var bgv: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var btncancel: UIButton!
    @IBAction func btncancel(_ sender: Any) {
        removeVerificationPopup(viewController: self)
    }
    @IBOutlet weak var bgvtitle: UIView!
    var timerr = 0.0
    override func viewDidLoad() {
        bgvtitle.backgroundColor = appclr
        super.viewDidLoad()
        timerr = 0.0
        setViewShade(view: bgv)
        // Do any additional setup after loading the view.
        MEDIAPROGRESS = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.timerr = self.timerr + 0.5
            if MEDIAPROGRESS >= 0.99 {
                print("Go!")
                let progress = (Float(MEDIAPROGRESS))
                self.progressBar.setProgress(Float(progress), animated:true)
                DispatchQueue.main.async {
                    timer.invalidate()
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                        self.removeVerificationPopup(viewController: self)
                    }
                }
            } else {
                print(MEDIAPROGRESS)
                let progress = (Float(MEDIAPROGRESS))
                self.progressBar.setProgress(Float(progress), animated:true)
                if self.timerr > 10.0{
                  //  MEDIAPROGRESS = 1
                }
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // Marks: - Remove custom popup
    public func removeVerificationPopup(viewController: UIViewController)
    {
        UIView.animate(withDuration: 0.25, animations: {
            viewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            viewController.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        })
    }
    public func setViewShade(view: UIView)
    {
        //view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = appclr.cgColor
        
        //MARK:- Shade a view
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
    }
}
