//
//  AddCaptian.swift
//  ZedChat
//
//  Created by MacBook Pro on 11/10/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import RSKGrowingTextView
import RSKKeyboardAnimationObserver

protocol AddCaptianDelegate: class {
    func btnsend(_ sender: Any, textCaptian: String)
    func btncancel(_ sender: Any)
}

class AddCaptian: UIViewController, UITextViewDelegate {

    weak var vcdelegate: AddCaptianDelegate?
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var txtvmsg: RSKGrowingTextView!
    @IBOutlet weak var btnsend: UIButton!
    
    @IBOutlet weak var btncancel: UIButton!
    var imgforview = UIImage()
    
    @IBOutlet weak var imgvbg: UIImageView!
    @IBAction func btncancel(_ sender: Any) {
        self.unregisterForKeyboardNotifications()
        vcdelegate?.btncancel(sender)
        objG.removeVerificationPopup(viewController: self)
    }
    @IBAction func btnsend(_ sender: Any) {
        self.unregisterForKeyboardNotifications()
        vcdelegate?.btnsend(sender, textCaptian: txtvmsg.text!)
        DispatchQueue.main.async {
            objG.removeVerificationPopup(viewController: self)
        }
    }
    
    @IBOutlet weak var imgvsend: UIImageView!
    override func viewDidAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Return", style: .done, target: self, action: #selector(self.returnButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        txtvmsg  .inputAccessoryView = doneToolbar
    }

    @objc func returnButtonAction()
    {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        //MARK:- Add Return Button in Keyboard for UITextView
        addDoneButtonOnKeyboard()
        btncancel.imageView?.contentMode = .scaleAspectFit
        obj.setImageViewShade(imageview: imgvbg)
        imgvbg.backgroundColor = appclr
        imgvbg.layer.cornerRadius = imgvbg.frame.size.height / 2
        imgvsend.center = imgvbg.center
        DispatchQueue.main.async {
            self.txtvmsg.layer.cornerRadius = self.txtvmsg.frame.size.height / 2
        }
        // Do any additional setup after loading the view.
        imgv.image = imgforview
        
        self.txtvmsg.backgroundColor = .white
        self.txtvmsg.clipsToBounds = true
        self.txtvmsg.delegate = self
        self.txtvmsg.layer.borderWidth = 0.2
        
        super.viewDidLoad()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.text = textView.text + "\n"
               DispatchQueue.main.async{
                   //   obj.putRightViewAndButtonInTextViewField(button: self.btnCamera, view: self.boombutton, txtview: self.txtmsgv, x: 0, width: 40, height: 40)
               }
               return false
           }
        return true
    }
    //MARK:- Growing textview delegates
    @IBOutlet weak var bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    private var isVisibleKeyboard = true
    // MARK: - Helper Methods
       private func adjustContent(for keyboardRect: CGRect) {
           let keyboardHeight = keyboardRect.height + 10
           self.bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint.constant = self.isVisibleKeyboard ? keyboardHeight - self.bottomLayoutGuide.length : 10.0
           self.view.layoutIfNeeded()
       }
       
       @IBAction func handleTapGestureRecognizer(sender: UITapGestureRecognizer) {
           self.txtvmsg.resignFirstResponder()
       }
    
    private func registerForKeyboardNotifications() {
        self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                       willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                                        self.isVisibleKeyboard = isShowing
                                        self.adjustContent(for: keyboardRectEnd)
            }, onComplete: { (finished, isShown) -> Void in
                self.isVisibleKeyboard = isShown
                
        }
        )
        
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
            self.adjustContent(for: keyboardRectEnd)
            }, onComplete: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        self.rsk_unsubscribeKeyboard()
    }
    //MARK:- End of Growing textview delegates
}

