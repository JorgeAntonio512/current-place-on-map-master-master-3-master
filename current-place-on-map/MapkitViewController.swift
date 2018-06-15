//
//  MapkitViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 5/12/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

class MapkitViewController: UIViewController {
    
    // MARK: - Properties
    var artworks: [Artwork] = []
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set initial location in Honolulu
       // let initialLocation = CLLocation(latitude: 30.265212, longitude: -97.756050)
        //centerMapOnLocation(location: initialLocation)
        mapView.userTrackingMode = .follow
        var region = MKCoordinateRegion()
        region.span = MKCoordinateSpanMake(0.7, 0.7); //Zoom distance
        let coordinate = CLLocationCoordinate2D(latitude: 30.265212, longitude: -97.756050)
        region.center = coordinate
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        //    mapView.register(ArtworkMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        if #available(iOS 11.0, *) {
            mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
       // loadInitialData()
        //mapView.addAnnotations(artworks)
        
        
        // show artwork on map
//            let artwork = Artwork(title: "King David Kalakaua",
//              locationName: "Waikiki Gateway Park",
//              discipline: "Sculpture",
//              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
//            mapView.addAnnotation(artwork)
   
        
        Database.database().reference().child("markers").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for child in snapshots {
                    print("Child: ", child)
                    
                    let snap = child
                    
                    guard let dict = snap.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                    
                    let lat = dict["latitude"] as? String
                    let latitude = (lat! as NSString).doubleValue
                    let long = dict["longitude"] as? String
                    let longitude = (long! as NSString).doubleValue
                    let titlez = dict["title"] as? String
                    let snippet = dict["snippet"] as? String
                    
                    
                    print("CHYEAH BOYYYY!!")
                    let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    //                    let marker = GMSMarker(position: position)
                    //                    marker.title = title
                    //                    marker.snippet = snippet
                    //                    marker.map = self.mapView
                    let artwork = Artwork(title: titlez!, locationName: snippet!, discipline: "Flag", coordinate: position)
                    self.mapView.addAnnotation(artwork)
                    
                }
            }
            
        })

    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            print("heyheyhey")
            //self.tabBarController?.tabBar.isHidden = false;
            //self.tabBarController?.tabBar.isHidden = false
            //self.enableView.isHidden = true;
            //performSegue(withIdentifier: "toMapy", sender: self)
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted){
            print("Location access was restricted.")
            //performSegue(withIdentifier: "toOpenSettings", sender: self)
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied){
            print("User denied access to location. this is da whey.")
            performSegue(withIdentifier: "toOpenSettings", sender: self)
        }
        else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined){
            print("Location status not determined. Scrubby.")
            // performSegue(withIdentifier: "toEnableLoc", sender: self)
            checkLocationAuthorizationStatus()
        }
        else{
            print("not getting location")
            // a default pin
        }
        
        
    }
    
    // MARK: - CLLocationManager
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            print("Location status not determined.")
            performSegue(withIdentifier: "toEnableLoc", sender: self)
        }
    }
    
    // MARK: - Helper methods
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func loadInitialData() {
        // 1
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            // 2
            let json = try? JSONSerialization.jsonObject(with: data),
            // 3
            let dictionary = json as? [String: Any],
            // 4
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // 5
        let validWorks = works.compactMap { Artwork(json: $0) }
        artworks.append(contentsOf: validWorks)
    }
    
}

// MARK: - MKMapViewDelegate

extension MapkitViewController: MKMapViewDelegate {
    
    //   1
    //  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //    guard let annotation = annotation as? Artwork else { return nil }
    //    // 2
    //    let identifier = "marker"
    //    var view: MKMarkerAnnotationView
    //    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    //      as? MKMarkerAnnotationView { // 3
    //      dequeuedView.annotation = annotation
    //      view = dequeuedView
    //    } else {
    //      // 4
    //      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //      view.canShowCallout = true
    //      view.calloutOffset = CGPoint(x: -5, y: 5)
    //      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    //    }
    //    return view
    //  }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        var region = MKCoordinateRegion()
//        region.span = MKCoordinateSpanMake(0.7, 0.7); //Zoom distance
//        let coordinate = CLLocationCoordinate2D(latitude: 30.265212, longitude: -97.756050)
//        region.center = coordinate
//        mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if view.rightCalloutAccessoryView == control {
            let location = view.annotation as! Artwork
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:
                MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
        else {
            
            Database.database().reference().child("markers").queryOrdered(byChild: "title").queryEqual(toValue: view.annotation?.title).observe(.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in snapshots {
                        print("Child: ", child)
                        
                        
                        let snap = child
                        
                        guard let dict = snap.value as? [String:Any] else {
                            print("Error")
                            return
                        }
                        
                        let lat = dict["url"] as? String
    
                        
                        
                        
                        print("gotcha!")
                        guard let url = URL(string: lat!) else {
                            return //be safe
                        }
                        
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                
            })
            
            
            
            
        }
    }
    
}
