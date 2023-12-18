//
//  ViewController.swift
//  MyFavouritePlaces
//
//  Created by Yuvaraj Mayank Konjeti on 18/12/23.
//

import UIKit
import MapKit
class ViewController: UIViewController,MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        if currentPlace == -1  {
            currentPlace = 0
        }
        guard places.count > currentPlace else { return }
        guard let name = places[currentPlace]["name"] else { return }
        guard let lat = places[currentPlace]["lat"] else { return }
        guard let lon = places[currentPlace]["lon"] else { return }
        guard let latitude = Double(lat) else { return }
        guard let longitude = Double(lon) else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        self.mapView.addAnnotation(annotation)
        print(currentPlace)
        loadPlaces()
    }
    func loadPlaces(){
        for place in places{
            let annotation = MKPointAnnotation()
            guard let name = place["name"] else { return }
            guard let lat = place["lat"] else { return }
            guard let lon = place["lon"] else { return }
            guard let latitude = Double(lat) else { return }
            guard let longitude = Double(lon) else { return }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.coordinate = coordinate
            annotation.title = name
            self.mapView.addAnnotation(annotation)
        }
    }
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.mapView)
            let newCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            print(newCoordinate)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil { print(error!)
                } else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    } }
                if title == "" {
                    title = "Added \(NSDate())"
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.mapView.addAnnotation(annotation)
                places.append(["name":title, "lat": String(newCoordinate.latitude), "lon":
                                String(newCoordinate.longitude)])
                userDefaults.set(places, forKey: keyForPlaces)

            }) }
    }
    
}

