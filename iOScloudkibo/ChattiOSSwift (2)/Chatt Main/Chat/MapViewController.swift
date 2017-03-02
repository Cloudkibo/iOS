//
//  MapViewViewController.swift
//  
//
//  Created by Cloudkibo on 02/03/2017.
//
//

import UIKit
import GoogleMaps
class MapViewController: UIViewController {

    @IBOutlet weak var viewMapOutlet: UIView!
    var mapView=GMSMapView()
    var latitude=""
    var longitude=""
    override func viewDidLoad() {
        super.viewDidLoad()

        
       // var locationManager = CLLocationManager()
        
        
        //locationManager.delegate = self
       // locationManager.requestWhenInUseAuthorization()
        var latDeg=CLLocationDegrees.init(latitude)
        var longDeg=CLLocationDegrees.init(longitude)
        
        if(latDeg != nil  && longDeg != nil)
        {
        let camera = GMSCameraPosition.camera(withLatitude: latDeg!, longitude: longDeg!, zoom: 15)
        self.mapView.camera = camera
        mapView.frame=viewMapOutlet.bounds
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(latDeg!, longDeg!)
            // marker.title = "Sydney"
            // marker.snippet = "Australia"
            marker.map = mapView
            
        viewMapOutlet.addSubview(mapView)
        }
        
        
        
       // var didFindMyLocation = false
       // viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)

        // Do any additional setup after loading the view.
    }

    
    
   /* func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            viewMap.myLocationEnabled = true
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
