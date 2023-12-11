//
//  DetailPlantViewController.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 4/12/2023.
//

import UIKit
import MapKit

class DetailPlantViewController: UIViewController {
    
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var detailPlantMapView: MKMapView!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantSpeciesLabel: UILabel!
    
    // MARK: Public props
    
    public var lat: String?
    public var long: String?
    public var species: String?
    public var familyNameValue: String?
    public var countryNameValue: String?
    public var imageFileName: String?
    public var recnum: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        loadPlantImage()
        loadSpecificPlantLocationOnMap()
    }
    
    @IBAction func onTapFav(_ sender: Any) {
        if let familyNameValue = familyNameValue,
            let species = species,
            let countryNameValue = countryNameValue,
            let recnum = recnum {

          _ = PlantDataManager
                .shared
                .createPlant(
                    family: familyNameValue,
                    country: countryNameValue,
                    species: species,
                    recnum: recnum
                ) { isExists in
                    if isExists {
                        self.presentAlert()
                    }
                    else {
                        print("saved!")
                    }
                }
           
        }
        
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Alert!", message: "already added to favourites tab, checkout there now", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "done", style: .default) { _ in
            self.tabBarController?.selectedIndex = 1
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}












// MARK: Private Methods

extension DetailPlantViewController {
    
    private func loadData() {
        familyNameLabel.text = familyNameValue
        countryNameLabel.text = countryNameValue
        plantSpeciesLabel.text = species
    }
    
    private func loadPlantImage() {
        if let image = imageFileName {
            self.downloadImage(from: URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness_images/\(image)")!)
        }
        
    }
    private func loadSpecificPlantLocationOnMap() {
        if lat != "" && long != "" {
            self.detailPlantMapView.isHidden = false
            let lati = Double(lat!)!
            let longi = Double(long!)!
            let initialLocation = CLLocationCoordinate2D(latitude: lati, longitude: longi)
            let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            detailPlantMapView.setRegion(region, animated: true)
            
            // Display the user's location on the map
            detailPlantMapView.showsUserLocation = true
            
            // Keep the map centered on the user's location
            detailPlantMapView.userTrackingMode = .follow
            
        }
        else {
            self.detailPlantMapView.isHidden = true
        }
    }
    
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            // Update the UI on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.plantImageView.image = UIImage(data: data)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
