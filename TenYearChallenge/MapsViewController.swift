//
//  MapsViewController.swift
//  TenYearChallenge
//
//  Created by 連振甫 on 2021/7/25.
//

import UIKit
import MapKit

class MapsViewController: UITableViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    
    var addresPosition = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        longitudeTextField.text = String(LocationManager.shared.info.coordinate.longitude)
        latitudeTextField.text = String(LocationManager.shared.info.coordinate.latitude)
        setupMapView()
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        addresPosition.coordinate = LocationManager.shared.info.coordinate
        mapView.showAnnotations([addresPosition], animated: true)
    }

    @IBAction func setAddressAction(_ sender: UIButton) {
        
        mapView.removeAnnotation(addresPosition)
        LocationManager.shared.setPosition(lat: Double(latitudeTextField.text!)!, long: Double(longitudeTextField.text!)!)
        addresPosition.coordinate = LocationManager.shared.info.coordinate
        mapView.showAnnotations([addresPosition], animated: true)
    }
}
