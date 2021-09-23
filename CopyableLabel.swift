//
//  CopyableLabel.swift
//
//  Created by Lech H. Conde on 01/11/16.
//  Copyright © 2016 Mavels Software & Consulting. All rights reserved.
//

import UIKit

class CopyableLabel: UILabel {
	
	override var canBecomeFirstResponder: Bool {
		return true
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		sharedInit()
        self.initialize()
	}
	
//    override init(frame aRect:CGRect){
//        super.init(frame: aRect)
//        self.initialize()
//    }

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.initialize()
//    }
    
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		sharedInit()
        self.initialize()
	}
	
	func sharedInit() {
		isUserInteractionEnabled = true
		addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
	}
	
	@objc func showMenu(sender: AnyObject?) {
		becomeFirstResponder()
		let menu = UIMenuController.shared
		if !menu.isMenuVisible {
			menu.setTargetRect(bounds, in: self)
			menu.setMenuVisible(true, animated: true)
		}
	}
	
	override func copy(_ sender: Any?) {
		let board = UIPasteboard.general
		board.string = text
		let menu = UIMenuController.shared
		menu.setMenuVisible(false, animated: true)
	}
	
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		return action == #selector(UIResponderStandardEditActions.copy)
	}
    
    
    
    //MARK:- Linked Label
    fileprivate let layoutManager = NSLayoutManager()
    fileprivate let textContainer = NSTextContainer(size: CGSize.zero)
    fileprivate var textStorage: NSTextStorage?
    
    
    
    
    func initialize(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LinkedLabel.handleTapOnLabel))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    override var attributedText: NSAttributedString?{
        didSet{
            if let _attributedText = attributedText{
                self.textStorage = NSTextStorage(attributedString: _attributedText)
                
                self.layoutManager.addTextContainer(self.textContainer)
                self.textStorage?.addLayoutManager(self.layoutManager)
                
                self.textContainer.lineFragmentPadding = 0.0;
                self.textContainer.lineBreakMode = self.lineBreakMode;
                self.textContainer.maximumNumberOfLines = self.numberOfLines;
            }
        }
    }
    
    @objc func handleTapOnLabel(tapGesture:UITapGestureRecognizer){
        
        var link = obj.findLink(string: self.text!)
        if link == ""{
            return
        }
        link = link.replacingOccurrences(of: "https://", with: "")
        link = link.replacingOccurrences(of: "http://", with: "")
        let locationOfTouchInLabel = tapGesture.location(in: tapGesture.view)
        let labelSize = tapGesture.view?.bounds.size
        if labelSize?.height ?? 0 > CGFloat(800) {
            return
        }
        let textBoundingBox = self.layoutManager.usedRect(for: self.textContainer)
        let textContainerOffset = CGPoint(x: ((labelSize?.width)! - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: ((labelSize?.height)! - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = self.layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        self.attributedText?.enumerateAttribute(NSAttributedString.Key.link, in: NSMakeRange(0, (self.attributedText?.length)!), options: NSAttributedString.EnumerationOptions(rawValue: UInt(0)), using:{
            (attrs: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
            
            if NSLocationInRange(indexOfCharacter, range){
                if let _attrs = attrs{
                    
                    guard var url = URL(string: "\(_attrs as! String)"), !url.absoluteString.isEmpty else {
                        return
                    }
                    link = "\(url)"
                    link = link.replacingOccurrences(of: "https://https://", with: "https://")
                    link = link.replacingOccurrences(of: "http://http://", with: "http://")
                    if link.contains("https://"){
                        
                    }
                    else if link.contains("http://"){
                    
                    }
                    else{
                        link = "https://\(link)"
                    }
                    url = URL(string: link)!
                    print("\(url)")
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }
}
extension String {
    var verifyUrl: Bool {
        get {
            let url = URL(string: self)

            if url == nil || NSData(contentsOf: url!) == nil {
                return false
            } else {
                return true
            }
        }
    }
}



