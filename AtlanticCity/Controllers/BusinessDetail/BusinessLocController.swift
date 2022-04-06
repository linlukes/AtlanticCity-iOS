//
//  BusinessLocController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 26/08/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import MapKit

class BusinessLocController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    var lat : Double?
    var lng : Double?
    var businessName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: lat ?? 0, longitude: lng ?? 0)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = businessName
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func backListener(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
