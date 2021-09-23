//
//  CheckBox.swift
//  ZedChat
//
//  Created by MacBook Pro on 16/07/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol CheckBoxDelegate: class {
    func didSelectCheckBox(indexPath: IndexPath)
    func didUnSelectCheckBox(indexPath: IndexPath)
}

class CheckBox: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "CheckUnCheckCell") as! CheckUnCheckCell
        
        cell.lbltitle.text = dataSource[indexPath.row]
        
        if dataSourceSelectedCheck.contains(dataSource[indexPath.row]){
            cell.imgvcheck.image = UIImage(named: "check")
        }
        else{
            cell.imgvcheck.image = UIImage(named: "uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tablev.beginUpdates()
        let cell = self.tablev.cellForRow(at: indexPath) as! CheckUnCheckCell
        if cell.imgvcheck.accessibilityIdentifier == "uncheck"
        {
            cell.imgvcheck.image = UIImage(named: "check")
            dataSourceSelectedCheck.append(dataSource[indexPath.row])
            CheckBoxDelegate?.didSelectCheckBox(indexPath: indexPath)
        }
        else
        {
            cell.imgvcheck.image = UIImage(named: "uncheck")
            let index = dataSourceSelectedCheck.firstIndex(of: dataSource[indexPath.row])
            dataSourceSelectedCheck.remove(at: index!)
            CheckBoxDelegate?.didUnSelectCheckBox(indexPath: indexPath)
        }
        self.tablev.endUpdates()
    }
    
    @IBOutlet weak var tablev: UITableView!
    weak var CheckBoxDelegate: CheckBoxDelegate?
    var dataSource = [String]()
    var dataSourceSelectedCheck = [String]()
    var viewController = UIViewController()
    
    
    @IBOutlet weak var btnok: UIButton!
    @IBAction func btnok(_ sender: Any) {
        objG.removeVerificationPopup()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tablev.register(UINib(nibName: "CheckUnCheckCell", bundle: nil), forCellReuseIdentifier: "CheckUnCheckCell")
        self.tablev.delegate = self
        self.tablev.dataSource = self
        self.tablev.reloadData()
        
        tablev.tableFooterView = UIView()
        
        btnok.layer.cornerRadius = 6
        
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            var frame = self.tablev.frame
            frame.size.height = self.tablev.contentSize.height
            self.tablev.frame = frame
            obj.setViewShade(view: self.tablev)
            self.btnok.frame.origin.y = self.tablev.frame.maxY + 5
            obj.setViewShade(view: self.btnok)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        objG.removeVerificationPopup()
    }
}
