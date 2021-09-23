//
//  PostInfoReadCell.swift
//  AMPL
//
//  Created by sameer on 10/06/2017 Anno Domini.
//  Copyright © 2017 sameer. All rights reserved.
//

import UIKit

class PostInfoReadCell: UITableViewCell, UIWebViewDelegate {

    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var imgpost: UIImageView!
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var webv: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webv.isHidden = true
        // Initialization code
        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(stopandicator), userInfo: nil, repeats: false);
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        andicator.stopAnimating()
    }
    
    @objc func stopandicator()
    {
        andicator.stopAnimating()
    }
    
    // Added
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\(error.localizedDescription)")
    }

}
