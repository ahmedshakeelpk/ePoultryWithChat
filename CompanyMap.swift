//
//  CompanyMap.swift
//  ePoltry
//
//  Created by MacBook Pro on 08/05/2019.
//  Copyright © 2019 sameer. All rights reserved.
//

import UIKit
import GoogleMaps

class CompanyMap: UIViewController, UITextFieldDelegate {

    var name = String()
    var catid = String()
    var latitude = String()
    var longitude = String()
    
    var arrNames = NSArray()
    var arrAddresses = NSArray()
    var arrPic = NSArray()
    
    var arrFax =  NSArray()
    var arrPhone =  NSArray()
    var arrEmail =  NSArray()
    var arrDesc = NSArray()
    var arrLatitide = NSArray()
    var arrLongitude = NSArray()
     var arrmarkers = [GMSMarker]()
    @IBOutlet weak var viewformap: GMSMapView!
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var txtsearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = name
        if latitude != "" && longitude != ""
        {
            let latitudee = Double(latitude)
            let longitudee =  Double(longitude)
            
            let position = CLLocationCoordinate2DMake(latitudee!, longitudee!)
            //MARK: - Draw Marker on Propery Point.
            let marker = GMSMarker()
            //let markerImage = UIImage(named: "startpoint")!.withRenderingMode(.alwaysTemplate)
            marker.position = position
            marker.title = name
            marker.icon = GMSMarker.markerImage(with: .red)
            
            arrmarkers.append(marker)
            //  marker.icon = markerImage
            marker.map = self.viewformap
            
            movetosaidlocation(lat: latitudee!, long: longitudee!, vformap: viewformap)
            
            viewformap.frame = self.view.frame
            txtsearch.isHidden = true
        }
        else
        {
            GetCompniesDetails()
        }
        funSearchSetting()
    }
    
    func GetCompniesDetails()
    {
        let url = BASEURL+"company/\(catid)/GeoCoordinates"
        print(url)
        //AIzaSyAuKnjskFgaCFnA1GynALATMpW0njGBe7Y
        andicator.startAnimating()
        obj.webServicesGetwithJsonResponse(url: url, completionHandler:
            {
                responseObject, error in
                self.andicator.stopAnimating()
                //print(responseObject)
                DispatchQueue.main.async {
                    if error == nil && responseObject != nil
                    {
                        if responseObject!.count > 0
                        {
                            let datadic = (responseObject! as NSDictionary).value(forKey: "data") as! NSArray
                            if datadic.count > 0
                            {
                                self.arrNames = datadic.value(forKey: "company") as! NSArray
                                self.arrAddresses = datadic.value(forKey: "Address") as! NSArray
                                self.arrPic = datadic.value(forKey: "compImagePath") as! NSArray
                                
                                self.arrPhone = datadic.value(forKey: "Phone") as! NSArray
                                self.arrFax = datadic.value(forKey: "Fax") as! NSArray
                                self.arrEmail = datadic.value(forKey: "EMail") as! NSArray
                                self.arrDesc = datadic.value(forKey: "Description") as! NSArray
                                self.arrLatitide = datadic.value(forKey: "latitude") as! NSArray
                                self.arrLongitude = datadic.value(forKey: "longitude") as! NSArray
                                
                                self.ShowCompaniesMap()
                            }
                            else
                            {
                                obj.showAlert(title: "Alert!", message: "No record found", viewController: self)
                            }
                        }
                        else
                        {
                            obj.showAlert(title: "Error!", message: (error?.description)!, viewController: self)
                        }
                    }
                    else
                    {
                        //  obj.showAlert(title: "Error", message: error!, viewController: self)
                    }
                }
        })
    }
    
    
    //MARK:- Show Property on google map
    func ShowCompaniesMap()
    {
        viewformap.clear()
        if isFiltered == true
        {
            for c in (0..<arrSearchIndex.count)
            {
                if let latitude = arrLatitide[c] as? Double
                {
                    if let longitude =  arrLongitude[c] as? Double
                    {
                        let position = CLLocationCoordinate2DMake(latitude, longitude)
                        //MARK: - Draw Marker on Propery Point.
                        let marker = GMSMarker()
                        //let markerImage = UIImage(named: "startpoint")!.withRenderingMode(.alwaysTemplate)
                        marker.position = position
                        marker.title = "\(arrNames[c])"
                        marker.icon = GMSMarker.markerImage(with: .red)
                        
                        arrmarkers.append(marker)
                        //  marker.icon = markerImage
                        marker.map = self.viewformap
                    }
                }
            }
        }else{
            for c in (0..<arrLatitide.count)
            {
                if let latitude = arrLatitide[c] as? Double
                {
                    if let longitude =  arrLongitude[c] as? Double
                    {
                        let position = CLLocationCoordinate2DMake(latitude, longitude)
                        //MARK: - Draw Marker on Propery Point.
                        let marker = GMSMarker()
                        //let markerImage = UIImage(named: "startpoint")!.withRenderingMode(.alwaysTemplate)
                        marker.position = position
                        marker.title = "\(arrNames[c])"
                        marker.icon = GMSMarker.markerImage(with: .red)
                        
                        arrmarkers.append(marker)
                        //  marker.icon = markerImage
                        marker.map = self.viewformap
                    }
                }
            }//END For Loop
            movetosaidlocation(lat: 33.6534007, long: 73.0806859, vformap: viewformap)
        }
    }
    //MARK: - Function to move map to said location
    func movetosaidlocation(lat:Double , long: Double, vformap :GMSMapView)
    {
        
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        viewformap.camera = GMSCameraPosition(target: center, zoom: 5.2, bearing: 0, viewingAngle: 0)
        viewformap.settings.compassButton = true
    }
    
    //MARK:- Search Section
    var isFiltered = Bool()
    var arrSearchIndex = NSMutableArray()
    var btncancelSearch = UIButton(type: .custom)
    
    @IBAction func btncancelSearch(sender: UIButton){
        txtsearch.text = ""
        self.view.endEditing(true)
        isFiltered = false
        arrSearchIndex = NSMutableArray()
        self.ShowCompaniesMap()
    }
    
    func funSearchSetting()
    {
        // search textfield func
        // search textfield func
        obj.putRightButtoninTextField(btn: btncancelSearch, txtfield: txtsearch, imgname: "cross", x: 20, width: 15, height: 15)
        btncancelSearch.addTarget(self, action: #selector(btncancelSearch(sender:)), for: .touchUpInside)
        obj.putLeftImgInTextField(txtfield: txtsearch, imgname: "search", x: 5, width: 25, height: 25)
        obj.txtbottomline(textfield: txtsearch)
        txtsearch.delegate = self
        txtsearch.addTarget(self, action: #selector(change), for: .editingChanged)
    }
    @objc func change()
    {
        let length = txtsearch.text
        if length?.count == 0
        {
            isFiltered = false
            //searchBar.responds(to: Selector(resignFirstResponder()))
            //txtsearch.resignFirstResponder()
            arrSearchIndex = NSMutableArray()
            self.ShowCompaniesMap()
        }
        else
        {
            isFiltered = true
            arrSearchIndex = NSMutableArray()
            for (index, temp) in arrNames.enumerated() {
                var name = "\(temp)"
                if name.isNumeric{
                    print("String contain only Numeric")
                    name = name.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                    name = name.trimmingCharacters(in: .whitespaces)
                    name = name.replacingOccurrences(of: " ", with: "")
                    name = name.replacingOccurrences(of: "+", with: "")
                    name = name.replacingOccurrences(of: "-", with: "")
                    name = name.replacingOccurrences(of: "(", with: "")
                    name = name.replacingOccurrences(of: ")", with: "")
                }
                // MARK:- case InSensitive Search
                if let _ = (name).range(of: "\(txtsearch.text!)", options: .caseInsensitive) {
                    self.arrSearchIndex.add(index)
                }
            }
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    //self.tablev?.reloadData()
                    self.ShowCompaniesMap()
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // Marks: - Uitextfields delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    //End Search Setting
}

