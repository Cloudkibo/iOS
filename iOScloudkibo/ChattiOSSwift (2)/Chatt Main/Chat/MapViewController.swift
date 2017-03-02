//
//  MapViewViewController.swift
//  
//
//  Created by Cloudkibo on 02/03/2017.
//
//

import UIKit
import GoogleMaps
class MapViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var viewMapOutlet: GMSMapView!
    
    var latitude=""
    var longitude=""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var locationManager = CLLocationManager()
        
        
        //locationManager.delegate = self
       // locationManager.requestWhenInUseAuthorization()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6)
        self.viewMapOutlet.isMyLocationEnabled = true
        
        self.viewMapOutlet.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
       // marker.title = "Sydney"
       // marker.snippet = "Australia"
        marker.map = viewMapOutlet
        
        
        var didFindMyLocation = false
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
